module vga_framebuffer(vs, hs, clock, reset_n, r, g, b, data, bus_read, bus_wait, 
  blank_n, sync_n, vga_clock, address);

output vs, hs;
input clock;
input reset_n;
output bus_read;
input bus_wait;
output [7:0] r,g,b;
input [31:0] data;
output [31:0] address;
output blank_n;
output sync_n;
output vga_clock;

parameter VIDMEM = 32'h00c00000;

wire active;
wire [9:0] x, y, xlookahead;
wire [24:0] scandata_out;
wire [7:0] scanpos;

reg [9:0] x_last, y_last;
reg state, state_next;
reg [17:0] pixel, pixel_next;
reg [7:0] idx, idx_next;
reg [31:0] scandata_in, scandata_in_next;
reg [31:0] address, address_next;
reg scandata_we, scandata_we_next;

localparam STATE_IDLE = 1'b0, STATE_GRAPHICS = 1'b1;

assign r = scandata_out[23:16];
assign g = scandata_out[15:8];
assign b = scandata_out[7:0];

assign bus_read = (state != STATE_IDLE);
assign xlookahead = x + 2'h2;

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    x_last <= 9'h0;
    y_last <= 9'h0;
    state <= STATE_IDLE;
    pixel <= 18'h0;
    idx <= 1'h0;
    scandata_in <= 16'h0;
    scandata_we <= 1'b0;
    address <= 32'h00000000;
  end else begin
    idx <= idx_next;
    x_last <= x;
    y_last <= y;
    state <= state_next;
    pixel <= pixel_next;
    scandata_in <= scandata_in_next;
    scandata_we <= scandata_we_next;
    address <= address_next;
  end
end

always @(*)
begin
  state_next = state;
  pixel_next = pixel;
  scandata_in_next = scandata_in;
  idx_next = idx;
  address_next = address;
  scandata_we_next = scandata_we;
  // x and y take care of themselves
  case (state)
    STATE_IDLE: begin
      if (y == 10'h0 && y_last != 10'h0 && x == 10'h0)
        pixel_next = 18'h0;
      if (y != y_last && x == 10'h0) begin
        state_next = STATE_GRAPHICS;
        address_next = VIDMEM + pixel + idx;
        idx_next = 1'b0;
      end
    end
    STATE_GRAPHICS:
      if (!bus_wait) begin
        scandata_in_next = data;
        scandata_we_next = 1'b0;
        if (idx < 10'd160) begin
          idx_next = idx + 1'b1;
          state_next = STATE_IDLE;
        end else begin
          pixel_next = pixel + idx;
          state_next = STATE_IDLE;
        end
      end
  endcase
end

vga_controller vga0(.x(x), .y(y), .active(active), .vs(vs), .hs(hs), .clock(clock), .reset_n(reset_n));
vga_linebuf scanline0(.clock(clock), .rdaddress(xlookahead[9:2]), .wraddress(idx), .wren(scandata_we),
  .q(scandata_out), .data(scandata_in));
endmodule
