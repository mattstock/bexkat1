module flash_controller(
  input clk_i,
  input rst_i,
  input [19:0] adr_i,
  input stb_i,
  output ack_o,
  output logic [31:0] dat_o,
  input we_i,
  input cyc_i,
  input [3:0] sel_i,
  input [7:0] databus_in,
  output [7:0] databus_out,
  output logic [21:0] addrbus_out,
  output we_n,
  output ce_n,
  output oe_n);

// for now, treat this as ROM
assign ce_n = 1'b0;
assign oe_n = 1'b0;
assign we_n = 1'b1;
assign databus_out = 8'h00;

assign ack_o = (state == STATE_DONE);

localparam [2:0] STATE_IDLE = 3'h0, STATE_WAIT = 3'h1, STATE_WAIT2 = 3'h2, STATE_WAIT3 = 3'h3, STATE_WAIT4 = 3'h4, STATE_READ = 3'h5, STATE_DONE = 3'h6;

logic [21:0] addrbus_out_next;
logic [31:0] dat_o_next;
logic [1:0] b, b_next;
logic [2:0] state, state_next;

always_ff @(posedge clk_i, posedge rst_i)
begin
  if (rst_i) begin
    b <= 2'h0;
    addrbus_out <= 22'h0;
    dat_o <= 32'h0;
    state <= STATE_IDLE;
  end else begin
    b <= b_next;
    addrbus_out <= addrbus_out_next;
    dat_o <= dat_o_next;
    state <= state_next;
  end
end

always_comb
begin
  state_next = state;
  addrbus_out_next = addrbus_out;
  b_next = b;
  dat_o_next = dat_o;
  case (state)
    STATE_IDLE: begin
      if (cyc_i & stb_i) begin
        state_next = STATE_WAIT;
        b_next = b + 2'h1;
      end
      addrbus_out_next = { adr_i, b };
    end
    STATE_WAIT: state_next = STATE_WAIT2;
    STATE_WAIT2: state_next = STATE_WAIT3;
    STATE_WAIT3: state_next = STATE_WAIT4;
    STATE_WAIT4: state_next = STATE_READ;
    STATE_READ: begin
      dat_o_next = { dat_o[23:0], databus_in };
      state_next = (b == 2'h0 ? STATE_DONE : STATE_IDLE);
    end
    STATE_DONE: state_next = STATE_IDLE;
  endcase
end

endmodule
