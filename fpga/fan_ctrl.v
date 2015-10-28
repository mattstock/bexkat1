module fan_ctrl(
  input clk,
  input rst_n,
  output fan_pwm);
  
reg [16:0] tick;

assign fan_pwm = tick[16];

always @(posedge clk or negedge rst_n)
  if (!rst_n)
    tick <= 17'h0;
  else
    tick <= tick + 1'h1;
  
endmodule
