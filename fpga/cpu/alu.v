// A simple ALU design
// Matt Stock 11/16/14
module alu(
  input clk_i,
  input rst_i,
  input [WIDTH-1:0] in1,
  input [WIDTH-1:0] in2,
  input [2:0] func,
  output [WIDTH-1:0] out,
  output reg c_out,
  output z_out,
  output n_out,
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

assign n_out = out[WIDTH-1];
assign z_out = ~|out;

wire [WIDTH-1:0] out_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
  begin
    out <= 32'h0;
  end
  else
  begin
    out <= out_next;
  end
end

always @*
begin
  out_next = out;
  case (func)
    ALU_AND: begin
      out_next = in1 & in2;
      v_out = 1'b0;
      c_out = 1'b0;
    end  
    ALU_OR: begin
      out_next = in1 | in2;
      v_out = 1'b0;
      c_out = 1'b0;
    end
    ALU_XOR: begin
      out_next = in1 ^ in2;
      v_out = 1'b0;
      c_out = 1'b0;
    end
    ALU_ADD: begin
      out_next = in1 + in2;
      v_out = (in1[WIDTH-1] & in2[WIDTH-1] & ~out[WIDTH-1]) | (~in1[WIDTH-1] & ~in2[WIDTH-1] & out[WIDTH-1]);
      c_out = (in1[WIDTH-1] & in2[WIDTH-1]) | (in2[WIDTH-1] & out[WIDTH-1]) | (out[WIDTH-1] & in1[WIDTH-1]);
    end  
    ALU_SUB: begin
      out_next = in1 - in2;
      v_out = (in1[WIDTH-1] & ~in2[WIDTH-1] & ~out[WIDTH-1]) | (~in1[WIDTH-1] & in2[WIDTH-1] & out[WIDTH-1]);
      c_out = ~in1[WIDTH-1] & in2[WIDTH-1] | in2[WIDTH-1] & out[WIDTH-1] | out[WIDTH-1] & ~in1[WIDTH-1];
    end  
    ALU_LSHIFT: begin
      {c_out, out_next} = in1 << in2;
      v_out = n_out ^ c_out;
    end
    ALU_RSHIFTA: begin
      out_next = $signed(in1) >>> in2;
      c_out = 1'b0;
      v_out = n_out;
    end
    ALU_RSHIFTL: begin
      out_next = in1 >> in2;
      c_out = 1'b0;
      v_out = n_out;
    end
  endcase
end

endmodule
