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

assign buswrite = (state == STATE_WRITE || state == STATE_WRITE2) && we_i;

assign dat_o = (state == STATE_POST ? result : 32'h0);
assign databus_out = dat_i;
assign bus_clock = clockout;
assign gw_n = 1'b1;
assign adv_n = 1'b1;
assign adsp_n = 1'b1;
assign adsc_n = ~(state == STATE_ADDRLATCH || state == STATE_ADDRLATCH2);
assign ce0_n = ~(select && adr_i[21]);
assign ce1_n = ~(select && ~adr_i[21]);
assign address_out = { 6'h00, adr_i[20:0] };
assign we_n = ~buswrite;
assign be_out = (buswrite ? ~sel_i : 4'hf);
assign oe_n = we_i || ~(state == STATE_READ || state == STATE_READ2 || state == STATE_WAIT || state == STATE_WAIT2);

logic [3:0] state, state_next;
logic [31:0] result, result_next;
logic clockout;

localparam [3:0] STATE_IDLE = 'h0, STATE_ADDRLATCH = 'h1, STATE_WRITE = 'h2, STATE_POST = 'h3, STATE_READ = 'h4, STATE_READ2 = 'h5, STATE_ADDRLATCH2 = 'h6,
  STATE_WAIT = 'h7, STATE_WAIT2 = 'h8, STATE_WRITE2 = 'h9;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
	 result <= 32'h0;
	 clockout <= 1'h0;
  end else begin
    state <= state_next;
	 result <= result_next;
	 clockout <= ~clockout;
  end
end

always_comb
begin
  state_next = state;
  result_next = result;
  case (state)
    STATE_IDLE: // low to high
      if (select && clockout)
        state_next = STATE_ADDRLATCH;
    STATE_ADDRLATCH: state_next = STATE_ADDRLATCH2;
	 STATE_ADDRLATCH2: state_next = (we_i ? STATE_WRITE : STATE_WAIT);
	 STATE_WAIT: state_next = STATE_WAIT2;
	 STATE_WAIT2: state_next = STATE_READ; 
    STATE_WRITE: state_next = STATE_WRITE2;
	 STATE_WRITE2: state_next = STATE_POST;
	 STATE_READ: state_next = STATE_READ2;
	 STATE_READ2: begin
	   result_next = databus_in;
	   state_next = STATE_POST;
    end
    STATE_POST: state_next = STATE_IDLE;
	 default: state_next = STATE_IDLE;
  endcase
end

endmodule
