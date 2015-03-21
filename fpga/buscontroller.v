module buscontroller(
  input clock,
  input reset_n,
  input [31:0] bm_address,
  input bm_read,
  input bm_write,
  output bm_wait,
  output start,
  output [9:0] chipselect);
  
reg [3:0] delay, delay_next;
reg [9:0] cs;
reg [1:0] state, state_next;

localparam [1:0] STATE_IDLE = 2'b00, STATE_START = 2'b01, STATE_PRE = 2'b10, STATE_POST = 2'b11;

assign bm_wait = (state == STATE_START || state_next == STATE_START || state == STATE_PRE);
assign chipselect = (state != STATE_IDLE ? cs : 10'h00);
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
    cs = 10'b0001000000; // RAM
  else if (bm_address >= 32'h00800000 && bm_address <= 32'h008007ff)
    cs = 10'b0000100000; // LED matrix
  else if (bm_address >= 32'hffffc000 && bm_address <= 32'hffffffff)
    cs = 10'b0010000000; // ROM
  else if (bm_address >= 32'h00800800 && bm_address <= 32'h00800807)
    cs = 10'b0000010000; // UART 0
  else if (bm_address >= 32'h00800808 && bm_address <= 32'h0080080f)
    cs = 10'b0000001000; // UART 1
  else if (bm_address >= 32'h00800810 && bm_address <= 32'h00800813)
    cs = 10'b0000000100; // SW
  else if (bm_address >= 32'h00800814 && bm_address <= 32'h0080081f)
    cs = 10'b0000000010; // Encoder
  else if (bm_address >= 32'h00c00000 && bm_address <= 32'h00cfffff)
    cs = 10'b0000000001; // SDRAM
  else if (bm_address >= 32'h00800c00 && bm_address <= 32'h00800cff)
    cs = 10'b0100000000; // LCD
  else
    cs = 10'b0000000000;
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
