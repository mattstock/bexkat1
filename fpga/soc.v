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

wire clock_2p7, clock_50, clock_25, clock_50p, clock_200, locked;
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
assign rst_n = locked;

// Wiring for external SDRAM, SSRAM & flash
assign sdram_clk = clock_200;

assign fl_oe_n = ~flash_read;
assign fl_we_n = ~flash_write;
assign fl_ce_n = ~(chipselect == 4'h8);
assign fl_rst_n = rst_n;
assign flash_ready = fl_ry;
assign fl_wp_n = 1'b1;

assign ssram_gw_n = 1'b1;
assign ssram_adv_n = 1'b1; // ~(chipselect == 4'h6 && bm_burst_adv);
assign ssram_clk = clock_50;
assign ssram_adsp_n = 1'b1; // ~(chipselect == 4'h6 && bm_burst);
assign ssram_adsc_n = ~(chipselect == 4'h6 && bus_start);
assign ssram_we_n = ~ssram_write;
assign ssram_be = (ssram_write ? ~cpu_be : 4'b1111);
assign ssram_oe_n = ~ssram_read;
assign ssram0_ce_n = ~(chipselect == 4'h6 && ~cpu_address[21]);
assign ssram1_ce_n = ~(chipselect == 4'h6 && cpu_address[21]);
assign fs_addrbus = cpu_address[26:0];
assign fs_databus = (ssram_write ? cpu_writedata : (flash_write ? (cpu_address[1] ? cpu_writedata[15:0] : cpu_writedata[31:16]) : 32'hzzzzzzzz));
assign sdram_databus = (sdram_we_n ? 32'hzzzzzzzz : sdram_dataout);

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
assign LEDG = { cpu_halt, sdram_ready, flash_ready, 6'b0000000 };

wire [7:0] chipselect;
wire [31:0] cpu_address;
wire [31:0] cpu_readdata, cpu_writedata, mon_readdata, ram_readdata, matrix_readdata, rom_readdata;
wire [31:0] vect_readdata, io_readdata, sdram_readdata, sdram_dataout;
wire [3:0] cpu_be, bm_be;
wire [7:0] lcd_dataout;
wire cpu_write, cpu_read, cpu_wait, ram_write, ram_read, rom_read, cpu_halt;
wire io_write, io_read, vect_read, sdram_read, sdram_write, sdram_ready, flash_ready, flash_read, flash_write;
wire matrix_oe_n, bus_start, mmu_buswrite, mmu_busfault;
wire matrix_read, matrix_write, ssram_read, ssram_write;

// quadrature encoder outputs 0-23
//rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
//  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

assign cpu_readdata = (chipselect == 4'h1 ? vect_readdata : 32'h0) |
                      (chipselect == 4'h2 ? rom_readdata : 32'h0) |
                      (chipselect == 4'h3 ? ram_readdata : 32'h0) |
                      (chipselect == 4'h5 ? matrix_readdata : 32'h0) |
                      (chipselect == 4'h4 ? io_readdata : 32'h0) |
                      (chipselect == 4'h6 ? fs_databus : 32'h0) |
                      (chipselect == 4'h7 ? sdram_readdata : 32'h0) |
                      (chipselect == 4'h8 ? { 16'h0000, fs_databus[15:0] } : 32'h0);

assign vect_read = (chipselect == 4'h1 ? cpu_read : 1'b0);
assign rom_read = (chipselect == 4'h2 ? cpu_read : 1'b0);
assign ram_read = (chipselect == 4'h3 ? cpu_read : 1'b0);
assign ram_write = (chipselect == 4'h3 ? cpu_write : 1'b0);
assign matrix_read = (chipselect == 4'h5 ? cpu_read : 1'b0);
assign matrix_write = (chipselect == 4'h5 ? cpu_write : 1'b0);
assign io_read = (chipselect == 4'h4 ? cpu_read : 1'b0);
assign io_write = (chipselect == 4'h4 ? cpu_write : 1'b0);
assign ssram_read = (chipselect == 4'h6 ? cpu_read : 1'b0);
assign ssram_write = (chipselect == 4'h6 ? mmu_buswrite : 1'b0);
assign sdram_read = (chipselect == 4'h7 ? cpu_read : 1'b0);
assign sdram_write = (chipselect == 4'h7 ? cpu_write : 1'b0);
assign flash_read = (chipselect == 4'h8 ? cpu_read : 1'b0);
assign flash_write = (chipselect == 4'h8 ? cpu_write : 1'b0);

always @(posedge clock_50)
begin
  if (KEY[3]) begin
    datadisp <= cpu_writedata;
    addrdisp <= cpu_address;
  end
end

bexkat2 bexkat0(.clk(clock_50), .reset_n(rst_n), .address(cpu_address), .read(cpu_read), .readdata(cpu_readdata),
  .write(cpu_write), .writedata(cpu_writedata), .byteenable(cpu_be), .waitrequest(cpu_wait), .halt(cpu_halt), .busfault(mmu_busfault));
vectors rom1(.clock(clock_50), .q(vect_readdata), .rden(vect_read), .address(cpu_address[6:2]));
monitor rom0(.clock(clock_50), .q(rom_readdata), .rden(rom_read), .address(cpu_address[15:2]));
scratch ram0(.clock(clock_50), .data(cpu_writedata), .q(ram_readdata), .wren(ram_write), .rden(ram_read), .address(cpu_address[13:2]),
  .byteena(cpu_be));
sdram_controller sdram0(.cpu_clk(clock_50), .mem_clk(clock_200), .reset_n(rst_n), .we_n(sdram_we_n), .cs_n(sdram_cs_n), .cke(sdram_cke),
    .cas_n(sdram_cas_n), .ras_n(sdram_ras_n), .dqm(sdram_dqm), .be(cpu_be), .ba(sdram_ba), .addrbus_out(sdram_addrbus),
    .databus_in(sdram_databus), .databus_out(sdram_dataout), .read(sdram_read), .write(sdram_write), .ready(sdram_ready),
    .address(cpu_address[26:2]), .data_in(cpu_writedata), .data_out(sdram_readdata));
//sdrc_top #(.SDR_DW(32)) sdram0(.sdram_clk(clock_50p), .sdram_resetn(rst_n), .cfg_sdr_width(2'b00), .cfg_colbits(2'b10),
//  .sdr_cke(sdram_cke), .sdr_cs_n(sdram_cs_n), .sdr_ras_n(sdram_ras_n), .sdr_cas_n(sdram_cas_n), .sdr_we_n(sdram_we_n),
//  .sdr_dqm(sdram_dqm), .sdr_ba(sdram_ba), .sdr_addr(sdram_addrbus), .sdr_dq(sdram_databus),
//  .cfg_sdr_tras_d(4'h5), .cfg_sdr_trp_d(4'h2), .cfg_sdr_trcd_d(4'h2), .cfg_sdr_en(1'b1), .cfg_req_depth(2'h2), .cfg_sdr_mode_reg(12'h0),
//  .cfg_sdr_cas(3'h2), .cfg_sdr_trcar_d(4'h2), .cfg_sdr_twr_d(4'h2), .cfg_sdr_rfsh(12'h300), .cfg_sdr_rfmax(3'h2));
led_matrix matrix0(.csi_clk(clock_50), .led_clk(clock_2p7), .rsi_reset_n(rst_n), .avs_s0_writedata(cpu_writedata), .avs_s0_readdata(matrix_readdata),
  .avs_s0_address(cpu_address[11:2]), .avs_s0_byteenable(cpu_be), .avs_s0_write(matrix_write), .avs_s0_read(matrix_read),
  .demux({rgb_a, rgb_b, rgb_c}), .rgb0(rgb0), .rgb1(rgb1), .rgb_stb(rgb_stb), .rgb_clk(rgb_clk), .oe_n(matrix_oe_n));
iocontroller io0(.clk(clock_50), .rst_n(rst_n), .miso(miso), .mosi(mosi), .sclk(sclk), .spi_selects(spi_selects), .sd_wp_n(sd_wp_n),
  .be(cpu_be), .data_in(cpu_writedata), .data_out(io_readdata), .read(io_read), .write(io_write), .address(cpu_address),
  .lcd_e(lcd_e), .lcd_data(lcd_dataout), .lcd_rs(lcd_rs), .lcd_on(lcd_on), .lcd_rw(lcd_rw),
  .rx0(serial0_rx), .tx0(serial0_tx), .tx1(serial1_tx), .sw(SW[15:0]), .itd_backlight(itd_backlight), .itd_dc(itd_dc));
mmu mmu0(.clock(clock_50), .reset_n(rst_n), .address(cpu_address),
  .read(cpu_read), .start(bus_start), .chipselect(chipselect), .write(cpu_write),
  .buswait(cpu_wait), .buswrite(mmu_buswrite), .map(SW[17]), .busfault(mmu_busfault));
sysclock pll0(.inclk0(raw_clock_50), .c0(clock_200), .c1(clock_25), .c2(clock_50), .c3(clock_50p), .areset(~KEY[0]), .locked(locked));
matrixpll pll1(.inclk0(raw_clock_50), .c0(clock_2p7));
fan_ctrl fan0(.clk(clock_25), .rst_n(rst_n), .fan_pwm(fan_ctrl));

endmodule
