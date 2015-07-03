module uart(clk, rst_n, rx, tx, be, data_in, data_out, select, write, address);

parameter clkfreq = 50000000;
parameter baud = 9600;

input clk;
input rst_n;
input rx;
input select;
output tx;
input [3:0] be;
input [31:0] data_in;
output [31:0] data_out;
input write;
input address;

wire tx_ready, rx_ready, tx_start;
wire [7:0] rx_in, tx_byte;

assign tx_byte = data_in[7:0];

reg [7:0] rx_byte, rx_byte_next;
reg [1:0] rx_queue, rx_queue_next;
reg tx_queue, tx_queue_next;

// memory logic
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    rx_queue <= 2'b00;
    rx_byte <= 8'h00;
    tx_queue <= 1'b0;
  end else begin
    rx_byte <= rx_byte_next;
    tx_queue <= tx_queue_next;
    rx_queue <= rx_queue_next;
  end
end

always @*
begin
  rx_byte_next = rx_byte;
  tx_queue_next = tx_queue;
  rx_queue_next = rx_queue;
  tx_start = 1'b0;
  data_out = 0;
  case ({select, write})
    'b11: begin    
      case (address)
        'h1: begin
          // nothing for now
        end
        'h0: begin
          if (tx_ready && be[0]) begin
            tx_queue_next = 1'b1;
          end
        end
      endcase
    end
    'b10: begin
      case (address)
        'h0: begin
          data_out = {16'h0000, rx_queue[0], tx_queue, tx_ready, 5'h00, rx_byte};
          if (rx_queue == 2'b01)
            rx_queue_next = 2'b11;
        end
        'h1: begin
          data_out = 32'hbeef0023;
        end
      endcase
    end
    'b00: if (rx_queue == 2'b11) rx_queue_next = 2'b00;
    'b01: begin end
  endcase
  if (rx_ready) begin
    rx_byte_next = rx_in;
    rx_queue_next = 2'b01;
  end
  if (tx_ready) begin
    if (tx_queue) begin
      tx_start = 1'b1;
      tx_queue_next = 1'b0;
    end
  end  
end

uart_tx #(.clkfreq(clkfreq), .baud(baud)) tx0(.clk(clk), .data(tx_byte), .start(tx_start), .ready(tx_ready), .serial_out(tx));
uart_rx #(.clkfreq(clkfreq), .baud(baud)) rx0(.clk(clk), .data(rx_in), .ready(rx_ready), .serial_in(rx));

//uart_fifo tx_fifo0(.q(tx_byte), .rdempty(), .wrfull(tx_full), .data(data_in[7:0]), .wrclk(clk), .rdclk(), .aclr(~rst_n), .wrreq(), .rdreq());
//uart_fifo rx_fifo0(.q(rx_top), .rdempty(), .wrfull(), .data(rx_byte), .wrclk(clk), .rdclk(), .aclr(~rst_n), .wrreq(rx_ready), .rdreq());

endmodule
