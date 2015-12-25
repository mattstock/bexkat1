module ps2_kbd(
  input clk_i,
  input rst_i,
  input ps2_clock,
  input ps2_data,
  output event_ready,
  output [7:0] event_data);

reg [10:0] eventbuf, eventbuf_next;
reg [2:0] clk_reg;
reg [2:0] data_reg;
reg [3:0] count, count_next;

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

wire ps2_clock_falling = (clk_reg[2:1] == 2'b10);
wire ps2_clock_rising = (clk_reg[2:1] == 2'b01);
wire kbd_data = data_reg[1];

assign event_data = eventbuf[8:1]; // STOP, PARITY, 8 x DATA, START
assign event_ready = (count == 4'h0) && ps2_clock_rising;

always @(*)
begin
  eventbuf_next = eventbuf;
  count_next = count; 
  if (ps2_clock_falling) begin
    if (count == 4'ha)
      count_next = 4'h0;
    else
      count_next = count + 1'b1;
    eventbuf_next <= {kbd_data, eventbuf[10:1]};
  end
end

endmodule
