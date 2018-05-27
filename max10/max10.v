`include "../../fpgalib/wb.vh"

module max10(input [1:0]   raw_clock_50,
	     input 	   ddr3_clk_50,
	     input 	   adc_clk_10,
	     input [1:0]   sw,
	     input [1:0]   key,
	     output [7:0]  ledr,
	     output [14:0] ddr3_a,
	     inout [15:0]  ddr3_dq,
	     output [2:0]  ddr3_ba,
	     output [1:0]  ddr3_dm,
	     output 	   ddr3_ras_n,
	     output 	   ddr3_cas_n,
	     output 	   ddr3_cke,
	     output 	   ddr3_clk,
	     output [1:0]  ddr3_dqs,
	     output 	   ddr3_reset_n,
	     output 	   ddr3_odt,
	     output 	   ddr3_we_n,
	     output 	   ddr3_cs_n,
	     inout [43:0]  gpio0,
	     inout [22:0]  gpio1);
  
  // System signals
  logic 		   clk_i, locked, rst_i;
  logic			   cpu_halt, bus0_error;
  logic [1:0] 		   serial0_interrupts;
  logic [3:0] 		   timer_interrupts;
  logic 		   cpu_inter_en;
  logic [3:0] 		   cpu_exception;
  logic 		   serial0_rx, serial0_tx, serial0_rts, serial0_cts;

  if_wb cpu_ibus(), cpu_dbus();
  if_wb ram0_ibus(), ram0_dbus();
  if_wb ram1_ibus(), ram1_dbus();
  if_wb io_dbus(), io_seg(), io_uart(), io_timer();
  
  assign gpio0[0] = serial0_tx;
  assign gpio0[1] = 1'bz;
  assign gpio0[2] = serial0_cts;
  assign gpio0[43:3] = 40'bz;
  assign gpio1[22:0] = 23'bz;
  
  assign serial0_rx = gpio0[1];
  assign serial0_rts = gpio0[3];
  assign ledr[7] = ~cpu_ibus.cyc;
  assign ledr[6] = ~cpu_ibus.stb;
  assign ledr[5] = ~cpu_ibus.ack;
  assign ledr[4] = ~cpu_dbus.cyc;
  assign ledr[3] = ~cpu_dbus.stb;
  assign ledr[2] = ~cpu_dbus.ack;
  assign ledr[1] = ~cpu_inter_en;
  assign ledr[0] = ~cpu_halt;
  
  assign rst_i = ~locked;
  
  parameter clkfreq = 10000000;
  syspll pll0(.inclk0(raw_clock_50[0]),
	      .areset(~key[0]), 
	      .locked(locked),
	      .c0(clk_i));

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
	       .p7(ram1_dbus.master));
  
  wb16k ram0(.clk_i(clk_i),
	     .rst_i(rst_i),
	     .bus0(ram0_ibus.slave),
	     .bus1(ram0_dbus.slave));

  wb4k ram1(.clk_i(clk_i),
	    .rst_i(rst_i),
	    .wren(1'b0),
	    .bus0(ram1_ibus.slave),
	    .bus1(ram1_dbus.slave));

  mmu #(.BASE(12)) mmu_bus2(.clk_i(clk_i),
			    .rst_i(rst_i),
			    .mbus(io_dbus.slave),
			    .p0(io_seg.master),
			    .p2(io_uart.master),
			    .p8(io_timer.master));
  
  segctrl #(.SEG(8)) io_seg0(.clk_i(clk_i),
			     .rst_i(rst_i),
			     .bus(io_seg.slave),
			     .sw(sw),
			     .out0(hex0),
			     .out1(hex1),
			     .out2(hex2),
			     .out3(hex3),
			     .out4(hex4),
			     .out5(hex5));

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

endmodule
