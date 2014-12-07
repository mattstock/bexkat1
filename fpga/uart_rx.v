module uart_rx(clk, baudclk, data, ready, serial_in);

input clk;
input baudclk;
output [7:0] data;
output ready;
input serial_in;

assign ready = 1'b0;
assign data = 8'h00;

endmodule
