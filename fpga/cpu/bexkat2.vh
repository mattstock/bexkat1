/* a single location for all of the control signals that need to be synced
 * within the CPU, and a list of all of the state memonics.
 */

`ifndef _BEXKAT2_VH
 `define _BEXKAT2_VH

// Opcode types (in sync with the ISA in binutils)
localparam T_INH = 4'h0, T_PUSH = 4'h1, T_POP = 4'h2, T_CMP = 4'h3, 
  T_MOV = 4'h4, T_FP = 4'h5, T_ALU = 4'h6, T_INT = 4'h7, 
  T_LDI = 4'h8, T_LOAD = 4'h9, T_STORE = 4'ha, T_BRANCH = 4'hb,
  T_JUMP = 4'hc, T_INTU = 4'hd, T_FPU = 4'he;

// MDR input select
localparam MDR_MDR = 4'h0, MDR_BUS = 4'h1, MDR_B = 4'h2, MDR_A = 4'h3,
  MDR_PC = 4'h4, MDR_INT = 4'h5, MDR_FPU = 4'h6, MDR_ALU = 4'h7, MDR_CCR = 4'h8;

// register input select
localparam REG_ALU = 2'h0, REG_MDR = 2'h1, REG_UVAL = 2'h2, REG_B = 2'h3;

// ALU in2 select
localparam ALU_B = 2'h0, ALU_SVAL = 2'h1, ALU_4 = 2'h2, ALU_1 = 2'h3;

// CCR select
localparam CCR_CCR = 2'h0, CCR_ALU = 2'h1, CCR_FPU = 2'h2, CCR_MDR = 2'h3;

// MAR select
localparam MAR_MAR = 2'h0, MAR_BUS = 2'h1, MAR_ALU = 2'h2, MAR_A = 2'h3;

// ADDR select
localparam ADDR_PC = 1'h0, ADDR_MAR = 1'h1;

// PC select
localparam PC_PC = 3'h0, PC_NEXT = 3'h1, PC_MAR = 3'h2, PC_REL = 3'h3,
  PC_ALU = 3'h4, PC_EXC = 3'h5;

localparam REG_WRITE_NONE = 2'h0, REG_WRITE_8 = 2'h1, REG_WRITE_16 = 2'h2, REG_WRITE_DW = 2'h3;

localparam REG_SP = 4'hf;

// INT functions
localparam INT_MUL=4'h0, INT_DIV=4'h1, INT_MOD=4'h2, INT_MULU=4'h3,
  INT_DIVU=4'h4, INT_MODU=4'h5, INT_MULX = 4'h6, INT_MULUX = 4'h7,
  INT_EXT=4'h8, INT_EXTB=4'h9, INT_COM=4'ha, INT_NEG=4'hb;

// FPU functions
localparam FPU_CVTIS = 3'h0, FPU_CVTSI = 3'h1, FPU_SQRT = 3'h2, FPU_NEG = 3'h3,
  FPU_ADD = 3'h4, FPU_SUB = 3'h5, FPU_MUL = 3'h6, FPU_DIV = 3'h7;

// INT2 select
localparam INT2_B = 1'b0, INT2_SVAL = 1'b1;

// ALU functions
localparam ALU_AND =     3'h0;
localparam ALU_OR =      3'h1;
localparam ALU_ADD =     3'h2;
localparam ALU_SUB =     3'h3;
localparam ALU_LSHIFT =  3'h4;
localparam ALU_RSHIFTA = 3'h5;
localparam ALU_RSHIFTL = 3'h6;
localparam ALU_XOR =     3'h7;

// states for control
localparam
  S_RESET = 7'h0,
  S_EXC = 7'h1,
  S_EXC2 = 7'h2,
  S_EXC3 = 7'h3,
  S_EXC4 = 7'h4,
  S_EXC5 = 7'h5,
  S_EXC6 = 7'h6,
  S_EXC7 = 7'h7,
  S_FETCH = 7'h8,
    S_FETCH2 = 7'h9,
  S_EVAL = 7'ha,
  S_TERM = 7'hb,
  S_ARG = 7'hc,
  S_ARG2 = 7'hd,
  S_INH = 7'he,
  S_RELADDR = 7'hf,
  S_RELADDR2 = 7'h10,
  S_PUSH = 7'h11,
  S_PUSH2 = 7'h12,
  S_PUSH3 = 7'h13,
  S_PUSH4 = 7'h14,
  S_PUSH5 = 7'h15,
  S_POP = 7'h16,
  S_POP2 = 7'h17,
  S_POP3 = 7'h18,
  S_POP4 = 7'h19,
  S_RTS3 = 7'h1a,
  S_RTS = 7'h1b,
  S_RTS2 = 7'h1c,
  S_CMP = 7'h1d,
  S_CMP2 = 7'h1e,
  S_CMP3 = 7'h1f,
  S_CMPS = 7'h20,
  S_CMPS2 = 7'h21,
  S_CMPS3 = 7'h22,
  S_MOV = 7'h23,
  S_MOV2 = 7'h24,
  S_INTU = 7'h25,
  S_INTU2 = 7'h26,
  S_FPU = 7'h27,
  S_FP = 7'h28,
  S_FP2 = 7'h29,
  S_MDR2RA = 7'h2a,
  S_ALU = 7'h2b,
  S_ALU2 = 7'h2c,
  S_ALU3 = 7'h2d,
  S_INT = 7'h2e,
  S_INT2 = 7'h2f,
  S_INT3 = 7'h30,
  S_BRANCH = 7'h31,
  S_LDIU = 7'h32,
  S_JUMP = 7'h33,
  S_JUMP2 = 7'h34,
  S_JUMP3 = 7'h35,
  S_LOAD = 7'h36,
  S_LOAD2 = 7'h37,
  S_LOAD3 = 7'h38,
  S_LOADD = 7'h39,
  S_STORE = 7'h3a,
  S_STORE2 = 7'h3b,
  S_STORE3 = 7'h3c,
  S_STORED = 7'h3d,
  S_STORED2 = 7'h3e,
  S_STORE4 = 7'h3f,
  S_HALT = 7'h40,
  S_ALU4 = 7'h41,
  S_EXC8 = 7'h42,
  S_EXC9 = 7'h43,
  S_EXC10 = 7'h44,
  S_EXC11 = 7'h45,
  S_RTI = 7'h46,
  S_RTI2 = 7'h47,
  S_RTI3 = 7'h48,
  S_RTI4 = 7'h49;

`endif
