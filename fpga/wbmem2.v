`include "../../fpgalib/wb.vh"

module wbmem2
  (input       clk_i,
   input       rst_i,
   if_wb.slave bus0,
   if_wb.slave bus1);

  logic [1:0]  delay0, delay1;
  

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
	delay0 <= { delay0[0], bus0.stb };
	delay1 <= { delay1[0], bus1.stb };
      end

  mram ram0(.clock(clk_i),
	    .data_a(bus0.dat_m),
	    .address_a(bus0.adr[15:2]),
	    .wren_a(bus0.we),
	    .q_a(bus0.dat_s),
	    .byteena_a(bus0.sel),
	    .data_b(bus1.dat_m),
	    .address_b(bus1.adr[15:2]),
	    .wren_b(bus1.we),
	    .q_b(bus1.dat_s),
	    .byteena_b(bus1.sel));

endmodule
