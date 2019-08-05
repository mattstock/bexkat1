`include "../../fpgalib/wb.vh"

`define SDRAM
`define VGA_GRAPHICS
`define VGA

`ifdef VGA_GRAPHICS
 `define VGA
`endif

module de10s(input         CLOCK_50,
	     input 	   CLOCK2_50,
	     input 	   CLOCK3_50,
	     input 	   CLOCK4_50,
	     input [9:0]   SW,
	     input [3:0]   KEY,
	     output [6:0]  HEX0,
	     output [6:0]  HEX1,
	     output [6:0]  HEX2,
	     output [6:0]  HEX3,
	     output [6:0]  HEX4,
	     output [6:0]  HEX5,
	     output [12:0] DRAM_ADDR,
	     inout [15:0]  DRAM_DQ,
	     output [1:0]  DRAM_BA,
	     output 	   DRAM_LDQM,
	     output 	   DRAM_UDQM,
	     output 	   DRAM_RAS_N,
	     output 	   DRAM_CAS_N,
	     output 	   DRAM_CKE,
	     output 	   DRAM_CLK,
	     output 	   DRAM_WE_N,
	     output 	   DRAM_CS_N,
	     output 	   VGA_HS,
	     output 	   VGA_VS,
	     output 	   VGA_BLANK_N,
	     output 	   VGA_SYNC_N,
	     output 	   VGA_CLK,
	     output [7:0]  VGA_R,
	     output [7:0]  VGA_G,
	     output [7:0]  VGA_B,
	     input 	   PS2_CLK,
	     input 	   PS2_DAT,
	     input 	   PS2_CLK2,
	     input 	   PS2_DAT2,
	     output [9:0]  LEDR);
 
  // System signals
  logic 		  clk_i, locked, rst_i;

  if_wb cpu_ibus(), cpu_dbus();
  if_wb ram0_ibus(), ram0_dbus();
  if_wb ram1_ibus(), ram1_dbus();
  if_wb io_dbus(), io_seg(), io_uart(), io_timer();
  if_wb io_matrix(), io_spi();
`ifdef SDRAM
  if_wb stats_dbus();
`endif
`ifdef VGA
  if_wb vga_dbus(), vga_fb0(), vga_fb1();
`endif

  assign rst_i = ~locked;

  parameter clkfreq = 10000000;
  syspll pll0(.refclk(CLOCK_50),
	      .rst(~KEY[0]), 
	      .locked(locked),
	      .outclk_0(clk_i),
	      .outclk_1(led_clk));

  bexkat2 cpu0(.clk_i(clk_i),
		.rst_i(rst_i),
		.ins_bus(cpu_ibus.master),
		.dat_bus(cpu_dbus.master),
		.halt(cpu_halt),
		.int_en(cpu_inter_en),
		.inter(cpu_exception));

  assign LEDR[0] = clk_i;
  assign LEDR[1] = led_clk;

endmodule // de10s
