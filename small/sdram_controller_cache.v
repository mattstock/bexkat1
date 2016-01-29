module sdram_controller_cache(input 		clk_i,
			      output 		mem_clk_o,
			      input 		rst_i,
			      input [20:0] 	adr_i,
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
			      output [1:0] 	dqm,
			      output [1:0] ba,
			      output [11:0] addrbus_out,
			      input [15:0] 	databus_in,
			      output [15:0] databus_out,
            output [1:0] cache_status,
			      input cache_en);

logic [20:0] cache_adr_o, adapt_adr_i;
logic [21:0] sdram_adr_i;
logic [31:0] cache_dat_o, adapt_dat_i, adapt_dat_o, sd_cache_dat_o;
logic [15:0] sdram_dat_o, sdram_dat_i;
logic [3:0] cache_sel_o, adapt_sel_i;
logic [1:0] sdram_sel_i;
logic adapt_cyc_i, adapt_we_i, adapt_stb_i, adapt_ack_o;
logic cache_cyc_o, cache_stb_o, cache_we_o, cache_stb_i, cache_ack_o;
logic sdram_cyc_i, sdram_stb_i, sdram_ack_o, sdram_we_i;

assign dat_o = (cache_en ? cache_dat_o : adapt_dat_o);
assign ack_o = (cache_en ? cache_ack_o : adapt_ack_o);
assign cache_stb_i = stb_i & cache_en;
assign adapt_adr_i = (cache_en ? cache_adr_o : adr_i);
assign adapt_dat_i = (cache_en ? sd_cache_dat_o : dat_i);
assign adapt_cyc_i = (cache_en ? cache_cyc_o : cyc_i);
assign adapt_stb_i = (cache_en ? cache_stb_o : stb_i);
assign adapt_sel_i = (cache_en ? cache_sel_o : sel_i);
assign adapt_we_i = (cache_en ? cache_we_o : we_i);

cache cache0(.clk_i(clk_i), .rst_i(rst_i), .s_adr_i(adr_i), .s_dat_i(dat_i),
	     .s_dat_o(cache_dat_o), .s_stb_i(cache_stb_i), .s_cyc_i(cyc_i),
	     .s_ack_o(cache_ack_o), .s_sel_i(sel_i), .s_we_i(we_i),
	     .m_adr_o(cache_adr_o), .m_dat_o(sd_cache_dat_o),
	     .m_dat_i(adapt_dat_o), .m_stb_o(cache_stb_o),
	     .m_cyc_o(cache_cyc_o), .m_ack_i(adapt_ack_o),
	     .m_sel_o(cache_sel_o), .m_we_o(cache_we_o), .cache_status(cache_status));

adapt32to16 adapt0(.clk_i(clk_i), .rst_i(rst_i), .s_dat_i(adapt_dat_i),
	     .s_dat_o(adapt_dat_o), .s_stb_i(adapt_stb_i), .s_cyc_i(adapt_cyc_i),
	     .s_ack_o(adapt_ack_o), .s_sel_i(adapt_sel_i), .s_we_i(adapt_we_i),
       .s_adr_i(adapt_adr_i),
       
	     .m_adr_o(sdram_adr_i), .m_dat_o(sdram_dat_i),
	     .m_dat_i(sdram_dat_o), .m_stb_o(sdram_stb_i),
	     .m_cyc_o(sdram_cyc_i), .m_ack_i(sdram_ack_o),
	     .m_sel_o(sdram_sel_i), .m_we_o(sdram_we_i));
       
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
