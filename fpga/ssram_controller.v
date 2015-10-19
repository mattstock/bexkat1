module ssram_controller(
  input clock,
  input reset_n,
  input [31:0] databus_in,
  output [31:0] databus_out,
  input read,
  input write,
  output wait_out,
  input [31:0] data_in,
  output [31:0] data_out,
  input [3:0] be_in,
  input [21:0] address_in,
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

wire select;
wire buswrite;

assign buswrite = (state == STATE_WRITE) && write;
assign select = read | write;

assign data_out = databus_in;
assign databus_out = data_in;
assign bus_clock = clock;
assign gw_n = 1'b1;
assign adv_n = 1'b1;
assign adsp_n = 1'b1;
assign adsc_n = ~(state == STATE_ADDRLATCH);
assign ce0_n = (select && ~address_in[21]);
assign ce1_n = (select && address_in[21]);
assign address_out = { 6'h00, address_in[20:0] };
assign we_n = ~buswrite;
assign be_out = (buswrite ? ~be_in : 4'hf);
assign oe_n = ~read;
assign wait_out = (state != STATE_POST);

reg [1:0] state, state_next;

localparam [1:0] STATE_IDLE = 2'h0, STATE_ADDRLATCH = 2'h1, STATE_WRITE = 2'h2, STATE_POST = 2'h3;

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
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
      if (read || write)
        state_next = STATE_ADDRLATCH;
    STATE_ADDRLATCH:
      if (write)
        state_next = STATE_WRITE;
      else
        state_next = STATE_POST;
    STATE_WRITE: state_next = STATE_POST;
    STATE_POST: state_next = STATE_IDLE;
  endcase
end

endmodule
