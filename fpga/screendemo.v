module screendemo(clk, rst_n, write, pixel, row, col);

input clk;
input rst_n;
output write;
output [23:0] pixel;
output [3:0] row;
output [4:0] col;

reg [8:0] count;
reg [23:0] pixel;
reg spin;

assign write = spin;
assign col = count[4:0];
assign row = count[8:5];

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    count <= 1'b0;
    spin <= 1'b0;
  end else begin
    spin <= ~spin;
    if (spin) begin
    case (row)
      4'h0: pixel <= { count[8:1], 16'h0000 };
      4'h1: pixel <= { count[8:1], count[8:1], 8'h00 };
      4'h2: pixel <= { 8'h00, count[8:1], 8'h00 };
      4'h3: pixel <= { 8'h00, count[8:1], count[8:1] };
      4'h4: pixel <= { 16'h0000, count[8:1] };
      4'h5: pixel <= { count[8:1], 8'h00, count[8:1] };
      4'h6: pixel <= { count[8:1], count[8:1], count[8:1] };
      4'h7: pixel <= { count[3:0], count[3:0], count[8:5], count[7:4], count[7:0] };
      4'h8: pixel <= { count[7:0], 16'h0000 };
      4'h9: pixel <= { count[7:0], count[7:0], 8'h00 };
      4'ha: pixel <= { 8'h00, count[7:0], 8'h00 };
      4'hb: pixel <= { 8'h00, count[7:0], count[8:1] };
      4'hc: pixel <= { 16'h0000, count[7:0] };
      4'hd: pixel <= { count[7:0], 8'h00, count[8:1] };
      4'he: pixel <= { count[7:0], count[7:0], count[7:0] };
      4'hf: pixel <= { count[7:4], count[4:1], count[8:5], count[5:2], count[8:1] };
    endcase
    count <= count + 1'b1;
    end
  end
end


endmodule
