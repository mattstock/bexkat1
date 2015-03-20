module buscontroller(
  input clock,
  input reset_n,
  input [31:0] bm_address,
  input bm_read,
  input bm_write,
  output bm_wait,
  output start,
  output [7:0] chipselect);
  
reg [3:0] delay, delay_next;
reg [7:0] cs;
reg [1:0] state, state_next;

localparam [1:0] STATE_IDLE = 2'b00, STATE_START = 2'b01, STATE_PRE = 2'b10, STATE_POST = 2'b11;

assign bm_wait = (state == STATE_START || state_next == STATE_START || state == STATE_PRE);
assign chipselect = (state != STATE_IDLE ? cs : 8'h00);
assign start = (state == STATE_START);

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_IDLE;
    delay <= 4'h0;
  end else begin
    state <= state_next;
    delay <= delay_next;
  end
end

always @*
begin
  if (bm_address >= 32'h0 && bm_address < 4*4096)
    cs = 8'b01000000;
  else if (bm_address >= 32'h00800000 && bm_address < 32'h008007ff)
    cs = 8'b00100000;
  else if (bm_address >= 32'hffffc000 && bm_address < 32'hffffffff)
    cs = 8'b10000000;
  else
    cs = 8'b00000000;
end

always @*
begin
  state_next = state;
  delay_next = delay;
  case (state)
    STATE_IDLE: begin
      if (bm_read | bm_write)
        state_next = STATE_START;
    end
    STATE_START: begin
      delay_next = 4'h2;
      if (bm_read | bm_write)
        state_next = STATE_PRE;
      else
        state_next = STATE_IDLE;
    end
    STATE_PRE: begin
      if (delay == 4'h0)
        state_next = STATE_POST;
      else begin
        if (~(bm_read | bm_write)) begin
          delay_next = 4'h0;
          state_next = STATE_IDLE;
        end else
          delay_next = delay - 1'b1;
      end
    end
    STATE_POST: begin
      if (~(bm_read | bm_write))
        state_next = STATE_IDLE;
    end
  endcase
end

endmodule
