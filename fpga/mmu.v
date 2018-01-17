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

  typedef enum 		bit { S_ACTIVE, S_CHANGE } state_t;
  
  logic [3:0] 		active, active_next;
  logic [3:0] 		count, count_next;
  logic 		active_stall, active_ack, active_stb;
  state_t               state, state_next;
  
  assign fault = 1'b0;

  always_ff @(posedge clk_i or posedge rst_i)
    if (rst_i)
      begin
	active <= 4'h0;
	count <= 4'h0;
	state <= S_ACTIVE;
      end
    else
      begin
	active <= active_next;
	count <= count_next;
	state <= state_next;
      end

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

  // switching based on the active slave
  always_comb
    begin
      rambus.stb = 1'b0;
      iobus.stb = 1'b0;
      rombus.stb = 1'b0;
      vectbus.stb = 1'b0;
      cpubus.dat_o = 32'h0;
      cpubus.ack = 1'b0;
      active_stall = 1'b0;
      active_ack = 1'b0;
      case (active)
	4'h0: // 128MB (32M x 32) SDRAM
	  begin
	    rambus.stb = active_stb;
	    cpubus.dat_o = rambus.dat_i;
	    cpubus.ack = rambus.ack;
	    active_stall = rambus.stall;
	    active_ack = rambus.ack;
	  end
	4'h3: // IO
	  begin	    
	    iobus.stb = active_stb;
	    cpubus.dat_o = iobus.dat_i;
	    cpubus.ack = iobus.ack;
	    active_stall = iobus.stall;
	    active_ack = iobus.ack;
	  end
	4'h7: // BIOS
	  begin
	    rombus.stb = active_stb;
	    cpubus.dat_o = rombus.dat_i;
	    cpubus.ack = rombus.ack;
	    active_stall = rombus.stall;
	    active_ack = rombus.ack;
	  end
	4'hf: // vectors
	  begin
	    vectbus.stb = active_stb;
	    cpubus.dat_o = vectbus.dat_i;
	    cpubus.ack = vectbus.ack;
	    active_stall = vectbus.stall;
	    active_ack = vectbus.ack;
	  end
	default:
	  begin end
      endcase // case (active)
    end

  // track the requests in flight to the active slave
  always_comb
    begin
      count_next = count;
      if (cpubus.cyc)
	begin
	  if (cpubus.stb && !active_stall && !cpubus.stall)
	    begin
	      if (!active_ack)
		count_next = count + 4'h1;
	    end
	  else
	    if (active_ack)
	      count_next = count - 4'h1;
	end // if (cpubus.cyc)
      else
	count_next = 4'h0;
    end

  // only change slaves where the in flight is zero
  // stall the cpu until that time
  always_comb
    begin
      state_next = state;
      active_next = active;
      cpubus.stall = active_stall;
      active_stb = cpubus.stb;
      case (state)
	S_ACTIVE:
	  if (cpubus.cyc && cpubus.stb)
	    if (active != cpubus.adr[31:28])
	      begin
		cpubus.stall = 1'b1;
		active_stb = 1'b0;
		if (count == 4'b0)
		  begin
		    state_next = S_CHANGE;
		    active_next = cpubus.adr[31:28];
		  end
	      end
	S_CHANGE:
	  begin
	    active_stb = 1'b0;
	    cpubus.stall = 1'b1;
	    state_next = S_ACTIVE;
	  end
	endcase // case S_CHANGE
      end // always_comb
  
endmodule
