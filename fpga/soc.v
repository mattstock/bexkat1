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
  output codec_xdcs,
  output codec_cs,
  input codec_irq,
  input rtc_miso,
  output rtc_mosi,
  output rtc_sclk,
  output gen_sclk,
  output rst_n,
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
  output [7:0] vga_b,
  input ps2mouse_clk,
  input ps2kbd_clk,
  input ps2mouse_data,
  input ps2kbd_data);

// System clock
wire sysclock, locked, rst_i;

assign rst_n = locked;
assign rst_i = ~locked;

sysclock pll0(.inclk0(raw_clock_50), .c0(sysclock), .areset(~KEY[0]), .locked(locked));

// SPI wiring
wire [7:0] spi_selects;
wire miso, mosi, sclk;

assign rtc_ss = spi_selects[4];
assign codec_cs = spi_selects[3];
assign codec_xdcs = spi_selects[2];
assign sd_ss = spi_selects[0];
assign gen_mosi = mosi;
assign sd_mosi = mosi;
assign rtc_mosi = mosi;
assign miso = (~spi_selects[0] ? sd_miso : 1'b0) |
              (~spi_selects[1] ? gen_miso : 1'b0) |
              (~spi_selects[2] ? rtc_miso : 1'b0) |
              (~spi_selects[3] ? rtc_miso : 1'b0) |
              (~spi_selects[4] ? rtc_miso : 1'b0) |
              (~spi_selects[5] ? rtc_miso : 1'b0);
assign gen_sclk = sclk;
assign sd_sclk = sclk;
assign rtc_sclk = sclk;

// ethernet stubs TODO
assign enet_tx_data = 4'hz;
assign enet_gtx_clk = 1'bz;
assign enet_tx_en = 1'b0;
assign enet_tx_er = 1'b0;
assign enet_mdc = 1'bz;
assign enet_mdio = 1'bz;
assign enet_rst_n = ~rst_i;

// LCD wiring
assign lcd_data = (lcd_rw ? 8'hzz : lcd_dataout);

// External SDRAM, SSRAM & flash bus wiring
assign sdram_databus = (~sdram_we_n ? sdram_dataout : 32'hzzzzzzzz);
assign fl_rst_n = ~rst_i;
assign fs_addrbus = (chipselect == 4'h8 ? flash_addrout : ssram_addrout);
assign fs_databus = (chipselect == 4'h6 && ~ssram_we_n ? ssram_dataout : 
                      (chipselect == 4'h8 && ~fl_we_n ? { 16'h0000, flash_dataout } : 32'hzzzzzzzz));

// System Blinknlights
assign LEDR = { SW[17], SW[16], io_interrupts, miso, mosi, sclk, ~codec_irq, ~codec_cs, ~codec_xdcs, ~sd_ss, cpu_halt, mmu_fault, cpu_cyc };
assign LEDG = { 7'h0, cache_hitmiss };

// Internal bus wiring
wire [3:0] chipselect;
wire [26:0] ssram_addrout, flash_addrout;
wire [31:0] cpu_address, vga_address, flash_readdata, ssram_readdata, ssram_dataout, vga_readdata;
wire [15:0] flash_dataout;
wire [31:0] cpu_readdata, cpu_writedata, mon_readdata, mandelbrot_readdata, matrix_readdata, rom_readdata;
wire [31:0] vect_readdata, io_readdata, sdram_readdata, sdram_dataout, vga_writedata, rom2_readdata;
wire [3:0] cpu_be, vga_sel, exception;
wire [5:0] io_interrupts;
wire [2:0] cpu_interrupt;
wire [7:0] lcd_dataout;
wire cpu_write, cpu_cyc, cpu_ack, cpu_halt;
wire vga_we, vga_cyc, vga_stb;
wire arb_cyc, cpu_gnt, vga_gnt;
wire mandelbrot_ack, io_ack;
wire rom_read, vect_read;
wire sdram_ack, vga_slave_ack;
wire [3:0] sdram_den_n;
wire flash_read, flash_write, flash_ready, flash_wait;
wire matrix_read, matrix_write, matrix_ack;
wire ssram_ack;
wire int_en, cache_enable, mmu_fault;
wire [1:0] cache_hitmiss;

// only need one cycle for reading onboard memory
reg [1:0] rom_ack, vect_ack;

always @(posedge sysclock or posedge rst_i)
begin
  if (rst_i) begin
    rom_ack <= 2'b0;
    vect_ack <= 2'b0;
  end else begin
    if (chipselect == 4'h0) begin
      rom_ack <= 2'b0;
      vect_ack <= 2'b0;
    end else begin
      rom_ack <= { rom_ack[0], rom_read };
      vect_ack <= { vect_ack[0], vect_read };
    end
  end
end

// interrupt priority encoder
always_comb
begin
  cpu_interrupt = 3'h0;
  if (int_en)
    casex ({ mmu_fault, io_interrupts })
      7'b1xxxxxx: cpu_interrupt = 3'h1; // MMU error
      7'b01xxxxx: cpu_interrupt = 3'h5; // timer3
      7'b001xxxx: cpu_interrupt = 3'h4; // timer2
      7'b0001xxx: cpu_interrupt = 3'h3; // timer1
      7'b00001xx: cpu_interrupt = 3'h2; // timer0
      7'b000001x: cpu_interrupt = 3'h6; // uart0 rx
      7'b0000001: cpu_interrupt = 3'h7; // uart0 tx
      7'b0000000: cpu_interrupt = 3'h0;
    endcase
end

assign cpu_readdata = (chipselect == 4'h1 ? vect_readdata : 32'h0) |
                      (chipselect == 4'h2 ? (SW[16] ? rom2_readdata : rom_readdata) : 32'h0) |
                      (chipselect == 4'h3 ? mandelbrot_readdata : 32'h0) |
                      (chipselect == 4'h4 ? io_readdata : 32'h0) |
                      (chipselect == 4'h5 ? matrix_readdata : 32'h0) |
                      (chipselect == 4'h6 ? ssram_readdata : 32'h0) |
                      (chipselect == 4'h7 ? sdram_readdata : 32'h0) |
                      (chipselect == 4'h8 ? flash_readdata : 32'h0) |
                      (chipselect == 4'ha ? vga_readdata : 32'h0);
assign cpu_ack = (chipselect == 4'h1 ? vect_ack[1] : 1'h0) |
                 (chipselect == 4'h2 ? rom_ack[1] : 1'h0) |
                 (chipselect == 4'h3 ? mandelbrot_ack : 1'h0) |
                 (chipselect == 4'h4 ? io_ack : 1'h0) |
                 (chipselect == 4'h5 ? matrix_ack : 1'h0) |
                 (chipselect == 4'h6 ? ssram_ack & cpu_gnt : 1'h0) |
                 (chipselect == 4'h7 ? sdram_ack : 1'h0) |
                 (chipselect == 4'h8 ? ~flash_wait : 1'h0) |
                 (chipselect == 4'ha ? vga_slave_ack : 1'h0);

assign rom_read = (chipselect == 4'h2 && cpu_cyc && ~cpu_write);
assign vect_read = (chipselect == 4'h1 && cpu_cyc && ~cpu_write);

bexkat2 bexkat0(.clk_i(sysclock), .rst_i(rst_i), .adr_o(cpu_address), .cyc_o(cpu_cyc), .dat_i(cpu_readdata),
  .we_o(cpu_write), .dat_o(cpu_writedata), .sel_o(cpu_be), .ack_i(cpu_ack), .halt(cpu_halt),
  .interrupt(cpu_interrupt), .exception(exception), .int_en(int_en));

mmu mmu0(.adr_i(cpu_address), .cyc_i(cpu_cyc), .chipselect(chipselect), .fault(mmu_fault), .cache_enable(cache_enable));

sdram_controller_cache sdram0(.clk_i(sysclock), .mem_clk_o(sdram_clk), .rst_i(rst_i), .adr_i(cpu_address[26:2]),
  .dat_i(cpu_writedata), .dat_o(sdram_readdata), .stb_i(chipselect == 4'h7), .cyc_i(cpu_cyc),
  .ack_o(sdram_ack), .sel_i(cpu_be), .we_i(cpu_write), .cache_status(cache_hitmiss),
  .we_n(sdram_we_n), .cs_n(sdram_cs_n), .cke(sdram_cke), .cas_n(sdram_cas_n), .ras_n(sdram_ras_n), .dqm(sdram_dqm), .ba(sdram_ba),
  .addrbus_out(sdram_addrbus), .databus_in(sdram_databus), .databus_out(sdram_dataout), .cache_en(SW[17]));
led_matrix rgbmatrix0(.clk_i(sysclock), .rst_i(rst_i), .dat_i(cpu_writedata), .dat_o(matrix_readdata),
  .adr_i(cpu_address[11:2]), .sel_i(cpu_be), .we_i(cpu_write), .stb_i(chipselect == 4'h5), .cyc_i(cpu_cyc), .ack_o(matrix_ack),
  .demux({matrix_a, matrix_b, matrix_c}), .matrix0(matrix0), .matrix1(matrix1), .matrix_stb(matrix_stb), .matrix_clk(matrix_clk), .oe_n(matrix_oe_n));
iocontroller io0(.clk_i(sysclock), .rst_i(rst_i), .dat_i(cpu_writedata), .dat_o(io_readdata), .we_i(cpu_write), .adr_i(cpu_address[16:0]),
  .stb_i(chipselect == 4'h4), .cyc_i(cpu_cyc), .ack_o(io_ack), .sel_i(cpu_be),
  .miso(miso), .mosi(mosi), .sclk(sclk), .spi_selects(spi_selects), .sd_wp(sd_wp_n), .fan(fan_ctrl),
  .lcd_e(lcd_e), .lcd_data(lcd_dataout), .lcd_rs(lcd_rs), .lcd_on(lcd_on), .lcd_rw(lcd_rw), .interrupts(io_interrupts),
  .rx0(serial0_rx), .tx0(serial0_tx), .rts0(serial0_rts), .cts0(serial0_cts), .tx1(serial1_tx), .sw(SW[15:0]),
  .ps2mouse({ps2mouse_clk, ps2mouse_data}), .ps2kbd({ps2kbd_clk, ps2kbd_data}), .codec_irq(codec_irq),
  .hex0(HEX0), .hex1(HEX1), .hex2(HEX2), .hex3(HEX3), .hex4(HEX4), .hex5(HEX5), .hex6(HEX6), .hex7(HEX7));
//mandunit mand0(.clk_i(sysclock), .rst_i(rst_i), .dat_i(cpu_writedata), .dat_o(mandelbrot_readdata), .cyc_i(cpu_cyc),
//  .adr_i(cpu_address[18:0]), .we_i(cpu_write), , .stb_i(chipselect == 4'h3), .sel_i(cpu_be), .ack_o(mandelbrot_ack));
monitor rom0(.clock(sysclock), .q(rom_readdata), .rden(rom_read), .address(cpu_address[16:2]));
testrom rom1(.clock(sysclock), .q(rom2_readdata), .rden(rom_read), .address(cpu_address[16:2]));

vectors vecram0(.clock(sysclock), .q(vect_readdata), .rden(vect_read), .address(cpu_address[6:2]));

wire [31:0] fs_adr;
wire [3:0] fs_sel;
wire fs_we;
wire ssram_stb;

assign fs_adr = (cpu_gnt ? cpu_address : vga_address);
assign fs_sel = (cpu_gnt ? cpu_be : vga_sel);
assign fs_we = (cpu_gnt ? cpu_write : vga_we);
assign ssram_stb = cpu_gnt | vga_gnt;

arbiter arb0(.clk_i(sysclock), .rst_i(rst_i), .cpu_cyc_i(chipselect == 4'h6), 
  .vga_cyc_i(vga_cyc), .cyc_o(arb_cyc), .cpu_gnt(cpu_gnt), .vga_gnt(vga_gnt), .ack_i(ssram_ack));

vga_master vga0(.clk_i(sysclock), .rst_i(rst_i), .master_adr_o(vga_address), .master_cyc_o(vga_cyc), .master_dat_i(ssram_readdata),
  .master_we_o(vga_we), .master_dat_o(vga_writedata), .master_sel_o(vga_sel), .master_ack_i(vga_gnt & ssram_ack), .master_stb_o(vga_stb),
  .slave_adr_i(cpu_address[11:2]), .slave_dat_i(cpu_writedata), .slave_sel_i(cpu_be), .slave_cyc_i(cpu_cyc), .slave_we_i(cpu_write),
  .slave_stb_i(chipselect == 4'ha), .slave_ack_o(vga_slave_ack), .slave_dat_o(vga_readdata),
  .vs(vga_vs), .hs(vga_hs), .r(vga_r), .g(vga_g), .b(vga_b), .blank_n(vga_blank_n), .vga_clock(vga_clock), .sync_n(vga_sync_n));

ssram_controller ssram0(.clk_i(sysclock), .rst_i(rst_i), 
  .stb_i(ssram_stb), .cyc_i(arb_cyc), .we_i(fs_we), 
  .ack_o(ssram_ack), .dat_i(cpu_writedata), .dat_o(ssram_readdata),
  .sel_i(fs_sel), .adr_i(fs_adr[21:0]),
  .databus_in(fs_databus), .databus_out(ssram_dataout),
  .address_out(ssram_addrout), .bus_clock(ssram_clk), .gw_n(ssram_gw_n), .adv_n(ssram_adv_n), .adsp_n(ssram_adsp_n),
  .adsc_n(ssram_adsc_n), .be_out(ssram_be), .oe_n(ssram_oe_n), .we_n(ssram_we_n), .ce0_n(ssram0_ce_n), .ce1_n(ssram1_ce_n));

flash_controller flash0(.clock(sysclock), .reset_n(~rst_i), .databus_in(fs_databus[15:0]), .databus_out(flash_dataout),
  .read(1'b0), .write(1'b0), .wait_out(flash_wait), .data_in(cpu_writedata), .data_out(flash_readdata),
  .be_in(cpu_be), .address_in(fs_adr[26:0]), .address_out(flash_addrout),
  .ready(fl_ry), .wp_n(fl_wp_n), .oe_n(fl_oe_n), .we_n(fl_we_n), .ce_n(fl_ce_n));

endmodule
