`include "../wb.vh"

module bios(input 	clk_i,
	    input       rst_i,
	    if_wb.slave rombus0,
	    if_wb.slave vectbus0,
	    if_wb.slave rombus1,
	    if_wb.slave vectbus1,
	    input       select);

  logic [31:0] 		rom_readdata0, rom2_readdata0;
  logic [31:0] 		rom_readdata1, rom2_readdata1;
   
  assign rombus0.dat_o = (select ? rom2_readdata0 : rom_readdata0);
  assign rombus0.ack = rom0_ack[1];
  assign vectbus0.ack = vect0_ack[1];
  assign rombus0.stall = 1'b0;
  assign vectbus0.stall = 1'b0;

  assign rombus1.dat_o = (select ? rom2_readdata1 : rom_readdata1);
  assign rombus1.ack = rom1_ack[1];
  assign vectbus1.ack = vect1_ack[1];
  assign rombus1.stall = 1'b0;
  assign vectbus1.stall = 1'b0;
  
  // only need one cycle for reading onboard memory
  logic [1:0] 		rom0_ack, rom1_ack;
  logic [1:0] 		vect0_ack, vect1_ack;
  
  always @(posedge clk_i or posedge rst_i)
    if (rst_i)
      begin
	vect0_ack <= 2'b0;
	rom0_ack <= 2'b0;
	vect1_ack <= 2'b0;
	rom1_ack <= 2'b0;
      end
    else
      begin
	vect0_ack <= (vectbus0.cyc ? 
		      { vect0_ack[0], vectbus0.stb } :
		      2'h0);
	rom0_ack <= (rombus0.cyc ? 
		     { rom0_ack[0], rombus0.stb } :
		     2'h0);
	vect1_ack <= (vectbus1.cyc ? 
		      { vect1_ack[0], vectbus1.stb } :
		      2'h0);
	rom1_ack <= (rombus1.cyc ?
		     { rom1_ack[0], rombus1.stb } :
		     2'h0);
      end
  
  monitor2 rom0(.clock(clk_i),
		.q_a(rom_readdata0),
		.address_a(rombus0.adr[16:2]),
		.q_b(rom_readdata1),
		.address_b(rombus1.adr[16:2]));
  testrom2 rom1(.clock(clk_i),
		.q_a(rom2_readdata0),
		.address_a(rombus0.adr[16:2]),
		.q_b(rom2_readdata1),
		.address_b(rombus1.adr[16:2]));
  vectors2 vecram0(.clock(clk_i),
		   .q_a(vectbus0.dat_o),
		   .address_a(vectbus0.adr[2]),
		   .q_b(vectbus1.dat_o),
		   .address_b(vectbus1.adr[2]));
  
endmodule
