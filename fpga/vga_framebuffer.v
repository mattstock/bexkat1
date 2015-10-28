module vga_framebuffer(
  input clock,
  input reset_n,
  input write,
  input [18:0] address,
  input [31:0] data,
  output vs,
  output hs,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b,
  output blank_n,
  output sync_n,
  output vga_clock,
  input sw);

wire [8:0] scandata_out;
wire [18:0] pixel;
wire [15:0] x, y;

assign sync_n = 1'b0;

assign r = (sw ? { scandata_out[8:6], 5'b0 } : (x == 0 || x == 16'd639 ? 8'hff : { scandata_out[8:6], 5'b0 }));
assign g = (sw ? { scandata_out[5:3], 5'b0 } : { scandata_out[5:3], 5'b0 });
assign b = (sw ? { scandata_out[2:0], 5'b0 } : (y == 0 || y == 16'd479 ? 8'hff : { scandata_out[2:0], 5'b0 }));

vga_controller vga0(.active(blank_n), .vs(vs), .hs(hs), .clock(vga_clock), .reset_n(reset_n), .pixel(pixel), .x(x), .y(y));
vgabuf vgamem0(.wrclock(clock), .data(data[8:0]), .wraddress(address), .wren(write), .rdclock(vga_clock), .rdaddress(pixel), .q(scandata_out));
vgapll vgapll0(.inclk0(clock), .c0(vga_clock));

endmodule
