module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG, clock_50,
  quad, rgb, pb,
  fs_addrbus, fs_databus, ssram_be, ssram0_ce_n, ssram1_ce_n, ssram_oe_n, ssram_we_n,
  ssram_adv_n, ssram_adsp_n, ssram_gw_n, ssram_adsc_n, ssram_clk,
  lcd_e, lcd_rw, lcd_on, lcd_rs, lcd_data,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n,
  fl_oe_n, fl_ce_n, fl_we_n, fl_rst_n, fl_ry, fl_wp_n,
  serial0_tx, serial0_rx, serial1_tx);

// SSRAM & flash
output [25:0] fs_addrbus;
inout [31:0] fs_databus;

// SSRAM
output [3:0] ssram_be;
output ssram_oe_n;
output ssram0_ce_n;
output ssram1_ce_n;
output ssram_we_n;
output ssram_adv_n;
output ssram_adsp_n;
output ssram_gw_n;
output ssram_adsc_n;
output ssram_clk;

// Flash
output fl_oe_n;
output fl_ce_n;
output fl_we_n;
input fl_ry;
output fl_rst_n;
output fl_wp_n;

// FPGA board stuff
input clock_50;
input [17:0] SW;
input [3:0] KEY;
output [8:0] LEDG;
output [17:0] LEDR;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;
output [6:0] HEX6;
output [6:0] HEX7;

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

// serial
input serial0_rx;
output serial0_tx, serial1_tx;

// LCD display
output lcd_e;
output lcd_rs;
output lcd_on;
output lcd_rw;
output [7:0] lcd_data;

wire rst_n;
wire [15:0] mem_monitor_data, led_matrix_data_out, encoder_data, serial0_data, serial1_data, serial2_data, spi_data;
wire [31:0] cpu_addrbus;
wire [15:0] cpu_data_out;
wire cpu_write, cpu_bytectl;

// Reset button
reg [2:0] rst_sync;
assign rst_n = rst_sync[2];
always @(posedge clock_50) rst_sync <= { rst_sync[1:0], KEY[0] };

assign lcd_on = SW[17];

// Wiring for external SSRAM & flash
assign ssram_gw_n = 1'b1;
assign ssram_adv_n = 1'b1;
assign ssram_clk = clock_50;
assign ssram_adsc_n = 1'b1;
assign fl_oe_n = ~fl_we_n;
assign fl_we_n = ~cpu_write;
assign fl_ce_n = 1'b1;
assign fl_rst_n = rst_n;
assign fl_wp_n = 1'b1;

// LED display driver
led_matrix led0(.clk(clock_50), .rst_n(rst_n), .rgb_a(rgb_a), .rgb_b(rgb_b), .rgb_c(rgb_c), .rgb0(rgb0), .rgb1(rgb1), .rgb_clk(rgb_clk), .rgb_stb(rgb_stb), .oe_n(rgb_oe_n),
  .data_in(cpu_data_out), .data_out(led_matrix_data_out), .write(cpu_write & mem_led_matrix), .address(cpu_addrbus[10:1]));

// visualization stuff
//hexdisp d7(.out(HEX7), .in(fs_addrbus[31:28]));
//hexdisp d6(.out(HEX6), .in(fs_addrbus[27:24]));
hexdisp d5(.out(HEX5), .in(fs_addrbus[23:20]));
hexdisp d4(.out(HEX4), .in(fs_addrbus[19:16]));
hexdisp d3(.out(HEX3), .in(fs_addrbus[15:12]));
hexdisp d2(.out(HEX2), .in(fs_addrbus[11:8]));
hexdisp d1(.out(HEX1), .in(fs_addrbus[7:4]));
hexdisp d0(.out(HEX0), .in(fs_addrbus[3:0]));
// Blinknlights
assign LEDR = { cpu_bytectl, cpu_write, cpu_data_out };

// quadrature encoder outputs 0-23
rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

fabirc fabric0(.clk_clk(clock_50), .reset_reset_n(~rst_n), .leds_export(LEDG), .fsbus_ssram1_ce_n(ssram1_ce_n),
  .fsbus_ssram0_ce_n(ssram0_ce_n), .fsbus_data(fs_databus), .fsbus_address(fs_addrbus), .fsbus_ssram_gw_n(ssram_we_n),
  .fsbus_ssram_bw_n(ssram_be), .fsbus_ssram_adsp_n(ssram_adsp_n), .fsbus_ssram_oe_n(ssram_oe_n), .uart_0_external_rxd(serial0_rx),
  .uart_0_external_txd(serial0_tx), .uart_0_external_cts_n(), .uart_0_external_rts(), .uart_1_external_txd(serial1_tx),
  .lcd_external_RS(lcd_rs), .lcd_external_E(lcd_e), .lcd_external_RW(lcd_rw), .lcd_external_data(lcd_data));

endmodule
