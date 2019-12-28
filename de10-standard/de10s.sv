`include "../../fpgalib/wb.vh"

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
	     output [2:0]  matrix0,
	     output [2:0]  matrix1,
	     output 	   matrix_clk,
	     output 	   matrix_oe_n,
	     output 	   matrix_a, 
	     output 	   matrix_b,
	     output 	   matrix_c,
	     output 	   matrix_stb,
	     input 	   serial0_rx,
	     output 	   serial0_tx,
	     input 	   serial0_cts,
	     output 	   serial0_rts,
	     output [9:0]  LEDR);
 
  // System signals
  logic 		   clk_i, locked, rst_i;
  logic 		   led_clk;
  logic 		   cpu_halt, bus0_error;
  logic [1:0] 		   serial0_interrupts;
  logic [3:0] 		   timer_interrupts;
  logic 		   cpu_inter_en;
  logic [3:0] 		   cpu_exception;
  logic [3:0] 		   spi_selects;
  logic 		   miso, mosi, sclk;
  logic [15:0] 		   sdram_dataout;
  logic 		   sdram_dir;
  logic [1:0] 		   cache_status;
  
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
  
  assign DRAM_DQ = (sdram_dir ? sdram_dataout :  16'hzzzz);

  assign LEDR = { cpu_ibus.cyc, cpu_ibus.stb, cpu_ibus.ack,
		  cpu_dbus.cyc, cpu_dbus.stb, cpu_dbus.ack,
		  io_dbus.cyc, io_dbus.stb, io_dbus.ack,
		  cpu_halt };
  
  assign rst_i = ~locked;

`ifdef VGA
  logic 		   vga_clock28, vga_clock25;

  vgaclock vgapll(.refclk(CLOCK_50),
		  .rst(~KEY[0]),
		  .outclk_0(vga_clock28),
		  .outclk_1(vga_clock25));
`endif
 
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
`ifdef VGA	       
	       .p8(vga_dbus.master),
	       .pc(vga_fb0.master),
`endif
	       .p7(ram1_dbus.master));
  
  
  dualram #(.AWIDTH(14),
	    .INIT_FILE("../monitor/max10rom.mif")) ram1(.clk_i(clk_i),
							.rst_i(rst_i),
							.wren(1'b0),
							.bus0(ram1_ibus.slave),
							.bus1(ram1_dbus.slave));

`ifdef SDRAM
  sdram16_controller_cache sdc0(.clk_i(clk_i),
				.rst_i(rst_i),
				.bus0(ram0_ibus.slave),
				.bus1(ram0_dbus.slave),
				.stats_bus(stats_dbus.slave),
				.mem_clk_o(DRAM_CLK),
				.we_n(DRAM_WE_N),
				.cs_n(DRAM_CS_N),
				.cke(DRAM_CKE),
				.cas_n(DRAM_CAS_N),
				.ras_n(DRAM_RAS_N),
				.dqm({ DRAM_UDQM, DRAM_LDQM }),
				.ba(DRAM_BA),
				.cache_status(cache_status),
				.addrbus_out(DRAM_ADDR),
				.databus_dir(sdram_dir),
				.databus_in(DRAM_DQ),
				.databus_out(sdram_dataout));
`else
  dualram #(.AWIDTH(14)) ram0(.clk_i(clk_i),
			      .rst_i(rst_i),
			      .wren(1'b1),
			      .bus0(ram0_ibus.slave),
			      .bus1(ram0_dbus.slave));
  assign DRAM_ADDR = 'h0;
  assign DRAM_RAS_N = 1'h1;
  assign DRAM_CAS_N = 1'h1;
  assign DRAM_CS_N = 1'h1;
  assign DRAM_WE_N = 1'h1;
  assign DRAM_LDQM = 1'h0;
  assign DRAM_UDQM = 1'h0;
  assign DRAM_CLK = 1'h0;
  assign DRAM_BA = 2'h0;
  assign DRAM_CKE = 1'h0;
  assign sdram_dataout = 16'h0;
  assign sdram_dir = 1'h0;
  
`endif
    
  mmu #(.BASE(12)) mmu_bus2(.clk_i(clk_i),
			    .rst_i(rst_i),
			    .mbus(io_dbus.slave),
			    .p0(io_seg.master),
			    .p2(io_uart.master),
			    .p7(io_spi.master),
			    .p8(io_timer.master),
			    .pc(io_matrix.master));
  
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

  segctrl io_seg0(.clk_i(clk_i),
		  .rst_i(rst_i),
		  .bus(io_seg.slave),
		  .sw(SW),
		  .out0(HEX0),
		  .out1(HEX1),
		  .out2(HEX2),
		  .out3(HEX3),
		  .out4(HEX4),
		  .out5(HEX5));

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

`ifdef VGA

  dualram2clock 
    #(.AWIDTH(16)) vgamem0(.clk0(clk_i),
			   .clk1(VGA_CLK),
			   .rst_i(rst_i),
			   .wren(1'b1),
			   .bus0(vga_fb0.slave),
			   .bus1(vga_fb1.slave));

  vga_master vga0(.clk_i(clk_i),
		  .rst_i(rst_i),
		  .vga_clock25(vga_clock25),
		  .vga_clock28(vga_clock28),
		  .inbus(vga_dbus.slave),
		  .outbus(vga_fb1.master),
		  .vs(VGA_VS),
		  .hs(VGA_HS),
		  .r(VGA_R),
		  .g(VGA_G),
		  .b(VGA_B),
		  .blank_n(VGA_BLANK_N),
		  .sync_n(VGA_SYNC_N),
		  .vga_clock(VGA_CLK));
  
`else // !`ifdef VGA
  
  assign VGA_R = 8'h0;
  assign VGA_G = 8'h0;
  assign VGA_B = 8'h0;
  assign VGA_HS = 1'h1;
  assign VGA_VS = 1'h1;
  assign VGA_BLANK_N = 1'h0;
  assign VGA_SYNC_N = 1'h0;

`endif //  `ifdef VGA

endmodule // de10s
