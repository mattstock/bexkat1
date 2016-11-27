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
assign ack_o = (state == STATE_POST || state == STATE_WRITE);

assign buswrite = (state == STATE_WRITE) && we_i;

assign dat_o = (state == STATE_POST ? databus_in : 32'h0);
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
assign oe_n = we_i;

reg [2:0] state, state_next;

localparam [2:0] STATE_IDLE = 'h0, STATE_ADDRLATCH = 'h1, STATE_WRITE = 'h2, STATE_POST = 'h3, STATE_READ = 'h4;

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
    STATE_ADDRLATCH: state_next = (we_i ? STATE_WRITE : STATE_READ);
    STATE_WRITE: state_next = STATE_IDLE;
	 STATE_READ: state_next = STATE_POST;
    STATE_POST: state_next = STATE_IDLE;
  endcase
end

endmodule
