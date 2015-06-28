module soc(
  input raw_clock_50,
  input [17:0] SW,
  input [3:0] KEY,
  output [8:0] LEDG,
  output [17:0] LEDR,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5,
  output [6:0] HEX6,
  output [6:0] HEX7,
  output [26:0] fs_addrbus,
  inout [31:0] fs_databus,
  output [3:0] ssram_be,
  output ssram_oe_n,
  output ssram0_ce_n,
  output ssram1_ce_n,
  output ssram_we_n,
  output ssram_adv_n,
  output ssram_adsp_n,
  output ssram_gw_n,
  output ssram_adsc_n,
  output ssram_clk,
  output fl_oe_n,
  output fl_ce_n,
  output fl_we_n,
  input fl_ry,
  output fl_rst_n,
  output fl_wp_n,
  output [12:0] sdram_addrbus,
  inout [31:0] sdram_databus,
  output [1:0] sdram_ba,
  output [3:0] sdram_dqm,
  output sdram_ras_n,
  output sdram_cas_n,
  output sdram_cke,
  output sdram_clk,
  output sdram_we_n,
  output sdram_cs_n,
  output vga_vs,
  output vga_hs,
  output [7:0] vga_r,
  output [7:0] vga_g, 
  output [7:0] vga_b,
  output vga_clock,
  output vga_sync_n,
  output vga_blank_n,
  output lcd_e,
  output lcd_rs,
  output lcd_on,
  output lcd_rw,
  inout [7:0] lcd_data,
  output [3:0] enet_tx_data,
  input [3:0] enet_rx_data,
  output enet_gtx_clk,
  output enet_tx_en,
  output enet_tx_er,
  inout enet_mdio,
  output enet_mdc,
  output enet_rst_n,
  input enet_int_n,
  input enet_link100,
  input enet_rx_clk,
  input enet_rx_col,
  input enet_rx_crs,
  input enet_rx_dv,
  input enet_rx_er,
  input enet_tx_clk,
  input sd_miso,
  output sd_mosi,
  output sd_ss,
  output sd_sclk,
  input gen_miso,
  output gen_mosi,
  output gen_ss,
  output touch_ss,
  output extsd_ss,
  output gen_sclk,
  input touch_irq,
  output itd_backlight,
  output itd_dc,
  output rst_n,
  input sd_wp_n,
  output fan_ctrl, 
  output [2:0] rgb0,
  output [2:0] rgb1,
  output rgb_clk,
  output rgb_oe_n,
  output rgb_a, 
  output rgb_b,
  output rgb_c,
  output rgb_stb,
  output [2:0] rgb,
  input [1:0] quad,
  input pb,
  input serial0_rx,
  input serial0_cts,
  output serial0_tx,
  output serial1_tx,
  output serial0_rts);

wire clock_5, clock_50, clock_25, clock_50p, locked;
wire [7:0] spi_selects;
wire miso, mosi, sclk;
assign rgb = 3'b000;

// some SPI wiring
assign sd_ss = spi_selects[0];
assign gen_ss = spi_selects[1];
assign touch_ss = spi_selects[2];
assign extsd_ss = spi_selects[3];
assign gen_mosi = mosi;
assign sd_mosi = mosi;
assign miso = (~spi_selects[0] ? sd_miso : 1'b0) |
              (~spi_selects[1] ? gen_miso : 1'b0) |
              (~spi_selects[2] ? gen_miso : 1'b0) |
              (~spi_selects[3] ? gen_miso : 1'b0);
assign gen_sclk = sclk;
assign sd_sclk = sclk;

// ethernet stubs
assign enet_tx_data = 4'hz;
assign enet_gtx_clk = 1'bz;
assign enet_tx_en = 1'b0;
assign enet_tx_er = 1'b0;
assign enet_mdc = 1'bz;
assign enet_mdio = 1'bz;
assign enet_rst_n = 1'b1;

// LCD handling
assign lcd_data = (lcd_rw ? 8'hzz : lcd_dataout);

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
assign ssram_adv_n = 1'b1; // ~(chipselect == 4'h6 && bm_burst_adv);
assign ssram_clk = clock_50p;
assign ssram_adsc_n = 1'b1; // ~(chipselect == 4'h6 && bm_burst);
assign ssram_adsp_n = ~(chipselect == 4'h6 && bm_start);
assign ssram_we_n = ~ssram_write;
assign ssram_be = (ssram_write ? ~bm_be : 4'b1111);
assign ssram_oe_n = ~ssram_read;
assign ssram0_ce_n = ~(chipselect == 4'h6 && ~bm_address[22]);
assign ssram1_ce_n = ~(chipselect == 4'h6 && bm_address[22]);
assign fs_addrbus = bm_address[26:0];
assign fs_databus = (ssram_oe_n ? bm_writedata : 32'hzzzzzzzz);

assign rgb_oe_n = matrix_oe_n;

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
assign LEDR = { 7'h0, chipselect };
assign LEDG = { locked, 8'b00000000 };

wire [7:0] chipselect;
wire [31:0] cpu_address, bm_address, vga_address;
wire [31:0] cpu_readdata, bm_writedata, bm_readdata, cpu_writedata, mon_readdata, ram_readdata, matrix_readdata, rom_readdata;
wire [31:0] vect_readdata, io_readdata;
wire [23:0] vga_readdata;
wire [3:0] cpu_be, bm_be;
wire [7:0] lcd_dataout;
wire cpu_write, cpu_read, cpu_wait, bm_read, bm_write, bm_wait, ram_write, ram_read, rom_read;
wire io_write, io_read, vga_wait, vga_read, vect_read;
wire matrix_oe_n;
wire matrix_read, matrix_write, ssram_read, ssram_write, bm_start, bm_burst, bm_burst_adv;
wire [1:0] bus_grant;

// quadrature encoder outputs 0-23
//rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
//  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

assign cpu_readdata = bm_readdata;
assign vga_readdata = bm_readdata[23:0];

assign bm_readdata = (chipselect == 4'h1 ? vect_readdata : 32'h0) |
                     (chipselect == 4'h2 ? rom_readdata : 32'h0) |
                     (chipselect == 4'h3 ? ram_readdata : 32'h0) |
                     (chipselect == 4'h5 ? matrix_readdata : 32'h0) |
                     (chipselect == 4'h4 ? io_readdata : 32'h0) |
                     (chipselect == 4'h6 ? fs_databus : 32'h0);

assign vect_read = (chipselect == 4'h1 ? bm_read : 1'b0);
assign rom_read = (chipselect == 4'h2 ? bm_read : 1'b0);
assign ram_read = (chipselect == 4'h3 ? bm_read : 1'b0);
assign ram_write = (chipselect == 4'h3 ? bm_write : 1'b0);
assign matrix_read = (chipselect == 4'h5 ? bm_read : 1'b0);
assign matrix_write = (chipselect == 4'h5 ? bm_write : 1'b0);
assign io_read = (chipselect == 4'h4 ? bm_read : 1'b0);
assign io_write = (chipselect == 4'h4 ? bm_write : 1'b0);
assign ssram_read = (chipselect == 4'h6 ? bm_read : 1'b0);
assign ssram_write = (chipselect == 4'h6 ? bm_write : 1'b0);

bexkat2 bexkat0(.clk(clock_50), .reset_n(rst_n), .address(cpu_address), .read(cpu_read), .readdata(cpu_readdata),
  .write(cpu_write), .writedata(cpu_writedata), .byteenable(cpu_be), .waitrequest(cpu_wait));
vectors rom1(.clock(clock_50), .q(vect_readdata), .rden(vect_read), .address(bm_address[6:2]));
monitor rom0(.clock(clock_50), .q(rom_readdata), .rden(rom_read), .address(bm_address[15:2]));
scratch ram0(.clock(clock_50), .data(bm_writedata), .q(ram_readdata), .wren(ram_write), .rden(ram_read), .address(bm_address[13:2]),
  .byteena(bm_be));
led_matrix matrix0(.csi_clk(clock_50), .led_clk(clock_5), .rsi_reset_n(rst_n), .avs_s0_writedata(bm_writedata), .avs_s0_readdata(matrix_readdata),
  .avs_s0_address(bm_address[11:2]), .avs_s0_byteenable(bm_be), .avs_s0_write(matrix_write), .avs_s0_read(matrix_read),
  .demux({rgb_a, rgb_b, rgb_c}), .rgb0(rgb0), .rgb1(rgb1), .rgb_stb(rgb_stb), .rgb_clk(rgb_clk), .oe_n(matrix_oe_n));

iocontroller io0(.clk(clock_50), .rst_n(rst_n), .miso(miso), .mosi(mosi), .sclk(sclk), .spi_selects(spi_selects), .sd_wp_n(sd_wp_n),
  .be(bm_be), .data_in(bm_writedata), .data_out(io_readdata), .read(io_read), .write(io_write), .address(bm_address),
  .lcd_e(lcd_e), .lcd_data(lcd_dataout), .lcd_rs(lcd_rs), .lcd_on(lcd_on), .lcd_rw(lcd_rw),
  .rx0(serial0_rx), .tx0(serial0_tx), .tx1(serial1_tx), .sw(SW[15:0]), .itd_backlight(itd_backlight), .itd_dc(itd_dc));

buscontroller bc0(.clock(clock_50), .reset_n(rst_n),
  .address(bm_address), .cpu_address(cpu_address), .vga_address(vga_address),
  .read(bm_read), .cpu_read(cpu_read), .vga_read(vga_read), 
  .start(bm_start), .chipselect(chipselect),
  .write(bm_write), .cpu_write(cpu_write),
  .cpu_writedata(cpu_writedata), .writedata(bm_writedata), .be(bm_be), .cpu_be(cpu_be),
  .burst(bm_burst), .burst_adv(bm_burst_adv),
  .cpu_wait(cpu_wait), .vga_wait(vga_wait), .map(SW[16]));
vga_framebuffer vga0(.vs(vga_vs), .hs(vga_hs), .sys_clock(clock_50), .vga_clock(clock_25), .reset_n(rst_n),
  .r(vga_r), .g(vga_g), .b(vga_b), .data(vga_readdata), .bus_read(vga_read), 
  .bus_wait(vga_wait), .address(vga_address), .blank_n(vga_blank_n));
sysclock pll0(.inclk0(raw_clock_50), .c0(clock_5), .c1(clock_25), .c2(clock_50), .c3(clock_50p), .areset(~KEY[0]), .locked(locked));
fan_ctrl fan0(.clk(clock_25), .rst_n(rst_n), .fan_pwm(fan_ctrl));

endmodule
