`include "../../fpgalib/wb.vh"

module wb32k
  (input       clk_i,
   input       rst_i,
   input       wren,
   if_wb.slave bus0,
   if_wb.slave bus1);

  logic [1:0]  delay0, delay1;
  logic [31:0] dat0_i, dat1_i, dat0_o, dat1_o;

`ifdef NO_MODPORT_EXPRESSIONS
  assign dat0_i = bus0.dat_s;
  assign bus0.dat_m = dat0_o;
  assign dat1_i = bus1.dat_s;
  assign bus1.dat_m = dat1_o;
`else
  assign dat0_i = bus0.dat_i;
  assign bus0.dat_o = dat0_o;
  assign dat1_i = bus1.dat_i;
  assign bus1.dat_o = dat1_o;
`endif  

  assign bus0.ack = delay0[1];
  assign bus0.stall = 1'b0;
  assign bus1.ack = delay1[1];
  assign bus1.stall = 1'b0;

  always_ff @(posedge clk_i or posedge rst_i)
    if (rst_i)
      begin
	delay0 <= 2'h0;
	delay1 <= 2'h0;
      end
    else
      begin
	if (bus0.cyc)
	  delay0 <= { delay0[0], bus0.cyc & bus0.stb };
	else
	  delay0 <= 2'h0;
	if (bus1.cyc)
	  delay1 <= { delay1[0], bus1.cyc & bus1.stb };
	else
	  delay1 <= 2'h0;
      end

  mram32k ram0(.clock(clk_i),
	       .data_a(dat0_i),
	       .address_a(bus0.adr[14:2]),
	       .wren_a(bus0.cyc & bus0.stb & bus0.we),
	       .q_a(dat0_o),
	       .byteena_a(bus0.sel),
	       .data_b(dat1_i),
	       .address_b(bus1.adr[14:2]),
	       .wren_b((wren ? bus1.cyc & bus1.stb & bus1.we : 1'b0)),
	       .q_b(dat1_o),
	       .byteena_b(bus1.sel));

endmodule
