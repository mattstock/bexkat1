module control(
  input clock,
  input reset_n,
  input [31:0] ir,
  output ir_write,
  input [3:0] ccr,
  output ccr_write,
  output [2:0] alu_func,
  output [1:0] alu1sel,
  output [2:0] alu2sel,
  output [2:0] regsel,
  output [4:0] reg_read_addr1,
  output [4:0] reg_read_addr2,
  output [4:0] reg_write_addr,
  output [1:0] reg_write,
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
  input bus_wait,
  input [1:0] bus_align);

wire [2:0] ir_mode = ir[31:29];
wire [7:0] ir_op   = ir[28:21];
wire [4:0] ir_ra   = ir[20:16];
wire [4:0] ir_rb   = ir[15:11];
wire [4:0] ir_rc   = ir[10:6];
wire carry, negative, overflow, zero;

assign {carry, negative, overflow, zero} = ccr;

reg [3:0] state, state_next;
reg [2:0] seq, seq_next;

localparam [3:0] STATE_FETCHIR = 4'h0, STATE_EVALIR = 4'h1, STATE_FETCHARG= 4'h2, STATE_EVALARG = 4'h3, STATE_FAULT = 4'h4, STATE_RESET = 4'h5;
localparam MODE_REG = 3'h0, MODE_REGIND = 3'h1, MODE_IMM = 3'h2, MODE_DIR = 3'h4;
localparam REG_WRITE_NONE = 2'b00, REG_WRITE_DW = 2'b11;
localparam REG_SP = 5'b11111;

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_RESET;
    seq <= 3'h0;
  end else begin
    seq <= seq_next;
    state <= state_next;
  end
end

always @(*)
begin
  state_next = state;
  seq_next = seq;
  ir_write = 1'b0;
  alu_func = 3'h2; // add
  alu1sel = 2'b0; // reg_data_out1
  ccr_write = 1'b0;
  alu2sel = 3'b0; // reg_data_out2
  regsel = 3'b0; // aluout
  reg_read_addr1 = ir_ra;
  reg_read_addr2 = ir_rb;
  reg_write_addr = ir_ra;
  reg_write = 2'b00;
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
    STATE_RESET: state_next = STATE_FETCHIR;
    STATE_FETCHIR: begin
      case (seq)
        3'h0: begin
          bus_read = 1'b1;
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
        default: state_next = STATE_FAULT;
      endcase
    end
    STATE_EVALIR: begin
      casex ({ir_mode, ir_op})
        {MODE_REG, 8'h00}: state_next = STATE_FETCHIR; // nop
        {MODE_REG, 8'h01}: begin // rts
          case (seq)
            3'h0: begin
              reg_read_addr1 = REG_SP;
              marsel = 2'h3; // mar <= SP
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              alu2sel = 3'h4; // aluval <= SP + 4
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              marsel = 2'h1; // mar <= busread
              reg_write_addr = REG_SP;
              reg_write = REG_WRITE_DW;
              regsel = 3'h0; // SP <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              pcsel = 3'h2; // PC <= mar 
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REG, 8'h05}: begin // push rA
          case (seq)
            3'h0: begin // ALUOUT <= SP - 4
              reg_read_addr1 = REG_SP;
              alu_func = 'h3; // sub
              alu2sel = 3'h4; // 4
              reg_read_addr2 = ir_ra;
              mdrsel = 3'h2; // mdr <= rA
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              reg_write_addr = REG_SP;
              reg_write = REG_WRITE_DW;
              regsel = 3'h0; // SP <= aluval
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
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REG, 8'h06}: begin // pop rA
          case (seq)
            3'h0: begin
              reg_read_addr1 = REG_SP;
              marsel = 2'h3; // mar <= SP
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              alu2sel = 3'h4; // aluval <= SP + 4
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              addrsel = 1'b1; // MAR
              bus_read = 1'b1;
              mdrsel = 3'h1; // mdr <= busread
              reg_write_addr = REG_SP;
              reg_write = REG_WRITE_DW;
              regsel = 3'h0; // SP <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              regsel = 3'h1; // rA <= mdr 
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REG, 8'h02}: begin // cmp
          alu_func = 'h3; // sub
          ccr_write = 1'b1; // set values in CCR
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 8'h03}: begin // inc rA
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
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REG, 8'h04}: begin // dec rA
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
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REG, 8'h07}: begin // mov
          regsel = 3'h4; // reg_data_out2
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 8'h08}: begin // com
          regsel = 3'h3; // ~reg_data_out2
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 8'h09}: begin // neg
          regsel = 3'h2; // -reg_data_out2
          reg_write = REG_WRITE_DW;          
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 8'h2x}: begin // alu rA <= rB + rC
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
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REG, 8'h3x}: begin // [un]signed rA <= rB * / % rC
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
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        {MODE_IMM, 8'h00}: begin // bra
          state_next = STATE_FETCHIR;
          pcsel = 3'h3; // relbranch
        end
        {MODE_IMM, 8'h01}: begin // beq
          state_next = STATE_FETCHIR;
          if (zero)
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h02}: begin // bne
          state_next = STATE_FETCHIR;
          if (~zero)
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h03}: begin // bgtu
          state_next = STATE_FETCHIR;
          if (~(zero | carry))
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h04}: begin // bgt
          state_next = STATE_FETCHIR;
          if (~(zero | (negative ^ overflow)))
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h05}: begin // bge
          state_next = STATE_FETCHIR;
          if (~(negative ^ overflow))
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h06}: begin // ble
          state_next = STATE_FETCHIR;
          if (zero | (negative ^ overflow))
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h07}: begin // blt
          state_next = STATE_FETCHIR;
          if (negative ^ overflow)
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h08}: begin // bgeu
          state_next = STATE_FETCHIR;
          if (~carry)
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h09}: begin // bltu
          state_next = STATE_FETCHIR;
          if (carry)
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h0a}: begin // bleu
          state_next = STATE_FETCHIR;
          if (carry | zero)
            pcsel = 3'h3;
        end
        {MODE_IMM, 8'h0b}: begin // brn
          state_next = STATE_FETCHIR;
        end
        {MODE_IMM, 8'h0c}: begin // ldis
          regsel = 3'h5; // rA <= signed 16bit
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_IMM, 8'h0d}: begin // ldiu
          regsel = 3'h6; // rA <= unsigned 16bit
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_REGIND, 8'h0a}: begin // lda
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
              seq_next = 3'h1;
            end
            3'h1: begin
              reg_write = REG_WRITE_DW; // rA <= aluval
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h00}: begin // st.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              mdrsel = 3'h3; // MDR <= rA
              bus_write = 1'b1; //  addrbus <= MAR
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h02}: begin // st
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1;
              byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
              mdrsel = 3'h3; // MDR <= rA (with bytelanes)
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h04}: begin // st.b
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_write = 1'b1; // addrbus <= MAR
              mdrsel = 3'h3; // MDR <= rA
              case (bus_align[1:0])
                2'b00: byteenable = 4'b1000;
                2'b01: byteenable = 4'b0100;
                2'b10: byteenable = 4'b0010;
                2'b11: byteenable = 4'b0001;
              endcase
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h01}: begin // ld.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
              seq_next = 3'h1;
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              seq_next = 3'h2;
            end
            3'h2: begin
              bus_read = 1'b1;
              mdrsel = 3'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h03}: begin // ld
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
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
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h05}: begin // ld.b
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
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
              if (bus_wait == 1'b0)
                seq_next = 3'h3;
            end
            3'h3: begin
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_REGIND, 8'h0b}: begin // jmp
          case (seq)
            3'h0: begin
              reg_read_addr1 = ir_rb;
              alu2sel = 3'h1; // aluval <= rB + ir_ind
              seq_next = 3'h1;
            end
            3'h1: begin
              pcsel = 3'h4; // PC <= aluval
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        {MODE_DIR, 8'hxx}: state_next = STATE_FETCHARG;
        default: state_next = STATE_FAULT;
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
          marsel = 2'h1; // mar <= busdata
          mdrsel = 3'h1 ; // mdr <= busdata
          seq_next = 3'h2;
        end
        3'h2: begin
          pcsel = 2'b1; // move PC forward
          seq_next = 3'b0;
          state_next = STATE_EVALARG;
        end
        default: state_next = STATE_FAULT;
      endcase
    end
    STATE_EVALARG: begin
      casex (ir_op)
        8'h0x: begin // alu rA <= rB + 0x12345678
          alu_func = ir_op[2:0];
          reg_read_addr1 = ir_rb;
          alu2sel = 3'h5; // MDR
          case (seq)
            3'h0: seq_next = 3'h1;
            3'h1: begin
              reg_write = REG_WRITE_DW; // rA <= aluout
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h2x: begin // [un]signed rA <= rB * / % 0x12345678
          case (ir_op)
            'h21: int_func = 'b001;
            'h22: int_func = 'b010;
            'h23: int_func = 'b100;
            'h24: int_func = 'b101;
            'h25: int_func = 'b110;
            default: int_func = 'b000;
          endcase
          reg_read_addr1 = ir_rb;
          int2sel = 2'h1; // MDR
          case (seq)
            'h6: begin
              seq_next = 3'h7;
              mdrsel = 3'h4; // MDR <= intout[31:0]
            end
            'h7: begin
              seq_next = 3'h0;
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;              
              state_next = STATE_FETCHIR;
            end
            default: seq_next = seq + 1'b1;
          endcase
        end
        8'h3c: begin // ldi
          state_next = STATE_FETCHIR;
          regsel = 3'h1; // rA <= MDR
          reg_write = REG_WRITE_DW;        
        end
        8'h3a: begin // jmpd
          state_next = STATE_FETCHIR;
          pcsel = 3'h2; // PC <= MAR;
        end
        8'h30: begin // std.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              mdrsel = 3'h3; // MDR <= rA
              bus_write = 1'b1; //  addrbus <= MAR
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h32: begin // std
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              bus_write = 1'b1;
              byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
              mdrsel = 3'h3; // MDR <= rA (with bytelanes)
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h34: begin // std.b
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              bus_write = 1'b1; // addrbus <= MAR
              mdrsel = 3'h3; // MDR <= rA
              case (bus_align[1:0])
                2'b00: byteenable = 4'b1000;
                2'b01: byteenable = 4'b0100;
                2'b10: byteenable = 4'b0010;
                2'b11: byteenable = 4'b0001;
              endcase
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h31: begin // ldd.l
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              bus_read = 1'b1;
              mdrsel = 3'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h33: begin // ldd
          addrsel = 1'b1; // MAR
          case (seq)
            3'h0: begin
              bus_read = 1'b1;
              byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
              mdrsel = 3'h1; // MDR <= databus
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h35: begin // ldd.b
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
              if (bus_wait == 1'b0)
                seq_next = 3'h1;
            end
            3'h1: begin
              regsel = 3'h1; // rA <= MDR
              reg_write = REG_WRITE_DW;
              seq_next = 3'h0;
              state_next = STATE_FETCHIR;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        8'h3b: begin // jsrd = push PC, jmp
          case (seq)
            3'h0: begin // aluval <= SP - 4
              reg_read_addr1 = REG_SP;
              alu_func = 'h3; // sub
              alu2sel = 3'h4; // 4
              seq_next = 3'h1;
              mdrsel = 3'h6; // MDR <= PC
              pcsel = 3'h2; // PC <= MAR
            end
            3'h1: begin
              marsel = 2'h2; // mar <= aluval
              reg_write_addr = REG_SP;
              reg_write = REG_WRITE_DW;
              regsel = 3'h0; // SP <= aluval
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
              state_next = STATE_FETCHIR;
              seq_next = 3'h0;
            end
            default: state_next = STATE_FAULT;
          endcase
        end
        default: state_next = STATE_FAULT;
      endcase
    end
    STATE_FAULT: state_next = STATE_FAULT;
    default: state_next = STATE_FAULT;
  endcase
end

endmodule
