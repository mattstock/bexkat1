module uart(clk, rst_n, rx, tx, be, data_in, data_out, select, write, address, interrupt);

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
output [1:0] interrupt;

assign interrupt = { rx_state == 2'b10, 1'b0 };

// transmit logic
reg [1:0] tx_state, tx_state_next, tx_shift, tx_shift_next;
wire tx_ready, tx_empty, tx_dequeue, tx_queue, tx_start, tx_full;
wire [7:0] tx_top;
reg [7:0] tx_byte, tx_byte_next;

assign tx_dequeue = (tx_shift == 2'b01);
assign tx_start = (tx_shift == 2'b10);
assign tx_queue = (tx_state == 2'b01);

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    tx_shift <= 2'b00;
    tx_state <= 2'b00;
    tx_byte <= 8'h00;
  end else begin
    tx_shift <= tx_shift_next;
    tx_state <= tx_state_next;
    tx_byte <= tx_byte_next;
  end
end

// TX dequeue
always @*
begin
  tx_shift_next = tx_shift;
  case (tx_shift)
    2'b00: begin // IDLE
      if (tx_ready && ~tx_empty)
        tx_shift_next = 2'b01;
    end
    2'b01: tx_shift_next = 2'b10; // DEQUEUE
    2'b10: tx_shift_next = 2'b11; // TX_START
    2'b11: begin // TX_WAIT
      if (~tx_ready)
        tx_shift_next = 2'b00;
    end
  endcase
end

// TX enqueue
always @*
begin
  tx_state_next = tx_state;
  tx_byte_next = tx_byte;
  case (tx_state)
    2'b00: begin // IDLE
      if (~tx_full && be[0] && select && write && ~address) begin
        tx_byte_next = data_in[7:0];
        tx_state_next = 2'b01;
      end
    end
    2'b01: tx_state_next = 2'b10; // TX_ENQUEUE
    2'b10: begin // TX_END
      if (~select)
        tx_state_next = 2'b00;
    end
    2'b11: begin end
  endcase
end

uart_tx #(.clkfreq(clkfreq), .baud(baud)) tx0(.clk(clk), .data(tx_top), .start(tx_start), .ready(tx_ready), .serial_out(tx));
uart_fifo tx_fifo0(.q(tx_top), .empty(tx_empty), .full(tx_full), .data(tx_byte), .clock(clk), .aclr(~rst_n), .wrreq(tx_queue), .rdreq(tx_dequeue));

// recieve logic
wire [7:0] rx_top, rx_in;
wire rx_empty, rx_full, rx_queue, rx_dequeue;
reg [7:0] rx_byte, rx_byte_next;
reg rx_ready, rx_ready_next;
reg [1:0] rx_state, rx_state_next;

assign data_out = { 16'h0000, rx_state[1], 1'b0, ~tx_full, 5'h00, rx_byte};

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    rx_byte <= 8'h00;
    rx_state <= 2'b00;
  end else begin
    rx_byte <= rx_byte_next;
    rx_state <= rx_state_next;
  end
end

always @*
begin
  rx_byte_next = rx_byte;
  rx_state_next = rx_state;
  rx_dequeue = 1'b0;
  case (rx_state)
    'b00: begin // RECV_WAIT
      if (~rx_empty) begin
        rx_dequeue = 1'b1;
        rx_state_next = 2'b01;
      end
    end
    'b01: begin // LOAD_BYTE
      rx_byte_next = rx_top;
      rx_state_next = 2'b10;
    end
    'b10: begin // READ_WAIT
      if (select && ~write)
        rx_state_next = 2'b11;
    end
    'b11: begin // READ_END
      if (~select)
        rx_state_next = 2'b00;
    end
  endcase
end

uart_rx #(.clkfreq(clkfreq), .baud(baud)) rx0(.clk(clk), .data(rx_in), .ready(rx_queue), .serial_in(rx));
uart_fifo rx_fifo0(.q(rx_top), .empty(rx_empty), .full(rx_full), .data(rx_in), .clock(clk), .aclr(~rst_n), .wrreq(rx_queue), .rdreq(rx_dequeue));

endmodule
