`include "../../fpgalib/bexkat1/bexkat1.vh"

module mmu(input clk_i,
	   input rst_i,
	   if_wb.slave cpubus,
	   if_wb.master p0,
	   if_wb.master p3,
	   if_wb.master p7,
	   if_wb.master pf);

  // fixed wiring
  always_comb
    begin
      p0.cyc = cpubus.cyc;
      p3.cyc = cpubus.cyc;
      p7.cyc = cpubus.cyc;
      pf.cyc = cpubus.cyc;
      p0.dat_o = cpubus.dat_i;
      p3.dat_o = cpubus.dat_i;
      p7.dat_o = cpubus.dat_i;
      pf.dat_o = cpubus.dat_i;
      p0.sel = cpubus.sel;
      p3.sel = cpubus.sel;
      p7.sel = cpubus.sel;
      pf.sel = cpubus.sel;
      p0.we = cpubus.we;
      p3.we = cpubus.we;
      p7.we = cpubus.we;
      pf.we = cpubus.we;
      p0.adr = cpubus.adr;
      p3.adr = cpubus.adr;
      p7.adr = cpubus.adr;
      pf.adr = cpubus.adr;
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
      p0.stb = 1'b0;
      p3.stb = 1'b0;
      p7.stb = 1'b0;
      pf.stb = 1'b0;
      cpubus.dat_o = 32'h0;
      cpubus.ack = 1'b0;
      cpubus.stall = 1'b0;
      
      case (state ? active : cpubus.adr[31:28])
	4'h0:
	  begin
	    p0.stb = cpubus.stb;
	    cpubus.dat_o = p0.dat_i;
	    cpubus.ack = p0.ack;
	    cpubus.stall = p0.stall;
	  end
	4'h3: // IO
	  begin	    
	    p3.stb = cpubus.stb;
	    cpubus.dat_o = p3.dat_i;
	    cpubus.ack = p3.ack;
	    cpubus.stall = p3.stall;
	  end
	4'h7: // BIOS
	  begin
	    p7.stb = cpubus.stb;
	    cpubus.dat_o = p7.dat_i;
	    cpubus.ack = p7.ack;
	    cpubus.stall = p7.stall;
	  end
	4'hf: // vectors
	  begin
	    pf.stb = cpubus.stb;
	    cpubus.dat_o = pf.dat_i;
	    cpubus.ack = pf.ack;
	    cpubus.stall = pf.stall;
	  end
	default:
	  begin end
      endcase // case (active)
    end // always_comb
endmodule
