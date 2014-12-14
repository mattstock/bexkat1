module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, LEDR, LEDG, clock_50, clock_27,
  aud_adclrck, aud_adcdat, aud_daclrck, aud_dacdat, aud_xck, aud_bclk, i2c_sclk, i2c_sdat,
  quad, rgb, pb,
  sram_addrbus, sram_databus, sram_we_n, sram_oe_n, sram_ub_n, sram_lb_n, sram_ce_n,
  ps2_dat, ps2_clk, lcd_e, lcd_rs, lcd_data,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n,
  fl_addrbus, fl_databus, fl_oe_n, fl_ce_n, fl_we_n, fl_rst_n,
  serial0_tx, serial0_rx, serial1_tx, serial1_rx,
  dram_dq, dram_addr, dram_ba, dram_ldqm, dram_udqm, dram_ras_n, dram_cas_n, dram_cke, dram_clk, dram_we_n, dram_ce_n);

// SRAM
output [17:0] sram_addrbus;
inout [15:0] sram_databus;
output sram_we_n;
output sram_oe_n;
output sram_ub_n;
output sram_lb_n;
output sram_ce_n;

// Flash
inout [7:0] fl_databus;
output [21:0] fl_addrbus;
output fl_oe_n;
output fl_ce_n;
output fl_we_n;
output fl_rst_n;

// SDRAM
inout [15:0] dram_dq;
output [11:0] dram_addr;
output [1:0] dram_ba;
output dram_ldqm;
output dram_udqm;
output dram_ras_n;
output dram_cas_n;
output dram_cke;
output dram_clk;
output dram_we_n;
output dram_ce_n;

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

// serial
input serial0_rx, serial1_rx;
output serial0_tx, serial1_tx;

// ps2
input ps2_dat;
input ps2_clk;

// LCD display
output lcd_e;
output lcd_rs;
output [7:0] lcd_data;

wire rst_n;
wire [5:0] encoder_val;
wire kbd_event;
wire [7:0] kbd_data;

wire mem_flash, mem_monitor, mem_dram, mem_sram, mem_led_matrix, mem_kbd, mem_encoder, mem_serial0, mem_serial1;
wire [15:0] mem_monitor_data, led_matrix_data_out, encoder_data, serial0_data, serial1_data;
wire [31:0] cpu_addrbus;
wire [15:0] cpu_data_out;
wire cpu_write, ccr;

wire [15:0] cpu_data_in0 = (mem_monitor ? mem_monitor_data : 16'h0000);
wire [15:0] cpu_data_in1 = (mem_flash ? { 8'h00, fl_databus } : 16'h0000);
wire [15:0] cpu_data_in2 = (mem_dram ? dram_dq : 16'h0000);
wire [15:0] cpu_data_in3 = (mem_sram ? sram_databus : 16'h0000);
wire [15:0] cpu_data_in4 = (mem_led_matrix ? led_matrix_data_out : 16'h0000);
wire [15:0] cpu_data_in5 = (mem_kbd ? { 8'h00, kbd_data}  : 16'h0000);
wire [15:0] cpu_data_in6 = (mem_encoder ? encoder_data : 16'h0000);
wire [15:0] cpu_data_in7 = (mem_serial0 ? serial0_data : 16'h0000);
wire [15:0] cpu_data_in8 = (mem_serial1 ? serial1_data : 16'h0000);
wire [15:0] cpu_data_in = cpu_data_in0 |
  cpu_data_in1 | cpu_data_in2 | cpu_data_in3 | cpu_data_in4 |
  cpu_data_in5 | cpu_data_in6 | cpu_data_in7 | cpu_data_in8;

assign rst_n = KEY[0];

// No audio for now
assign aud_adclrck = aud_daclrck;
assign aud_daclrck = 1'b0;
assign aud_dacdat = 1'bz;
assign aud_xck = 1'bz;
assign aud_bclk = 1'bz;
assign i2c_sclk = 1'bz;

// No SDRAM for now, need a refresh module
assign dram_addr = 12'h00000;
assign dram_ba = 2'h0;
assign dram_ldqm = 1'b0; // use these for byte writes?
assign dram_udqm = 1'b0; // use there for byte writes?
assign dram_ras_n = 1'b1;
assign dram_cas_n = 1'b1;
assign dram_cke = 1'b0;
assign dram_clk = clock_50;
assign dram_we_n = ~cpu_write;
assign dram_ce_n = ~mem_dram;
assign dram_dq = (cpu_write ? cpu_data_out : 16'hzzzz);

// Wiring for external SRAM
assign sram_lb_n = 1'b0;  // use these for byte writes?
assign sram_ub_n = 1'b0;  // use these for byte writes?
assign sram_we_n = ~cpu_write;
assign sram_ce_n = ~mem_sram;
assign sram_oe_n = ~sram_we_n;
assign sram_databus = (cpu_write ? cpu_data_out : 16'hzzzz);
assign sram_addrbus = cpu_addrbus[18:1]; // Byte addressable, but word memory

// Flash wiring
assign fl_addrbus = cpu_addrbus[21:0];
assign fl_oe_n = ~fl_we_n;
assign fl_we_n = ~cpu_write;
assign fl_ce_n = ~mem_flash;
assign fl_rst_n = rst_n;
assign fl_databus = (cpu_write ? cpu_data_out[7:0] : 8'hzz);

// Generate demo screenbuffer data
//screendemo demo0(.clk(clock_50), .rst_n(rst_n), .write(rgb_write), .pixel(rgb_matrix), .row(rgb_row), .col(rgb_col));

// LED display driver
led_matrix led0(.clk(clock_50), .rst_n(rst_n), .rgb_a(rgb_a), .rgb_b(rgb_b), .rgb_c(rgb_c), .rgb0(rgb0), .rgb1(rgb1), .rgb_clk(rgb_clk), .rgb_stb(rgb_stb), .oe_n(rgb_oe_n),
  .data_in(cpu_data_out), .data_out(led_matrix_data_out), .write(cpu_write & mem_led_matrix), .address(cpu_addrbus[9:0]));

// visualization stuff
hexdisp d0(.out(HEX3), .in(cpu_data_out[15:12]));
hexdisp d1(.out(HEX2), .in(cpu_data_out[11:8]));
hexdisp d2(.out(HEX1), .in(cpu_data_out[7:4]));
hexdisp d3(.out(HEX0), .in(cpu_data_out[3:0]));
// Blinknlights
assign LEDG = { cpu_write, mem_sram, mem_led_matrix, mem_flash, mem_dram, mem_monitor, kbd_event, pb};
assign LEDR = { 6'h00, ccr};

// quadrature encoder outputs 0-23
rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

// LCD module
lcd_module lcd0(.clk(clock_50), .rst_n(rst_n), .e(lcd_e), .data_out(lcd_data), .rs(lcd_rs));

// Keyboard
user_input kbd0(.clk(clock_50), .rst_n(rst_n), .ps2_clock(ps2_clk), .ps2_data(ps2_dat), .data_read(pb), .data_ready(kbd_event), .data_out(kbd_data));

// UART for RS232
uart uart0(.clk(clock_50), .rst_n(rst_n), .rx(serial0_rx), .tx(serial0_tx), .data_in(cpu_data_out), .data_out(serial0_data),
  .write(cpu_write & mem_serial0), .address(cpu_addrbus[3:0]));
// UART for speach generator
uart uart1(.clk(clock_50), .rst_n(rst_n), .rx(serial1_rx), .tx(serial1_tx), .data_in(cpu_data_out), .data_out(serial1_data),
  .write(cpu_write & mem_serial1), .address(cpu_addrbus[3:0]));

mycpu cpu0(.clk(clock_50), .rst_n(rst_n), .addrbus(cpu_addrbus), .data_in(cpu_data_in), .data_out(cpu_data_out), .write_out(cpu_write), .ccr(ccr));

// Chip select logic
mem_select memmap0(.address(cpu_addrbus), .flash(mem_flash), .dram(mem_dram), .sram(mem_sram), .monitor(mem_monitor), .led_matrix(mem_led_matrix),
  .kbd(mem_kbd), .encoder(mem_encoder), .serial0(mem_serial0), .serial1(mem_serial1));

// ROM monitor code
monitor rom0(.clock(clock_50), .address(cpu_addrbus[12:1]), .q(mem_monitor_data));
 
endmodule
