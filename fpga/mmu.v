`include "../../fpgalib/bexkat1/bexkat1.vh"

module mmu(if_wb.slave  cpubus,
	   if_wb.master iobus,
	   if_wb.master rambus,
	   if_wb.master rombus,
	   if_wb.master vectbus,
	   input 	supervisor,
	   output 	fault);
   
   logic 		f;
   
   assign fault = (cpubus.cyc ? f : 1'b0);

   always_comb
     begin
	f = 1'b0;
	cpubus.dat_o = 32'h0;
	cpubus.ack = 1'b0;
	cpubus.stall = 1'b0;
	iobus.cyc = cpubus.cyc;
	iobus.dat_o = cpubus.dat_i;
	iobus.stb = 1'b0;
	iobus.sel = cpubus.sel;
	iobus.we = cpubus.we;
	iobus.adr = cpubus.adr;
	rombus.cyc = cpubus.cyc;
	rombus.stb = 1'b0;
	rombus.dat_o = cpubus.dat_i;
	rombus.we = cpubus.we;
	rombus.sel = cpubus.sel;
	rombus.adr = cpubus.adr;
	rambus.we = cpubus.we;
	rambus.cyc = cpubus.cyc;
	rambus.stb = 1'b0;
	rambus.dat_o = cpubus.dat_i;
	rambus.sel = cpubus.sel;
	rambus.adr = cpubus.adr;
	vectbus.we = cpubus.we;
	vectbus.cyc = cpubus.cyc;
	vectbus.stb = 1'b0;
	vectbus.dat_o = cpubus.dat_i;
	vectbus.sel = cpubus.sel;
	vectbus.adr = cpubus.adr;
	
	case (cpubus.adr[31:28])
	  4'h0: // 128MB (32M x 32) SDRAM
	    begin
	       rambus.stb = cpubus.stb;
	       cpubus.dat_o = rambus.dat_i;
	       cpubus.ack = rambus.ack;
	       cpubus.stall = rambus.stall;
	    end
	  4'h3: // IO
	    begin
	       iobus.stb = cpubus.stb;
	       cpubus.dat_o = iobus.dat_i;
	       cpubus.ack = iobus.ack;
	       cpubus.stall = iobus.stall;
	    end
	  4'h7: // BIOS
	    begin
	       rombus.stb = cpubus.stb;
	       cpubus.dat_o = rombus.dat_i;
	       cpubus.ack = rombus.ack;
	       cpubus.stall = rombus.stall;
	    end
	  4'hf: // vectors
	    begin
	       rombus.stb = cpubus.stb;
	       cpubus.dat_o = vectbus.dat_i;
	       cpubus.ack = vectbus.ack;
	       cpubus.stall = vectbus.stall;
	    end
	  default:
	    f = 1'h1;
	endcase
     end
   
endmodule
