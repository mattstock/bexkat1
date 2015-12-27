module uart_rx(clk_i, data, ready, serial_in);

parameter clkfreq = 500000000;
parameter baud = 9600;

input clk_i;
output [7:0] data;
output ready;
input serial_in;

reg [1:0] rx_sync;
reg [1:0] rx_count;
reg rx_bit;
reg [3:0] state;
reg [2:0] bit_spacing;

wire next_bit = baud8clk && (bit_spacing == 'h7);
wire baud8clk;

always @(posedge clk_i)
if (baud8clk) begin
  rx_sync <= {rx_sync[0], serial_in};
  if (rx_sync[1] && rx_count != 2'b11)
    rx_count <= rx_count + 1'b1;
  else
    if (~rx_sync[1] && rx_count != 2'b00)
      rx_count <= rx_count - 1'b1;
  if (rx_count == 2'b00)
    rx_bit <= 1'b0;
  else
    if (rx_count == 2'b11)
      rx_bit <= 1'b1;
  case (state)
    4'b0000: if (~rx_bit) state <= 4'b1000;
    4'b0001: if (next_bit) state <= 4'b1000;
    4'b1000: if (next_bit) state <= 4'b1001;
    4'b1001: if (next_bit) state <= 4'b1010;
    4'b1010: if (next_bit) state <= 4'b1011;
    4'b1011: if (next_bit) state <= 4'b1100;
    4'b1100: if (next_bit) state <= 4'b1101;
    4'b1101: if (next_bit) state <= 4'b1110;
    4'b1110: if (next_bit) state <= 4'b1111;
    4'b1111: if (next_bit) state <= 4'b0010;
    4'b0010: if (next_bit) state <= 4'b0000;
    default: state <= 4'b0000;
  endcase
end

always @(posedge clk_i)
if (state == 0)
  bit_spacing <= 0;
else
  if (baud8clk)
    bit_spacing <= bit_spacing + 1'b1;

always @(posedge clk_i) begin
  if (baud8clk && next_bit && state[3])
    data <= {rx_bit, data[7:1]};
  ready <= (state == 4'b0010 && next_bit && rx_bit);
end

baudgen #(.clkfreq(clkfreq), .baud(8*baud)) rxbaud(.clk_i(clk_i), .enable(1'b1), .baudclk(baud8clk));

endmodule
