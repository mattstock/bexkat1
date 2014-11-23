module baudgen(clk, enable, baudclk, control);

input clk;
input enable;
output baudclk;
input [31:0] control;

parameter clkfreq = 50000000; // 50Mhz
parameter baud = 9600; // hardcode for now

reg [15:0] counter;

reg baudclk;

always @(posedge clk)
begin
  baudclk = 1'b0;
  if (enable) begin
    if (counter < clkfreq/baud)
      counter <= counter + 1'b1;
    else begin
      baudclk = 1'b1;
      counter <= 16'h0;
    end
  end else begin
    counter <= 16'h0;
    baudclk <= 1'b0;
  end
end

endmodule
