module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG, clock_50,
  quad, rgb, pb,
  fs_addrbus, fs_databus, ssram_be, ssram0_ce_n, ssram1_ce_n, ssram_oe_n, ssram_we_n,
  ssram_adv_n, ssram_adsp_n, ssram_gw_n, ssram_adsc_n, ssram_clk,
  lcd_e, lcd_rw, lcd_on, lcd_rs, lcd_data,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n,
  fl_oe_n, fl_ce_n, fl_we_n, fl_rst_n, fl_ry, fl_wp_n,
  serial0_tx, serial0_rx, serial1_tx, serial2_tx, serial2_rx);

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
input serial0_rx, serial2_rx;
output serial0_tx, serial1_tx, serial2_tx;

// LCD display
output lcd_e;
output lcd_rs;
output lcd_on;
output lcd_rw;
output [7:0] lcd_data;

wire rst_n, cpu_fault;
wire mem_flash, mem_monitor, mem_dram, mem_ssram0, mem_ssram1, mem_led_matrix;
wire mem_switch, mem_encoder, mem_serial0, mem_serial1, mem_serial2;
wire [15:0] mem_monitor_data, led_matrix_data_out, encoder_data, serial0_data, serial1_data, serial2_data, spi_data;
wire [31:0] cpu_addrbus;
wire [15:0] cpu_data_out;
wire cpu_write, cpu_bytectl;
wire [3:0] ccr;

wire [15:0] cpu_data_in0 = (mem_monitor ? mem_monitor_data : 16'h0000);
wire [15:0] cpu_data_in1 = (mem_flash | mem_ssram0 | mem_ssram1 ? fs_databus[15:0] : 16'h0000);
wire [15:0] cpu_data_in4 = (mem_led_matrix ? led_matrix_data_out : 16'h0000);
wire [15:0] cpu_data_in6 = (mem_encoder ? encoder_data : 16'h0000);
wire [15:0] cpu_data_in7 = (mem_serial0 ? serial0_data : 16'h0000);
wire [15:0] cpu_data_in8 = (mem_serial1 ? serial1_data : 16'h0000);
wire [15:0] cpu_data_in9 = (mem_serial2 ? serial2_data : 16'h0000);
wire [15:0] cpu_data_in10 = (mem_switch ? { 8'h00, SW[7:0] } : 16'h0000);
wire [15:0] cpu_data_in = cpu_data_in0 | cpu_data_in1 | cpu_data_in4 |
  cpu_data_in6 | cpu_data_in7 | cpu_data_in8 | cpu_data_in9 | cpu_data_in10;

// Reset button
reg [2:0] rst_sync;
assign rst_n = rst_sync[2];
always @(posedge clock_50) rst_sync <= { rst_sync[1:0], KEY[0] };

// Wiring for external SSRAM & flash
assign ssram_be = 4'b1111; // for now, disable byte writes
assign ssram_we_n = 1'b1;
assign ssram0_ce_n = ~mem_ssram0;
assign ssram1_ce_n = ~mem_ssram1;
assign ssram_oe_n = cpu_write | ~(mem_ssram0 | mem_ssram1);
assign ssram_adv_n = 1'b1;
assign ssram_adsp_n = ~(mem_ssram0 | mem_ssram1);
assign ssram_gw_n = ~cpu_write;
assign ssram_clk = clock_50;
assign ssram_adsc_n = 1'b1;
assign fl_oe_n = ~fl_we_n;
assign fl_we_n = ~cpu_write;
assign fl_ce_n = 1'b1;
assign fl_rst_n = rst_n;
assign fl_wp_n = 1'b1;
assign fs_databus = (cpu_write ? { 16'h0000, cpu_data_out} : 32'hzzzz);
assign fs_addrbus = cpu_addrbus[26:1]; 

// LED display driver
led_matrix led0(.clk(clock_50), .rst_n(rst_n), .rgb_a(rgb_a), .rgb_b(rgb_b), .rgb_c(rgb_c), .rgb0(rgb0), .rgb1(rgb1), .rgb_clk(rgb_clk), .rgb_stb(rgb_stb), .oe_n(rgb_oe_n),
  .data_in(cpu_data_out), .data_out(led_matrix_data_out), .write(cpu_write & mem_led_matrix), .address(cpu_addrbus[10:1]));

// visualization stuff
hexdisp d7(.out(HEX7), .in(cpu_addrbus[31:28]));
hexdisp d6(.out(HEX6), .in(cpu_addrbus[27:24]));
hexdisp d5(.out(HEX5), .in(cpu_addrbus[23:20]));
hexdisp d4(.out(HEX4), .in(cpu_addrbus[19:16]));
hexdisp d3(.out(HEX3), .in(cpu_addrbus[15:12]));
hexdisp d2(.out(HEX2), .in(cpu_addrbus[11:8]));
hexdisp d1(.out(HEX1), .in(cpu_addrbus[7:4]));
hexdisp d0(.out(HEX0), .in(cpu_addrbus[3:0]));
// Blinknlights
assign LEDG = { cpu_fault, 4'h0, mem_monitor, mem_ssram0, mem_ssram1, mem_led_matrix};
assign LEDR = { cpu_bytectl, cpu_write, cpu_data_out };

// quadrature encoder outputs 0-23
rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

// LCD module
assign lcd_on = SW[17];
assign lcd_rw = 1'b0;
lcd_module lcd0(.clk(clock_50), .rst_n(rst_n), .e(lcd_e), .data_out(lcd_data), .rs(lcd_rs));

// UART for RS232
uart #(.baud(115200)) uart0(.clk(clock_50), .rst_n(rst_n), .rx(serial0_rx), .tx(serial0_tx), .data_in(cpu_data_out), .data_out(serial0_data),
  .write(cpu_write), .select(mem_serial0), .address(cpu_addrbus[3:0]));
// UART for speach generator
uart #(.baud(9600)) uart1(.clk(clock_50), .rst_n(rst_n), .tx(serial1_tx), .data_in(cpu_data_out), .data_out(serial1_data),
  .write(cpu_write), .select(mem_serial1), .address(cpu_addrbus[3:0]));
// UART for logic level testing
uart #(.baud(115200)) uart2(.clk(clock_50), .rst_n(rst_n), .rx(serial2_rx), .tx(serial2_tx), .data_in(cpu_data_out), .data_out(serial2_data),
  .write(cpu_write), .select(mem_serial2), .address(cpu_addrbus[3:0]));
 
mycpu cpu0(.clk(clock_50), .rst_n(rst_n), .addrbus(cpu_addrbus), .data_in(cpu_data_in), .data_out(cpu_data_out), .write_out(cpu_write), 
  .bytectl(cpu_bytectl), .ccr(ccr), .fault(cpu_fault));

// Chip select logic
mem_select memmap0(.address(cpu_addrbus), .flash(mem_flash), .sram0(mem_ssram0), .sram1(mem_ssram1), .monitor(mem_monitor), .led_matrix(mem_led_matrix),
  .encoder(mem_encoder), .serial0(mem_serial0), .serial1(mem_serial1), .serial2(mem_serial2), .switch(mem_switch));

// ROM monitor code
monitor rom0(.clock(clock_50), .address(cpu_addrbus[12:1]), .q(mem_monitor_data));

endmodule
