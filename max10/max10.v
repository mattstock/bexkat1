`include "../../fpgalib/wb.vh"

module max10(input [1:0]   raw_clock_50,
	     input [9:0]   sw,
	     input [1:0]   key,
	     output [9:0]  ledr,
	     output [7:0]  hex0,
	     output [7:0]  hex1,
	     output [7:0]  hex2,
	     output [7:0]  hex3,
	     output [7:0]  hex4,
	     output [7:0]  hex5,
	     output [12:0] sdram_addrbus,
	     inout [15:0]  sdram_databus,
	     output [1:0]  sdram_ba,
	     output [1:0]  sdram_dqm,
	     output 	   sdram_ras_n,
	     output 	   sdram_cas_n,
	     output 	   sdram_cke,
	     output 	   sdram_clk,
	     output 	   sdram_we_n,
	     output 	   sdram_cs_n,
	     input 	   sd_miso,
	     output 	   sd_mosi,
	     output 	   sd_ss,
	     output 	   sd_sclk,
	     output 	   rtc_ss,
	     output 	   eth_ss,
	     output 	   codec_pbdat,
	     input 	   codec_reclrc,
	     input 	   codec_pblrc,
	     input 	   codec_recdat,
	     inout 	   codec_sdin,
	     inout 	   codec_sclk,
	     input 	   codec_bclk,
	     output 	   codec_mclk,
	     input 	   rtc_miso,
	     output 	   rtc_mosi,
	     output 	   rtc_sclk,
	     output [2:0]  matrix0,
	     output [2:0]  matrix1,
	     output 	   matrix_clk,
	     output 	   matrix_oe_n,
	     output 	   matrix_a, 
	     output 	   matrix_b,
	     output 	   matrix_c,
	     output 	   matrix_stb,
	     output 	   serial1_tx,
	     input 	   serial1_rx,
	     input 	   serial0_rx,
	     input 	   serial0_cts,
	     output 	   serial0_tx,
	     output 	   serial0_rts,
	     output 	   vga_hs,
	     output 	   vga_vs,
	     output 	   reset_n,
	     input 	   ard_reset_n,
	     output [3:0]  vga_r,
	     output [3:0]  vga_g,
	     output [3:0]  vga_b,
	     input 	   ps2kbd_clk,
	     input 	   ps2kbd_data);

  // System signals
  wire 			   clk_i, locked, rst_i;
  wire 			   vga_clock, cpu_halt;

  if_wb cpu_ibus(), cpu_dbus();
  if_wb ram0_ibus(), ram0_dbus();
  if_wb ram1_ibus(), ram1_dbus();
  if_wb io_dbus(), io_seg(), io_uart();
  
  assign ledr[9] = cpu_ibus.cyc;
  assign ledr[8] = cpu_ibus.ack;
  assign ledr[7] = cpu_dbus.cyc;
  assign ledr[6] = cpu_dbus.ack;
  assign ledr[0] = sw[0];
  
  assign reset_n = 1'h1;
  assign rst_i = ~locked;
  
  parameter clkfreq = 1000000;
  syspll pll0(.inclk0(raw_clock_50[0]),
	      .areset(~ard_reset_n), 
	      .locked(locked),
	      .c0(clk_i), 
	      .c1(vga_clock));

  bexkat1p cpu0(.clk_i(clk_i),
		.rst_i(rst_i),
		.ins_bus(cpu_ibus.master),
		.dat_bus(cpu_dbus.master),
		.halt(cpu_halt),
		.inter(3'h0));

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
	       .p7(ram1_dbus.master));
  
  wb16k ram0(.clk_i(clk_i),
	     .rst_i(rst_i),
	     .bus0(ram0_ibus.slave),
	     .bus1(ram0_dbus.slave));

  wb4k ram1(.clk_i(clk_i),
	    .rst_i(rst_i),
	    .wren(sw[0]),
	    .bus0(ram1_ibus.slave),
	    .bus1(ram1_dbus.slave));

  mmu #(.BASE(12)) mmu_bus2(.clk_i(clk_i),
			    .rst_i(rst_i),
			    .mbus(io_dbus.slave),
			    .p0(io_seg.master),
			    .p2(io_uart.master));
  
  segctrl #(.SEG(8)) io_seg0(.clk_i(clk_i),
			     .rst_i(rst_i),
			     .bus(io_seg.slave),
			     .out0(hex0),
			     .out1(hex1),
			     .out2(hex2),
			     .out3(hex3),
			     .out4(hex4),
			     .out5(hex5));
  
endmodule
