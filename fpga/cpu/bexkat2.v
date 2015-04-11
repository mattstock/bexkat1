`timescale 1ns / 1ns

module bexkat2(
  input clk,
  input reset_n,
  input waitrequest,
  output [31:0] address,
  output reg read,
  output reg write,
  input [31:0] readdata,
  output [31:0] writedata,
  output [3:0] byteenable);

// Control signals
wire [1:0] reg_write;
wire [2:0] alu_func, int_func;
wire addrsel, ir_write, ccr_write;
wire [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
wire [1:0] pcsel, marsel, alu1sel, int1sel, int2sel;
wire [2:0] mdrsel, regsel, alu2sel;

// Data paths
wire [31:0] alu_out, reg_data_out1, reg_data_out2;
wire [31:0] ir_next;
wire [63:0] int_out;
wire [3:0] ccr_next;
wire alu_carry, alu_negative, alu_overflow, alu_zero;

// Special registers
reg [31:0] mdr, mdr_next, mar, pc, aluval, ir;
reg [32:0] pc_next, mar_next;
reg [31:0] reg_data_in, alu_in1, alu_in2, int_in1, int_in2;
reg [63:0] intval;
reg [3:0] ccr;

// opcode format
wire [31:0] ir_ind = { {21{ir[10]}}, ir[10:0] };
wire [31:0] ir_bra = { {16{ir[15]}}, ir[15:0] };

// Data switching logic
assign writedata = mdr;
assign address = (addrsel ? mar : pc);
assign ir_next = (ir_write ? readdata : ir);
assign ccr_next = (ccr_write ? {alu_carry, alu_negative, alu_overflow, alu_zero} : ccr);

always @(posedge clk or negedge reset_n)
begin
  if (!reset_n) begin
    pc <= 'hffffc000; // start boot at base of monitor for now
    ir <= 0;
    mdr <= 0;
    mar <= 0;
    aluval <= 0;
    intval <= 0;
    ccr <= 4'b0000;
  end else begin
    pc <= pc_next[31:0];
    ir <= ir_next;
    mdr <= mdr_next;
    mar <= mar_next[31:0];
    aluval <= alu_out;
    intval <= int_out;
    ccr <= ccr_next;
  end
end

always @* begin
  case (pcsel)
    2'h0: pc_next = pc;
    2'h1: pc_next = pc + 'h4;
    2'h2: pc_next = { 1'b0, mar };
    2'h3: pc_next = { 1'b0, pc } + ir_bra;  // relative branching
    default: pc_next = pc;
  endcase  
  case (marsel)
    2'h0: mar_next = mar;
    2'h1: mar_next = readdata;
    2'h2: mar_next = aluval;
    2'h3: mar_next = reg_data_out1;
    default: mar_next = mar;
  endcase 
  case (mdrsel)
    3'h0: mdr_next = mdr;
    3'h1: mdr_next = readdata;
    3'h2: mdr_next = aluval;
    3'h3: mdr_next = reg_data_out1;
    3'h4: mdr_next = intval[31:0];
    3'h5: mdr_next = intval[63:32];
    default: mdr_next = mdr;
  endcase
  case (regsel)
    3'h0: reg_data_in = aluval;
    3'h1: reg_data_in = mdr;
    3'h2: reg_data_in = -reg_data_out2;
    3'h3: reg_data_in = ~reg_data_out2;
    3'h4: reg_data_in = reg_data_out2;
    3'h5: reg_data_in = {{16{ir[15]}}, ir[15:0] }; // sign ext
    3'h6: reg_data_in = { 16'h0000, ir[15:0] }; // no sign ext
    default: reg_data_in = 0;
  endcase
  case (alu1sel)
    3'h0: alu_in1 = reg_data_out1;
    3'h1: alu_in1 = mar;
    3'h2: alu_in1 = mdr;
    default: alu_in1 = 0;
  endcase
  case (alu2sel)
    3'h0: alu_in2 = reg_data_out2;
    3'h1: alu_in2 = ir_ind;
    3'h2: alu_in2 = 1;
    3'h3: alu_in2 = ir_bra;
    3'h4: alu_in2 = 4;
    3'h5: alu_in2 = mdr;
    default: alu_in2 = 0;
  endcase
  case (int1sel)
    3'h0: int_in1 = reg_data_out1;
    default: int_in1 = reg_data_out1;
  endcase
  case (int2sel)
    3'h0: int_in2 = reg_data_out2;
    3'h1: int_in2 = mdr;
    default: int_in2 = reg_data_out2;
  endcase  
end

control con0(.clock(clk), .reset_n(reset_n), .ir(ir), .ir_write(ir_write), .ccr(ccr), .ccr_write(ccr_write), .alu_func(alu_func), .alu1sel(alu1sel), .alu2sel(alu2sel),
  .regsel(regsel), .reg_read_addr1(reg_read_addr1), .reg_read_addr2(reg_read_addr2), .reg_write_addr(reg_write_addr), .reg_write(reg_write),
  .mdrsel(mdrsel), .marsel(marsel), .pcsel(pcsel), .int1sel(int1sel), .int2sel(int2sel), .int_func(int_func),
  .addrsel(addrsel), .byteenable(byteenable), .bus_read(read), .bus_write(write), .bus_wait(waitrequest));

alu alu0(.in1(alu_in1), .in2(alu_in2), .func(alu_func), .out(alu_out), .c_out(alu_carry), .n_out(alu_negative), .v_out(alu_overflow), .z_out(alu_zero));
intcalc int0(.clock(clk), .func(int_func), .in1(int_in1), .in2(int_in2), .out(int_out));
registerfile intreg(.clk(clk), .rst_n(reset_n), .read1(reg_read_addr1), .read2(reg_read_addr2), .write_addr(reg_write_addr),
  .write_data(reg_data_in), .write_en(reg_write), .data1(reg_data_out1), .data2(reg_data_out2));

endmodule
