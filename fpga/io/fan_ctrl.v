module fan_ctrl(
  input clk_i,
  input rst_i,
  input [31:0] speed,
  output reg fan_pwm);
  
reg [16:0] tick;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    tick <= 17'h0;
    fan_pwm <= 1'b1;
  end else begin
    if (tick == speed) begin
      tick <= 17'h0;
      fan_pwm <= ~fan_pwm;
    end else begin
      tick <= tick + 1'h1;
      fan_pwm <= fan_pwm;
    end
  end
end

endmodule
