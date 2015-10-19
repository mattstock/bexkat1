module flash_controller(
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
  input [25:0] address_in,
  output [26:0] address_out,
  input ready,
  output wp_n,
  output oe_n,
  output we_n,
  output ce_n);

wire select;
wire buswrite;

assign buswrite = (state == STATE_WRITE) && write;
assign select = read | write;
assign wp_n = 1'b1;
assign data_out = databus_in;
assign databus_out = data_in;
assign ce_n = ~select;
assign address_out = { 1'b0, address_in};
assign we_n = ~buswrite;
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
