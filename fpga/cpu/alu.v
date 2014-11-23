// A simple 32-bit ALU design
// Matt Stock 11/16/14
module alu(
  input wire [WIDTH-1:0] in1,
  input wire [WIDTH-1:0] in2,
  input wire [3:0] func,
  input wire c_in,
  input wire z_in,
  output reg [WIDTH-1:0] out,
  output reg c_out,
  output wire z_out,
  output wire n_out,
  output reg v_out
);

parameter WIDTH = 16;

localparam ALU_NOP =     'h0;
localparam ALU_AND =     'h1;
localparam ALU_OR =      'h2;
localparam ALU_ADD =     'h3;
localparam ALU_SUB =     'h4;
localparam ALU_LSHIFT =  'h5;
localparam ALU_RSHIFTA = 'h6;
localparam ALU_RSHIFTL = 'h7;
localparam ALU_XOR =     'h8;

assign n_out = out[WIDTH-1];
assign z_out = ~|{out,z_in};

always @*
begin
  case (func)
    ALU_AND: begin
      out = in1 & in2;
      v_out = 1'b0;
      c_out = c_in;
    end  
    ALU_OR: begin
      out = in1 | in2;
      v_out = 1'b0;
      c_out = c_in;
    end
    ALU_XOR: begin
      out = in1 ^ in2;
      v_out = 1'b0;
      c_out = c_in;
    end
    ALU_ADD: begin
      out = in1 + in2 + c_in;
      v_out = (in1[WIDTH-1] & in2[WIDTH-1] & ~out[WIDTH-1]) | (~in1[WIDTH-1] & ~in2[WIDTH-1] & out[WIDTH-1]);
      c_out = (in1[WIDTH-1] & in2[WIDTH-1]) | (in2[WIDTH-1] & out[WIDTH-1]) | (out[WIDTH-1] & in1[WIDTH-1]);
    end  
    ALU_SUB: begin
      out = in1 - in2;
      v_out = (in1[WIDTH-1] & ~in2[WIDTH-1] & ~out[WIDTH-1]) | (~in1[WIDTH-1] & in2[WIDTH-1] & out[WIDTH-1]);
      c_out = ~in1[WIDTH-1] & in2[WIDTH-1] | in2[WIDTH-1] & out[WIDTH-1] | out[WIDTH-1] & ~in1[WIDTH-1];
    end  
    ALU_LSHIFT: begin
      {c_out, out} = {in1, c_in}; // carry_in should be zero, unless this is for 16 bit shift
      v_out = n_out ^ c_out;
    end
    ALU_RSHIFTA: begin
      {out, c_out} = {in1[WIDTH-1], in1};
      v_out = n_out ^ c_out;
    end
    ALU_RSHIFTL: begin
      {out, c_out} = {c_in, in1};
      v_out = n_out ^ c_out;
    end
    default: begin
      out = in1;
      v_out = 1'b0;
      c_out = c_in;
    end
  endcase
end

endmodule