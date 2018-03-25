`include "../../fpgalib/wb.vh"

module wbmem
  (input       clk_i,
   input       rst_i,
   if_wb.slave bus);

  logic [1:0]  delay;
  logic [31:0] dat_i, dat_o;
  
`ifdef NO_MODPORT_EXPRESSIONS
  assign dat_i = bus.dat_s;
  assign bus.dat_m = dat_o;
`else
  assign dat_i = bus.dat_i;
  assign bus.dat_o = dat_o;
`endif

  assign bus.ack = delay[1];
  assign bus.stall = 1'b0;

  always_ff @(posedge clk_i or posedge rst_i)
    if (rst_i)
      delay <= 2'h0;
    else
      delay <= { delay[0], bus.stb };

  mram1 ram0(.clock(clk_i),
	     .data(dat_i),
	     .address(bus.adr[15:2]),
	     .wren(bus.we),
	     .q(dat_o),
	     .byteena(bus.sel));

endmodule
