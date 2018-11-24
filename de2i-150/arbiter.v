module arbiter(
  input clk_i,
  input rst_i,
  input ack_i,
  input cpu_cyc_i,
  input vga_cyc_i,
  output cyc_o,
  output cpu_gnt,
  output vga_gnt);

assign cyc_o = (vga_gnt ? vga_cyc_i : 1'b0) | (cpu_gnt ? cpu_cyc_i : 1'b0);
assign cpu_gnt = (state == STATE_CPU_GRANT);
assign vga_gnt = (state == STATE_VGA_GRANT);

localparam [1:0] STATE_IDLE = 2'h0, STATE_VGA_GRANT = 2'h1, STATE_CPU_GRANT = 2'h3;

reg [1:0] state, state_next;


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
      if (vga_cyc_i)
        state_next = STATE_VGA_GRANT;
      else if (cpu_cyc_i)
        state_next = STATE_CPU_GRANT;
    STATE_VGA_GRANT: if (!vga_cyc_i) state_next = STATE_IDLE;
    STATE_CPU_GRANT: if (!cpu_cyc_i) state_next = STATE_IDLE;
    default: state_next = STATE_IDLE;
  endcase
end

endmodule
