module debounce(clk, in, out);

input clk;
input in;
output out;

reg out;
reg sync_0;
reg sync_1;

always @(posedge clk) sync_0 <= ~in;
always @(posedge clk) sync_1 <= sync_0;

reg [15:0] delay_cnt;

wire idle = (out == sync_1);
wire delay_cnt_max = &delay_cnt;

always @(posedge clk)
begin
  if (idle)
    delay_cnt <= 16'b0;
  else begin
    delay_cnt <= delay_cnt + 16'b1;
    if (delay_cnt_max)
      out <= ~out;
  end
end

endmodule
