`include "../../fpgalib/wb.vh"

`define SDRAM
`define VGA_GRAPHICS
`define VGA

`ifdef VGA_GRAPHICS
 `define VGA
`endif

module de10s(input        CLOCK_50,
	     input 	  CLOCK2_50,
	     input 	  CLOCK3_50,
	     input 	  CLOCK4_50,
	     input [9:0]  SW,
	     input [3:0]  KEY,
	     output [9:0] LED);

  logic [30:0] 		  tick;

  always_ff @(posedge CLOCK_50)
    begin
      tick <= tick + 1;
    end

  assign LED = tick[30:21];
  
endmodule // de10s
