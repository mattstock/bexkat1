module sdram_controller_cache(input 		clk_i,
			      output 		mem_clk_o,
			      input 		rst_i,
			      input [24:0] 	adr_i,
			      input [31:0] 	dat_i,
			      output [31:0] 	dat_o,
			      input 		stb_i,
			      input 		cyc_i,
			      output 		ack_o,
			      input [3:0] 	sel_i,
			      input 		we_i,
			      output 		we_n,
			      output 		cs_n,
			      output 		cke,
			      output 		cas_n,
			      output 		ras_n,
			      output [3:0] 	dqm,
			      output [1:0] 	ba,
			      output [12:0] addrbus_out,
					output databus_dir,
			      input [31:0] 	databus_in,
			      output [31:0] databus_out,
            output [1:0] cache_status,
				input cache_mode);

parameter width32 = 1'b1;

wire [24:0] cache_adr_o;
wire [31:0] sdram_dat_o, sdram_dat_i;
wire [3:0] cache_sel_o;
wire cache_cyc_o, cache_stb_o, cache_we_o;
wire sdram_ack_o, sdram_stall_o;

cache #(.width32(width32)) cache0(.clk_i(clk_i), .rst_i(rst_i), .s_adr_i(adr_i), .s_dat_i(dat_i),
	     .s_dat_o(dat_o), .s_stb_i(stb_i), .s_cyc_i(cyc_i),
	     .s_ack_o(ack_o), .s_sel_i(sel_i), .s_we_i(we_i),
	     .m_adr_o(cache_adr_o), .m_dat_o(sdram_dat_i),
	     .m_dat_i(sdram_dat_o), .m_stb_o(cache_stb_o),
	     .m_cyc_o(cache_cyc_o), .m_ack_i(sdram_ack_o), .m_stall_i(sdram_stall_o),
	     .m_sel_o(cache_sel_o), .m_we_o(cache_we_o), .cache_status(cache_status));

sdram_controller #(.width32(width32)) sdram0(.clk_i(clk_i), .mem_clk_o(mem_clk_o), .rst_i(rst_i),
			.adr_i(cache_adr_o), .dat_i(sdram_dat_i),
			.dat_o(sdram_dat_o), .stb_i(cache_stb_o),
			.cyc_i(cache_cyc_o), .ack_o(sdram_ack_o), .stall_o(sdram_stall_o),
			.sel_i(cache_sel_o), .we_i(cache_we_o), .we_n(we_n),
			.cs_n(cs_n), .cke(cke), .cas_n(cas_n),
			.ras_n(ras_n), .dqm(dqm), .ba(ba),
			.addrbus_out(addrbus_out), .databus_dir(databus_dir),
			.databus_in(databus_in), .databus_out(databus_out));

endmodule
