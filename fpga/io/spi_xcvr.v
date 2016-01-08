module spi_xcvr(
  input clk_i,
  input rst_i,
  input [15:0] conf,
  input start,
  output [7:0] rx,
  output reg done,
  input [7:0] tx,
  input miso,
  output mosi,
  output reg sclk);

parameter clockfreq = 50000000; // 50MHz
parameter speed3 =    30000000; // 13MHz
parameter speed2 =    20000000; // 8MHz
parameter speed1 =    10000000; // 4.167MHz
parameter speed0 =     1000000; // 1MHz

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

logic [31:0] maxval;
wire cpol, cpha;
wire [1:0] speedselect;

assign {speedselect, cpol, cpha} = conf[3:0];

always_comb
  case (speedselect)
    2'b00: maxval = clockfreq/speed0;
    2'b01: maxval = clockfreq/speed1;
    2'b10: maxval = clockfreq/speed2;
    2'b11: maxval = clockfreq/speed3;
  endcase

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
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

always @(posedge clk_i)
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
