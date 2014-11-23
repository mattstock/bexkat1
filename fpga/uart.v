module uart(clk, rst_n, rx, tx, data_in, data_out, write, address, baudclk);

input clk;
input rst_n;
input rx;
output tx;
input [15:0] data_in;
output [15:0] data_out;
input write;
input [3:0] address;
output baudclk;

wire tx_busy, rx_ready, tx_start;
wire [7:0] rx_in;

reg [31:0] control, control_next; // stores baud rate divisor, other crap
reg [7:0] tx_byte, tx_byte_next;
reg [7:0] rx_byte, rx_byte_next;
reg rx_queue, rx_queue_next, tx_queue, tx_queue_next;

// memory logic
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    control <= 32'h0001c200; // 15200, N, 8, 1 default
    tx_byte <= 8'h00;
    rx_queue <= 1'b0;
    tx_queue <= 1'b0;
  end else begin
    control <= control_next;
    tx_byte <= tx_byte_next;
    tx_queue <= tx_queue_next;
    rx_queue <= rx_queue_next;
  end
end

always @*
begin
  control_next = control;
  tx_byte_next = tx_byte;
  tx_queue_next = tx_queue;
  rx_queue_next = rx_queue;
  tx_start = 1'b0;
  if (!tx_busy) begin
    if (tx_queue) begin
      tx_start = 1'b1;
      tx_queue_next = 1'b0;
    end
  end
  if (rx_ready) begin
    rx_byte_next = rx_in;
    rx_queue_next = 1'b1;
  end 
  if (write) begin
    case (address)
      'h0: begin
        if (!tx_busy) begin
          tx_queue_next = 1'b1;
          tx_byte_next = data_in[7:0];
        end
      end
      'h2: control_next[15:0] = data_in;
      'h3: control_next[31:16] = data_in;
      default: control_next = control; // default
    endcase
  end
  case (address)
    'h0: begin
      data_out = {rx_queue, tx_queue, 6'h00, rx_byte};
      rx_queue_next = 1'b0;
    end
    'h2: data_out = control[15:0];
    'h3: data_out = control[31:16];
    default: data_out = 16'h0000;
  endcase
end

uart_tx tx0(.clk(clk), .baudclk(baudclk), .data(tx_byte), .start(tx_start), .busy(tx_busy), .serial_out(tx));
//uart_rx rx0(.clk(clk), .baudclk(baudclk), .data(rx_in), .ready(rx_ready), .serial_in(rx));
baudgen baud0(.clk(clk), .baudclk(baudclk), .enable(tx_busy), .control(control));

//uart_fifo tx_fifo0(.q(tx_byte), .rdempty(), .wrfull(tx_full), .data(data_in[7:0]), .wrclk(clk), .rdclk(), .aclr(~rst_n), .wrreq(), .rdreq());
//uart_fifo rx_fifo0(.q(rx_top), .rdempty(), .wrfull(), .data(rx_byte), .wrclk(clk), .rdclk(), .aclr(~rst_n), .wrreq(rx_ready), .rdreq());

endmodule
