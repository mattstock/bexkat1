module spi_xcvr(
  input clock,
  input reset_n,
  input [15:0] conf,
  input start,
  output [7:0] rx,
  output reg done,
  input [7:0] tx,
  input miso,
  output mosi,
  output reg sclk);

parameter clockfreq = 50000000; // 50MHz
parameter hispeed =  8000000; //  16MHz
parameter lospeed =  500000; //  1Mhz

reg [8:0] buffer, buffer_next;
reg done_next;
reg [1:0] state, state_next;
reg sclk_next;
reg [2:0] bits, bits_next;

reg spiclk;
reg [31:0] counter;

localparam STATE_IDLE = 2'h0, STATE_LEAD = 2'h1, STATE_TRAIL = 2'h2, STATE_START = 2'h3;

assign done = (state == STATE_IDLE);
assign mosi = buffer[8];
assign rx = (cpha ? buffer[7:0] : buffer[8:1]);

wire [31:0] maxval;
wire speedselect, cpol, cpha;

assign {speedselect, cpol, cpha} = conf[2:0];
assign maxval = (speedselect ? clockfreq/hispeed : clockfreq/lospeed);

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_IDLE;
    buffer <= 8'h00;
    sclk <= 1'b0;
    bits <= 'h0;
  end else begin
    state <= state_next;
    buffer <= buffer_next;
    sclk <= sclk_next;
    bits <= bits_next;
  end
end

always @(posedge clock)
begin
  spiclk = 1'b0;
  if (state != 4'h0)
    if (counter < maxval)
      counter = counter + 1'h1;
    else begin
      counter = 'h0;
      spiclk = 1'b1;
    end
  else
    counter = 'h0;
end

always @*
begin
  state_next = state;
  buffer_next = buffer;
  sclk_next = sclk;
  bits_next = bits;
  case (state)
    STATE_IDLE: begin
      sclk_next = cpol;
      if (start) begin
        buffer_next = (cpha ? { 1'b0, tx } : { tx, 1'b0 });
        bits_next = 'h7;
        state_next = STATE_START;
      end
    end
    STATE_START: begin // clock still in inactive state, but present the correct buffer info
      if (spiclk)
        state_next = STATE_LEAD;
    end
    STATE_LEAD: begin // leading edge
      if (spiclk) begin
        if (cpha)
          buffer_next = buffer << 1;
        else
          buffer_next[0] = miso;
        sclk_next = ~sclk;
        state_next = STATE_TRAIL;
      end
    end
    STATE_TRAIL: begin // trailing edge
      if (spiclk) begin
        if (cpha)
          buffer_next[0] = miso;
        else
          buffer_next = buffer << 1;  
        sclk_next = ~sclk;
        bits_next = bits - 1'b1;
        if (bits == 'h0)
          state_next = STATE_IDLE;
        else
          state_next = STATE_LEAD;
      end
    end
  endcase
end

endmodule
