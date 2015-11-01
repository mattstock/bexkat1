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
  output rtc_ss,
  input rtc_miso,
  output rtc_mosi,
  output rtc_sclk,
  output touch_ss,
  output extsd_ss,
  output gen_sclk,
  input touch_irq,
  output itd_ss,
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
  output serial0_rts,
  output vga_hs,
  output vga_vs,
  output vga_blank_n,
  output vga_sync_n,
  output vga_clock,
  output [7:0] vga_r,
  output [7:0] vga_g,
  output [7:0] vga_b);

wire sysclock, locked;
wire [7:0] spi_selects;
wire miso, mosi, sclk;
assign rgb = 3'b000;

// some SPI wiring
assign sd_ss = spi_selects[0];
assign itd_ss = spi_selects[1];
assign touch_ss = spi_selects[2];
assign extsd_ss = spi_selects[3];
assign rtc_ss = spi_selects[4];
assign gen_mosi = mosi;
assign sd_mosi = mosi;
assign rtc_mosi = mosi;
assign miso = (~spi_selects[0] ? sd_miso : 1'b0) |
              (~spi_selects[1] ? gen_miso : 1'b0) |
              (~spi_selects[2] ? gen_miso : 1'b0) |
              (~spi_selects[3] ? gen_miso : 1'b0) |
              (~spi_selects[4] ? rtc_miso : 1'b0);
assign gen_sclk = sclk;
assign sd_sclk = sclk;
assign rtc_sclk = sclk;

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

assign serial0_rts = serial0_cts; // who needs hardware handshaking?
assign rst_n = locked;

// Wiring for external SDRAM, SSRAM & flash
assign sdram_clk = sysclock;

assign rgb_oe_n = matrix_oe_n;

reg [31:0] addrdisp, datadisp;

// visualization stuff
hexdisp d7(.out(HEX7), .in(addrdisp[31:28]));
hexdisp d6(.out(HEX6), .in(addrdisp[27:24]));
hexdisp d5(.out(HEX5), .in(addrdisp[23:20]));
hexdisp d4(.out(HEX4), .in(addrdisp[19:16]));
hexdisp d3(.out(HEX3), .in(addrdisp[15:12]));
hexdisp d2(.out(HEX2), .in(addrdisp[11:8]));
hexdisp d1(.out(HEX1), .in(addrdisp[7:4]));
hexdisp d0(.out(HEX0), .in(addrdisp[3:0]));

// Blinknlights
assign LEDR = { 7'h0, chipselect };
assign LEDG = { cpu_halt, sdram_ready, fl_ry, 1'b0, int_en, exception };

wire [3:0] chipselect;
wire [26:0] ssram_addrout, flash_addrout;
wire [31:0] cpu_address, flash_readdata, ssram_readdata, ssram_dataout;
wire [15:0] flash_dataout;
wire [31:0] cpu_readdata, cpu_writedata, mon_readdata, mandelbrot_readdata, matrix_readdata, rom_readdata;
wire [31:0] vect_readdata, io_readdata, sdram_readdata, sdram_dataout;
wire [3:0] cpu_be, exception;
wire [1:0] io_interrupt;
wire [2:0] cpu_interrupt;
wire [7:0] lcd_dataout;
wire cpu_write, cpu_cyc, cpu_ack, cpu_halt;
wire mandelbrot_write, mandelbrot_read, mandelbrot_wait;
wire io_write, io_read, io_wait;
wire rom_read, vect_read;
wire sdram_read, sdram_write, sdram_ready, sdram_wait;
wire flash_read, flash_write, flash_ready, flash_wait;
wire matrix_read, matrix_write, matrix_oe_n, matrix_ack;
wire ssram_ack;
wire vga_write;
wire int_en, cache_enable, mmu_fault;

// only need one cycle for reading onboard memory
reg [1:0] rom_ack, vect_ack, vga_ack;

always @(posedge sysclock or negedge rst_n)
begin
  if (!rst_n) begin
    rom_ack <= 2'b0;
    vect_ack <= 2'b0;
    vga_ack <= 2'b0;
  end else begin
    rom_ack <= { rom_ack[0], rom_read };
    vect_ack <= { vect_ack[0], vect_read };
    vga_ack <= { vga_ack[0], vga_write };
  end
end

assign fl_rst_n = rst_n;

assign fs_addrbus = (chipselect == 4'h8 ? flash_addrout : ssram_addrout);
assign fs_databus = (chipselect == 4'h6 && ~ssram_we_n ? ssram_dataout : 
                      (chipselect == 4'h8 && ~fl_we_n ? { 16'h0000, flash_dataout } : 32'hzzzzzzzz));
assign sdram_databus = (~sdram_we_n ? sdram_dataout : 32'hzzzzzzzz);

always @(posedge sysclock)
begin
  if (KEY[3]) begin
    datadisp <= cpu_writedata;
    addrdisp <= cpu_address;
  end
end

// interrupt hierarchy
always @(*)
begin
  if (mmu_fault)
    cpu_interrupt = 3'h0; // for now
  else if (|io_interrupt)
    cpu_interrupt = { 1'b1, io_interrupt };
  else
    cpu_interrupt = 3'h0;
end

assign cpu_readdata = (chipselect == 4'h1 ? vect_readdata : 32'h0) |
                      (chipselect == 4'h2 ? rom_readdata : 32'h0) |
                      (chipselect == 4'h3 ? mandelbrot_readdata : 32'h0) |
                      (chipselect == 4'h4 ? io_readdata : 32'h0) |
                      (chipselect == 4'h5 ? matrix_readdata : 32'h0) |
                      (chipselect == 4'h6 ? ssram_readdata : 32'h0) |
                      (chipselect == 4'h7 ? sdram_readdata : 32'h0) |
                      (chipselect == 4'h8 ? flash_readdata : 32'h0);
assign cpu_ack = (chipselect == 4'h1 ? vect_ack[1] : 1'h0) |
                 (chipselect == 4'h2 ? rom_ack[1] : 1'h0) |
                 (chipselect == 4'h3 ? ~mandelbrot_wait : 1'h0) |
                 (chipselect == 4'h4 ? ~io_wait : 1'h0) |
                 (chipselect == 4'h5 ? matrix_ack : 1'h0) |
                 (chipselect == 4'h6 ? ssram_ack: 1'h0) |
                 (chipselect == 4'h7 ? ~sdram_wait : 1'h0) |
                 (chipselect == 4'h8 ? ~flash_wait : 1'h0);

assign io_read = (chipselect == 4'h4 && cpu_cyc && ~cpu_write);
assign io_write = (chipselect == 4'h4 && cpu_cyc && cpu_write);
assign rom_read = (chipselect == 4'h2 && cpu_cyc && ~cpu_write);
assign vect_read = (chipselect == 4'h1 && cpu_cyc && ~cpu_write);
   
sysclock pll0(.inclk0(raw_clock_50), .c0(sysclock), .areset(~KEY[0]), .locked(locked));

bexkat2 bexkat0(.clk_i(sysclock), .rst_i(~rst_n), .address(cpu_address), .cyc_o(cpu_cyc), .readdata(cpu_readdata),
  .we_o(cpu_write), .writedata(cpu_writedata), .byteenable(cpu_be), .ack_i(cpu_ack), .halt(cpu_halt),
  .interrupt(cpu_interrupt), .exception(exception), .int_en(int_en));
mmu mmu0(.adr_i(cpu_address), .cyc_i(cpu_cyc), .chipselect(chipselect), .fault(mmu_fault), .cache_enable(cache_enable));

// 0x00000000 - 0x003fffff
ssram_controller ssram0(.clk_i(sysclock), .rst_i(~rst_n), .databus_in(fs_databus), .databus_out(ssram_dataout),
  .stb_i(chipselect == 4'h6), .cyc_i(cpu_cyc), .we_i(cpu_write), .ack_o(ssram_ack), .dat_i(cpu_writedata), .dat_o(ssram_readdata),
  .sel_i(cpu_be), .adr_i(cpu_address[21:0]), .address_out(ssram_addrout), .bus_clock(ssram_clk),
  .gw_n(ssram_gw_n), .adv_n(ssram_adv_n), .adsp_n(ssram_adsp_n), .adsc_n(ssram_adsc_n), .be_out(ssram_be),
  .oe_n(ssram_oe_n), .we_n(ssram_we_n), .ce0_n(ssram0_ce_n), .ce1_n(ssram1_ce_n));
// 0x00800000 - 0x008007ff
led_matrix matrix0(.clk_i(sysclock), .rst_i(~rst_n), .dat_i(cpu_writedata), .dat_o(matrix_readdata),
  .adr_i(cpu_address[11:2]), .sel_i(cpu_be), .we_i(cpu_write), .stb_i(chipselect == 4'h5), .cyc_i(cpu_cyc), .ack_o(matrix_ack),
  .demux({rgb_a, rgb_b, rgb_c}), .rgb0(rgb0), .rgb1(rgb1), .rgb_stb(rgb_stb), .rgb_clk(rgb_clk), .oe_n(matrix_oe_n));
// 0x00800800 - 0x00800fff
iocontroller io0(.clk(sysclock), .rst_n(rst_n), .miso(miso), .mosi(mosi), .sclk(sclk), .spi_selects(spi_selects), .sd_wp_n(sd_wp_n),
  .be(cpu_be), .data_in(cpu_writedata), .data_out(io_readdata), .read(io_read), .write(io_write), .address(cpu_address),
  .lcd_e(lcd_e), .lcd_data(lcd_dataout), .lcd_rs(lcd_rs), .lcd_on(lcd_on), .lcd_rw(lcd_rw), .interrupt(io_interrupt), .wait_out(io_wait),
  .rx0(serial0_rx), .tx0(serial0_tx), .tx1(serial1_tx), .sw(SW[15:0]), .itd_backlight(itd_backlight), .itd_dc(itd_dc), .fan(fan_ctrl));
// 0xb0000000 - 0xbfffffff
//vga_framebuffer vga0(.clock(sysclock), .reset_n(rst_n), .address(cpu_address[20:2]), .write(vga_write), .data(cpu_writedata),
//  .vs(vga_vs), .hs(vga_hs), .r(vga_r), .g(vga_g), .b(vga_b), .blank_n(vga_blank_n), .vga_clock(vga_clock), .sync_n(vga_sync_n), .sw(SW[17]));
// 0xc0000000 - 0xcfffffff
sdram_controller sdram0(.cpu_clk(sysclock), .mem_clk(sysclock), .reset_n(rst_n), .we_n(sdram_we_n), .cs_n(sdram_cs_n), .cke(sdram_cke),
    .cas_n(sdram_cas_n), .ras_n(sdram_ras_n), .dqm(sdram_dqm), .be(cpu_be), .ba(sdram_ba), .addrbus_out(sdram_addrbus),
    .databus_in(sdram_databus), .databus_out(sdram_dataout), .read(1'b0), .write(1'b0), .ready(sdram_ready),
    .address(cpu_address[26:2]), .data_in(cpu_writedata), .data_out(sdram_readdata), .wait_out(sdram_wait));
// 0xd0000000 - 0xdfffffff
//mandunit mand0(.clock(sysclock), .rst_n(rst_n), .data_in(cpu_writedata), .data_out(mandelbrot_readdata),
//  .write(mandelbrot_write), .read(mandelbrot_read), .address(cpu_address[18:0]), .be(cpu_be), .wait_out(mandelbrot_wait));
// 0xe0000000 - 0xefffffff
flash_controller flash0(.clock(sysclock), .reset_n(rst_n), .databus_in(fs_databus[15:0]), .databus_out(flash_dataout),
  .read(1'b0), .write(1'b0), .wait_out(flash_wait), .data_in(cpu_writedata), .data_out(flash_readdata),
  .be_in(cpu_be), .address_in(cpu_address[26:0]), .address_out(flash_addrout),
  .ready(fl_ry), .wp_n(fl_wp_n), .oe_n(fl_oe_n), .we_n(fl_we_n), .ce_n(fl_ce_n));
// 0xffff0000 - 0xffffffdf
monitor rom0(.clock(sysclock), .q(rom_readdata), .rden(rom_read), .address(cpu_address[15:2]));
// 0xffffffe0 - 0xffffffff
vectors vecram0(.clock(sysclock), .q(vect_readdata), .rden(vect_read), .address(cpu_address[6:2]));

endmodule
