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

reg [31:0] xnull [11:0];
reg [31:0] ynull [11:0];
reg [31:0] xmid [1:0];

always @(posedge clock or negedge rst_n)
begin
  if (!rst_n) begin
    for (int i=0; i < 12; i++) begin
      xnull[i] <= 32'h0;
      ynull[i] <= 32'h0;
    end
    xmid[0] <= 32'h0;
    xmid[1] <= 32'h0;
  end else begin
    for (int i=0; i < 11; i++) begin
      xnull[i] <= xnull[i+1];
      ynull[i] <= ynull[i+1];
    end
    xnull[11] <= x0;
    ynull[11] <= y0;
    xmid[0] <= xmid[1];
    xmid[1] <= xy2;
  end

end

// should be 19 cycles
fp_mult xsq0(.clock(clock), .aclr(~rst_n), .dataa(xn), .datab(xn), .result(xsq));
fp_mult ysq0(.clock(clock), .aclr(~rst_n), .dataa(yn), .datab(yn), .result(ysq));
fp_mult xymul0(.clock(clock), .aclr(~rst_n), .dataa(xn), .datab(yn), .result(xy));
fp_mult xymul1(.clock(clock), .aclr(~rst_n), .dataa(xy), .datab(32'h40000000), .result(xy2));
fp_addsub xmidsub0(.clock(clock), .aclr(~rst_n), .add_sub(1'b0), .dataa(xsq), .datab(ysq), .result(xmidsub));
fp_addsub xnext0(.clock(clock), .aclr(~rst_n), .add_sub(1'b1), .dataa(xnull[0]), .datab(xmidsub), .result(xn1));
fp_addsub ynext0(.clock(clock), .aclr(~rst_n), .add_sub(1'b1), .dataa(ynull[0]), .datab(xy2), .result(yn1));

endmodule
