module vga_framebuffer(vs, hs, sys_clock, vga_clock, reset_n, r, g, b, data, bus_read, bus_wait, 
  blank_n, address);

output vs, hs;
input vga_clock;
input sys_clock;
input reset_n;
output bus_read;
input bus_wait;
output [7:0] r,g,b;
input [23:0] data;
output [31:0] address;
output blank_n;

parameter VIDMEM = 32'h00c00000;

reg [15:0] x_sync[2:0], y_sync[2:0];

wire [15:0] x, y, x_raw, y_raw, xlookahead;
wire [24:0] scandata_out;
wire [7:0] scanpos;

assign x = x_sync[2];
assign y = y_sync[2];

reg [15:0] y_last;
reg [1:0] state, state_next;
reg [17:0] pixel, pixel_next;
reg [17:0] idx, idx_next;
reg [31:0] address, address_next;
reg scandata_we, scandata_we_next;

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUS = 2'h1, STATE_GRAPHICS = 2'h2, STATE_RELEASE = 2'h3;

assign r = scandata_out[23:16];
assign g = scandata_out[15:8];
assign b = scandata_out[7:0];

assign bus_read = (state == STATE_BUS || state == STATE_GRAPHICS);

always @(posedge sys_clock) begin
  x_sync[2] <= x_sync[1];
  x_sync[1] <= x_sync[0];
  x_sync[0] <= x_raw;
  y_sync[2] <= y_sync[1];
  y_sync[1] <= y_sync[0];
  y_sync[0] <= y_raw;
end

always @(posedge sys_clock or negedge reset_n)
begin
  if (!reset_n) begin
    y_last <= 9'h0;
    state <= STATE_IDLE;
    pixel <= 18'h0;
    idx <= 1'h0;
    scandata_we <= 1'b0;
    address <= 32'h00000000;
  end else begin
    idx <= idx_next;
    y_last <= y;
    state <= state_next;
    pixel <= pixel_next;
    scandata_we <= scandata_we_next;
    address <= address_next;
  end
end

always @(*)
begin
  state_next = state;
  pixel_next = pixel;
  idx_next = idx;
  address_next = address;
  scandata_we_next = scandata_we;
  // x and y take care of themselves
  case (state)
    STATE_IDLE: begin
      if (y == 12'h0 && y_last != 12'h0 && x == 12'h0) begin
        pixel_next = 18'h0;
        address_next = VIDMEM;
      end
      if (y != y_last && x == 12'h0) begin
        state_next = STATE_BUS;
        address_next = VIDMEM + pixel + idx;
        idx_next = 1'b0;
      end
    end
    STATE_BUS: begin
      if (!bus_wait) begin
        scandata_we_next = 1'b1;
        state_next = STATE_GRAPHICS;
      end
    end
    STATE_GRAPHICS: begin
      scandata_we_next = 1'b0;
      if (idx < 17'ha00) begin
        idx_next = idx + 3'h4;
        state_next = STATE_RELEASE;
      end else begin
        pixel_next = pixel + idx;
        state_next = STATE_IDLE;
      end
    end
    STATE_RELEASE: begin
      address_next = VIDMEM + pixel + idx;
      state_next = STATE_BUS;
    end
  endcase
end

vga_controller vga0(.x(x_raw), .y(y_raw), .active(blank_n), .vs(vs), .hs(hs), .clock(vga_clock), .reset_n(reset_n));
vgalinebuf scanline0(.wrclock(sys_clock), .rdclock(vga_clock), .rdaddress(x), .wraddress(idx[11:2]), .wren(scandata_we),
  .q(scandata_out), .data(data));
endmodule
