module mandelbrot(
  input clock,
  input rst_n,
  input [31:0] x0,
  input [31:0] xn,
  input [31:0] y0,
  input [31:0] yn,
  output [31:0] xn1,
  output [31:0] yn1);

wire [31:0] xsq, ysq, xy, xy2, xmidsub;

// tick 0
mand_mult xsq0(.clock(clock), .dataa(xn), .datab(xn), .result(xsq)); // xsq <= xn * xn
mand_mult ysq0(.clock(clock), .dataa(yn), .datab(yn), .result(ysq)); // ysq <= yn * yn
mand_mult xymul0(.clock(clock), .dataa(xn), .datab(yn), .result(xy)); // xy <= xn * yn
// tick 10
mand_mult xymul1(.clock(clock), .dataa(xy), .datab(32'h40000000), .result(xy2)); // xy2 <= xy * 2.0
mand_sub xmidsub0(.clock(clock), .dataa(xsq), .datab(ysq), .result(xmidsub)); // xmidsub <= xsq - ysq
// tick 20
mand_add xnext0(.clock(clock), .dataa(x0), .datab(xmidsub), .result(xn1)); // 
mand_add ynext0(.clock(clock), .dataa(y0), .datab(xy2), .result(yn1));
// tick 30

endmodule
