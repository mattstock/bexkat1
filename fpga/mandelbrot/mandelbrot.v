module mandelbrot(
  input clk_i,
  input rst_i,
  input [160:0] load,
  input [31:0] xn,
  input [31:0] yn,
  output [31:0] xnext,
  output [31:0] ynext,
  output [160:0] store,
  output [31:0] result);

/*
 * The idea here is to have a uniform 50 cycle pipelined operation.
 * The big challenge is to then iterate this efficiently and pull to/from
 * memory in the parent.
 */

wire [31:0] xsq, ysq, xy, xn1, yn1, xn2, xy2, xmidsub;
wire [31:0] ry, rx, x0, y0;
wire [160:0] shift_taps;

assign xnext = xnbuf[0];
assign ynext = ynbuf[0];
assign x0 = shift_taps[63:32];
assign y0 = shift_taps[31:0];
reg [31:0] xnbuf [19:0];
reg [31:0] ynbuf [19:0];

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
  begin
    for (int i=0; i < 20; i = i + 1)
    begin
      xnbuf[i] <= 32'h0;
      ynbuf[i] <= 32'h0;
    end
  end
  else
  begin
    for (int i=0; i < 19; i = i + 1)
    begin
      xnbuf[i] <= xnbuf[i+1];
      ynbuf[i] <= ynbuf[i+1];
    end
    xnbuf[19] = xn1;
    ynbuf[19] = yn1;
  end
end

// tick 0
mand_mult xsq0(.clock(clk_i), .dataa(xn), .datab(xn), .result(xsq)); // xsq <= xn * xn
mand_mult ysq0(.clock(clk_i), .dataa(yn), .datab(yn), .result(ysq)); // ysq <= yn * yn
mand_mult xymul0(.clock(clk_i), .dataa(xn), .datab(yn), .result(xy)); // xy <= xn * yn
// tick 10
mand_mult xymul1(.clock(clk_i), .dataa(xy), .datab(32'h40000000), .result(xy2)); // xy2 <= xy * 2.0
mand_sub xmidsub0(.clock(clk_i), .dataa(xsq), .datab(ysq), .result(xmidsub)); // xmidsub <= xsq - ysq
// tick 20
mand_add xnext0(.clock(clk_i), .dataa(x0), .datab(xmidsub), .result(xn1)); // 
mand_add ynext0(.clock(clk_i), .dataa(y0), .datab(xy2), .result(yn1));
// tick 30
mand_mult xn1sq0(.clock(clk_i), .dataa(xn1), .datab(xn1), .result(rx));
mand_mult yn1sq0(.clock(clk_i), .dataa(yn1), .datab(yn1), .result(ry));
// tick 40
mand_add ressum0(.clock(clk_i), .dataa(rx), .datab(ry), .result(result));
// tick 50

shift shiftreg0(.clock(clk_i), .aclr(rst_i), .shiftin(load), .shiftout(store), .taps1x(shift_taps));

endmodule
