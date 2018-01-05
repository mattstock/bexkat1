`include "../wb.vh"

module bios(input 	clk_i,
	    input       rst_i,
	    if_wb.slave rombus,
	    if_wb.slave vectbus,
	    input       select);

  logic [31:0] 		rom_readdata, rom2_readdata;
   
  assign rombus.dat_o = (select ? rom2_readdata : rom_readdata);
  assign rombus.ack = rom_ack[1];
  assign vectbus.ack = vect_ack[1];
  assign rombus.stall = 1'b0;
  assign vectbus.stall = 1'b0;
  
  // only need one cycle for reading onboard memory
  logic [1:0] 		rom_ack;
  logic [1:0] 		vect_ack;
  
  always @(posedge clk_i or posedge rst_i)
    if (rst_i)
      begin
	vect_ack <= 2'b0;
	rom_ack <= 2'b0;
      end
    else
      begin
	vect_ack <= (vectbus.cyc ? { vect_ack[0], vectbus.stb } : 2'b0);
	rom_ack <= (rombus.cyc ? { rom_ack[0], rombus.stb } : 2'b0);
      end
  
  monitor rom0(.clock(clk_i),
	       .q(rom_readdata),
	       .rden(rombus.cyc & rombus.stb),
	       .address(rombus.adr[16:2]));
  testrom rom1(.clock(clk_i),
	       .q(rom2_readdata),
	       .rden(rombus.cyc & rombus.stb),
	       .address(rombus.adr[16:2]));
  vectors vecram0(.clock(clk_i),
		  .q(vectbus.dat_o),
		  .rden(vectbus.cyc & vectbus.stb),
		  .address(vectbus.adr[6:2]));
  
endmodule
