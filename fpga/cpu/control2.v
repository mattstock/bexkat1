`timescale 1ns / 1ns
`include "bexkat2.vh"
  
module control2(input clk_i,
		input rst_i,
		input [31:0] ir,
		output ir_write,
		input [2:0] ccr,
		output [1:0] ccrsel,
		output [2:0] alu_func,
		output [1:0] alu2sel,
		output [2:0] regsel,
		output [3:0] reg_read_addr1,
		output [3:0] reg_read_addr2,
		output [3:0] reg_write_addr,
		output [1:0] reg_write,
		output a_write,
		output b_write,
		output [3:0] mdrsel,
		output [1:0] marsel,
		output int2sel,
		output [3:0] int_func,
		output [2:0] fpu_func,
		output fpccr_write,
		output [2:0] pcsel,
		output addrsel,
		output [3:0] byteenable,
		output bus_cyc,
		output bus_write,
		output halt,
		output int_en,
		output vectoff_write,
		input supervisor,
		input bus_ack,
		output reg [3:0] exception,
		input [2:0] interrupt,
		input [1:0] bus_align);

assign halt = (state == S_HALT);
assign int_en = interrupts_enabled;

// IR helpers
wire [3:0]  ir_type  = ir[31:28];
wire [3:0]  ir_op    = ir[27:24];
wire [3:0]  ir_ra    = ir[23:20];
wire [3:0]  ir_rb    = ir[19:16];
wire [3:0]  ir_rc    = ir[15:12];
wire [31:0] ir_uval  = { 17'h0000, ir[15:1] };
wire ir_size         = ir[0];

wire ccr_ltu, ccr_lt, ccr_eq;
assign { ccr_ltu, ccr_lt, ccr_eq } = ccr;

reg [7:0] state, state_next;
reg interrupts_enabled, interrupts_enabled_next;
reg [3:0] exception_next;
reg [7:0] delay, delay_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= S_RESET;
    interrupts_enabled <= 1'b0;
    exception <= 4'h0;
    delay <= 8'h00;
  end else begin
    state <= state_next;
    interrupts_enabled <= interrupts_enabled_next;
    exception <= exception_next;
    delay <= (delay == 8'h00 ? delay_next : delay - 8'h1);
  end
end

always @(*)
begin
  state_next = state;
  interrupts_enabled_next = interrupts_enabled;
  exception_next = exception;
  ir_write = 1'b0;
  alu_func = ALU_ADD;
  ccrsel = CCR_CCR;
  alu2sel = ALU_B;
  regsel = REG_ALU;
  reg_read_addr1 = ir_ra;
  reg_read_addr2 = ir_rb;
  reg_write_addr = ir_ra;
  a_write = 1'h0;
  b_write = 1'h0;
  reg_write = REG_WRITE_NONE;
  mdrsel = MDR_MDR;
  marsel = MAR_MAR;
  int2sel = INT2_B;
  fpccr_write = 1'b0;
  fpu_func = FPU_CVTIS;
  addrsel = ADDR_PC;
  pcsel = PC_PC;
  bus_cyc = 1'b0;
  bus_write = 1'b0;
  byteenable = 4'b1111;
  vectoff_write = 1'b0;
  int_func = INT_NEG;
  delay_next = 8'h00;
  
  case (state)
    S_RESET: begin
      exception_next = 4'h0;
      state_next = S_EXC;
    end
    S_EXC: begin
      // for everyone except reset, we need to push the PC onto the stack
      if (exception == 4'h0)
        state_next = S_EXC5;
      else begin
	a_write = 1'b1; // A <= SP
        reg_read_addr1 = REG_SP;
        mdrsel = MDR_PC;
	state_next = S_EXC2;
      end
    end // case: S_EXC
    S_EXC2: begin
        alu2sel = ALU_4;
        alu_func = ALU_SUB;
        state_next = S_EXC3;
    end
    S_EXC3: begin
      marsel = MAR_ALU;
      reg_write_addr = REG_SP;
      reg_write = REG_WRITE_DW;
      state_next = S_EXC4;
    end
    S_EXC4: begin
      addrsel = ADDR_MAR;
      bus_cyc = 1'b1;
      bus_write = 1'b1;       
      if (bus_ack)
        state_next = S_EXC5;
    end
    S_EXC5: begin
      pcsel = PC_EXC; // load exception_next handler address into PC
      state_next = S_EXC6;
    end
    S_EXC6: begin
      bus_cyc = 1'b1;
      marsel = MAR_BUS;
      if (bus_ack)
        state_next = S_EXC7;
    end
    S_EXC7: begin
      pcsel = PC_MAR;
      state_next = S_FETCH;
    end
    S_FETCH: begin
      bus_cyc = 1'b1;
      ir_write = 1'b1; // latch bus into ir
      if (|interrupt && interrupts_enabled) begin
        state_next = S_EXC;
        interrupts_enabled_next = 1'b0;
        exception_next = { 1'b0, interrupt};
      end else
        if (bus_ack)
          state_next = S_FETCH2;
    end // case: S_FETCH
    S_FETCH2: begin
      pcsel = PC_NEXT;
      state_next = S_EVAL;
    end
    S_EVAL: begin
      if (ir_size)
	state_next = S_ARG;
      else
	case (ir_type)
          T_INH: state_next = S_INH;
          T_PUSH: state_next = (ir_op == 4'h1 ? S_RELADDR : S_PUSH);
          T_POP: state_next = S_POP;
          T_CMP: state_next = S_CMP;
          T_MOV: state_next = S_MOV;
	  T_INTU: state_next = S_INTU;
          T_INT: state_next = S_INT;
          T_FPU: state_next = S_FPU;
          T_FP: state_next = S_FP;
          T_ALU: state_next = S_ALU;
          T_LDI: state_next = S_LDIU;
          T_LOAD: state_next = S_LOAD;
          T_STORE: state_next = S_STORE;
          T_BRANCH: state_next = S_BRANCH;
          T_JUMP: state_next = S_JUMP;
          default: state_next = S_HALT;
	endcase
    end // case: S_EVAL
    S_TERM: state_next = S_FETCH;
    S_ARG: begin
      bus_cyc = 1'b1;
      marsel = MAR_BUS;
      mdrsel = MDR_BUS;
      if (bus_ack)
        state_next = S_ARG2;
    end
    S_ARG2: begin
      pcsel = PC_NEXT;
      case (ir_type)
	T_INH: state_next = S_INH;
	T_PUSH: state_next = S_PUSH2;
	T_STORE: state_next = S_STORED;
	T_LOAD: state_next = S_LOADD;
	T_JUMP: state_next = S_EXC7;
	T_LDI: state_next = S_MDR2RA;
	default: state_next = S_HALT;
      endcase
    end
    S_INH: begin
      case (ir_op)
	4'h0: state_next = S_FETCH; // nop
	4'h1: begin
	  if (ir_size) begin // setint
	    vectoff_write = 1'b1;
	    state_next = S_FETCH;
	  end else begin // trap
	    exception_next = { 1'b1, ir_uval[2:0] }; // upper 8 are swi
            state_next = S_EXC;
          end
	end
	4'h2: begin // cli
          interrupts_enabled_next = 1'b0;
	  state_next = S_FETCH;
	end
	4'h3: begin // sti
          interrupts_enabled_next = 1'b1;
	  state_next = S_FETCH;
	end
  default: state_next = S_HALT;
      endcase // case (ip_op)
    end // case: S_INH
    S_RELADDR: begin
      // jsr only
      reg_read_addr1 = ir_rb;
      a_write = 1'b1; // A <= rB
      state_next = S_RELADDR2;
    end
    S_RELADDR2: begin
      alu2sel = ALU_SVAL;
      state_next = S_PUSH2;
    end
    S_PUSH: begin // push, jsrd, jsr
      b_write = 1'b1; // B <= rA
      reg_read_addr2 = ir_ra;
      state_next = S_PUSH2;
    end
    S_PUSH2: begin
      casex ({ir_size,ir_op})
	5'h11: begin // jsrd
	  mdrsel = MDR_PC;
	  pcsel = PC_MAR;
	end
	5'h01: begin // jsr
	  mdrsel = MDR_PC;
	  pcsel = PC_ALU;
	end
  5'h02: begin // bsr
    mdrsel = MDR_PC;
    pcsel = PC_REL;
  end
	default: begin
	  mdrsel = MDR_B;
	end
      endcase // casex ({ir_size,ir_op})
      a_write = 1'b1; // A <= SP
      reg_read_addr1 = REG_SP; // SP
      state_next = S_PUSH3;
    end
    S_PUSH3: begin
      alu2sel = ALU_4;
      alu_func = ALU_SUB;
      state_next = S_PUSH4;
    end
    S_PUSH4: begin
       marsel = MAR_ALU; // MAR <= aluout
       reg_write_addr = REG_SP; // SP <= aluout
       reg_write = REG_WRITE_DW;
       state_next = S_PUSH5;
    end
    S_PUSH5: begin
       addrsel = ADDR_MAR;
       bus_cyc = 1'b1;
       bus_write = 1'b1;            
       if (bus_ack)
         state_next = S_TERM;
    end
    S_POP: begin // pop
      reg_read_addr1 = REG_SP;
      a_write = 1'b1;
      state_next = S_POP2;
    end
    S_POP2: begin
      alu2sel = ALU_4;
      marsel = MAR_A;
      state_next = S_POP3;
    end
    S_POP3: begin
      reg_write = REG_WRITE_DW; // SP <= aluout
      reg_write_addr = REG_SP;
      case (ir_op)
	4'h0: state_next = S_POP4;
	default: state_next = S_RTS;
      endcase
    end
    S_POP4: begin
      addrsel = ADDR_MAR;
      bus_cyc = 1'b1;
      mdrsel = MDR_BUS;
      if (bus_ack)
        state_next = S_MDR2RA;
    end
    S_RTS: begin // rts
      pcsel = PC_MAR;
      state_next = S_RTS2;
    end
    S_RTS2: begin
      marsel = MAR_BUS;
      bus_cyc = 1'b1;
      if (bus_ack)
	state_next = S_RTS3;
    end
    S_RTS3: begin
      pcsel = PC_MAR;
      if (ir_op == 4'h2) begin
        interrupts_enabled_next = 1'b1;
        exception_next = 4'h0;
      end
      state_next = S_FETCH;
    end
    S_CMP: begin // cmp
      a_write = 1'b1; // A <= rA
      b_write = 1'b1; // B <= rB
      if (ir_op == 4'h0)
	state_next = S_CMP2;
      else
	state_next = S_CMPS;
    end
    S_CMP2: begin
      alu_func = ALU_SUB;
      state_next = S_CMP3;
    end
    S_CMP3: begin
      alu_func = ALU_SUB; // hold so we select the correct CCR value TODO fix
      ccrsel = 2'h1;
      state_next = S_FETCH;
    end
    S_CMPS: state_next = S_CMPS2; // cmp.s
    S_CMPS2: state_next = S_CMPS3;
    S_CMPS3: begin
      ccrsel = CCR_FPU;
      state_next = S_FETCH;
    end
    S_MOV: begin // mov, mov.l, mov.b
      reg_read_addr2 = ir_rb;
      b_write = 1'b1; // B <= rB
      state_next = S_MOV2;
    end
    S_MOV2: begin
      regsel = REG_B;
      reg_write = ir_op[1:0];
      state_next = S_FETCH;
    end
    S_INTU: begin
      reg_read_addr2 = ir_rb;
      b_write = 1'b1; // B <= rB
      state_next = S_INTU2;
    end
    S_INTU2: begin
      int2sel = INT2_B;
      int_func = ir_op;
      mdrsel = MDR_INT;
      state_next = S_MDR2RA;
    end
    S_FPU: begin
      reg_read_addr2 = ir_rb;
      b_write = 1'b1; // B <= rB
      delay_next = 8'h11;
      state_next = S_FP2;
    end
    S_FP: begin
      reg_read_addr1 = ir_rb;
      a_write = 1'b1; // A <= rB
      reg_read_addr2 = ir_rc;
      b_write = 1'b1; // B <= rC
      delay_next = 8'ha;
      state_next = S_FP2;
    end
    S_FP2: begin
      fpu_func = ir_op[2:0];
      mdrsel = MDR_FPU;
      if (delay == 8'h00)
        state_next = S_MDR2RA;
    end
    S_MDR2RA: begin
      regsel = REG_MDR; // rA <= MDR
      reg_write = REG_WRITE_DW;
      state_next = S_FETCH;
    end
    S_ALU: begin
      reg_read_addr1 = ir_rb;
      a_write = 1'b1; // A <= rB
      reg_read_addr2 = ir_rc;
      b_write = 1'b1; // B <= rC
      if (ir_op[3])
	state_next = S_ALU3;
      else
	state_next = S_ALU2;
    end
    S_ALU2: begin
      alu_func = ir_op[2:0];
      state_next = S_ALU4;
    end
    S_ALU3: begin
      alu_func = ir_op[2:0];
      alu2sel = ALU_SVAL;
      state_next = S_ALU4;
    end
    S_ALU4: begin
      mdrsel = MDR_ALU;
      state_next = S_MDR2RA;
    end
    S_INT: begin
      reg_read_addr1 = ir_rb;
      a_write = 1'b1; // A <= rB
      reg_read_addr2 = ir_rc;
      b_write = 1'b1; // B <= rC
      delay_next = 8'hc;
      if (ir_op[3])
	state_next = S_INT3;
      else
	state_next = S_INT2;
    end
    S_INT2: begin
      int_func = { 1'b0, ir_op[2:0] };
      mdrsel = MDR_INT;
      if (delay == 8'h00)
        state_next = S_MDR2RA;
    end
    S_INT3: begin
      int2sel = INT2_SVAL;
      int_func = { 1'b0, ir_op[2:0] };
      mdrsel = MDR_INT;
      if (delay == 8'h00)
        state_next = S_MDR2RA;
    end
    S_BRANCH: begin
      case (ir_op)
	4'h0: pcsel = PC_REL; // bra
	4'h1: if (ccr_eq) pcsel = PC_REL; // beq
	4'h2: if (~ccr_eq) pcsel = PC_REL; // bne
	4'h3: if (~(ccr_ltu | ccr_eq)) pcsel = PC_REL; // bgtu
	4'h4: if (~(ccr_lt | ccr_eq)) pcsel = PC_REL; // bgt
	4'h5: if (~ccr_lt) pcsel = PC_REL; // bge
	4'h6: if (ccr_lt | ccr_eq) pcsel = PC_REL; // ble
	4'h7: if (ccr_lt) pcsel = PC_REL; // blt
	4'h8: if (~ccr_ltu) pcsel = PC_REL; // bgeu
	4'h9: if (ccr_ltu) pcsel = PC_REL; // bltu
	4'ha: if (ccr_ltu | ccr_eq) pcsel = PC_REL; // bleu
	default: pcsel = PC_PC; // brn
      endcase // case (ir_op)
      state_next = S_FETCH;
    end
    S_LDIU: begin
      regsel = REG_UVAL;
      reg_write = REG_WRITE_DW;
      state_next = S_FETCH;
    end
    S_JUMP: begin
      reg_read_addr1 = ir_rb;
      a_write = 1'b1;
      state_next = S_JUMP2;
    end 
    S_JUMP2: begin
      alu2sel = ALU_SVAL;
      state_next = S_JUMP3;
    end
    S_JUMP3: begin
      pcsel = PC_ALU;
      state_next = S_FETCH;
    end    
    S_LOAD: begin
      reg_read_addr1 = ir_rb;
      a_write = 1'b1; // A <= rB
      state_next = S_LOAD2;
    end
    S_LOAD2: begin
      alu2sel = ALU_SVAL;
      state_next = S_LOAD3;
    end
    S_LOAD3: begin
      marsel = MAR_ALU;
      state_next = S_LOADD;
    end
    S_LOADD: begin
      addrsel = ADDR_MAR;
      bus_cyc = 1'b1;
      mdrsel = MDR_BUS;
      if (ir_op[1:0] == 2'h1)
	byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
      else if (ir_op[1:0] == 2'h2)
	case (bus_align[1:0])
          2'b00: byteenable = 4'b1000;
          2'b01: byteenable = 4'b0100;
          2'b10: byteenable = 4'b0010;
          2'b11: byteenable = 4'b0001;
        endcase
      if (bus_ack)
	state_next = S_MDR2RA;
    end
    S_STORE: begin
      reg_read_addr1 = ir_rb;
      a_write = 1'b1; // A <= rB
      state_next = S_STORE2;
    end
    S_STORE2: begin
      alu2sel = ALU_SVAL;
      a_write = 1'b1; // A <= rA
      state_next = S_STORE3;
    end
    S_STORE3: begin
      marsel = MAR_ALU;
      mdrsel = MDR_A;
      state_next = S_STORE4;
    end
    S_STORED: begin
      a_write = 1'b1;
      state_next = S_STORED2;
    end
    S_STORED2: begin
      mdrsel = MDR_A;
      state_next = S_STORE4;
    end
    S_STORE4: begin // MAR has address, MDR value
      addrsel = ADDR_MAR;
      bus_cyc = 1'b1;
      bus_write = 1'b1;
      if (ir_op[1:0] == 2'h1)
	byteenable = (bus_align[1] ? 4'b0011 : 4'b1100);
      else if (ir_op[1:0] == 2'h2)
	case (bus_align[1:0])
          2'b00: byteenable = 4'b1000;
          2'b01: byteenable = 4'b0100;
          2'b10: byteenable = 4'b0010;
          2'b11: byteenable = 4'b0001;
        endcase
      if (bus_ack)
	state_next = S_TERM;
    end
    S_HALT: state_next = S_HALT;
  endcase // case (state)
end
  
endmodule
