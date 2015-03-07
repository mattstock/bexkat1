`timescale 1ns / 1ns

module bexkat1(
  input csi_clk,
  input rsi_reset_n,
  input avm_m0_waitrequest,
  output [31:0] avm_m0_address,
  output reg avm_m0_read,
  input [31:0] avm_m0_readdata,
  output [31:0] avm_m0_writedata,
  output reg avm_m0_write,
  output [3:0] avm_m0_byteenable);

reg [31:0] pc;
reg [32:0] pc_next;
reg [31:0] mar;
reg [32:0] mar_next;
reg [3:0] state, state_next, retstate, retstate_next;
reg [31:0] ir, ir_next;
reg avm_m0_write_next, avm_m0_read_next;
reg [3:0] be, be_next;
reg [31:0] mdr, mdr_next;
reg [3:0] ccr, ccr_next;
reg [7:0] delay, delay_next;
reg addrsel, addrsel_next;
reg [31:0] divmul2, divmul2_next;

parameter big_endian = 1'b1;

// combinatorial stuff
reg [31:0] alu_in2;
reg [3:0] alu_func;
reg [2:0] int_func;
reg [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
reg [1:0] reg_write;

wire [31:0] busdata;

assign avm_m0_writedata = (big_endian ? mdr : {mdr[7:0], mdr[15:8], mdr[23:16], mdr[31:24]});
assign busdata = (big_endian ? avm_m0_readdata : {avm_m0_readdata[7:0], avm_m0_readdata[15:8], 
  avm_m0_readdata[23:16], avm_m0_readdata[31:24]});
assign avm_m0_byteenable = (big_endian ? be : {be[0], be[1], be[2], be[3]});

assign avm_m0_address = (addrsel ? mar : pc);

wire data_access;
reg [31:0] reg_data_out1, reg_data_out2, reg_data_in;
wire carry, negative, overflow, zero;
wire alu_carry, alu_negative, alu_overflow, alu_zero;
wire [31:0] alu_out, fp_out, int_out, cvt_int_out, cvt_fp_out;

localparam STATE_FETCHIR = 4'h0, STATE_FETCHARG = 4'h1, STATE_EVALIR = 4'h2, STATE_EVALARG = 4'h3;
localparam STATE_STORE = 4'h4, STATE_LOAD = 4'h5, STATE_MEMSAVE = 4'h6, STATE_MEMLOAD = 4'h7;
localparam STATE_JSR = 4'h8, STATE_RTS = 4'h9, STATE_PUSH = 4'ha, STATE_POP = 4'hb;
localparam STATE_FAULT = 4'hc;

localparam REG_SP = 5'b11111;
localparam ADDR_PC = 1'b0, ADDR_MAR = 1'b1;

localparam MODE_REG = 3'h0, MODE_REGIND = 3'h1, MODE_IMM = 3'h2, MODE_DIR = 3'h4;

// opcode format
wire [2:0] ir_mode = ir[31:29];
wire [7:0] ir_op   = ir[28:21];
wire [4:0] ir_ra   = ir[20:16];
wire [4:0] ir_rb   = ir[15:11];
wire [4:0] ir_rc   = ir[10:6];
wire [31:0] ir_ind = { {20{ir[10]}}, ir[10:0] };
		  
assign {carry, negative, overflow, zero} = ccr;

localparam REG_WRITE_NONE = 2'b00, REG_WRITE_DW = 2'b11;

always @(posedge csi_clk or negedge rsi_reset_n)
begin
  if (!rsi_reset_n) begin
    pc <= 'hffc00000; // start boot at base of monitor for now
    state <= STATE_FETCHIR;
    ir <= 'h0000000;
    mdr <= 'h00000000;
    mar <= 'h00000000;
    addrsel <= ADDR_PC;
    ccr <= 'h0;
    delay <= 'h0;
    avm_m0_write <= 1'b0;
    avm_m0_read <= 1'b0;
    be <= 4'h0;
    divmul2 <= 'h1;
    retstate <= STATE_FETCHIR;
  end else begin
    pc <= pc_next[31:0];
    state <= state_next;
    delay <= delay_next;
    ir <= ir_next;
    mdr <= mdr_next;
    mar <= mar_next[31:0];
    addrsel <= addrsel_next;
    ccr <= ccr_next;
    avm_m0_read <= avm_m0_read_next;
    avm_m0_write <= avm_m0_write_next;
    be <= be_next;
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
  ccr_next = ccr;
  be_next = be;
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
  alu_in2 = 'h4;
  case (state)
    STATE_FETCHIR: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_EVALIR;
      avm_m0_write_next = 1'b0;
      avm_m0_read_next = 1'b1;
      be_next = 4'b1111;
      addrsel_next = ADDR_PC;
    end
    STATE_MEMLOAD: begin
      if (avm_m0_waitrequest == 1'b0) begin
        state_next = retstate;
        avm_m0_read_next = 1'b0;
        be_next = 4'b0000;
        case (retstate)
          STATE_EVALIR: begin
            ir_next = busdata;
	          mar_next = { {16{busdata[15]}}, busdata[15:0] } ;
            mdr_next = { 16'h0000, busdata[15:0] };
            pc_next = pc + 'h4;
          end
          STATE_EVALARG: begin
            mar_next = busdata;
            mdr_next = busdata;
            pc_next = pc + 'h4;
          end
          STATE_JSR: begin
          end
          STATE_RTS: begin
            pc_next = busdata;
            reg_read_addr1 = REG_SP;
            mar_next = reg_data_out1;
            reg_write = REG_WRITE_DW;
            reg_write_addr = REG_SP; // SP + 4
          end
          STATE_POP: begin
            mdr_next = busdata;
            reg_read_addr1 = REG_SP;
            mar_next = reg_data_out1;
            reg_write = REG_WRITE_DW;
            reg_write_addr = REG_SP; // SP + 4
          end
          STATE_LOAD: begin
            case (be)
              4'b1111: mdr_next = busdata;
              4'b0011: mdr_next = { {16{busdata[15]}}, busdata[15:0] };
              4'b1100: mdr_next = { {16{busdata[31]}}, busdata[31:16] };
              4'b0001: mdr_next = { {24{busdata[7]}}, busdata[7:0] };
              4'b0010: mdr_next = { {24{busdata[15]}}, busdata[15:8] };
              4'b0100: mdr_next = { {24{busdata[23]}}, busdata[23:16] };
              4'b1000: mdr_next = { {24{busdata[31]}}, busdata[31:24] };
              default: mdr_next = busdata;
            endcase
          end
          default:
            state_next = STATE_FAULT;
        endcase
      end
    end
    STATE_RTS: begin
      state_next = STATE_FETCHIR;
      addrsel_next = ADDR_PC;
    end
    STATE_MEMSAVE: begin
      if (avm_m0_waitrequest == 1'b0) begin
        state_next = retstate;
        be_next = 4'b0000;
        avm_m0_write_next = 1'b0;
      end
    end
    STATE_EVALIR: begin
      casex ({ir_mode, ir_op})
        {MODE_REG, 8'h00}: state_next = STATE_FETCHIR; // nop
        {MODE_REG, 8'h01}: begin // rts
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_RTS;
          avm_m0_read_next = 1'b1;
          be_next = 4'b1111;
          reg_read_addr1 = REG_SP;
          mar_next = reg_data_out1;
          addrsel_next = ADDR_MAR;
        end
        {MODE_REG, 8'h02}: begin // cmp
          alu_func = 'h3; // sub
          alu_in2 = reg_data_out2;
          if (delay == 'h0) begin
            delay_next = 'h2;
          end else begin
            delay_next = delay - 1'b1;
            if (delay == 'h1) begin
              ccr_next = {alu_carry, alu_negative, alu_overflow, alu_zero};
              state_next = STATE_FETCHIR;
            end
          end
        end
        {MODE_REG, 8'h03}: begin // inc rA
          alu_in2 = 'h1;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 8'h04}: begin // dec rA
          alu_func = 'h3; // sub
          alu_in2 = 'h1;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_REG, 8'h05}: begin // push rA
          state_next = STATE_MEMSAVE;
          retstate_next = STATE_PUSH;
          avm_m0_write_next = 1'b1;
          be_next= 4'b1111;
          mar_next = alu_out;
          mdr_next = reg_data_out2;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = REG_SP;
          alu_func = 'h3; // sub
          reg_write = REG_WRITE_DW;
          reg_write_addr = REG_SP;
          reg_read_addr2 = ir_ra;
        end
        {MODE_REG, 8'h06}: begin // pop rA
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_POP;
          avm_m0_read_next = 1'b1;
          be_next = 4'b1111;
          mar_next = reg_data_out1;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = REG_SP;
        end
        {MODE_REG, 8'h07}: begin // mov
          state_next = STATE_FETCHIR;
          reg_read_addr1 = ir_rb;
          reg_data_in = reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        {MODE_REG, 8'h08}: begin // com
          state_next = STATE_FETCHIR;
          reg_read_addr1 = ir_rb;
          reg_data_in = ~reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        {MODE_REG, 8'h09}: begin // neg
          state_next = STATE_FETCHIR;
          reg_read_addr1 = ir_rb;
          reg_data_in = -reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        {MODE_REG, 8'h2x}: begin // alu rA <= rB + rC
          alu_func = ir_op[3:0];
          reg_read_addr1 = ir_rb;
          reg_read_addr2 = ir_rc;
          alu_in2 = reg_data_out2;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
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
          divmul2_next = reg_data_out2;
          if (delay == 'h0) begin
            delay_next = 'h7;
          end else begin
            delay_next = delay - 1'b1;
            if (delay == 'h1) begin
              reg_data_in = int_out;
              reg_write = REG_WRITE_DW;
              state_next = STATE_FETCHIR;
            end
          end
        end       
        {MODE_IMM, 8'h00}: begin // bra
          state_next = STATE_FETCHIR;
          pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h01}: begin // beq
          state_next = STATE_FETCHIR;
          if (zero)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h02}: begin // bne
          state_next = STATE_FETCHIR;
          if (~zero)
            pc_next = { 1'b0, pc } + mar;        
        end
        {MODE_IMM, 8'h03}: begin // bgtu
          state_next = STATE_FETCHIR;
          if (~(zero | carry))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h04}: begin // bgt
          state_next = STATE_FETCHIR;
          if (~(zero | (negative ^ overflow)))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h05}: begin // bge
          state_next = STATE_FETCHIR;
          if (~(negative ^ overflow))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h06}: begin // ble
          state_next = STATE_FETCHIR;
          if (zero | (negative ^ overflow))
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h07}: begin // blt
          state_next = STATE_FETCHIR;
          if (negative ^ overflow)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h08}: begin // bgeu
          state_next = STATE_FETCHIR;
          if (~carry)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h09}: begin // bltu
          state_next = STATE_FETCHIR;
          if (carry)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h0a}: begin // bleu
          state_next = STATE_FETCHIR;
          if (carry | zero)
            pc_next = { 1'b0, pc } + mar;
        end
        {MODE_IMM, 8'h0b}: begin // brn
          state_next = STATE_FETCHIR;
        end
        {MODE_IMM, 8'h0c}: begin // ldis
          reg_data_in = mar; // mar holds a sign-extended copy of ir[15:0]
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_IMM, 8'h0d}: begin // ldiu
          reg_data_in = mdr; // same as ir[15:0] really
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR;
        end
        {MODE_REGIND, 8'h00}: begin // st.l
          state_next = STATE_MEMSAVE;
          retstate_next = STATE_STORE;
          avm_m0_write_next = 1'b1;
          avm_m0_read_next = 1'b0;
          be_next = 4'b1111;
           
          mar_next = alu_out;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;

          reg_read_addr2 = ir_ra;
          mdr_next = reg_data_out2;
        end
        {MODE_REGIND, 8'h01}: begin // ld.l
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD;
          avm_m0_read_next = 1'b1;
          be_next = 4'b1111;

          mar_next = alu_out;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;
        end
        {MODE_REGIND, 8'h02}: begin // st
          state_next = STATE_MEMSAVE;
          retstate_next = STATE_STORE;
          avm_m0_write_next = 1'b1;
          avm_m0_read_next = 1'b0;
           
          mar_next = alu_out;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;

          reg_read_addr2 = ir_ra;
          if (alu_out[1]) begin
            be_next = 4'b1100;
            mdr_next[31:16] = reg_data_out2[15:0];
          end else begin
            be_next = 4'b0011;
            mdr_next = reg_data_out2;
          end
        end
        {MODE_REGIND, 8'h03}: begin // ld
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD;
          avm_m0_read_next = 1'b1;
          mar_next = alu_out;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;
          addrsel_next = ADDR_MAR;
          be_next = (alu_out[1] ? 4'b1100 : 4'b0011);
        end
        {MODE_REGIND, 8'h04}: begin // st.b
          state_next = STATE_MEMSAVE;
          retstate_next = STATE_STORE;
          avm_m0_write_next = 1'b1;
          avm_m0_read_next = 1'b0;

          mar_next = alu_out;
          addrsel_next = ADDR_MAR;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;

          reg_read_addr2 = ir_ra;
          case (alu_out[1:0])
            2'b00: begin 
              mdr_next[7:0] = reg_data_out2[7:0];
              be_next = 4'b0001;
            end
            2'b01: begin
              mdr_next[15:8] = reg_data_out2[7:0];
              be_next = 4'b0010;
            end
            2'b10: begin
              mdr_next[23:16] = reg_data_out2[7:0];
              be_next = 4'b0100;
            end
            2'b11: begin
              mdr_next[31:24] = reg_data_out2[7:0];
              be_next = 4'b1000;
            end
          endcase
        end
        {MODE_REGIND, 8'h05}: begin // ld.b
          state_next = STATE_MEMLOAD;
          retstate_next = STATE_LOAD;
          avm_m0_read_next = 1'b1;
          case (alu_out[1:0])
            2'b00: be_next = 4'b0001;
            2'b01: be_next = 4'b0010;
            2'b10: be_next = 4'b0100;
            2'b11: be_next = 4'b1000;
          endcase
          mar_next = alu_out;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;
          addrsel_next = ADDR_MAR;
        end
        {MODE_REGIND, 8'h0a}: begin // lda
          state_next = STATE_FETCHIR;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;
          reg_write = REG_WRITE_DW;
        end
        {MODE_REGIND, 8'h0b}: begin // jmp
          state_next = STATE_FETCHIR;
          reg_read_addr1 = ir_rb;
          alu_in2 = ir_ind;
          pc_next = { 1'b0, alu_out};
        end
        {MODE_DIR, 8'hxx}: state_next = STATE_FETCHARG;
        default: state_next = STATE_FAULT;
      endcase
    end
    STATE_FETCHARG: begin
      state_next = STATE_MEMLOAD;
      retstate_next = STATE_EVALARG;
      avm_m0_read_next = 1'b1;
      be_next = 4'b1111;
      addrsel_next = ADDR_PC;
    end
    STATE_EVALARG: begin
        casex (ir_op)
          8'h0x: begin // alu rA <= rB + 0xabcd1234
            alu_func = ir_op[3:0];
            reg_read_addr1 = ir_rb;
            alu_in2 = mdr;
            reg_write = REG_WRITE_DW;
            state_next = STATE_FETCHIR;
          end
          8'h2x: begin // [un]signed rA <= rB * / % 0xabcd1234
            case (ir_op)
              'h21: int_func = 'b001;
              'h22: int_func = 'b010;
              'h23: int_func = 'b100;
              'h24: int_func = 'b101;
              'h25: int_func = 'b110;
              default: int_func = 'b000;
            endcase
            reg_read_addr1 = ir_rb;
            divmul2_next = mdr;
            if (delay == 'h0) begin
              delay_next = 'h7;
            end else begin
              delay_next = delay - 1'b1;
              if (delay == 'h1) begin
                reg_data_in = int_out;
                reg_write = REG_WRITE_DW;
                state_next = STATE_FETCHIR;
              end
            end
          end
          8'h3c: begin // ldi
            state_next = STATE_FETCHIR;
            reg_data_in = mdr;
            reg_write = REG_WRITE_DW;        
          end
          8'h30: begin // std.l
            state_next = STATE_MEMSAVE;
            retstate_next = STATE_STORE;
            avm_m0_write_next = 1'b1;
            avm_m0_read_next = 1'b0;
            be_next = 4'b1111;

            mdr_next = reg_data_out1;
            addrsel_next = ADDR_MAR;
          end
          8'h31: begin // ldd.l
            state_next = STATE_MEMLOAD;
            retstate_next = STATE_LOAD;
            avm_m0_read_next = 1'b1;
            be_next = 4'b1111;
            addrsel_next = ADDR_MAR;
          end
          8'h32: begin // std
            state_next = STATE_MEMSAVE;
            retstate_next = STATE_STORE;
            avm_m0_write_next = 1'b1;
            avm_m0_read_next = 1'b0;
            
            if (mar[1]) begin
              be_next = 4'b1100;
              mdr_next[31:16] = reg_data_out1[15:0];
            end else begin
              be_next = 4'b0011;
              mdr_next[15:0] = reg_data_out1[15:0];
            end
            addrsel_next = ADDR_MAR;
          end
          8'h33: begin // ldd
            state_next = STATE_MEMLOAD;
            retstate_next = STATE_LOAD;
            avm_m0_read_next = 1'b1;
            be_next = (alu_out[1] ? 4'b1100 : 4'b0011);
            addrsel_next = ADDR_MAR;
          end
          8'h34: begin // std.b
	          state_next = STATE_MEMSAVE;
	          retstate_next = STATE_STORE;
	          avm_m0_write_next = 1'b1;

            case (mar[1:0])
              2'b00: begin 
                mdr_next[7:0] = reg_data_out1[7:0];
                be_next = 4'b0001;
              end
              2'b01: begin
                mdr_next[15:8] = reg_data_out1[7:0];
                be_next = 4'b0010;
              end
              2'b10: begin
                mdr_next[23:16] = reg_data_out1[7:0];
                be_next = 4'b0100;
              end
              2'b11: begin
                mdr_next[31:24] = reg_data_out1[7:0];
                be_next = 4'b1000;
              end
            endcase      

            addrsel_next = ADDR_MAR;
          end
          8'h35: begin // ldd.b
            state_next = STATE_MEMLOAD;
            retstate_next = STATE_LOAD;
            avm_m0_read_next = 1'b1;
            case (alu_out[1:0])
              2'b00: be_next = 4'b0001;
              2'b01: be_next = 4'b0010;
              2'b10: be_next = 4'b0100;
              2'b11: be_next = 4'b1000;
            endcase
            addrsel_next = ADDR_MAR;
          end
          8'h3a: begin // jmpd
            state_next = STATE_FETCHIR;
            pc_next = { 1'b0, mar};
          end
          8'h3b: begin // jsrd
            state_next = STATE_MEMSAVE;
            retstate_next = STATE_JSR;
            avm_m0_write_next = 1'b1;
            be_next= 4'b1111;
            mar_next = alu_out;
            mdr_next = pc;
            pc_next = mar;
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
      state_next = STATE_FETCHIR;
      addrsel_next = ADDR_PC;
    end
    STATE_LOAD: begin
      state_next = STATE_FETCHIR;
      reg_data_in = mdr;
      reg_write = REG_WRITE_DW;
      addrsel_next = ADDR_PC;
    end
    STATE_POP: begin
      state_next = STATE_FETCHIR;
      reg_data_in = mdr;
      reg_write = REG_WRITE_DW;
      addrsel_next = ADDR_PC;
    end
    STATE_PUSH: begin
      state_next = STATE_FETCHIR;
      addrsel_next = ADDR_PC;
    end
    STATE_JSR: begin
      state_next = STATE_FETCHIR;
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
