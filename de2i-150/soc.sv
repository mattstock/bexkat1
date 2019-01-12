`include "../../fpgalib/wb.vh"

`define SDRAM

module soc(input 	 raw_clock_50,
	   input [17:0]  SW,
	   input [3:0] 	 KEY,
	   output [8:0]  LEDG,
	   output [17:0] LEDR,
	   output [6:0]  HEX0,
	   output [6:0]  HEX1,
	   output [6:0]  HEX2,
	   output [6:0]  HEX3,
	   output [6:0]  HEX4,
	   output [6:0]  HEX5,
	   output [6:0]  HEX6,
	   output [6:0]  HEX7,
	   output [12:0] sdram_addrbus,
	   inout [31:0]  sdram_databus,
	   output [1:0]  sdram_ba,
	   output [3:0]  sdram_dqm,
	   output 	 sdram_ras_n,
	   output 	 sdram_cas_n,
	   output 	 sdram_cke,
	   output 	 sdram_clk,
	   output 	 sdram_we_n,
	   output 	 sdram_cs_n,
	   output 	 lcd_e,
	   output 	 lcd_rs,
	   output 	 lcd_on,
	   output 	 lcd_rw,
	   inout [7:0] 	 lcd_data,
	   input 	 sd_miso,
	   output 	 sd_mosi,
	   output 	 sd_ss,
	   output 	 sd_sclk,
	   input 	 ext_miso,
	   output 	 ext_mosi,
	   output 	 ext_sclk,
	   output 	 rtc_ss,
	   output 	 led_ss,
	   input 	 sd_wp_n,
	   output 	 fan_pwm, 
	   output [2:0]  matrix0,
	   output [2:0]  matrix1,
	   output 	 matrix_clk,
	   output 	 matrix_oe_n,
	   output 	 matrix_a, 
	   output 	 matrix_b,
	   output 	 matrix_c,
	   output 	 matrix_stb,
	   output 	 serial1_tx,
	   input 	 serial1_rx,
	   output 	 serial2_tx,
	   input 	 serial2_rx,
	   input 	 serial2_cts,
	   output 	 serial2_rts,
	   input 	 serial0_rx,
	   input 	 serial0_cts,
	   output 	 serial0_tx,
	   output 	 serial0_rts,
	   output 	 vga_hs,
	   output 	 vga_vs,
	   output 	 vga_blank_n,
	   output 	 vga_sync_n,
	   output 	 vga_clock,
	   output [7:0]  vga_r,
	   output [7:0]  vga_g,
	   output [7:0]  vga_b,
	   input 	 ps2kbd_clk,
	   input 	 ps2kbd_data,
	   output 	 reset_n);

  // System signals
  logic 		      clk_i, locked, rst_i;
  logic 		      led_clk;
  logic 		      cpu_halt, bus0_error;
  logic [1:0] 		      serial0_interrupts;
  logic [3:0] 		      timer_interrupts;
  logic 		      cpu_inter_en;
  logic [3:0] 		      cpu_exception;
  logic [31:0] 		      sdram_dataout;
  logic 		      sdram_dir;
  logic [1:0] 		      cache_status;
  logic [3:0] 		      spi_selects;
  logic 		      miso, mosi, sclk;
  
  if_wb cpu_ibus(), cpu_dbus();
  if_wb ram0_ibus(), ram0_dbus();
  if_wb ram1_ibus(), ram1_dbus();
`ifdef SDRAM
  if_wb stats_dbus();
`endif
  if_wb vga_dbus(), vga_fb();
  if_wb io_dbus(), io_seg(), io_uart(), io_timer();
  if_wb io_matrix(), io_spi();

  assign sdram_databus = (sdram_dir ? sdram_dataout :  16'hzzzz);

  assign LEDG[8] = 1'h0;
  assign LEDG[7:6] = cache_status;
  assign LEDG[5:2] = cpu_exception;
  assign LEDG[1] = cpu_inter_en;
  assign LEDG[0] = cpu_halt;
  assign LEDR[17:15] = { cpu_ibus.cyc, cpu_ibus.stb, cpu_ibus.ack };
  assign LEDR[14:12] = { cpu_dbus.cyc, cpu_dbus.stb, cpu_dbus.ack };
  assign LEDR[11:9] = { io_dbus.cyc, io_dbus.stb, io_dbus.ack };
  assign LEDR[8:6] = { ram0_dbus.cyc, ram0_dbus.stb, ram0_dbus.ack };
  assign LEDR[5] = 1'h0;
  assign LEDR[4:0] = { miso, mosi, sclk, ~spi_selects[1], ~spi_selects[0] };
  
  assign rst_i = ~locked;

  assign rtc_ss = spi_selects[1];
  assign sd_ss = spi_selects[0];
  assign sd_mosi = mosi;
  assign ext_mosi = mosi;
  assign sd_sclk = sclk;
  assign ext_sclk = sclk;
  assign miso = (~spi_selects[0] ? sd_miso : ext_miso);

  // need 25MHz
  assign vga_clock = led_clk;
  
  parameter clkfreq = 10000000;
  syspll pll0(.inclk0(raw_clock_50),
	      .areset(~KEY[0]), 
	      .locked(locked),
	      .c0(clk_i),
	      .c1(led_clk));

  bexkat2 cpu0(.clk_i(clk_i),
		.rst_i(rst_i),
		.ins_bus(cpu_ibus.master),
		.dat_bus(cpu_dbus.master),
		.halt(cpu_halt),
		.int_en(cpu_inter_en),
		.inter(cpu_exception));

  assign bus0_error = (cpu_ibus.cyc & cpu_ibus.stb & !ram1_ibus.stb);

  interrupt_encoder intenc0(.clk_i(clk_i),
			    .rst_i(rst_i),
			    .mmu(bus0_error),
			    .timer_in(timer_interrupts),
			    .serial0_in(serial0_interrupts),
			    .enabled(cpu_inter_en),
			    .cpu_exception(cpu_exception));
  
  mmu mmu_bus0(.clk_i(clk_i),
	       .rst_i(rst_i),
	       .mbus(cpu_ibus.slave),
	       .p0(ram0_ibus.master),
	       .p7(ram1_ibus.master));
  
  mmu mmu_bus1(.clk_i(clk_i),
	       .rst_i(rst_i),
	       .mbus(cpu_dbus.slave),
	       .p0(ram0_dbus.master),
	       .p3(io_dbus.master),
`ifdef SDRAM
	       .p5(stats_dbus.master),
`endif
	       .p7(ram1_dbus.master),
	       .p8(vga_dbus.master));
  
  wb16k
    #(.INIT_FILE("../monitor/de2rom.mif"))
  ram1(.clk_i(clk_i),
       .rst_i(rst_i),
       .wren(1'b0),
       .bus0(ram1_ibus.slave),
       .bus1(ram1_dbus.slave));

`ifdef SDRAM  
  sdram32_controller_cache sdc0(.clk_i(clk_i),
				.rst_i(rst_i),
				.bus0(ram0_ibus.slave),
				.bus1(ram0_dbus.slave),
				.stats_bus(stats_dbus.slave),
				.mem_clk_o(sdram_clk),
				.we_n(sdram_we_n),
				.cs_n(sdram_cs_n),
				.cke(sdram_cke),
				.cas_n(sdram_cas_n),
				.ras_n(sdram_ras_n),
				.dqm(sdram_dqm),
				.ba(sdram_ba),
				.cache_status(cache_status),
				.addrbus_out(sdram_addrbus),
				.databus_dir(sdram_dir),
				.databus_in(sdram_databus),
				.databus_out(sdram_dataout));
`else
  wb16k ram0(.clk_i(clk_i),
	     .rst_i(rst_i),
	     .wren(1'b1),
	     .bus0(ram0_ibus.slave),
	     .bus1(ram0_dbus.slave));
  assign sdram_dataout = 32'h0;
  assign sdram_addrbus = 'h0;
  assign sdram_ras_n = 1'h1;
  assign sdram_cas_n = 1'h1;
  assign sdram_cs_n = 1'h1;
  assign sdram_we_n = 1'h1;
  assign sdram_dqm = 4'h0;
  assign sdram_clk = 1'h0;
  assign cache_status = 2'h0;
`endif
  
  
  mmu #(.BASE(12)) mmu_bus2(.clk_i(clk_i),
			    .rst_i(rst_i),
			    .mbus(io_dbus.slave),
			    .p0(io_seg.master),
			    .p2(io_uart.master),
			    .p7(io_spi.master),
			    .p8(io_timer.master),
			    .pc(io_matrix.master));
  
  segctrl io_seg0(.clk_i(clk_i),
		  .rst_i(rst_i),
		  .bus(io_seg.slave),
		  .sw(SW),
		  .out0(HEX0),
		  .out1(HEX1),
		  .out2(HEX2),
		  .out3(HEX3),
		  .out4(HEX4),
		  .out5(HEX5),
		  .out6(HEX6),
		  .out7(HEX7));

  uart #(.CLKFREQ(clkfreq),
	 .BAUD(115200)) uart0(.clk_i(clk_i),
			      .rst_i(rst_i),
			      .bus(io_uart.slave),
			      .tx(serial0_tx),
			      .rx(serial0_rx),
			      .cts(serial0_cts),
			      .rts(serial0_rts),
			      .interrupt(serial0_interrupts));

  timerint timerint0(.clk_i(clk_i),
		     .rst_i(rst_i),
		     .bus(io_timer.slave),
		     .interrupt(timer_interrupts));

  fan_ctrl fan0(.clk(clk_i), .reset(rst_i),
		.avs_write(1'b0),
		.coe_fan_pwm(fan_pwm));

  led_matrix mx0(.clk_i(clk_i),
		 .rst_i(rst_i),
		 .bus(io_matrix.slave),
		 .led_clk(led_clk),
		 .matrix0(matrix0),
		 .matrix1(matrix1),
		 .matrix_clk(matrix_clk),
		 .matrix_stb(matrix_stb),
		 .matrix_oe_n(matrix_oe_n),
		 .demux({matrix_a, matrix_b, matrix_c}));

  spi_master #(.CLKFREQ(clkfreq)) spi0(.clk_i(clk_i),
				       .rst_i(rst_i),
				       .bus(io_spi.slave),
				       .miso(miso),
				       .mosi(mosi),
				       .sclk(sclk),
				       .selects(spi_selects),
				       .wp(sd_wp_n));

  dualram vgamem0(.clk_i(clk_i),
		  .rst_i(rst_i),
		  .bus1(vga_fb.slave));
  
  vga_master vga0(.clk_i(clk_i),
		  .rst_i(rst_i),
		  .inbus(vga_dbus.slave),
		  .outbus(vga_fb.master),
		  .vs(vga_vs),
		  .hs(vga_hs),
		  .r(vga_r),
		  .g(vga_g),
		  .b(vga_b),
		  .blank_n(vga_blank_n),
		  .sync_n(vga_sync_n),
		  .vga_clock(vga_clock));
  
endmodule
