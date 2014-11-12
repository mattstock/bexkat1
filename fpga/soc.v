module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, LEDR, LEDG, clock_50, clock_27,
  aud_adclrck, aud_adcdat, aud_daclrck, aud_dacdat, aud_xck, aud_bclk, i2c_sclk, i2c_sdat,
  quad, rgb, pb,
  sram_addrbus, sram_databus, sram_we_n, sram_oe_n, sram_ub_n, sram_lb_n, sram_ce_n,
  lcd_i2c_sclk, lcd_i2c_sdat,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n);

// SRAM
output [17:0] sram_addrbus;
inout [15:0] sram_databus;
output sram_we_n;
output sram_oe_n;
output sram_ub_n;
output sram_lb_n;
output sram_ce_n;

// FPGA board stuff
input clock_50;
input [1:0] clock_27;
input [9:0] SW;
input [3:0] KEY;
output [7:0] LEDG;
output [9:0] LEDR;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;

// LED panel
output [2:0] rgb0;
output [2:0] rgb1;
output rgb_clk;
output rgb_oe_n;
output rgb_a, rgb_b, rgb_c;
output rgb_stb;

// rgb encoder
output [2:0] rgb;
input [1:0] quad;
input pb;

// CODEC
inout i2c_sdat;
output i2c_sclk;
output aud_xck;
output aud_bclk;
output aud_dacdat;
output aud_daclrck;
output aud_adclrck;
input aud_adcdat;

// i2c pair for lcd
inout lcd_i2c_sdat;
output lcd_i2c_sclk;

wire rst_n;
wire [5:0] val;
wire [23:0] rgb_matrix;
wire [3:0] rgb_row;
wire [4:0] rgb_col;
wire rgb_write;

assign rst_n = KEY[0];
assign LEDG = { rgb_clk, rgb_stb, 5'b0, pb};
assign LEDR = { 3'b000, val };
assign aud_adclrck = aud_daclrck;
assign aud_daclrck = 1'b0;
assign aud_dacdat = 1'bz;
assign aud_xck = 1'bz;
assign aud_bclk = 1'bz;
assign i2c_sclk = 1'bz;
assign lcd_i2c_sclk = 1'bz;
assign sram_ce_n = 1'b0;
assign sram_lb_n = 1'b0;
assign sram_ub_n = 1'b0;
assign sram_we_n = 1'b1;
assign sram_oe_n = ~sram_we_n;
assign sram_databus = 16'hzzzz;
assign sram_addrbus = 18'h000000;
assign rgb_oe_n = SW[9];

// Generate demo screenbuffer data
screendemo demo0(.clk(clock_50), .rst_n(rst_n), .write(rgb_write), .pixel(rgb_matrix), .row(rgb_row), .col(rgb_col));

// LED display driver
led_matrix lcd0(.clk(clock_50), .rst_n(rst_n), .rgb_a(rgb_a), .rgb_b(rgb_b), .rgb_c(rgb_c), .rgb0(rgb0), .rgb1(rgb1), .rgb_clk(rgb_clk), .rgb_stb(rgb_stb), .pixel(rgb_matrix),
  .write(rgb_write), .row(rgb_row), .col(rgb_col));

// visualization stuff
hexdisp d0(.out(HEX3), .in(4'b0));
hexdisp d1(.out(HEX2), .in(4'h1));
hexdisp d2(.out(HEX1), .in(4'h2));
hexdisp d3(.out(HEX0), .in(4'h4));

// quadrature encoder outputs 0-23
quadenc q0(.clk(clock_50), .rst_n(rst_n), .quadA(quad[0]), .quadB(quad[1]), .count(val));

assign rgb = val[2:0];
 
endmodule
