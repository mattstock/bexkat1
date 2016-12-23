module vga_module(
  input clk_i,
  input rst_i,
  input cyc_i,
  output ack_o,
  input we_i,
  input [3:0] sel_i,
  input [31:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o,
  input stb_i,
  output vs,
  output hs,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b,
  output blank_n,
  input vga_clock,
  output sync_n,
  input [31:0] databus_in,
  output [31:0] databus_out,
  output [26:0] address_out,
  output bus_clock,
  output gw_n,
  output adv_n,
  output adsp_n,
  output adsc_n,
  output [3:0] be_out,
  output oe_n,
  output we_n,
  output ce0_n,
  output ce1_n);

wire [31:0] fs_adr, vga_address;
wire [31:0] ssram_readdata, vga_readdata;
wire [3:0] fs_sel, vga_sel;
wire fs_we, vga_we, ssram_ack, vga_ack;
wire ssram_stb, arb_stb, vga_stb;
wire vga_cyc, arb_cyc, cpu_gnt, vga_gnt;

assign fs_adr = (cpu_gnt ? adr_i : vga_address);
assign fs_sel = (cpu_gnt ? sel_i : vga_sel);
assign fs_we = (cpu_gnt ? we_i : vga_we);
assign ssram_stb = cpu_gnt | vga_gnt;
assign ack_o = (vga_stb ? vga_ack : ssram_ack & cpu_gnt);
assign dat_o = (vga_stb ? vga_readdata : ssram_readdata);
assign vga_stb = (adr_i[31:28] == 4'h8);
assign arb_stb = (adr_i[31:28] == 4'hc);

arbiter arb0(.clk_i(clk_i), .rst_i(rst_i), .cpu_cyc_i(cyc_i & arb_stb),
 .vga_cyc_i(vga_cyc), .cyc_o(arb_cyc), .cpu_gnt(cpu_gnt), .vga_gnt(vga_gnt), .ack_i(ssram_ack));
 
vga_master vga0(.clk_i(clk_i), .rst_i(rst_i), .master_adr_o(vga_address), .master_cyc_o(vga_cyc), .master_dat_i(ssram_readdata),
  .master_we_o(vga_we), .master_sel_o(vga_sel), .master_ack_i(vga_gnt & ssram_ack),
  .slave_adr_i(adr_i[11:2]), .slave_dat_i(dat_i), .slave_sel_i(sel_i), .slave_cyc_i(cyc_i), .slave_we_i(we_i),
  .slave_stb_i(vga_stb), .slave_ack_o(vga_ack), .slave_dat_o(vga_readdata),
  .vs(vs), .hs(hs), .r(r), .g(g), .b(b), .blank_n(blank_n), .vga_clock(vga_clock), .sync_n(sync_n));
  
ssram_controller ssram0(.clk_i(clk_i), .rst_i(rst_i), 
 .stb_i(ssram_stb), .cyc_i(arb_cyc), .we_i(fs_we),
 .ack_o(ssram_ack), .dat_i(dat_i), .dat_o(ssram_readdata),
 .sel_i(fs_sel), .adr_i(fs_adr[21:0]),
 .databus_in(databus_in), .databus_out(databus_out),
 .address_out(address_out), .bus_clock(bus_clock), .gw_n(gw_n), .adv_n(adv_n), .adsp_n(adsp_n),
 .adsc_n(adsc_n), .be_out(be_out), .oe_n(oe_n), .we_n(we_n), .ce0_n(ce0_n), .ce1_n(ce1_n));
  
endmodule
