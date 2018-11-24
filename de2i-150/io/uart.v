module uart(
  input clk_i,
  input rst_i,
  input [3:0] sel_i,
  input [31:0] dat_i,
  output [31:0] dat_o,
  input stb_i,
  input cyc_i,
  output ack_o,
  input we_i,
  input adr_i,
  input rx,
  output tx,
  input cts,
  output rts,
  output [1:0] interrupt);

parameter clkfreq = 50000000;
parameter baud = 9600;

assign dat_o = result;
assign ack_o = (state == STATE_DONE);
assign interrupt = 2'b00;
assign rts = cts;

localparam [2:0] STATE_IDLE = 3'h0, STATE_WRITE = 3'h1, STATE_READ = 3'h2, STATE_READ2 = 3'h3, STATE_READ3 = 3'h4,
  STATE_DONE = 3'h5;
localparam [1:0] TX_IDLE = 2'h0, TX_START = 2'h1, TX_DEQUEUE = 2'h2, TX_WAIT = 2'h3;

reg [31:0] conf, conf_next, result, result_next;

// transmit logic
reg [1:0] tx_shift, tx_shift_next;
reg [2:0] state, state_next;
reg [7:0] rx_byte, rx_byte_next;
wire tx_ready, tx_empty, tx_full, rx_empty, rx_full, rx_queue;
wire [7:0] tx_top, rx_top, rx_in;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
    conf <= 32'h0;
    result <= 32'h0;
    rx_byte <= 8'h0;
    tx_shift <= TX_IDLE;
  end else begin
    state <= state_next;
    result <= result_next;
    conf <= conf_next;
    rx_byte <= rx_byte_next;
    tx_shift <= tx_shift_next;
  end
end

  
always @(*)
begin
  state_next = state;
  result_next = result;
  rx_byte_next = rx_byte;
  conf_next = conf;
  case (state)
    STATE_IDLE: begin
      if (cyc_i & stb_i) begin
        case (adr_i)
          1'b0: state_next = (we_i ? STATE_WRITE : STATE_READ);
          1'b1: begin
            if (we_i) begin
              if (sel_i[3])
                conf_next[31:24] = dat_i[31:24];
              if (sel_i[2])
                conf_next[23:16] = dat_i[23:16];
              if (sel_i[1])
                conf_next[15:8] = dat_i[15:8];
              if (sel_i[0])
                conf_next[7:0] = dat_i[7:0];
            end else
              result_next = conf;
            state_next = STATE_DONE;
          end
        endcase
      end
    end
    STATE_WRITE: state_next = STATE_DONE;
    STATE_READ: begin
      if (rx_empty) begin
        result_next[15:0] = { 2'b00, ~tx_full, 5'h00, rx_byte }; 
        state_next = STATE_DONE;
      end else
        state_next = STATE_READ2;
    end
    STATE_READ2: begin
      rx_byte_next = rx_top;
      state_next = STATE_READ3;
    end
    STATE_READ3: begin
      result_next[15:0] = { 2'b10, ~tx_full, 5'h00, rx_byte };
      state_next = STATE_DONE;
    end
    STATE_DONE: state_next = STATE_IDLE;
  endcase
end

// TX dequeue
always @*
begin
  tx_shift_next = tx_shift;
  case (tx_shift)
    TX_IDLE: begin // IDLE
      if (tx_ready && ~tx_empty)
        tx_shift_next = TX_DEQUEUE;
    end
    TX_DEQUEUE: tx_shift_next = TX_START;
    TX_START: tx_shift_next = TX_WAIT;
    TX_WAIT: begin
      if (~tx_ready)
        tx_shift_next = TX_IDLE;
    end
  endcase
end

uart_tx #(.clkfreq(clkfreq), .baud(baud)) tx0(.clk_i(clk_i), .data(tx_top), .start(tx_shift == TX_START), .ready(tx_ready), .serial_out(tx));
uart_fifo tx_fifo0(.q(tx_top), .empty(tx_empty), .full(tx_full), .data(dat_i[7:0]), .clock(clk_i), .aclr(rst_i),
  .wrreq(state == STATE_WRITE), .rdreq(tx_shift == TX_DEQUEUE));

uart_rx #(.clkfreq(clkfreq), .baud(baud)) rx0(.clk_i(clk_i), .data(rx_in), .ready(rx_queue), .serial_in(rx));
uart_fifo rx_fifo0(.q(rx_top), .empty(rx_empty), .full(rx_full), .data(rx_in), .clock(clk_i), .aclr(rst_i),
  .wrreq(rx_queue), .rdreq(state == STATE_READ));

endmodule
