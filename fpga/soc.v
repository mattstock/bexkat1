module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG, clock_50,
  quad, rgb, pb,
  fs_addrbus, fs_databus, ssram_be, ssram0_ce_n, ssram1_ce_n, ssram_oe_n, ssram_we_n,
  ssram_adv_n, ssram_adsp_n, ssram_gw_n, ssram_adsc_n, ssram_clk,
  lcd_e, lcd_rw, lcd_on, lcd_rs, lcd_data,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n,
  fl_oe_n, fl_ce_n, fl_we_n, fl_rst_n, fl_ry, fl_wp_n,
  sdram_addrbus, sdram_databus, sdram_ba, sdram_dqm, sdram_ras_n, sdram_cas_n, sdram_cke, sdram_clk,
  sdram_we_n, sdram_cs_n,
  serial0_tx, serial0_rx, serial1_tx);

// SSRAM & flash
output [26:0] fs_addrbus;
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

// SDRAM
output [12:0] sdram_addrbus;
inout [31:0] sdram_databus;
output [1:0] sdram_ba;
output [3:0] sdram_dqm;
output sdram_ras_n;
output sdram_cas_n;
output sdram_cke;
output sdram_clk;
output sdram_we_n;
output sdram_cs_n;

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

// Reset button
reg [2:0] rst_sync;
assign rst_n = rst_sync[2];
always @(posedge clock_50) rst_sync <= { rst_sync[1:0], KEY[0] };

assign lcd_on = SW[17];

// Wiring for external SDRAM, SSRAM & flash
assign sdram_clk = clock_50;
assign ssram_gw_n = 1'b1;
assign ssram_adv_n = 1'b1;
assign ssram_clk = clock_50;
assign ssram_adsc_n = 1'b1;
assign fl_oe_n = ~fl_we_n;
assign fl_we_n = 1'b1;
assign fl_ce_n = 1'b1;
assign fl_rst_n = rst_n;
assign fl_wp_n = 1'b1;

// visualization stuff
hexdisp d7(.out(HEX7), .in(4'h0));
hexdisp d6(.out(HEX6), .in({ 1'b0, fs_addrbus[26:24] }));
hexdisp d5(.out(HEX5), .in(fs_addrbus[23:20]));
hexdisp d4(.out(HEX4), .in(fs_addrbus[19:16]));
hexdisp d3(.out(HEX3), .in(fs_addrbus[15:12]));
hexdisp d2(.out(HEX2), .in(fs_addrbus[11:8]));
hexdisp d1(.out(HEX1), .in(fs_addrbus[7:4]));
hexdisp d0(.out(HEX0), .in(fs_addrbus[3:0]));
// Blinknlights
assign LEDR = 18'h0000;
assign LEDG[8] = 1'b1;

// quadrature encoder outputs 0-23
//rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
//  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

fabirc fabric0(.clk_clk(clock_50), .reset_reset_n(rst_n), .fsbus_ssram1_ce_n(ssram1_ce_n),
  .fsbus_ssram0_ce_n(ssram0_ce_n), .fsbus_data(fs_databus), .fsbus_address(fs_addrbus), .fsbus_ssram_we_n(ssram_we_n),
  .fsbus_ssram_be_n(ssram_be), .fsbus_ssram_adsp_n(ssram_adsp_n), .fsbus_ssram_oe_n(ssram_oe_n),
  .sdram0_wire_addr(sdram_addrbus), .sdram0_wire_ba(sdram_ba), .sdram0_wire_cas_n(sdram_cas_n), .sdram0_wire_cke(sdram_cke),
  .sdram0_wire_cs_n(sdram_cs_n), .sdram0_wire_dq(sdram_databus), .sdram0_wire_dqm(sdram_dqm), .sdram0_wire_ras_n(sdram_ras_n),
  .sdram0_wire_we_n(sdram_we_n), .uart0_rxd(serial0_rx), .uart0_txd(serial0_tx), .uart1_txd(serial1_tx), .uart1_rxd(1'b0),
  .led_matrix_a(rgb_a), .led_matrix_b(rgb_b), .led_matrix_c(rgb_c), .led_matrix_rgb0(rgb0), .led_matrix_rgb1(rgb1),
  .led_matrix_rgb_oe_n(rgb_oe_n), .led_matrix_stb(rgb_stb), .led_matrix_rgb_clk(rgb_clk),
  .lcd_RS(lcd_rs), .lcd_RW(lcd_rw), .lcd_data(lcd_data), .lcd_E(lcd_e),
  .sw_export(SW[7:0]), .ledg_export(LEDG[7:0]));

endmodule
