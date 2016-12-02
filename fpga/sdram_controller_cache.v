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
			      input [31:0] 	databus_in,
			      output [31:0] databus_out,
            output [1:0] cache_status,
				input cache_mode);

wire [24:0] cache_adr_o, sdram_adr_i;
wire [31:0] cache_dat_o, sdram_dat_o, sdram_dat_i, sd_cache_dat_o;
wire [3:0] cache_sel_o, sdram_sel_i;
wire cache_cyc_o, cache_stb_o, cache_we_o, cache_stb_i, cache_ack_o;
wire sdram_cyc_i, sdram_stb_i, sdram_ack_o, sdram_we_i;

assign dat_o = cache_dat_o;
assign ack_o = cache_ack_o;
assign cache_stb_i = stb_i;
assign sdram_adr_i = cache_adr_o;
assign sdram_dat_i = sd_cache_dat_o;
assign sdram_cyc_i = cache_cyc_o;
assign sdram_stb_i = cache_stb_o;
assign sdram_sel_i = cache_sel_o;
assign sdram_we_i = cache_we_o;

cache cache0(.clk_i(clk_i), .rst_i(rst_i), .s_adr_i(adr_i), .s_dat_i(dat_i),
	     .s_dat_o(cache_dat_o), .s_stb_i(cache_stb_i), .s_cyc_i(cyc_i),
	     .s_ack_o(cache_ack_o), .s_sel_i(sel_i), .s_we_i(we_i),
	     .m_adr_o(cache_adr_o), .m_dat_o(sd_cache_dat_o),
	     .m_dat_i(sdram_dat_o), .m_stb_o(cache_stb_o),
	     .m_cyc_o(cache_cyc_o), .m_ack_i(sdram_ack_o),
	     .m_sel_o(cache_sel_o), .m_we_o(cache_we_o), .cache_status(cache_status));

sdram_controller sdram0(.clk_i(clk_i), .mem_clk_o(mem_clk_o), .rst_i(rst_i),
			.adr_i(sdram_adr_i), .dat_i(sdram_dat_i),
			.dat_o(sdram_dat_o), .stb_i(sdram_stb_i),
			.cyc_i(sdram_cyc_i), .ack_o(sdram_ack_o),
			.sel_i(sdram_sel_i), .we_i(sdram_we_i), .we_n(we_n),
			.cs_n(cs_n), .cke(cke), .cas_n(cas_n),
			.ras_n(ras_n), .dqm(dqm), .ba(ba),
			.addrbus_out(addrbus_out),
			.databus_in(databus_in), .databus_out(databus_out));

endmodule
