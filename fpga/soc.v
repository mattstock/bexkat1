module soc(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG, clock_50,
  quad, rgb, pb,
  fs_addrbus, fs_databus, ssram_be, ssram0_ce_n, ssram1_ce_n, ssram_oe_n, ssram_we_n,
  ssram_adv_n, ssram_adsp_n, ssram_gw_n, ssram_adsc_n, ssram_clk,
  lcd_e, lcd_rw, lcd_on, lcd_rs, lcd_data,
  rgb0, rgb1, rgb_a, rgb_b, rgb_c, rgb_stb, rgb_clk, rgb_oe_n,
  fl_oe_n, fl_ce_n, fl_we_n, fl_rst_n, fl_ry, fl_wp_n,
  sdram_addrbus, sdram_databus, sdram_ba, sdram_dqm, sdram_ras_n, sdram_cas_n, sdram_cke, sdram_clk,
  sdram_we_n, sdram_cs_n,
  serial0_tx, serial0_rx, serial0_cts, serial0_rts, serial1_tx);

// SSRAM & flash
output [26:0] fs_addrbus;
inout [31:0] fs_databus;

// SSRAM
output [3:0] ssram_be;
output ssram_oe_n;
output ssram0_ce_n;
output ssram1_ce_n;
output ssram_we_n;
output ssram_adv_n;
output ssram_adsp_n;
output ssram_gw_n;
output ssram_adsc_n;
output ssram_clk;

// Flash
output fl_oe_n;
output fl_ce_n;
output fl_we_n;
input fl_ry;
output fl_rst_n;
output fl_wp_n;

// SDRAM
output [12:0] sdram_addrbus;
inout [31:0] sdram_databus;
output [1:0] sdram_ba;
output [3:0] sdram_dqm;
output sdram_ras_n;
output sdram_cas_n;
output sdram_cke;
output sdram_clk;
output sdram_we_n;
output sdram_cs_n;

// FPGA board stuff
input clock_50;
input [17:0] SW;
input [3:0] KEY;
output [8:0] LEDG;
output [17:0] LEDR;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;
output [6:0] HEX6;
output [6:0] HEX7;

// LED panel
output [2:0] rgb0;
output [2:0] rgb1;
output rgb_clk;
output rgb_oe_n;
output rgb_a, rgb_b, rgb_c;
output rgb_stb;

// rgb encoder
output [2:0] rgb;
input [1:0] quad;
input pb;

// serial
input serial0_rx, serial0_cts;
output serial0_tx, serial1_tx, serial0_rts;

// LCD display
output lcd_e;
output lcd_rs;
output lcd_on;
output lcd_rw;
output [7:0] lcd_data;

wire rst_n;
wire uart0_txd;

// Reset button
reg [2:0] rst_sync;
assign rst_n = rst_sync[2];
always @(posedge clock_50) rst_sync <= { rst_sync[1:0], KEY[0] };

assign lcd_on = SW[17];
assign serial0_rts = serial0_cts;
assign serial0_tx = (SW[15] ? serial0_rx : uart0_txd);

// Wiring for external SDRAM, SSRAM & flash
assign sdram_clk = clock_50;
assign ssram_gw_n = 1'b1;
assign ssram_adv_n = 1'b1;
assign ssram_clk = clock_50;
assign ssram_adsc_n = 1'b1;
assign fl_oe_n = ~fl_we_n;
assign fl_we_n = 1'b1;
assign fl_ce_n = 1'b1;
assign fl_rst_n = rst_n;
assign fl_wp_n = 1'b1;

// visualization stuff
hexdisp d7(.out(HEX7), .in(4'h0));
hexdisp d6(.out(HEX6), .in({ 1'b0, fs_addrbus[26:24] }));
hexdisp d5(.out(HEX5), .in(fs_addrbus[23:20]));
hexdisp d4(.out(HEX4), .in(fs_addrbus[19:16]));
hexdisp d3(.out(HEX3), .in(fs_addrbus[15:12]));
hexdisp d2(.out(HEX2), .in(fs_addrbus[11:8]));
hexdisp d1(.out(HEX1), .in(fs_addrbus[7:4]));
hexdisp d0(.out(HEX0), .in(fs_addrbus[3:0]));
// Blinknlights
assign LEDR = 18'h0000;
assign LEDG[8] = 1'b1;

wire [31:0] cpu_address;
wire [31:0] cpu_readdata, cpu_writedata, mon_readdata, ram_readdata, ram_writedata;
wire [3:0] cpu_be;
wire cpu_write, cpu_read, cpu_wait, ram_write, ram_read, mon_read;

// quadrature encoder outputs 0-23
//rgb_enc io0(.clk(clock_50), .rst_n(rst_n), .quad(quad), .button(pb), .rgb_out(rgb),
//  .write(cpu_write & mem_encoder), .address(cpu_addrbus[2:1]), .data_in(cpu_data_out), .data_out(encoder_data));

bexkat1 bexkat0(.csi_clk(clock_50), .rsi_reset_n(rst_n), .avm_m0_address(cpu_address), .avm_m0_read(cpu_read), .avm_m0_readdata(cpu_readdata),
  .avm_m0_write(cpu_write), .avm_m0_writedata(cpu_writedata), .avm_m0_byteenable(cpu_be), .avm_m0_waitrequest(cpu_wait));
monitor mon0(.clock(clock_50), .q(mon_readdata), .rden(mon_read), .address(cpu_address[13:2]));
scratch ram0(.clock(clock_50), .data(ram_writedata), .q(ram_readdata), .wren(ram_write), .rden(ram_read), .address(cpu_address[13:2]),
  .byteena(cpu_be));
assign cpu_readdata = (cpu_address[31] ? mon_readdata : ram_readdata);
assign ram_write = (cpu_address[31] ? 1'b0 : cpu_write);
assign ram_read = (cpu_address[31] ? 1'b0 : cpu_read);
assign mon_read = (cpu_address[31] ? cpu_read : 1'b0);
assign cpu_wait = state;

assign ram_writedata = cpu_writedata;

reg state;

always @(posedge clock_50 or negedge rst_n)
begin
  if (!rst_n) begin
    state <= 1'b0;
  end else begin
    if (!state && (cpu_read || cpu_write)) begin
      state <= 1'b1;
    end else begin
      state <= 1'b0;
    end
  end
end
  
endmodule
