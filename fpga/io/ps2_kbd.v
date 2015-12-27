module ps2_kbd(
  input clk_i,
  input rst_i,
  input ps2_clock,
  input ps2_data,
  input we_i,
  input cyc_i,
  input stb_i,
  output ready,
  output ack_o,
  output [7:0] dat_o);

reg [10:0] eventbuf, eventbuf_next;
reg [2:0] clk_reg;
reg [2:0] data_reg;
reg [3:0] count, count_next;

wire ps2_clock_falling = (clk_reg[2:1] == 2'b10);
wire ps2_clock_rising = (clk_reg[2:1] == 2'b01);
wire kbd_data = data_reg[1];
wire [7:0] event_data = eventbuf[8:1]; // STOP, PARITY, 8 x DATA, START
wire event_ready = (count == 4'h0) && ps2_clock_rising;
wire readreq = cyc_i & stb_i;

assign ack_o = ack[1];

// only need one cycle for reading onboard memory
reg [1:0] ack;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
    ack <= 2'b0;
  else
    ack <= (stb_i ? { ack[0], readreq } : 2'b0);
end

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    eventbuf <= 11'h0;
    count <= 4'h0;
    clk_reg <= 3'h0;
    data_reg <= 3'h0;
  end else begin
    eventbuf <= eventbuf_next;
    count <= count_next;
    clk_reg <= {clk_reg[1:0], ps2_clock};
    data_reg <= {data_reg[1:0], ps2_data};
  end
end

always @(*)
begin
  eventbuf_next = eventbuf;
  count_next = count; 
  if (ps2_clock_falling) begin
    if (count == 4'ha)
      count_next = 4'h0;
    else
      count_next = count + 1'b1;
    eventbuf_next = {kbd_data, eventbuf[10:1]};
  end
end

ps2_kbd_fifo fifo0(.rdclk(clk_i), .rdempty(~ready), .q(dat_o), .rdreq(readreq),
  .wrclk(clk_i), .wrreq(event_ready), .data(event_data));
  
endmodule
