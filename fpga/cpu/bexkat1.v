`timescale 1ns / 1ns

module bexkat1(
  input csi_clk,
  input rsi_reset_n,
  input avm_m0_waitrequest,
  output [31:0] avm_m0_address,
  output reg avm_m0_read,
  input [15:0] avm_m0_readdata,
  output [15:0] avm_m0_writedata,
  output reg avm_m0_write,
  output reg [1:0] avm_m0_byteenable);

reg [31:0] pc;
reg [32:0] pc_next;
reg [31:0] mar;
reg [32:0] mar_next;
reg [7:0] state, state_next, retstate, retstate_next;
reg [31:0] ir, ir_next;
reg avm_m0_write_next, avm_m0_read_next;
reg [1:0] avm_m0_byteenable_next;
reg [31:0] mdr, mdr_next;
reg [3:0] ccr, ccr_next;
reg [7:0] delay, delay_next;
reg addrsel, addrsel_next;
reg mdrsel, mdrsel_next;
reg [31:0] divmul2, divmul2_next;

// combinatorial stuff
reg [31:0] alu_in2;
reg [3:0] alu_func;
reg [2:0] int_func;
reg [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
reg [1:0] reg_write;

assign avm_m0_writedata = (mdrsel ? mdr[15:0] : mdr[31:16]);
assign avm_m0_address = (addrsel ? mar : pc);

wire data_access;
reg [31:0] reg_data_out1, reg_data_out2, reg_data_in;
wire carry, negative, overflow, zero;
wire alu_carry, alu_negative, alu_overflow, alu_zero;
wire [31:0] alu_out, fp_out, int_out, cvt_int_out, cvt_fp_out;

localparam STATE_FETCHIR1 = 8'h00, STATE_FETCHIR2 = 8'h01, STATE_FETCHIR3 = 8'h02, STATE_EVALIR1 = 8'h03, STATE_EVALIR2 = 8'h04, STATE_EVALIR3 = 8'h05;
localparam STATE_STORE = 8'h06, STATE_STORE2 = 8'h07;
localparam STATE_LOAD = 8'h08, STATE_LOAD2 = 8'h09, STATE_JSR = 8'h0a, STATE_JSR2 = 8'h0b;
localparam STATE_PUSH = 8'h0c, STATE_PUSH2 = 8'h0d, STATE_POP = 8'h0e, STATE_POP2 = 8'h0f;
localparam STATE_MEMLOAD = 8'h10, STATE_MEMSAVE = 8'h11, STATE_RTS = 8'h12, STATE_RTS2 = 8'h13, STATE_LOAD3 = 8'h14, STATE_FAULT = 8'h15;

localparam REG_SP = 5'b11111;
localparam MDR_HIGH = 1'b0, MDR_LOW = 1'b1;
localparam ADDR_PC = 1'b0, ADDR_MAR = 1'b1;

localparam MODE_INH2 = 3'h0, MODE_IMM3 = 3'h1, MODE_REGIND = 3'h2, MODE_REG = 3'h3, MODE_INH = 3'h4, MODE_IMM2 = 3'h5, MODE_DIR = 3'h6, MODE_IMM3a = 3'h7;

// opcode format
wire [2:0] ir_mode = ir[31:29];
wire [7:0] ir_op   = (ir[31] ? (ir[30:29] == 2'b00 ? { ir[28:26], 5'b00000 } : ir[28:21]) : { ir[28:26], ir[15:11] });
wire [4:0] ir_rb   = ir[25:21];
wire [4:0] ir_rc   = ir[4:0];
wire [4:0] ir_ra   = ir[20:16];

assign {carry, negative, overflow, zero} = ccr;

localparam REG_WRITE_NONE = 2'b00, REG_WRITE_W0 = 2'b01, REG_WRITE_W1 = 2'b10, REG_WRITE_DW = 2'b11;

always @(posedge csi_clk or negedge rsi_reset_n)
begin
  if (!rsi_reset_n) begin
    pc <= 'hffc00000; // start boot at base of monitor for now
    state <= STATE_FETCHIR1;
    ir <= 'h0000000;
    mdr <= 'h00000000;
    mar <= 'h00000000;
    addrsel <= ADDR_PC;
    mdrsel <= MDR_LOW;
    ccr <= 'h0;
    delay <= 'h0;
    avm_m0_write <= 1'b0;
    avm_m0_read <= 1'b0;
    avm_m0_byteenable <= 2'b11;
    divmul2 <= 'h1;
    retstate <= STATE_FETCHIR1;
  end else begin
    pc <= pc_next[31:0];
    state <= state_next;
    delay <= delay_next;
    ir <= ir_next;
    mdr <= mdr_next;
    mar <= mar_next[31:0];
    addrsel <= addrsel_next;
    mdrsel <= mdrsel_next;
    ccr <= ccr_next;
    avm_m0_read <= avm_m0_read_next;
    avm_m0_write <= avm_m0_write_next;
    avm_m0_byteenable <= avm_m0_byteenable_next;
    divmul2 <= divmul2_next;
    retstate <= retstate_next;
  end
end

always @*
begin
  pc_next = pc;
  state_next = state;
  delay_next = delay;
  ir_next = ir;
  mdr_next = mdr;
  avm_m0_write_next = avm_m0_write;
  avm_m0_read_next = avm_m0_read;
  mar_next = mar;
  addrsel_next = addrsel;
  mdrsel_next = mdrsel;
  ccr_next = ccr;
  avm_m0_byteenable_next = avm_m0_byteenable;
  divmul2_next = divmul2;
  retstate_next = retstate;
  
  // Control signals we need to deal with
  alu_func = 4'h2; // add is default
  int_func = 3'b000;
  reg_read_addr1 = ir_ra;
  reg_read_addr2 = ir_rb;
  reg_write_addr = ir_ra;
  reg_data_in = alu_out;
  reg_write = REG_WRITE_NONE;
  alu_in2 = 'h2;
  case (state)
    STATE_FETCHIR1: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_EVALIR1;
      avm_m0_write_next = 1'b0;
      avm_m0_read_next = 1'b1;
      avm_m0_byteenable_next = 2'b11;
      addrsel_next = ADDR_PC;
    end
    STATE_MEMLOAD: begin
      if (avm_m0_waitrequest == 1'b0) begin
        state_next = retstate;
        avm_m0_read_next = 1'b0;
	avm_m0_write_next = 1'b0; 
        avm_m0_byteenable_next = 2'b00;
        case (retstate)
          STATE_EVALIR1: begin
            ir_next = { avm_m0_readdata, 16'h0000 };
            pc_next = pc + 'h2;
          end
          STATE_EVALIR2: begin
            case (ir_mode)
              MODE_IMM2  : begin
                mar_next = { {16{avm_m0_readdata[15]}},avm_m0_readdata };
                mdr_next = { 16'h0000, avm_m0_readdata };
              end
              MODE_REGIND: begin
                mar_next = { {21{avm_m0_readdata[10]}}, avm_m0_readdata[10:0] };
                ir_next[15:0] = avm_m0_readdata;
              end
              MODE_DIR   : mar_next = { 16'h0000, avm_m0_readdata };
              MODE_IMM3a : mdr_next = { 16'h0000, avm_m0_readdata };
              default    : ir_next[15:0] = avm_m0_readdata;
            endcase
            pc_next = pc + 'h2;
          end
          STATE_EVALIR3: begin
            case (ir_mode)
              MODE_DIR: mar_next = { mar[15:0], avm_m0_readdata };
              default: mdr_next = { mdr[15:0], avm_m0_readdata }; 
            endcase
            pc_next = pc + 'h2;
          end
	  STATE_JSR: begin
	  end
	  STATE_JSR2: begin
	  end
          STATE_RTS: begin
            pc_next[31:16] = avm_m0_readdata;
            reg_read_addr1 = REG_SP;
            mar_next = reg_data_out1;
            reg_write = REG_WRITE_DW;
            reg_write_addr = REG_SP; // SP + 2
          end
          STATE_RTS2: begin
            pc_next[15:0] = avm_m0_readdata;
            reg_read_addr1 = REG_SP;
            mar_next = reg_data_out1;
            reg_write = REG_WRITE_DW;
            reg_write_addr = REG_SP; // SP + 2
          end
          STATE_POP: begin
            mdr_next[31:16] = avm_m0_readdata;
            reg_read_addr1 = REG_SP;
            mar_next = reg_data_out1;
            reg_write = REG_WRITE_DW;
            reg_write_addr = REG_SP; // SP + 2
          end
          STATE_POP2: begin
            mdr_next[15:0] = avm_m0_readdata;
            reg_read_addr1 = REG_SP;
            mar_next = reg_data_out1;
            reg_write = REG_WRITE_DW;
            reg_write_addr = REG_SP; // SP + 2
          end
          STATE_LOAD: mdr_next[31:16] = avm_m0_readdata;
          STATE_LOAD2: mdr_next[15:0] = avm_m0_readdata;
          STATE_LOAD3: begin
            case (avm_m0_byteenable)
              2'b10: mdr_next = { {24{avm_m0_readdata[15]}}, avm_m0_readdata[15:8] };
	            2'b01: mdr_next = { {24{avm_m0_readdata[7]}}, avm_m0_readdata[7:0] };
              default: mdr_next = { {16{avm_m0_readdata[15]}}, avm_m0_readdata };
            endcase
          end
          default:
            state_next = STATE_FAULT;
        endcase
      end
    end
    STATE_RTS: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_RTS2;
      avm_m0_read_next = 1'b1;
      avm_m0_byteenable_next = 2'b11;
      mar_next = reg_data_out1;
      addrsel_next = ADDR_MAR;
      reg_read_addr1 = REG_SP;
    end
    STATE_RTS2: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
    end
    STATE_MEMSAVE: begin
      if (avm_m0_waitrequest == 1'b0) begin
        state_next = retstate;
        avm_m0_write_next = 1'b0;
      end
    end
    STATE_EVALIR1: begin
      casex ({ir_mode, ir_op})
        {MODE_INH, 8'h0x}: state_next = STATE_FETCHIR1; // nop
        {MODE_INH, 8'h2x}: begin // rts
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_RTS;
          avm_m0_read_next = 1'b1;
          avm_m0_byteenable_next = 2'b11;
          reg_read_addr1 = REG_SP;
          mar_next = reg_data_out1;
          addrsel_next = ADDR_MAR;
        end
        {MODE_INH, 8'h4x}: begin // cmp
          alu_func = 'h3; // sub
          alu_in2 = reg_data_out2;
          if (delay == 'h0) begin
            delay_next = 'h2;
          end else begin
            delay_next = delay - 1'b1;
            if (delay == 'h1) begin
              ccr_next = {alu_carry, alu_negative, alu_overflow, alu_zero};
              state_next = STATE_FETCHIR1;
            end
          end
        end
        {MODE_INH, 8'h6x}: begin // inc rA
          alu_in2 = 'h1;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {MODE_INH, 8'h8x}: begin // dec rA
          alu_func = 'h3; // sub
          alu_in2 = 'h1;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {MODE_INH, 8'hax}: begin // push rA
          state_next = STATE_MEMSAVE;
          retstate_next = STATE_PUSH;
          avm_m0_write_next = 1'b1;
          avm_m0_read_next = 1'b0;
          avm_m0_byteenable_next= 2'b11;
          mar_next = alu_out;
          mdr_next = reg_data_out2;
          mdrsel_next = MDR_LOW;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = REG_SP;
          alu_func = 'h3; // sub
          reg_write = REG_WRITE_DW;
          reg_write_addr = REG_SP;
          reg_read_addr2 = ir_ra;
        end
        {MODE_INH, 8'hcx}: begin // pop rA
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_POP;
          avm_m0_read_next = 1'b1;
          avm_m0_byteenable_next = 2'b11;
          mar_next = reg_data_out1;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = REG_SP;
        end
        {MODE_INH, 8'hex}: begin // mov
          state_next = STATE_FETCHIR1;
          reg_read_addr1 = ir_rb;
          reg_data_in = reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        default: state_next = STATE_FETCHIR2;
      endcase
    end
    STATE_FETCHIR2: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_EVALIR2;
      avm_m0_write_next = 1'b0;
      avm_m0_read_next = 1'b1;
      avm_m0_byteenable_next = 2'b11;
      addrsel_next = ADDR_PC;
    end
    STATE_EVALIR2: begin
      casex ({ir_mode, ir_op})
        {MODE_INH2, 8'bxx0xxx1x}: begin // com
          state_next = STATE_FETCHIR1;
          reg_read_addr1 = ir_rb;
          reg_data_in = ~reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        {MODE_INH2, 8'bxx1xxx1x}: begin // neg
          state_next = STATE_FETCHIR1;
          reg_read_addr1 = ir_rb;
          reg_data_in = -reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        {MODE_IMM2, 8'bxxx1xxx0}: begin // ldis
          reg_data_in = mar;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {MODE_IMM2, 8'bxxx1xxx1}: begin // ldiu
          reg_data_in = mdr;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {MODE_IMM2, 8'bxxx00000}: begin // bra
          state_next = STATE_FETCHIR1;
          pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx00001}: begin // beq
          state_next = STATE_FETCHIR1;
          if (zero)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx00010}: begin // bne
          state_next = STATE_FETCHIR1;
          if (~zero)
            pc_next = { 1'b0, pc } + mar;        
        end
        {MODE_IMM2, 8'bxxx00011}: begin // bgtu
          state_next = STATE_FETCHIR1;
          if (~(zero | carry))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx00100}: begin // bgt
          state_next = STATE_FETCHIR1;
          if (~(zero | (negative ^ overflow)))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx00101}: begin // bge
          state_next = STATE_FETCHIR1;
          if (~(negative ^ overflow))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx00110}: begin // ble
          state_next = STATE_FETCHIR1;
          if (zero | (negative ^ overflow))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx00111}: begin // blt
          state_next = STATE_FETCHIR1;
          if (negative ^ overflow)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx01000}: begin // bgeu
          state_next = STATE_FETCHIR1;
          if (~carry)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx01001}: begin // bltu
          state_next = STATE_FETCHIR1;
          if (carry)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx01010}: begin // bleu
          state_next = STATE_FETCHIR1;
          if (carry | zero)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM2, 8'bxxx01011}: begin // brn
          state_next = STATE_FETCHIR1;
        end
        {MODE_REG, 8'bxx0xxxxx}: begin // alu rA <= rB + rC
          alu_func = ir_op[3:0];
          reg_read_addr1 = ir_rb;
          reg_read_addr2 = ir_rc;
          alu_in2 = reg_data_out2;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {MODE_REG, 8'bxx1xxxxx}: begin // [un]signed rA <= rB * / % rC
          case (ir_op)
            'h29: int_func = 'b001;
            'h2a: int_func = 'b010;
            'h2b: int_func = 'b100;
            'h2c: int_func = 'b101;
            'h2d: int_func = 'b110;
            default: int_func = 'b000;
          endcase
          reg_read_addr1 = ir_rb;
          reg_read_addr2 = ir_rc;
          divmul2_next = reg_data_out2;
          if (delay == 'h0) begin
            delay_next = 'h7;
          end else begin
            delay_next = delay - 1'b1;
            if (delay == 'h1) begin
              reg_data_in = int_out;
              reg_write = REG_WRITE_DW;
              state_next = STATE_FETCHIR1;
            end
          end
        end
        {MODE_REGIND, 8'h00}: begin // st.l
	  state_next = STATE_MEMSAVE;
	  retstate_next = STATE_STORE;
	  avm_m0_write_next = 1'b1;
	  avm_m0_read_next = 1'b0;
	  avm_m0_byteenable_next = 2'b11;
           
	  mar_next = alu_out;
	  addrsel_next = ADDR_MAR;
	  reg_read_addr1 = ir_rb;
          alu_in2 = mar;

          reg_read_addr2 = ir_ra;
          mdr_next = reg_data_out2;
          mdrsel_next = MDR_HIGH;
        end
        {MODE_REGIND, 8'h01}: begin // ld.l
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD;
          avm_m0_read_next = 1'b1;
          avm_m0_byteenable_next = 2'b11;

	  mar_next = alu_out;
	  addrsel_next = ADDR_MAR;
	  reg_read_addr1 = ir_rb;
          alu_in2 = mar;
        end
        {MODE_REGIND, 8'h02}: begin // st
	  state_next = STATE_MEMSAVE;
	  retstate_next = STATE_STORE2;
	  avm_m0_write_next = 1'b1;
	  avm_m0_read_next = 1'b0;
	  avm_m0_byteenable_next = 2'b11;
           
	  mar_next = alu_out;
	  addrsel_next = ADDR_MAR;
	  reg_read_addr1 = ir_rb;
          alu_in2 = mar;

          reg_read_addr2 = ir_ra;
          mdr_next = reg_data_out2;
          mdrsel_next = MDR_LOW;
        end
        {MODE_REGIND, 8'h03}: begin // ld
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD3;
          avm_m0_read_next = 1'b1;
          avm_m0_byteenable_next = 2'b11;
          mar_next = alu_out;
          reg_read_addr1 = ir_rb;
          alu_in2 = mar;
          addrsel_next = ADDR_MAR;
        end
        {MODE_REGIND, 8'h04}: begin // st.b
	  state_next = STATE_MEMSAVE;
	  retstate_next = STATE_STORE2;
	  avm_m0_write_next = 1'b1;
	  avm_m0_read_next = 1'b0;

	  mar_next = alu_out;
	  addrsel_next = ADDR_MAR;
	  reg_read_addr1 = ir_rb;
          alu_in2 = mar;

          reg_read_addr2 = ir_ra;
          mdrsel_next = MDR_LOW;

          if (alu_out[0]) begin
            mdr_next[7:0] = reg_data_out2[7:0];
	    avm_m0_byteenable_next = 2'b01;
          end else begin
            mdr_next[15:8] = reg_data_out2[7:0];
	    avm_m0_byteenable_next = 2'b10;
	  end
        end
        {MODE_REGIND, 8'h05}: begin // ld.b
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD3;
          avm_m0_read_next = 1'b1;
          if (alu_out[0])
            avm_m0_byteenable_next = 2'b01;
          else
            avm_m0_byteenable_next = 2'b10;
          mar_next = alu_out;
          reg_read_addr1 = ir_rb;
          alu_in2 = mar;
          addrsel_next = ADDR_MAR;
        end
        {MODE_REGIND, 8'h0a}: begin // lda
          state_next = STATE_FETCHIR1;
          reg_read_addr1 = ir_rb;
          alu_in2 = mar;
          reg_write = REG_WRITE_DW;
        end
        {MODE_REGIND, 8'ha0}: begin // jmp
          state_next = STATE_FETCHIR1;
          reg_read_addr1 = ir_rb;
          alu_in2 = mar;
          pc_next = { 1'b0, alu_out};
        end
        {MODE_REGIND, 8'ha1}: begin // jsr
          state_next = STATE_FAULT;
          // Can't really do two ALU ops at once, both the relative computation of the new PC
          // and the setup for the SP and PUSH op.
        end
        default: state_next = STATE_FETCHIR3;
      endcase
    end
    STATE_FETCHIR3: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_EVALIR3;
      avm_m0_write_next = 1'b0;
      avm_m0_read_next = 1'b1;
      avm_m0_byteenable_next = 2'b11;
      addrsel_next = ADDR_PC;
    end
    STATE_EVALIR3: begin
      casex ({ir_mode, ir_op})
        {MODE_IMM3, 8'h0x}: begin // alu rA <= rB + 0xabcd
          alu_func = ir_op[3:0];
          reg_read_addr1 = ir_rb;
          alu_in2 = { {16{mdr[15]}}, mdr[15:0] };
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {MODE_IMM3, 8'h2x}: begin // [un]signed rA <= rB * / % 0xabcd
          case (ir_op)
            'h29: int_func = 'b001;
            'h2a: int_func = 'b010;
            'h2b: int_func = 'b100;
            'h2c: int_func = 'b101;
            'h2d: int_func = 'b110;
            default: int_func = 'b000;
          endcase
          reg_read_addr1 = ir_rb;
          divmul2_next = { {16{mdr[15]}}, mdr[15:0] };
          if (delay == 'h0) begin
            delay_next = 'h7;
          end else begin
            delay_next = delay - 1'b1;
            if (delay == 'h1) begin
              reg_data_in = int_out;
              reg_write = REG_WRITE_DW;
              state_next = STATE_FETCHIR1;
            end
          end
        end
        {MODE_IMM3a, 8'h00}: begin // ldi
          state_next = STATE_FETCHIR1;
          reg_data_in = mdr;
          reg_write = REG_WRITE_DW;        
        end
        {MODE_DIR, 8'h00}: begin // std.l
 	  state_next = STATE_MEMSAVE;
	  retstate_next = STATE_STORE;
	  avm_m0_write_next = 1'b1;
	  avm_m0_read_next = 1'b0;
	  avm_m0_byteenable_next = 2'b11;

          mdr_next = reg_data_out1;
          mdrsel_next = MDR_HIGH;
          addrsel_next = ADDR_MAR;
        end
        {MODE_DIR, 8'h01}: begin // ldd.l
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD;
          avm_m0_read_next = 1'b1;
          avm_m0_byteenable_next = 2'b11;
          addrsel_next = ADDR_MAR;
        end
        {MODE_DIR, 8'h02}: begin // std
	        state_next = STATE_MEMSAVE;
	        retstate_next = STATE_STORE2;
	        avm_m0_write_next = 1'b1;
	        avm_m0_read_next = 1'b0;
	        avm_m0_byteenable_next = 2'b11;

          mdr_next = reg_data_out1;
          mdrsel_next = MDR_LOW;
          addrsel_next = ADDR_MAR;
        end
        {MODE_DIR, 8'h03}: begin // ldd
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD3;
          avm_m0_read_next = 1'b1;
          avm_m0_byteenable_next = 2'b11;
          addrsel_next = ADDR_MAR;
        end
        {MODE_DIR, 8'h04}: begin // std.b
	        state_next = STATE_MEMSAVE;
	        retstate_next = STATE_STORE2;
	        avm_m0_write_next = 1'b1;
	        avm_m0_read_next = 1'b0;

	        if (mar[0]) begin
	          avm_m0_byteenable_next = 2'b01;
          end else begin
            mdr_next[15:8] = mdr[7:0];
	          avm_m0_byteenable_next = 2'b10;
	        end

          mdrsel_next = MDR_LOW;
          addrsel_next = ADDR_MAR;
        end
        {MODE_DIR, 8'h05}: begin // ldd.b
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD3;
          avm_m0_read_next = 1'b1;
          if (mar[0])
	          avm_m0_byteenable_next = 2'b01;
          else
	          avm_m0_byteenable_next = 2'b10;
          addrsel_next = ADDR_MAR;
        end
        {MODE_DIR, 8'h80}: begin // jmpd
          state_next = STATE_FETCHIR1;
          pc_next = { 1'b0, mar};
        end
        {MODE_DIR, 8'h81}: begin // jsrd
          state_next = STATE_MEMSAVE;
          retstate_next = STATE_JSR;
          avm_m0_write_next = 1'b1;
          avm_m0_read_next = 1'b0;
          avm_m0_byteenable_next= 2'b11;
          mar_next = alu_out;
          mdr_next = pc;
          pc_next = mar;
          mdrsel_next = MDR_LOW;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = REG_SP;
          alu_func = 'h3; // sub
          reg_write = REG_WRITE_DW;
          reg_write_addr = REG_SP;
        end
        default: state_next = STATE_FAULT;
      endcase 
    end
    STATE_STORE: begin
      state_next = STATE_MEMSAVE;
      retstate_next = STATE_STORE2;
      avm_m0_write_next = 1'b1;
      avm_m0_read_next = 1'b0;
      avm_m0_byteenable_next = 2'b11;
           
      mar_next = mar + 'h2;
      mdrsel_next = MDR_LOW;
    end
    STATE_STORE2: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
    end
    STATE_LOAD: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_LOAD2;
      avm_m0_read_next = 1'b1;
      avm_m0_byteenable_next = 2'b11;
      mar_next = mar + 'h2;
      reg_data_in = mdr;
      reg_write = REG_WRITE_W1;
    end
    STATE_LOAD2: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
      reg_data_in = mdr;
      reg_write = REG_WRITE_W0;
    end
    STATE_LOAD3: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
      reg_data_in = { {16{mdr[15]}} , mdr[15:0] };
      reg_write = REG_WRITE_DW;
    end
    STATE_POP: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_POP2;
      avm_m0_read_next = 1'b1;
      avm_m0_byteenable_next = 2'b11;
      mar_next = reg_data_out1;
      addrsel_next = ADDR_MAR;
      reg_read_addr1 = REG_SP;
    end
    STATE_POP2: begin
      state_next = STATE_FETCHIR1;
      reg_data_in = mdr;
      reg_write = REG_WRITE_DW;
      addrsel_next = ADDR_PC;
    end
    STATE_PUSH: begin
      state_next = STATE_MEMSAVE;
      retstate_next = STATE_PUSH2;
      avm_m0_write_next = 1'b1;
      avm_m0_read_next = 1'b0;
      avm_m0_byteenable_next= 2'b11;
      mar_next = alu_out;
      mdrsel_next = MDR_HIGH;
      addrsel_next = ADDR_MAR;
      reg_read_addr1 = REG_SP;
      alu_func = 'h3; // sub
      reg_write = REG_WRITE_DW;
      reg_write_addr = REG_SP;
    end
    STATE_PUSH2: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
    end
    STATE_JSR: begin
      state_next = STATE_MEMSAVE;
      retstate_next = STATE_JSR2;
      avm_m0_write_next = 1'b1;
      avm_m0_read_next = 1'b0;
      avm_m0_byteenable_next= 2'b11;
      mar_next = alu_out;
      mdrsel_next = MDR_HIGH;
      addrsel_next = ADDR_MAR;
      reg_read_addr1 = REG_SP;
      alu_func = 'h3; // sub
      reg_write = REG_WRITE_DW;
      reg_write_addr = REG_SP;      
    end // case: STATE_JSR
    STATE_JSR2: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC; 
    end
    STATE_FAULT: state_next = STATE_FAULT;
  endcase
end

alu alu0(.in1(reg_data_out1), .in2(alu_in2), .func(alu_func), .out(alu_out), .c_out(alu_carry), .n_out(alu_negative), .v_out(alu_overflow), .z_out(alu_zero));
intcalc int0(.clock(csi_clk), .func(int_func), .in1(reg_data_out1), .in2(divmul2), .out(int_out));
registerfile intreg(.clk(csi_clk), .rst_n(rsi_reset_n), .read1(reg_read_addr1), .read2(reg_read_addr2), .write_addr(reg_write_addr),
  .write_data(reg_data_in), .write_en(reg_write), .data1(reg_data_out1), .data2(reg_data_out2));
  
endmodule
