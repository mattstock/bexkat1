`include "../../fpgalib/bexkat1/exceptions.vh"

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
  input ext_miso,
  output ext_mosi,
  output ext_sclk,
  output rtc_ss,
  output led_ss,
  output codec_pbdat,
  input codec_reclrc,
  input codec_pblrc,
  input codec_recdat,
  inout codec_sdin,
  inout codec_sclk,
  input codec_bclk,
  output codec_mclk,
  input sd_wp_n,
  output fan_ctrl, 
  output [2:0] matrix0,
  output [2:0] matrix1,
  output matrix_clk,
  output matrix_oe_n,
  output matrix_a, 
  output matrix_b,
  output matrix_c,
  output matrix_stb,
  output serial1_tx,
  input serial1_rx,
  output serial2_tx,
  input serial2_rx,
  input serial2_cts,
  output serial2_rts,
  input serial0_rx,
  input serial0_cts,
  output serial0_tx,
  output serial0_rts,
  output vga_hs,
  output vga_vs,
  output vga_blank_n,
  output vga_sync_n,
  output vga_clock,
  output [7:0] vga_r,
  output [7:0] vga_g,
  output [7:0] vga_b,
  input ps2kbd_clk,
  input ps2kbd_data,
  input irda_rxd,
  input [7:0] td_data,
  input td_hs,
  input td_vs,
  input td_clk27,
  output td_reset_n,
  output reset_n,
  inout td_sclk,
  inout td_sdat,
  input accel_int1,
  inout accel_sclk,
  inout accel_sdat);

// System clock
wire sysclock, rst_i, locked;

assign reset_n = KEY[1];
assign rst_i = ~locked;

parameter clkfreq = 100000000;

sysclock pll0(.inclk0(raw_clock_50), .c0(sysclock), .areset(~KEY[0]), .c1(vga_clock), .c2(enet_gtx_clk), .locked(locked));
codec_pll pll1(.inclk0(raw_clock_50), .areset(~KEY[0]), .c0(codec_mclk));

// SPI wiring
wire [7:0] spi_selects;
wire miso, mosi, sclk;

assign rtc_ss = spi_selects[4];
assign led_ss = spi_selects[1];
assign sd_ss = spi_selects[0];
assign sd_mosi = mosi;
assign ext_mosi = mosi;
assign miso = (~spi_selects[0] ? sd_miso : 1'b0) |
              (~spi_selects[1] ? ext_miso : 1'b0) |
              (~spi_selects[2] ? ext_miso : 1'b0) |
              (~spi_selects[3] ? ext_miso : 1'b0) |
              (~spi_selects[4] ? ext_miso : 1'b0) |
              (~spi_selects[5] ? ext_miso : 1'b0);
assign sd_sclk = sclk;
assign ext_sclk = sclk;

// codec/external I2C
assign codec_sdin = (~i2c_tx ? 1'b0 : 1'bz);
assign codec_sclk = (~i2c_clock ? 1'b0 : 1'bz);

// accelerometer I2C
assign accel_sdat = (~accel_tx ? 1'b0 : 1'bz);
assign accel_sclk = (~accel_clock ? 1'b0 : 1'bz);

// eth I2C
assign enet_mdio = (~enet_i2c_tx ? 1'b0 : 1'bz);
assign enet_mdc = (~enet_i2c_clock ? 1'b0 : 1'bz);
assign enet_rst_n = ~rst_i;

// TD Decoder
assign td_sdat = (~td_tx ? 1'b0 : 1'bz);
assign td_sclk = (~td_clock ? 1'b0 : 1'bz);
assign td_reset_n = ~rst_i;

// ethernet stubs TODO
assign enet_tx_data = 4'hz;
assign enet_tx_en = 1'b0;
assign enet_tx_er = 1'b0;

// LCD wiring
assign lcd_data = (lcd_rw ? 8'hzz : lcd_dataout);

// External SDRAM, SSRAM & flash bus wiring
assign sdram_databus = (sdram_dir ? sdram_dataout : 32'hzzzzzzzz);
assign fl_rst_n = 1'b1;
assign fl_oe_n = 1'b1;
assign fl_we_n = 1'b1;
assign fl_ce_n = 1'b1;
assign fl_wp_n = 1'b1;
assign fs_addrbus = ssram_addrout;
assign fs_databus = (~ssram_we_n ? ssram_dataout : 32'hzzzzzzzz);

// System Blinknlights
assign LEDR = { SW[17], enet_rx_crs, io_interrupts, miso, mosi, sclk, i2c_clock, i2c_tx, td_sdat, ~sd_ss, cpu_halt, mmu_fault, cpu_cyc };
assign LEDG = { ~irda_rxd, enet_rx_dv, enet_rx_data, supervisor, cache_hitmiss };

// Internal bus wiring
wire [3:0] chipselect;
wire [26:0] ssram_addrout;
wire [31:0] cpu_address, mmu_address, vga_readdata, ssram_dataout;
wire [31:0] cpu_readdata, cpu_writedata, mon_readdata, mandelbrot_readdata, rom_readdata;
wire [31:0] vect_readdata, io_readdata, sdram_readdata, sdram_dataout;
wire [3:0] cpu_be, exception;
wire [5:0] io_interrupts;
wire [3:0] cpu_interrupt;
wire [7:0] lcd_dataout;
wire cpu_write, cpu_cyc, cpu_ack, cpu_halt;
wire mandelbrot_ack, io_ack;
wire rom_read, vect_read, supervisor;
wire sdram_ack;
wire [3:0] sdram_den_n;
wire vga_ack, rom_ack;
wire int_en, mmu_fault;
wire [1:0] cache_hitmiss;
wire i2c_tx, i2c_clock;
wire enet_i2c_tx, enet_i2c_clock;
wire td_tx, td_clock;
wire accel_tx, accel_clock;
wire sdram_dir;

// only need one cycle for reading onboard memory
reg [1:0] vect_ack;

always @(posedge sysclock or posedge rst_i)
begin
  if (rst_i)
    vect_ack <= 2'b0;
  else begin
    if (chipselect == 4'h0)
      vect_ack <= 2'b0;
    else
      vect_ack <= { vect_ack[0], vect_read };
  end
end

// interrupt priority encoder
always_comb
begin
  cpu_interrupt = 4'h0;
  if (int_en)
    casex ({ mmu_fault, io_interrupts })
      7'b1xxxxxx: cpu_interrupt = EXC_MMU;
      7'b01xxxxx: cpu_interrupt = EXC_TIMER3;
      7'b001xxxx: cpu_interrupt = EXC_TIMER2;
      7'b0001xxx: cpu_interrupt = EXC_TIMER1;
      7'b00001xx: cpu_interrupt = EXC_TIMER0;
      7'b000001x: cpu_interrupt = EXC_UART0_RX;
      7'b0000001: cpu_interrupt = EXC_UART0_TX;
      7'b0000000: cpu_interrupt = EXC_RESET;
    endcase
end

assign cpu_readdata = (chipselect == 4'h1 ? vect_readdata : 32'h0) |
                      (chipselect == 4'h2 ? rom_readdata : 32'h0) |
                      (chipselect == 4'h3 ? mandelbrot_readdata : 32'h0) |
                      (chipselect == 4'h4 ? io_readdata : 32'h0) |
                      (chipselect == 4'h6 ? vga_readdata : 32'h0) |
                      (chipselect == 4'h7 ? sdram_readdata : 32'h0);
assign cpu_ack = (chipselect == 4'h1 ? vect_ack[1] : 1'h0) |
                 (chipselect == 4'h2 ? rom_ack : 1'h0) |
                 (chipselect == 4'h3 ? mandelbrot_ack : 1'h0) |
                 (chipselect == 4'h4 ? io_ack : 1'h0) |
                 (chipselect == 4'h6 ? vga_ack : 1'h0) |
                 (chipselect == 4'h7 ? sdram_ack : 1'h0);

assign vect_read = (chipselect == 4'h1 && cpu_cyc && ~cpu_write);

bexkat1 bexkat0(.clk_i(sysclock), .rst_i(rst_i), .adr_o(cpu_address), .cyc_o(cpu_cyc), .dat_i(cpu_readdata),
  .we_o(cpu_write), .dat_o(cpu_writedata), .sel_o(cpu_be), .ack_i(cpu_ack), .halt(cpu_halt), .supervisor(supervisor),
  .inter(cpu_interrupt[2:0]), .exception(exception), .int_en(int_en));

mmu mmu0(.adr_i(cpu_address), .adr_o(mmu_address), .cyc_i(cpu_cyc), .chipselect(chipselect), .supervisor(supervisor), .we_i(cpu_write), .fault(mmu_fault));

sdram_controller_cache sdram0(.clk_i(sysclock), .mem_clk_o(sdram_clk), .rst_i(rst_i), .adr_i(cpu_address[26:2]), .stats_stb_i(cpu_address[31:28] == 4'h4),
  .dat_i(cpu_writedata), .dat_o(sdram_readdata), .stb_i(chipselect == 4'h7), .cyc_i(cpu_cyc),
  .ack_o(sdram_ack), .sel_i(cpu_be), .we_i(cpu_write), .cache_status(cache_hitmiss),
  .we_n(sdram_we_n), .cs_n(sdram_cs_n), .cke(sdram_cke), .cas_n(sdram_cas_n), .ras_n(sdram_ras_n), .dqm(sdram_dqm), .ba(sdram_ba),
  .addrbus_out(sdram_addrbus), .databus_in(sdram_databus), .databus_out(sdram_dataout), .databus_dir(sdram_dir));
iocontroller #(.clkfreq(clkfreq)) io0(.clk_i(sysclock), .rst_i(rst_i), .dat_i(cpu_writedata), .dat_o(io_readdata), .we_i(cpu_write), .adr_i(cpu_address[16:2]),
  .stb_i(chipselect == 4'h4), .cyc_i(cpu_cyc), .ack_o(io_ack), .sel_i(cpu_be),
  .miso(miso), .mosi(mosi), .sclk(sclk), .spi_selects(spi_selects), .sd_wp(sd_wp_n), .fan(fan_ctrl),
  .lcd_e(lcd_e), .lcd_data(lcd_dataout), .lcd_rs(lcd_rs), .lcd_on(lcd_on), .lcd_rw(lcd_rw), .interrupts(io_interrupts),
  .rx0(serial0_rx), .tx0(serial0_tx), .rts0(serial0_rts), .cts0(serial0_cts), .tx1(serial1_tx), .rx1(serial1_rx),
  .tx2(serial2_tx), .rx2(serial2_rx), .rts2(serial2_rts), .cts2(serial2_cts), .sw(SW[15:0]),
  .ps2kbd({ps2kbd_clk, ps2kbd_data}), .hex7(HEX7), .hex6(HEX6), .hex5(HEX5), .hex4(HEX4), .hex3(HEX3), .hex2(HEX2), .hex1(HEX1), .hex0(HEX0),
  .codec_pbdat(codec_pbdat), .codec_recdat(codec_recdat),
  .codec_reclrc(codec_reclrc), .codec_pblrc(codec_pblrc),
  .i2c_dataout({accel_tx, td_tx, i2c_tx, enet_i2c_tx}), .i2c_datain({accel_sdat, td_sdat, codec_sdin, enet_mdio}),
  .i2c_scl({accel_clock, td_clock, i2c_clock, enet_i2c_clock}), .i2c_clkin({accel_sclk, td_sclk, codec_sclk, enet_mdc}),
  .irda(irda_rxd), .matrix_a(matrix_a), .matrix_b(matrix_b), .matrix_c(matrix_c), .matrix_stb(matrix_stb),
  .matrix_oe_n(matrix_oe_n), .matrix_clk(matrix_clk), .matrix0(matrix0), .matrix1(matrix1));
assign mandelbrot_ack = 1'b1;
assign mandelbrot_readdata = 32'h0;
//mandunit mand0(.clk_i(sysclock), .rst_i(rst_i), .dat_i(cpu_writedata), .dat_o(mandelbrot_readdata), .cyc_i(cpu_cyc),
//  .adr_i(cpu_address[4:2]), .we_i(cpu_write), .stb_i(chipselect == 4'h3), .sel_i(cpu_be), .ack_o(mandelbrot_ack));

bios bios0(.clk_i(sysclock), .rst_i(rst_i), .cyc_i(cpu_cyc), .dat_o(rom_readdata), .stb_i(chipselect == 4'h2), .select(SW[17]), .ack_o(rom_ack), .adr_i(cpu_address[16:2]));
vectors vecram0(.clock(sysclock), .q(vect_readdata), .rden(vect_read), .address(cpu_address[6:2]));

vga_module video0(.clk_i(sysclock), .rst_i(rst_i), .cyc_i(cpu_cyc), .ack_o(vga_ack), .we_i(cpu_write), .sel_i(cpu_be),
  .adr_i(cpu_address), .dat_i(cpu_writedata), .dat_o(vga_readdata), .stb_i(chipselect == 4'h6), 
  .vs(vga_vs), .hs(vga_hs), .r(vga_r), .g(vga_g), .b(vga_b), .blank_n(vga_blank_n), .vga_clock(vga_clock), .sync_n(vga_sync_n),
  .databus_in(fs_databus), .databus_out(ssram_dataout),
  .address_out(ssram_addrout), .bus_clock(ssram_clk), .gw_n(ssram_gw_n), .adv_n(ssram_adv_n), .adsp_n(ssram_adsp_n),
  .adsc_n(ssram_adsc_n), .be_out(ssram_be), .oe_n(ssram_oe_n), .we_n(ssram_we_n), .ce0_n(ssram0_ce_n), .ce1_n(ssram1_ce_n));

endmodule
