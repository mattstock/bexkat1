// A simple ALU design
// Matt Stock 11/16/14
module alu(
  input wire [WIDTH-1:0] in1,
  input wire [WIDTH-1:0] in2,
  input wire [3:0] func,
  input wire c_in,
  input wire z_in,
  output reg [WIDTH-1:0] out_long,
  output reg [WIDTH-1:0] out,
  output reg c_out,
  output wire z_out,
  output wire n_out,
  output reg v_out
);

parameter WIDTH = 32;

localparam ALU_AND =     'h0;
localparam ALU_OR =      'h1;
localparam ALU_ADD =     'h2;
localparam ALU_SUB =     'h3;
localparam ALU_LSHIFT =  'h4;
localparam ALU_RSHIFTA = 'h5;
localparam ALU_RSHIFTL = 'h6;
localparam ALU_XOR =     'h7;
localparam ALU_MUL =     'h8;
localparam ALU_MULU =    'h9;

assign n_out = out[WIDTH-1];
assign z_out = ~|{out,z_in};

wire [2*WIDTH-1:0] mul_out, mulu_out;

always @*
begin
  case (func)
    ALU_AND: begin
      out = in1 & in2;
      out_long = 'h0;
      v_out = 1'b0;
      c_out = c_in;
    end  
    ALU_OR: begin
      out = in1 | in2;
      out_long = 'h0;
      v_out = 1'b0;
      c_out = c_in;
    end
    ALU_XOR: begin
      out = in1 ^ in2;
      out_long = 'h0;
      v_out = 1'b0;
      c_out = c_in;
    end
    ALU_ADD: begin
      out = in1 + in2 + c_in;
      out_long = 'h0;
      v_out = (in1[WIDTH-1] & in2[WIDTH-1] & ~out[WIDTH-1]) | (~in1[WIDTH-1] & ~in2[WIDTH-1] & out[WIDTH-1]);
      c_out = (in1[WIDTH-1] & in2[WIDTH-1]) | (in2[WIDTH-1] & out[WIDTH-1]) | (out[WIDTH-1] & in1[WIDTH-1]);
    end  
    ALU_SUB: begin
      out = in1 - in2;
      out_long = 'h0;
      v_out = (in1[WIDTH-1] & ~in2[WIDTH-1] & ~out[WIDTH-1]) | (~in1[WIDTH-1] & in2[WIDTH-1] & out[WIDTH-1]);
      c_out = ~in1[WIDTH-1] & in2[WIDTH-1] | in2[WIDTH-1] & out[WIDTH-1] | out[WIDTH-1] & ~in1[WIDTH-1];
    end  
    ALU_LSHIFT: begin
      {c_out, out} = in1 << in2;
      out_long = 'h0;
      v_out = n_out ^ c_out;
    end
    ALU_RSHIFTA: begin
      {out, c_out} = in1 >>> in2;
      out_long = 'h0;
      v_out = n_out ^ c_out;
    end
    ALU_RSHIFTL: begin
      {out, c_out} = in1 >> in2;
      out_long = 'h0;
      v_out = n_out ^ c_out;
    end
    ALU_MUL: begin
      {out_long, out} = mul_out;
      c_out = 1'b0;
      v_out = 1'b0;
    end
    ALU_MULU: begin
      {out_long, out} = mulu_out;
      c_out = 1'b0;
      v_out = 1'b0;
    end
    default: begin
      out = in1;
      out_long = 'h0;
      v_out = 1'b0;
      c_out = c_in;
    end
  endcase
end

intumult m0(.dataa(in1), .datab(in2), .result(mulu_out));
intsmult m1(.dataa(in1), .datab(in2), .result(mul_out));

endmodule
