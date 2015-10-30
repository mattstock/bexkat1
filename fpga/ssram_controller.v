module ssram_controller(
  input clk_i,
  input rst_i,
  input cyc_i,
  input we_i,
  input stb_i,
  output ack_o,
  input [31:0] dat_i,
  output [31:0] dat_o,
  input [3:0] sel_i,
  input [21:0] adr_i,
  input [31:0] databus_in,
  output [31:0] databus_out,
  output [26:0] address_out,
  output bus_clock,
  output gw_n,
  output adv_n,
  output adsp_n,
  output adsc_n,
  output [3:0] be_out,
  output oe_n,
  output we_n,
  output ce0_n,
  output ce1_n);

wire buswrite;
wire select;

assign select = cyc_i & stb_i;
assign ack_o = (state == STATE_POST);

assign buswrite = (state == STATE_WRITE) && we_i;

assign dat_o = databus_in;
assign databus_out = dat_i;
assign bus_clock = clk_i;
assign gw_n = 1'b1;
assign adv_n = 1'b1;
assign adsc_n = 1'b1;
assign adsp_n = ~(state == STATE_ADDRLATCH);
assign ce0_n = ~(select && ~adr_i[21]);
assign ce1_n = ~(select && adr_i[21]);
assign address_out = { 6'h00, adr_i[20:0] };
assign we_n = ~buswrite;
assign be_out = (buswrite ? ~sel_i : 4'hf);
assign oe_n = ~((state == STATE_POST) && ~we_i);

reg [1:0] state, state_next;

localparam [1:0] STATE_IDLE = 2'h0, STATE_ADDRLATCH = 2'h1, STATE_WRITE = 2'h2, STATE_POST = 2'h3;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
  end else begin
    state <= state_next;
  end
end

always @*
begin
  state_next = state;
  case (state)
    STATE_IDLE:
      if (select)
        state_next = STATE_ADDRLATCH;
    STATE_ADDRLATCH: state_next = STATE_WRITE;
    STATE_WRITE: state_next = STATE_POST;
    STATE_POST: state_next = STATE_IDLE;
  endcase
end

endmodule
