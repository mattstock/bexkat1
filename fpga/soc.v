module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG, raw_clock_50,
  quad, rgb, pb,
  fs_addrbus, fs_databus, ssram_be, ssram0_ce_n, ssram1_ce_n, ssram_oe_n, ssram_we_n,
  ssram_adv_n, ssram_adsp_n, ssram_gw_n, ssram_adsc_n, ssram_clk,
  lcd_e, lcd_rw, lcd_on, lcd_rs, lcd_data,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n,
  fl_oe_n, fl_ce_n, fl_we_n, fl_rst_n, fl_ry, fl_wp_n,
  sdram_addrbus, sdram_databus, sdram_ba, sdram_dqm, sdram_ras_n, sdram_cas_n, sdram_cke, sdram_clk,
  sdram_we_n, sdram_cs_n,
  vga_vs, vga_hs, vga_r, vga_g, vga_b, vga_clock, vga_sync_n, vga_blank_n,
  serial0_tx, serial0_rx, serial0_cts, serial0_rts, serial1_tx);

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
input raw_clock_50;
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

// VGA
output vga_vs;
output vga_hs;
output [7:0] vga_r, vga_g, vga_b;
output vga_clock;
output vga_sync_n;
output vga_blank_n;

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
input serial0_rx, serial0_cts;
output serial0_tx, serial1_tx, serial0_rts;

// LCD display
output lcd_e;
output lcd_rs;
output lcd_on;
output lcd_rw;
output [7:0] lcd_data;

wire rst_n, clock_100, clock_200, clock_50, clock_25, locked;

assign rgb = 3'b000;
assign lcd_data = 8'hzz;
assign lcd_e = 1'b0;
assign lcd_rw = 1'b1;
assign lcd_rs = 1'b0;
assign lcd_on = SW[17];
assign serial0_rts = serial0_cts;
assign vga_sync_n = 1'b0;
assign vga_clock = clock_25;
assign rst_n = locked;

// Wiring for external SDRAM, SSRAM & flash
assign sdram_clk = 1'b0;
assign sdram_databus = 32'hzzzzzzzz;
assign sdram_cke = 1'b1;
assign sdram_we_n = 1'b1;
assign sdram_cs_n = 1'b1;
assign sdram_cas_n = 1'b1;
assign sdram_ras_n = 1'b1;
assign sdram_dqm = 4'b0000;
assign sdram_ba = 2'b00;
assign sdram_addrbus = 13'h0000;
assign fl_oe_n = ~fl_we_n;
assign fl_we_n = 1'b1;
assign fl_ce_n = 1'b1;
assign fl_rst_n = rst_n;
assign fl_wp_n = 1'b1;

assign ssram_gw_n = 1'b1;
assign ssram_adv_n = ~(chipselect[0] && bm_burst_adv);
assign ssram_clk = clock_100;
assign ssram_adsc_n = ~(chipselect[0] && bm_burst);
assign ssram_adsp_n = ~(chipselect[0] && bm_start);
assign ssram_we_n = ~ssram_write;
assign ssram_be = (ssram_write ? ~bm_be : 4'b1111);
assign ssram_oe_n = ~ssram_read;
assign ssram0_ce_n = ~(chipselect[0] && ~bm_address[22]);
assign ssram1_ce_n = ~(chipselect[0] && bm_address[22]);
assign fs_addrbus = bm_address[26:0];
assign fs_databus = (ssram_oe_n ? bm_writedata : 32'hzzzzzzzz);

// visualization stuff
hexdisp d7(.out(HEX7), .in(bm_address[31:28]));
hexdisp d6(.out(HEX6), .in(bm_address[27:24]));
hexdisp d5(.out(HEX5), .in(bm_address[23:20]));
hexdisp d4(.out(HEX4), .in(bm_address[19:16]));
hexdisp d3(.out(HEX3), .in(bm_address[15:12]));
hexdisp d2(.out(HEX2), .in(bm_address[11:8]));
hexdisp d1(.out(HEX1), .in(bm_address[7:4]));
hexdisp d0(.out(HEX0), .in(bm_address[3:0]));
// Blinknlights
assign LEDR = { 8'h0, chipselect };
assign LEDG = { locked, 8'b00000000 };

wire [9:0] chipselect;
wire [31:0] cpu_address, bm_address, vga_address;
wire [31:0] cpu_readdata, bm_writedata, bm_readdata, cpu_writedata, mon_readdata, ram_readdata, matrix_readdata, rom_readdata;
wire [31:0] uart0_readdata, uart0_writedata, uart1_readdata, uart1_writedata;
wire [23:0] vga_readdata;
wire [3:0] cpu_be, bm_be;
wire cpu_write, cpu_read, cpu_wait, bm_read, bm_write, bm_wait, ram_write, ram_read, rom_read;
wire uart0_write, uart0_read, uart1_write, uart1_read, vga_wait, vga_read;
wire matrix_read, matrix_write, ssram_read, ssram_write, bm_start, bm_burst, bm_burst_adv;
wire [1:0] bus_grant;

// quadrature encoder outputs 0-23
//rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
//  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

assign cpu_readdata = bm_readdata;
assign vga_readdata = bm_readdata[23:0];

assign bm_readdata = (chipselect[7] ? rom_readdata : 32'h0) |
                     (chipselect[6] ? ram_readdata : 32'h0) |
                     (chipselect[5] ? matrix_readdata : 32'h0) |
                     (chipselect[4] ? uart0_readdata : 32'h0) |
                     (chipselect[3] ? uart1_readdata : 32'h0) |
                     (chipselect[0] ? fs_databus : 32'h0);

assign rom_read = (chipselect[7] ? bm_read : 1'b0);
assign ram_read = (chipselect[6] ? bm_read : 1'b0);
assign ram_write = (chipselect[6] ? bm_write : 1'b0);
assign matrix_read = (chipselect[5] ? bm_read : 1'b0);
assign matrix_write = (chipselect[5] ? bm_write : 1'b0);
assign uart0_read = (chipselect[4] ? bm_read : 1'b0);
assign uart0_write = (chipselect[4] ? bm_write : 1'b0);
assign uart1_read = (chipselect[3] ? bm_read : 1'b0);
assign uart1_write = (chipselect[3] ? bm_write : 1'b0);
assign ssram_read = (chipselect[0] ? bm_read : 1'b0);
assign ssram_write = (chipselect[0] ? bm_write : 1'b0);

//bexkat1 bexkat0(.csi_clk(clock_50), .rsi_reset_n(rst_n), .avm_m0_address(cpu_address), .avm_m0_read(cpu_read), .avm_m0_readdata(cpu_readdata),
//  .avm_m0_write(cpu_write), .avm_m0_writedata(cpu_writedata), .avm_m0_byteenable(cpu_be), .avm_m0_waitrequest(cpu_wait));
bexkat2 bexkat0(.clk(clock_50), .reset_n(rst_n), .address(cpu_address), .read(cpu_read), .readdata(cpu_readdata),
  .write(cpu_write), .writedata(cpu_writedata), .byteenable(cpu_be), .waitrequest(cpu_wait));
monitor rom0(.clock(clock_50), .q(rom_readdata), .rden(rom_read), .address(bm_address[13:2]));
scratch ram0(.clock(clock_50), .data(bm_writedata), .q(ram_readdata), .wren(ram_write), .rden(ram_read), .address(bm_address[13:2]),
  .byteena(bm_be));
led_matrix matrix0(.csi_clk(clock_50), .rsi_reset_n(rst_n), .avs_s0_writedata(bm_writedata), .avs_s0_readdata(matrix_readdata),
  .avs_s0_address(bm_address[11:2]), .avs_s0_byteenable(bm_be), .avs_s0_write(matrix_write), .avs_s0_read(matrix_read),
  .rgb_a(rgb_a), .rgb_b(rgb_b), .rgb_c(rgb_c), .rgb0(rgb0), .rgb1(rgb1), .rgb_stb(rgb_stb), .rgb_clk(rgb_clk), .oe_n(rgb_oe_n));
uart #(.baud(115200)) uart0(.clk(clock_50), .rst_n(rst_n), .rx(serial0_rx), .tx(serial0_tx), .data_in(bm_writedata), .be(bm_be),
  .data_out(uart0_readdata), .select(uart0_read|uart0_write), .write(uart0_write), .address(bm_address[2]));
uart uart1(.clk(clock_50), .rst_n(rst_n), .rx(1'b0), .tx(serial1_tx), .data_in(bm_writedata), .be(bm_be),
  .data_out(uart1_readdata), .select(uart1_read|uart1_write), .write(uart1_write), .address(bm_address[2]));
buscontroller bc0(.clock(clock_50), .reset_n(rst_n),
  .address(bm_address), .cpu_address(cpu_address), .vga_address(vga_address),
  .read(bm_read), .cpu_read((SW[17] ? cpu_read : 1'b0)), .vga_read((SW[16] ? vga_read : 1'b0)), 
  .start(bm_start), .chipselect(chipselect),
  .write(bm_write), .cpu_write((SW[17] ? cpu_write : 1'b0)),
  .cpu_writedata(cpu_writedata), .writedata(bm_writedata), .be(bm_be), .cpu_be(cpu_be),
  .burst(bm_burst), .burst_adv(bm_burst_adv),
  .cpu_wait(cpu_wait), .vga_wait(vga_wait));
vga_framebuffer vga0(.vs(vga_vs), .hs(vga_hs), .sys_clock(clock_50), .vga_clock(clock_25), .reset_n(rst_n),
  .r(vga_r), .g(vga_g), .b(vga_b), .data(vga_readdata), .bus_read(vga_read), 
  .bus_wait(vga_wait), .address(vga_address), .blank_n(vga_blank_n));
sysclock pll0(.inclk0(raw_clock_50), .c0(clock_100), .c1(clock_25), .c2(clock_50), .c3(clock_200), .areset(~KEY[0]), .locked(locked));

endmodule
