module control(
  input clock,
  input reset_n,
  input [31:0] ir,
  output ir_write,
  input [2:0] ccr,
  output [1:0] ccrsel,
  output [2:0] alu_func,
  output [2:0] alu1sel,
  output [2:0] alu2sel,
  output [3:0] regsel,
  output [3:0] reg_read_addr1,
  output [3:0] reg_read_addr2,
  output [3:0] reg_write_addr,
  output reg_write,
  output [3:0] mdrsel,
  output [2:0] marsel,
  output [1:0] int1sel,
  output [1:0] int2sel,
  output [2:0] int_func,
  output [2:0] pcsel,
  output addrsel,
  output [1:0] fpccrsel,
  output [3:0] byteenable,
  output bus_read,
  output bus_write,
  output halt,
  output int_en,
  output vectoff_write,
  input supervisor,
  input bus_wait,
  output reg [3:0] exception,
  output fp_addsub,
  input [2:0] interrupt,
  input [1:0] bus_align);

assign halt = (state == STATE_HALT);
assign int_en = interrupts_enabled;

wire [1:0] ir_mode = ir[31:30];
wire [6:0] ir_op;
wire [3:0] ir_ra   = ir[19:16];
wire [3:0] ir_rb   = ir[15:12];
wire [3:0] ir_rc   = ir[11:8];

wire ccr_ltu, ccr_lt, ccr_eq;
assign { ccr_ltu, ccr_lt, ccr_eq } = ccr;

reg [3:0] state, state_next;
reg [4:0] seq, seq_next;
reg interrupts_enabled, interrupts_enabled_next;
reg [3:0] exception_next;

localparam [3:0] STATE_FETCHIR = 4'h0, STATE_EVALIR = 4'h1, STATE_FETCHARG = 4'h2, STATE_EVALARG = 4'h3, STATE_HALT = 4'h4;
localparam [3:0] STATE_EXCEPTION = 4'h5, STATE_RESET = 4'h6, STATE_FETCHDOUBLE = 4'h7;
localparam MODE_REG = 2'h0, MODE_REGIND = 2'h1, MODE_IMM = 2'h2, MODE_DIR = 2'h3;
localparam REG_WRITE_NONE = 1'b0, REG_WRITE_DW = 1'b1;

parameter REG_SP = 4'hf;

always @(ir_mode or ir)
case (ir_mode)
  MODE_REG:    ir_op = ir[29:23];
  MODE_REGIND: ir_op = { 3'b000, ir[29:26] };
  MODE_IMM:    ir_op = { 3'b000, ir[29:26] };
  MODE_DIR:    ir_op = { 1'b0, ir[29:24] };
endcase

// tacky to peek at this, but need it for trap
wire [31:0] ir_uval = { 16'h0000, ir[23:20], ir[11:0] };

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_RESET;
    seq <= 5'h0;
    interrupts_enabled = 1'b0;
    exception <= 4'h0;
  end else begin
    seq <= seq_next;
    state <= state_next;
    interrupts_enabled <= interrupts_enabled_next;
    exception <= exception_next;
  end
end

always @(*)
begin
  state_next = state;
  seq_next = seq;
  interrupts_enabled_next = interrupts_enabled;
  exception_next = exception;
  ir_write = 1'b0;
  alu_func = 3'h2; // add
  alu1sel = 3'b0; // reg_data_out1
  ccrsel = 2'h0;
  alu2sel = 3'b0; // reg_data_out2
  regsel = 4'b0; // aluout
  fp_addsub = 1'b0;
  reg_read_addr1 = ir_ra;
  reg_read_addr2 = ir_rb;
  reg_write_addr = ir_ra;
  reg_write = 1'b0;
  mdrsel = 4'b0;
  marsel = 3'b0;
  int1sel = 2'b0;
  int2sel = 2'b0;
  int_func = 3'b0;
  fpccrsel = 2'b0;
  addrsel = 1'b0; // PC
  pcsel = 3'b0;
  bus_read = 1'b0;
  bus_write = 1'b0;
  ir_write = 1'b0;
  byteenable = 5'b01111;
  vectoff_write = 1'b0;
  
  case (state)
    STATE_RESET: begin
      exception_next = 4'h0;
      state_next = STATE_EXCEPTION;
    end
    STATE_EXCEPTION: begin
      // for everyone except reset, we need to push the PC onto the stack, just like jsr
      case (seq)
        3'h0: begin
          if (exception == 4'h0)
            seq_next = 3'h3;
          else begin
            alu2sel = 3'h4; // aluout <= SP - 'h4
            alu_func = 3'h3; // -
            reg_read_addr1 = REG_SP; // SP
            seq_next = 3'h1;
            mdrsel = 4'h6; // MDR <= PC
          end
        end
        3'h1: begin
          marsel = 3'h2; // mar <= aluout
          reg_write_addr = REG_SP; // SP <= aluout
          reg_write = REG_WRITE_DW;
          addrsel = 1'b1; // MAR
          bus_write = 1'b1;
          seq_next = 3'h2;
        end
        3'h2: begin
          addrsel = 1'b1; // MAR
          bus_write = 1'b1;            
          if (bus_wait == 1'b0)
            seq_next = 3'h3;
        end
        3'h3: begin
          pcsel = 3'h5; // load exception_next handler address into PC
          seq_next = 3'h4;
        end
        3'h4: begin
          bus_read = 1'b1;
          if (bus_wait == 1'b0)
            seq_next = 3'h5;
        end
        3'h5: begin
          bus_read = 1'b1;
          marsel = 3'h1; // MAR <= vector address
          seq_next = 3'h6;
        end
        3'h6: begin
          pcsel = 3'h2; // PC <= MAR
          seq_next = 3'h0;
          state_next = STATE_FETCHIR;
        end
        default: state_next = STATE_HALT;
      endcase
    end
    STATE_FETCHIR: begin
      case (seq)
        3'h0: begin
          bus_read = 1'b1;
          if (|interrupt && interrupts_enabled) begin
            state_next = STATE_EXCEPTION;
            interrupts_enabled_next = 1'b0;
            exception_next = { 1'b0, interrupt};
          end else
            if (bus_wait == 1'b0) // wait until we get control of bus
              seq_next = 3'h1;
        end
        3'h1: begin
          bus_read = 1'b1; // still assert bus control
          ir_write = 1'b1; // latch bus into ir
          seq_next = 3'h2;
        end
        3'h2: begin
          pcsel = 3'b1; // move PC forward
          seq_next = 3'b0;
          state_next = STATE_EVALIR;
        end
        default: state_next = STATE_HALT;
      endcase
    end
    STATE_EVALIR: begin
      casex ({ir_mode, ir_op})
        {MODE_REG, 7'h00}: state_next = STATE_FETCHIR; // nop
        {MODE_REG, 7'h01}: begin // rts
          case (seq)
            3'h0: begin
              reg_read_addr1 = REG_SP; // SP
              marsel = 3'h3; // mar <= SP
              seq_next = 3'h1;
            end
            3'h1: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              if (bus_wait == 1'b0)
                seq_next = 3'h2;
            end
            3'h2: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              marsel = 3'h1; // mar <= databus
              alu2sel = 3'h4; // aluout <= SP + 'h4
              reg_read_addr1 = REG_SP; // SP
              seq_next = 3'h3;
            end
            3'h3: begin
              pcsel = 3'h2; // PC <= mar 
              reg_write = REG_WRITE_DW; // SP <= aluout 
              reg_write_addr = REG_SP;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REG, 7'h02}: begin // rti
          // almost the same as rts, but reenable interrupts
          case (seq)
            3'h0: begin
              interrupts_enabled_next = 1'b1;
              exception_next = 4'h0;
              reg_read_addr1 = REG_SP; // SP
              marsel = 3'h3; // mar <= SP
              seq_next = 3'h1;
            end
            3'h1: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              if (bus_wait == 1'b0)
                seq_next = 3'h2;
            end
            3'h2: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              marsel = 3'h1; // mar <= databus
              alu2sel = 3'h4; // aluout <= SP + 'h4
              reg_read_addr1 = REG_SP; // SP
              seq_next = 3'h3;
            end
            3'h3: begin
              pcsel = 3'h2; // PC <= mar 
              reg_write = REG_WRITE_DW; // SP <= aluout 
              reg_write_addr = REG_SP;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end          
        {MODE_REG, 7'h03}: begin // inc rA
          case (seq)
            3'h0: begin
              alu2sel = 'h2; // aluval <= regA + 1
              seq_next = 3'h1;
            end
            3'h1: begin
              reg_write = REG_WRITE_DW; // rA <= aluval
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REG, 7'h04}: begin // dec rA
          case (seq)
            3'h0: begin
              alu_func = 'h3; // sub
              alu2sel = 'h2; // aluval <= regA - 1
              seq_next = 3'h1;
            end
            3'h1: begin  
              reg_write = REG_WRITE_DW; // rA <= aluval
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REG, 7'h05}: begin // push rA
          case (seq)
            3'h0: begin
              alu2sel = 3'h4; // aluout <= SP - 'h4
              alu_func = 3'h3; // -
              reg_read_addr1 = REG_SP; // SP
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluout
              mdrsel = 4'h3; // mdr <= rA
              reg_write_addr = REG_SP; // SP <= aluout
              reg_write = REG_WRITE_DW;
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;
              seq_next = 3'h2;
            end
            3'h2: begin
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;            
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              addrsel = 1'b1;
              seq_next = 3'h4;
            end
            3'h4: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REG, 7'h06}: begin // pop rA
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              marsel = 3'h3; // mar <= SP
              alu2sel = 3'h4; // aluout <= SP + 'h4
              reg_read_addr1 = REG_SP; // SP
              seq_next = 3'h1;
            end
            3'h1: begin
              reg_write = REG_WRITE_DW; // SP <= aluout 
              reg_write_addr = REG_SP;
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              bus_read = 1'b1;
              mdrsel = 4'h1; // mdr <= busread
              seq_next = 3'h4;
            end
            3'h4: begin
              regsel = 4'h1; // rA <= mdr 
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REG, 7'h09}: begin // cmp
          alu_func = 'h3; // sub
          ccrsel = 2'h1; // set values in CCR
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h0a}: begin // mov
          regsel = 4'h4; // reg_data_out2
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h0b}: begin // com
          regsel = 4'h3; // ~reg_data_out2
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h0c}: begin // neg
          regsel = 4'h2; // -reg_data_out2
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h0d}: begin // cmp.s
          case (seq)
            4'h3: begin
              seq_next = 4'h0;
              ccrsel = 2'h3;
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_REG, 7'h10}: begin // cvtis
          case (seq)
            4'ha: begin
              seq_next = 4'hb;
              mdrsel = 4'h7;
            end
            4'hb: begin
              seq_next = 4'h0;
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_REG, 7'h11}: begin // cvtsi
          case (seq)
            4'ha: begin
              seq_next = 4'hb;
              mdrsel = 4'h8;
            end
            4'hb: begin
              seq_next = 4'h0;
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_REG, 7'h12}: begin // ext.b
          regsel = 4'h9; // reg_data_out2[7:0] + extend
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h13}: begin // ext
          regsel = 4'ha; // reg_data_out2[15:0] + extend
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h14}: begin // cli
          interrupts_enabled_next = 1'b0;
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h15}: begin // sti
          interrupts_enabled_next = 1'b1;
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 7'h1c}: begin // sqrt.s
          case (seq)
            5'h11: begin
              seq_next = 5'h12;
              mdrsel = 4'hc; // MDR <= fp_sqrt
            end
            5'h12: begin
              seq_next = 5'h0;
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_REG, 7'h2x}: begin // alu rA <= rB + rC
          alu_func = ir_op[2:0];
          reg_read_addr1 = ir_rb;
          reg_read_addr2 = ir_rc;
          case (seq)
            3'h0: seq_next = 3'h1;
            3'h1: begin
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REG, 7'h3x}: begin // [un]signed rA <= rB * / % rC
          case (ir_op)
            'h31: int_func = 'b001;
            'h32: int_func = 'b010;
            'h33: int_func = 'b100;
            'h34: int_func = 'b101;
            'h35: int_func = 'b110;
            default: int_func = 'b000;
          endcase
          reg_read_addr1 = ir_rb;
          reg_read_addr2 = ir_rc;
          case (seq)
            4'hc: begin
              if (ir_op == 'h36 || ir_op == 'h37)
                mdrsel = 4'h5; // MDR <= intout[63:32]
              else
                mdrsel = 4'h4; // MDR <= intout[31:0]
              seq_next = 4'hd;
            end
            4'hd: begin
              seq_next = 4'h0;
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_REG, 7'h4x}: begin // fp math
          fp_addsub =  (ir_op == 7'h40 || ir_op == 7'h44);
          reg_read_addr1 = ir_rb;
          reg_read_addr2 = ir_rc;
          case (seq)
            5'h0: begin
              case (ir_op)
                7'h40: seq_next = 5'ha;
                7'h41: seq_next = 5'ha;
                7'h42: seq_next = 5'h8;
                7'h43: seq_next = 5'h9;
                default: seq_next = 5'h0;
              endcase
            end
            5'h2: begin
              seq_next = 5'h1;
              case (ir_op)
                7'h40: begin
                  mdrsel = 4'h9; // MDR <= fp_addsub
                  fpccrsel = 2'h1;
                end
                7'h41: begin
                  mdrsel = 4'h9; // MDR <= fp_addsub
                  fpccrsel = 2'h1;
                end
                7'h42: begin
                  mdrsel = 4'ha; // MDR <= fp_mult
                  fpccrsel = 2'h2;
                end
                7'h43: begin
                  mdrsel = 4'hb; // MDR <= fp_div
                  fpccrsel = 2'h3;
                end
                default: mdrsel = 4'h0;
              endcase
            end
            5'h1: begin
              seq_next = 5'h0;
              regsel = 4'h1; // fp_rA <= MDR
              reg_write = REG_WRITE_DW;
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq - 1'b1;
          endcase
        end
        {MODE_IMM, 7'h00}: begin // bra
          state_next = STATE_FETCHIR;
          pcsel = 3'h3; // relbranch
        end
        {MODE_IMM, 7'h01}: begin // beq
          state_next = STATE_FETCHIR;
          if (ccr_eq)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h02}: begin // bne
          state_next = STATE_FETCHIR;
          if (~ccr_eq)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h04}: begin // bgt
          state_next = STATE_FETCHIR;
          if (~(ccr_lt | ccr_eq))
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h05}: begin // bge
          state_next = STATE_FETCHIR;
          if (~ccr_lt)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h06}: begin // ble
          state_next = STATE_FETCHIR;
          if (ccr_lt | ccr_eq)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h07}: begin // blt
          state_next = STATE_FETCHIR;
          if (ccr_lt)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h03}: begin // bgtu
          state_next = STATE_FETCHIR;
          if (~(ccr_ltu | ccr_eq))
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h08}: begin // bgeu
          state_next = STATE_FETCHIR;
          if (~ccr_ltu)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h09}: begin // bltu
          state_next = STATE_FETCHIR;
          if (ccr_ltu)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h0a}: begin // bleu
          state_next = STATE_FETCHIR;
          if (ccr_ltu | ccr_eq)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h0b}: begin // brn
          state_next = STATE_FETCHIR;
        end
        {MODE_IMM, 7'h0c}: begin // ldiu
          regsel = 4'h6; // rA <= unsigned 16bit
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_REGIND, 7'h00}: begin // st.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluval
              mdrsel = 4'h3; // MDR <= rA
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1; //  addrbus <= MAR
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h02}: begin // st
          addrsel = 1'b1; // MAR
          byteenable = (bus_align[1] ? 5'b00011 : 5'b01100);
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluval
              mdrsel = 4'h3; // MDR <= rA (with bytelanes)
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1;
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h04}: begin // st.b
          addrsel = 1'b1; // MAR
          case (bus_align[1:0])
            2'b00: byteenable = 5'b01000;
            2'b01: byteenable = 5'b00100;
            2'b10: byteenable = 5'b00010;
            2'b11: byteenable = 5'b00001;
          endcase
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluval
              mdrsel = 4'h3; // MDR <= rA
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1; // addrbus <= MAR
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h01}: begin // ld.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              mdrsel = 4'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h03}: begin // ld
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              byteenable = (bus_align[1] ? 5'b00011 : 5'b01100);
              mdrsel = 4'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h05}: begin // ld.b
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              case (bus_align[1:0])
                2'b00: byteenable = 5'b01000;
                2'b01: byteenable = 5'b00100;
                2'b10: byteenable = 5'b00010;
                2'b11: byteenable = 5'b00001;
              endcase
              mdrsel = 4'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h09}: begin // jmp
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              pcsel = 3'h4; // PC <= aluval
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_REGIND, 7'h0a}: begin // jsr
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              alu2sel = 3'h4; // aluout <= SP - 'h4
              alu_func = 3'h3; // -
              reg_read_addr1 = REG_SP; // SP
              mdrsel = 4'h6; // MDR <= PC
              pcsel = 3'h4; // PC <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              marsel = 3'h2; // mar <= aluout
              reg_write_addr = REG_SP; // SP <= aluout
              reg_write = REG_WRITE_DW;
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;
              seq_next = 3'h3;
            end
            3'h3: begin
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;            
              if (bus_wait == 1'b0)
                seq_next = 3'h4;
            end
            3'h4: begin
              addrsel = 1'b1;
              seq_next = 3'h5;
            end
            3'h5: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_DIR, 7'h0x}: begin // alu rA <= rB + 0x1234
          alu_func = ir_op[2:0];
          reg_read_addr1 = ir_rb;
          alu2sel = 3'h1; // sval
          case (seq)
            3'h0: seq_next = 3'h1;
            3'h1: begin
              reg_write = REG_WRITE_DW; // rA <= aluout
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        {MODE_DIR, 7'h10}: state_next = STATE_FETCHARG;    // std.l
        {MODE_DIR, 7'h11}: state_next = STATE_FETCHARG;    // ldd.l
        {MODE_DIR, 7'h12}: state_next = STATE_FETCHARG;    // std
        {MODE_DIR, 7'h13}: state_next = STATE_FETCHARG;    // ldd
        {MODE_DIR, 7'h14}: state_next = STATE_FETCHARG;    // std.b
        {MODE_DIR, 7'h15}: state_next = STATE_FETCHARG;    // ldd.b
        {MODE_DIR, 7'h16}: state_next = STATE_FETCHARG;    // std.d
        {MODE_DIR, 7'h17}: state_next = STATE_FETCHARG;    // ldd.d
        {MODE_DIR, 7'h18}: state_next = STATE_FETCHARG;    // ldi
        {MODE_DIR, 7'h19}: state_next = STATE_FETCHDOUBLE; // ldi.d
        {MODE_DIR, 7'h2x}: begin // [un]signed rA <= rB * / % 0x1234
          case (ir_op)
            'h21: int_func = 'b001;
            'h22: int_func = 'b010;
            'h23: int_func = 'b100;
            'h24: int_func = 'b101;
            'h25: int_func = 'b110;
            default: int_func = 'b000;
          endcase
          reg_read_addr1 = ir_rb;
          int2sel = 2'h1; // sval
          case (seq)
            'h6: begin
              if (ir_op == 'h26 || ir_op == 'h27)
                mdrsel = 4'h5; // MDR <= intout[63:32]
              else
                mdrsel = 4'h4; // MDR <= intout[31:0]
              seq_next = 3'h7;
            end
            'h7: begin
              seq_next = 3'h0;
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_DIR, 7'h30}: state_next = STATE_FETCHARG; // jmpd
        {MODE_DIR, 7'h31}: state_next = STATE_FETCHARG; // jsrd
        {MODE_DIR, 7'h32}: begin // trap
          exception_next = { 1'b1, ir_uval[2:0] }; // upper 8 are swi
          state_next = STATE_EXCEPTION;
        end
        {MODE_DIR, 7'h33}: state_next = STATE_FETCHARG; // setint
        default: begin
          exception_next = 4'h3; // bad opcode
          state_next = STATE_EXCEPTION;
        end
      endcase
    end
    STATE_FETCHARG: begin
      case (seq)
        3'h0: begin
          bus_read = 1'b1;
          if (bus_wait == 1'b0) // wait until we get control of bus
            seq_next = 3'h1;
        end
        3'h1: begin
          bus_read = 1'b1; // still assert bus control
          marsel = 3'h1; // mar <= busdata
          mdrsel = 4'h1 ; // mdr <= busdata
          seq_next = 3'h2;
        end
        3'h2: begin
          pcsel = 2'b1; // move PC forward
          seq_next = 3'b0;
          state_next = STATE_EVALARG;
        end
        default: state_next = STATE_HALT;
      endcase
    end
    STATE_FETCHDOUBLE: begin // two word load
      case (seq)
        4'h0: begin
          byteenable = 5'b11111;
          bus_read = 1'b1;
          if (bus_wait == 1'b0) // wait until we get control of bus
            seq_next = 4'h1;
        end
        4'h1: begin
          byteenable = 5'b11111;
          bus_read = 1'b1; // still assert bus control
          mdrsel = 4'h1 ; // mdr <= busdata
          seq_next = 4'h2;
        end
        4'h2: begin
          pcsel = 2'b1; // move PC forward
          seq_next = 4'h3;
        end
        4'h3: begin
          bus_read = 1'b1;
          if (bus_wait == 1'b0) // wait until we get control of bus
            seq_next = 4'h4;
        end
        4'h4: begin
          bus_read = 1'b1; // still assert bus control
          mdrsel = 4'h1 ; // mdr <= busdata
          seq_next = 4'h5;
        end
        4'h5: begin
          pcsel = 2'b1; // move PC forward
          seq_next = 4'b0;
          state_next = STATE_EVALARG;
        end
        default: state_next = STATE_HALT;
      endcase
    end
    STATE_EVALARG: begin
      casex (ir_op)
        7'h10: begin // std.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              mdrsel = 4'h3; // MDR <= rA
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_write = 1'b1; //  addrbus <= MAR
              if (bus_wait == 1'b0)
                seq_next = 3'h2;
            end
            3'h2: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h11: begin // ldd.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin // allow address to settle
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_read = 1'b1;
              mdrsel = 4'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h2;
            end
            3'h2: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h12: begin // std
          addrsel = 1'b1; // MAR
          byteenable = (bus_align[1] ? 5'b00011 : 5'b01100);
          case (seq)
            3'h0: begin
              mdrsel = 4'h3; // MDR <= rA (with bytelanes)
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_write = 1'b1;
              if (bus_wait == 1'b0)
                seq_next = 3'h2;
            end
            3'h2: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h13: begin // ldd
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              bus_read = 1'b1;
              byteenable = (bus_align[1] ? 5'b00011 : 5'b01100);
              mdrsel = 4'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h14: begin // std.b
          addrsel = 1'b1; // MAR
          case (bus_align[1:0])
            2'b00: byteenable = 5'b01000;
            2'b01: byteenable = 5'b00100;
            2'b10: byteenable = 5'b00010;
            2'b11: byteenable = 5'b00001;
          endcase
          case (seq)
            3'h0: begin
              mdrsel = 4'h3; // MDR <= rA
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_write = 1'b1; // addrbus <= MAR
              if (bus_wait == 1'b0)
                seq_next = 3'h2;
            end
            3'h2: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h15: begin // ldd.b
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              bus_read = 1'b1;
              case (bus_align[1:0])
                2'b00: byteenable = 5'b01000;
                2'b01: byteenable = 5'b00100;
                2'b10: byteenable = 5'b00010;
                2'b11: byteenable = 5'b00001;
              endcase
              mdrsel = 4'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h16: begin // std.d
        end
        7'h17: begin // ldd.d
        end
        7'h18: begin // ldi
          state_next = STATE_FETCHIR;
          regsel = 4'h1; // rA <= MDR
          reg_write = REG_WRITE_DW;        
        end
        7'h19: begin // ldi.d
          state_next = STATE_FETCHIR;
          regsel = 4'h1; // rA <= MDR
          reg_write = REG_WRITE_DW;        
        end
        7'h30: begin // jmpd
          state_next = STATE_FETCHIR;
          pcsel = 3'h2; // PC <= MAR;
        end
        7'h31: begin // jsrd = push PC, jmp
          case (seq)
            3'h0: begin
              alu2sel = 3'h4; // aluout <= SP - 'h4
              alu_func = 3'h3; // -
              reg_read_addr1 = REG_SP; // SP
              seq_next = 3'h1;
              mdrsel = 4'h6; // MDR <= PC
              pcsel = 3'h2; // PC <= MAR
            end
            3'h1: begin
              marsel = 3'h2; // mar <= aluout
              reg_write_addr = REG_SP; // SP <= aluout
              reg_write = REG_WRITE_DW;
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;
              seq_next = 3'h2;
            end
            3'h2: begin
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;            
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              addrsel = 1'b1;
              seq_next = 3'h4;
            end
            3'h4: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h33: begin // setint
          vectoff_write = 1'b1;
          state_next = STATE_FETCHIR;  
        end
        default: begin
          exception_next = 4'h3; // bad opcode
          state_next = STATE_EXCEPTION;
        end
      endcase
    end
    STATE_HALT: state_next = STATE_HALT;
    default: state_next = STATE_HALT;
  endcase
end

endmodule
