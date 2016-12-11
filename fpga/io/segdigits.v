module segdigits(
  input [31:0] in,
  output [6:0] out0,
  output [6:0] out1,
  output [6:0] out2,
  output [6:0] out3,
  output [6:0] out4,
  output [6:0] out5,
  output [6:0] out6,
  output [6:0] out7);

hexdisp h0(.in(in[3:0]), .out(out0));  
hexdisp h1(.in(in[7:4]), .out(out1));  
hexdisp h2(.in(in[11:8]), .out(out2));  
hexdisp h3(.in(in[15:12]), .out(out3));  
hexdisp h4(.in(in[19:16]), .out(out4));  
hexdisp h5(.in(in[23:20]), .out(out5));  
hexdisp h6(.in(in[27:24]), .out(out6));  
hexdisp h7(.in(in[31:28]), .out(out7));  
  
endmodule

  