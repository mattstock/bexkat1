`include "../../fpgalib/bexkat1/bexkat1.vh"

module mmu(input        clk_i,
	   input        rst_i,
	   if_wb.slave  cpubus,
	   if_wb.master iobus,
	   if_wb.master rambus,
	   if_wb.master rombus,
	   if_wb.master vectbus,
	   input        supervisor,
	   output       fault);

  assign fault = 1'b0;

  // fixed wiring
  always_comb
    begin
      iobus.cyc = cpubus.cyc;
      iobus.dat_o = cpubus.dat_i;
      iobus.sel = cpubus.sel;
      iobus.we = cpubus.we;
      iobus.adr = cpubus.adr;
      rombus.cyc = cpubus.cyc;
      rombus.dat_o = cpubus.dat_i;
      rombus.we = cpubus.we;
      rombus.sel = cpubus.sel;
      rombus.adr = cpubus.adr;
      rambus.we = cpubus.we;
      rambus.cyc = cpubus.cyc;
      rambus.dat_o = cpubus.dat_i;
      rambus.sel = cpubus.sel;
      rambus.adr = cpubus.adr;
      vectbus.we = cpubus.we;
      vectbus.cyc = cpubus.cyc;
      vectbus.dat_o = cpubus.dat_i;
      vectbus.sel = cpubus.sel;
      vectbus.adr = cpubus.adr;
    end // always_comb

  logic state, state_next;
  logic [3:0] active, active_next;
  
  always_ff @(posedge clk_i or posedge rst_i)
    if (rst_i)
      begin
	active <= 4'hf;
	state <= 1'b0;
      end
    else
      begin
	active <= active_next;
	state <= state_next;
      end

  always_comb
    begin
      active_next = active;
      state_next = state;
      case (state)
	1'b0:
	  if (cpubus.cyc)
	    begin
	      active_next = cpubus.adr[31:28];
	      state_next = 1'b1;
	    end
	1'b1:
	  if (!cpubus.cyc)
	    state_next = 1'b0;
      endcase
    end
      
  always_comb
    begin
      rambus.stb = 1'b0;
      iobus.stb = 1'b0;
      rombus.stb = 1'b0;
      vectbus.stb = 1'b0;
      cpubus.dat_o = 32'h0;
      cpubus.ack = 1'b0;
      cpubus.stall = 1'b0;
      
      case (state ? active : cpubus.adr[31:28])
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
	    vectbus.stb = cpubus.stb;
	    cpubus.dat_o = vectbus.dat_i;
	    cpubus.ack = vectbus.ack;
	    cpubus.stall = vectbus.stall;
	  end
	default:
	  begin end
      endcase // case (active)
    end // always_comb
endmodule
