module spi_xcvr(clk, rst_n, conf, start, rx, done, tx, miso, mosi, sclk);

parameter clkfreq = 50000000;
parameter speed = 500000; // 500kHz default

input clk;
input rst_n;
input [15:0] conf;
input start;
output [7:0] rx;
output done;
input [7:0] tx;
input miso;
output mosi;
output sclk;

reg [8:0] buffer, buffer_next;
reg done, done_next;
reg [1:0] state, state_next;
reg sclk, sclk_next;
reg [2:0] bits, bits_next;

reg spiclk;
reg [31:0] counter;

localparam STATE_IDLE = 'h0, STATE_LEAD = 'h1, STATE_TRAIL = 'h2;

assign done = (state == STATE_IDLE);
assign mosi = buffer[8];
assign rx = buffer[8:1];

wire cpol, cpha;
assign {cpol, cpha} = conf[1:0];

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    state <= STATE_IDLE;
    buffer <= 8'h00;
    sclk <= 1'b1;
    bits <= 'h0;
  end else begin
    state <= state_next;
    buffer <= buffer_next;
    sclk <= sclk_next;
    bits <= bits_next;
  end
end

always @(posedge clk)
begin
  spiclk = 1'b0;
  if (state != 4'h0)
    if (counter < clkfreq/speed)
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
        buffer_next[8:1] = tx;
        state_next = STATE_LEAD;
        bits_next = 'h7;
      end
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
