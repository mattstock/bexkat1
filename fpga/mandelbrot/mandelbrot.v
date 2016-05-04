module mandelbrot(
  input clock,
  input rst_i,
  input trigger,
  input [31:0] x0,
  input [31:0] xn,
  input [31:0] y0,
  input [31:0] yn,
  output [31:0] x0next,
  output [31:0] y0next,
  output [31:0] xnext,
  output [31:0] ynext,
  output complete,
  output [31:0] result);

/*
 * The idea here is to have a uniform 50 cycle pipelined operation.
 * The big challenge is to then iterate this efficiently and pull to/from
 * memory in the parent.
 */

wire [31:0] xsq, ysq, xy, xn1, yn1, xn2, xy2, xmidsub;
wire [31:0] ry, rx;

assign xnext = xnbuf[0];
assign ynext = ynbuf[0];
assign x0next = xbuf[0];
assign y0next = ybuf[0];
assign complete = active[0];

reg [49:0] active;
reg [31:0] xbuf [49:0];
reg [31:0] ybuf [49:0];
reg [31:0] xnbuf [19:0];
reg [31:0] ynbuf [19:0];

always @(posedge clock or posedge rst_i)
begin
  if (rst_i)
  begin
    active <= 50'h0;
    for (int i=0; i < 50; i = i + 1)
    begin
      xbuf[i] <= 32'h0;
      ybuf[i] <= 32'h0;
    end
    for (int i=0; i < 20; i = i + 1)
    begin
      xnbuf[i] <= 32'h0;
      ynbuf[i] <= 32'h0;
    end
  end
  else
  begin
    active <= { trigger, active[49:1] };
    for (int i=0; i < 49; i = i + 1)
    begin
      xbuf[i] <= xbuf[i+1];
      ybuf[i] <= ybuf[i+1];
    end
    for (int i=0; i < 19; i = i + 1)
    begin
      xnbuf[i] <= xnbuf[i+1];
      ynbuf[i] <= ynbuf[i+1];
    end
    xnbuf[19] = xn1;
    ynbuf[19] = yn1;
    xbuf[49] <= x0;
    ybuf[49] <= y0;
  end
end

// tick 0
mand_mult xsq0(.clock(clock), .dataa(xn), .datab(xn), .result(xsq)); // xsq <= xn * xn
mand_mult ysq0(.clock(clock), .dataa(yn), .datab(yn), .result(ysq)); // ysq <= yn * yn
mand_mult xymul0(.clock(clock), .dataa(xn), .datab(yn), .result(xy)); // xy <= xn * yn
// tick 10
mand_mult xymul1(.clock(clock), .dataa(xy), .datab(32'h40000000), .result(xy2)); // xy2 <= xy * 2.0
mand_sub xmidsub0(.clock(clock), .dataa(xsq), .datab(ysq), .result(xmidsub)); // xmidsub <= xsq - ysq
// tick 20
mand_add xnext0(.clock(clock), .dataa(xbuf[30]), .datab(xmidsub), .result(xn1)); // 
mand_add ynext0(.clock(clock), .dataa(ybuf[30]), .datab(xy2), .result(yn1));
// tick 30
mand_mult xn1sq0(.clock(clock), .dataa(xn1), .datab(xn1), .result(rx));
mand_mult yn1sq0(.clock(clock), .dataa(yn1), .datab(yn1), .result(ry));
// tick 40
mand_add ressum0(.clock(clock), .dataa(rx), .datab(ry), .result(result));
// tick 50

endmodule
