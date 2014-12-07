// A simple 32/16-bit ALU design
// Matt Stock 12/2/14
module doublealu(
  input wire [WIDTH-1:0] in1,
  input wire [WIDTH-1:0] in2,
  input wire [1:0] path_width,
  input wire [3:0] func,
  input wire c_in,
  input wire z_in,
  output reg [WIDTH-1:0] out,
  output reg c_out,
  output wire z_out,
  output wire n_out,
  output reg v_out
);

parameter WIDTH = 32;

assign n_out = (|path_width ? f_negative : h_negative);
assign c_out = (|path_width ? f_carry : h_carry);
assign v_out = (|path_width ? f_overflow : h_overflow);
assign z_out = (|path_width ? f_zero : h_zero);
assign out = (|path_width ? {alu1_out, alu0_out} : {16'h0000, alu0_out});

wire [WIDTH/2-1:0] alu0_out, alu1_out;
wire h_carry;
wire h_negative;
wire h_overflow;
wire h_zero;
wire f_carry;
wire f_negative;
wire f_overflow;
wire f_zero;

alu #(16) alu1(.in1((path_width[1] ? in1[WIDTH-1:WIDTH/2] : 'h0000)),
               .in2((path_width[0] ? in2[WIDTH-1:WIDTH/2] : 'h0000)), .func(func), .out(alu1_out),
  .c_in(h_carry), .z_in(h_zero), .c_out(f_carry), .n_out(f_negative), .v_out(f_overflow), .z_out(f_zero));
  
alu #(16) alu0(.in1(in1[WIDTH/2-1:0]), .in2(in2[WIDTH/2-1:0]), .func(func), .out(alu0_out),
  .c_in(c_in), .z_in(z_in), .c_out(h_carry), .n_out(h_negative), .v_out(h_overflow), .z_out(h_zero));

endmodule
