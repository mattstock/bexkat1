module uart_tx(clk, baudclk, data, start, busy, serial_out);

input clk;
input baudclk;
input [7:0] data;
input start;
output busy;
output serial_out;

reg [3:0] state;
reg muxbit;

assign busy = ~(state == 4'b0000);
assign serial_out = (state<4) | (state[3] & muxbit);

always @(posedge clk)
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
  4'b1111: if (baudclk) state <= 4'b0001; // bit 7
  4'b0001: if (baudclk) state <= 4'b0000; // stop 1
  default: if (baudclk) state <= 4'b0000;
endcase

always @(*)
case (state[2:0])
  3'h0: muxbit = data[0];
  3'h1: muxbit = data[1];
  3'h2: muxbit = data[2];
  3'h3: muxbit = data[3];
  3'h4: muxbit = data[4];
  3'h5: muxbit = data[5];
  3'h6: muxbit = data[6];
  3'h7: muxbit = data[7];
endcase  

endmodule
