module uart_tx(clk, data, start, ready, serial_out);

input clk;
input [7:0] data;
input start;
output ready;
output serial_out;

reg [3:0] state;
reg [7:0] tx_byte;

wire baudclk;

assign ready = (state == 4'b0000);
assign serial_out = (state<4) | (state[3] & tx_byte[0]);

always @(posedge clk) begin
  if (ready && start)
    tx_byte <= data;
  else
    if (state[3] & baudclk)
      tx_byte <= (tx_byte >> 1); 
  case (state)
    4'b0000: if (start) state <= 4'b0100;
    4'b0100: if (baudclk) state <= 4'b1000; // start
    4'b1000: if (baudclk) state <= 4'b1001; // bit 0
    4'b1001: if (baudclk) state <= 4'b1010; // bit 1
    4'b1010: if (baudclk) state <= 4'b1011; // bit 2
    4'b1011: if (baudclk) state <= 4'b1100; // bit 3
    4'b1100: if (baudclk) state <= 4'b1101; // bit 4
    4'b1101: if (baudclk) state <= 4'b1110; // bit 5
    4'b1110: if (baudclk) state <= 4'b1111; // bit 6
    4'b1111: if (baudclk) state <= 4'b0010; // bit 7
    4'b0010: if (baudclk) state <= 4'b0000; // stop 1
    default: if (baudclk) state <= 4'b0000;
  endcase
end

baudgen txbaud(.clk(clk), .enable(~ready), .baudclk(baudclk));

endmodule
