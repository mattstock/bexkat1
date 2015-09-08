module control(
  input clock,
  input reset_n,
  input [31:0] ir,
  output ir_write,
  input [3:0] ccr,
  output ccr_write,
  output [2:0] alu_func,
  output [2:0] alu1sel,
  output [2:0] alu2sel,
  output [3:0] regsel,
  output [3:0] reg_read_addr1,
  output [3:0] reg_read_addr2,
  output [3:0] reg_write_addr,
  output reg_write,
  output [2:0] mdrsel,
  output [1:0] marsel,
  output [1:0] int1sel,
  output [1:0] int2sel,
  output [2:0] int_func,
  output [2:0] pcsel,
  output addrsel,
  output [3:0] byteenable,
  output bus_read,
  output bus_write,
  output halt,
  output vectoff_write,
  input supervisor,
  input bus_wait,
  input busfault,
  input [1:0] bus_align);

assign vectoff_write = 1'b0; // hardcode interrupt vector offset
assign halt = (state == STATE_HALT);

wire [1:0] ir_mode = ir[31:30];
wire [6:0] ir_op;
wire [3:0] ir_ra   = ir[19:16];
wire [3:0] ir_rb   = ir[15:12];
wire [3:0] ir_rc   = ir[11:8];

wire carry, negative, overflow, zero;
assign {carry, negative, overflow, zero} = ccr;

reg [3:0] state, state_next;
reg [2:0] seq, seq_next;
reg [3:0] exception, exception_next;

localparam [3:0] STATE_FETCHIR = 4'h0, STATE_EVALIR = 4'h1, STATE_FETCHARG = 4'h2, STATE_EVALARG = 4'h3, STATE_HALT = 4'h4, STATE_EXCEPTION = 4'h5, STATE_RESET = 4'h6;
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

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_RESET;
    seq <= 3'h0;
    exception <= 4'h0;
  end else begin
    seq <= seq_next;
    state <= state_next;
    exception <= exception_next;
  end
end

always @(*)
begin
  state_next = state;
  seq_next = seq;
  exception_next = exception;
  ir_write = 1'b0;
  alu_func = 3'h2; // add
  alu1sel = 3'b0; // reg_data_out1
  ccr_write = 1'b0;
  alu2sel = 3'b0; // reg_data_out2
  regsel = 4'b0; // aluout
  reg_read_addr1 = ir_ra;
  reg_read_addr2 = ir_rb;
  reg_write_addr = ir_ra;
  reg_write = 1'b0;
  mdrsel = 3'b0;
  marsel = 2'b0;
  int1sel = 2'b0;
  int2sel = 2'b0;
  int_func = 3'b0;
  addrsel = 1'b0; // PC
  pcsel = 3'b0;
  bus_read = 1'b0;
  bus_write = 1'b0;
  ir_write = 1'b0;
  byteenable = 4'b1111;
  
  case (state)
    STATE_RESET: begin
      case (seq)
        3'h0: begin
          pcsel = 3'h5; // load exception_next handler address into PC
          bus_read = 1'b1;
          if (busfault) begin
            state_next = STATE_EXCEPTION;
            exception_next = 4'h1;
          end else
            if (bus_wait == 1'b0)
              seq_next = 3'h1;
        end
        3'h1: begin
          bus_read = 1'b1;
          marsel = 2'h1; // MAR <= vector address
          seq_next = 3'h2;
        end
        3'h2: begin
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
          if (busfault) begin
            state_next = STATE_EXCEPTION;
            exception_next = 4'h1;
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
          // evaulate if we are leaving an exception_next state
          // pop other content off of stack
          // pop return point
          // revert priv mode to original
          case (seq)
            3'h0: begin
              reg_read_addr1 = REG_SP; // SP
              marsel = 2'h3; // mar <= SP
              seq_next = 3'h1;
            end
            3'h1: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
                if (bus_wait == 1'b0)
                  seq_next = 3'h2;
            end
            3'h2: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              marsel = 2'h1; // mar <= databus
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
              marsel = 2'h2; // mar <= aluout
              mdrsel = 3'h3; // mdr <= rA
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
              marsel = 2'h3; // mar <= SP
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
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
                if (bus_wait == 1'b0)
                  seq_next = 3'h3;
            end
            3'h3: begin
              bus_read = 1'b1;
              mdrsel = 3'h1; // mdr <= busread
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
          ccr_write = 1'b1; // set values in CCR
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
            'h6: begin
              seq_next = 3'h7;
              mdrsel = 3'h4; // MDR <= intout[31:0]
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
        {MODE_IMM, 7'h00}: begin // bra
          state_next = STATE_FETCHIR;
          pcsel = 3'h3; // relbranch
        end
        {MODE_IMM, 7'h01}: begin // beq
          state_next = STATE_FETCHIR;
          if (zero)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h02}: begin // bne
          state_next = STATE_FETCHIR;
          if (~zero)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h03}: begin // bgtu
          state_next = STATE_FETCHIR;
          if (~(zero | carry))
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h04}: begin // bgt
          state_next = STATE_FETCHIR;
          if (~(zero | (negative ^ overflow)))
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h05}: begin // bge
          state_next = STATE_FETCHIR;
          if (~(negative ^ overflow))
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h06}: begin // ble
          state_next = STATE_FETCHIR;
          if (zero | (negative ^ overflow))
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h07}: begin // blt
          state_next = STATE_FETCHIR;
          if (negative ^ overflow)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h08}: begin // bgeu
          state_next = STATE_FETCHIR;
          if (~carry)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h09}: begin // bltu
          state_next = STATE_FETCHIR;
          if (carry)
            pcsel = 3'h3;
        end
        {MODE_IMM, 7'h0a}: begin // bleu
          state_next = STATE_FETCHIR;
          if (carry | zero)
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
              marsel = 2'h2; // mar <= aluval
              mdrsel = 3'h3; // MDR <= rA
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1; //  addrbus <= MAR
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
          byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              mdrsel = 3'h3; // MDR <= rA (with bytelanes)
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1;
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
            2'b00: byteenable = 4'b1000;
            2'b01: byteenable = 4'b0100;
            2'b10: byteenable = 4'b0010;
            2'b11: byteenable = 4'b0001;
          endcase
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_sval
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              mdrsel = 3'h3; // MDR <= rA
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1; // addrbus <= MAR
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              mdrsel = 3'h1; // MDR <= databus
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
              mdrsel = 3'h1; // MDR <= databus
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              case (bus_align[1:0])
                2'b00: byteenable = 4'b1000;
                2'b01: byteenable = 4'b0100;
                2'b10: byteenable = 4'b0010;
                2'b11: byteenable = 4'b0001;
              endcase
              mdrsel = 3'h1; // MDR <= databus
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
              mdrsel = 3'h6; // MDR <= PC
              pcsel = 3'h4; // PC <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              marsel = 2'h2; // mar <= aluout
              reg_write_addr = REG_SP; // SP <= aluout
              reg_write = REG_WRITE_DW;
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;
              seq_next = 3'h3;
            end
            3'h3: begin
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;            
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
        {MODE_DIR, 7'h1x}: state_next = STATE_FETCHARG;
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
              seq_next = 3'h7;
              mdrsel = 3'h4; // MDR <= intout[31:0]
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
        {MODE_DIR, 7'h30}: state_next = STATE_FETCHARG;
        {MODE_DIR, 7'h31}: state_next = STATE_FETCHARG;
        {MODE_DIR, 7'h32}: begin // trap
          state_next = STATE_EXCEPTION; // TODO
        end
        default: state_next = STATE_HALT;
      endcase
    end
    STATE_FETCHARG: begin
      case (seq)
        3'h0: begin
          bus_read = 1'b1;
          if (busfault) begin
            state_next = STATE_EXCEPTION;
            exception_next = 4'h1;
          end else
            if (bus_wait == 1'b0) // wait until we get control of bus
              seq_next = 3'h1;
        end
        3'h1: begin
          bus_read = 1'b1; // still assert bus control
          marsel = 2'h1; // mar <= busdata
          mdrsel = 3'h1 ; // mdr <= busdata
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
    STATE_EVALARG: begin
      casex (ir_op)
        7'h10: begin // std.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              mdrsel = 3'h3; // MDR <= rA
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_write = 1'b1; //  addrbus <= MAR
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
              mdrsel = 3'h1; // MDR <= databus
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
          byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
          case (seq)
            3'h0: begin
              mdrsel = 3'h3; // MDR <= rA (with bytelanes)
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_write = 1'b1;
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
              byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
              mdrsel = 3'h1; // MDR <= databus
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
            2'b00: byteenable = 4'b1000;
            2'b01: byteenable = 4'b0100;
            2'b10: byteenable = 4'b0010;
            2'b11: byteenable = 4'b0001;
          endcase
          case (seq)
            3'h0: begin
              mdrsel = 3'h3; // MDR <= rA
              seq_next = 3'h1;
            end
            3'h1: begin
              bus_write = 1'b1; // addrbus <= MAR
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
                2'b00: byteenable = 4'b1000;
                2'b01: byteenable = 4'b0100;
                2'b10: byteenable = 4'b0010;
                2'b11: byteenable = 4'b0001;
              endcase
              mdrsel = 3'h1; // MDR <= databus
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
                if (bus_wait == 1'b0)
                  seq_next = 3'h1;
            end
            // std.s
            // ldd.s
            3'h1: begin
              regsel = 4'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_HALT;
          endcase
        end
        7'h18: begin // ldi
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
              mdrsel = 3'h6; // MDR <= PC
              pcsel = 3'h2; // PC <= MAR
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluout
              reg_write_addr = REG_SP; // SP <= aluout
              reg_write = REG_WRITE_DW;
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;
              seq_next = 3'h2;
            end
            3'h2: begin
              addrsel = 1'b1; // MAR
              bus_write = 1'b1;            
              if (busfault) begin
                state_next = STATE_EXCEPTION;
                exception_next = 4'h1;
              end else
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
        default: state_next = STATE_HALT;
      endcase
    end
    STATE_HALT: state_next = STATE_HALT;
    STATE_EXCEPTION: begin
      state_next = STATE_HALT;
      // check exception_next type
      // mark that we're in an exception_next in the CPU state
      // up priv mode if needed (supervisor stack)
      // put info onto stack
      // call exception_next handler code
    end
    default: state_next = STATE_HALT;
  endcase
end

endmodule
