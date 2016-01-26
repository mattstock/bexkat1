module smallsoc(
  input raw_clock_50,
  input [9:0] SW,
  input [3:0] KEY,
  output [7:0] LEDG,
  output [9:0] LEDR,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [17:0] sram_addrbus,
  inout [15:0] sram_databus,
  output [1:0] sram_be,
  output sram_ce_n,
  output sram_we_n,
  output sram_oe_n,
  output [11:0] sdram_addrbus,
  inout [15:0] sdram_databus,
  output [1:0] sdram_ba,
  output [1:0] sdram_dqm,
  output sdram_ras_n,
  output sdram_cas_n,
  output sdram_cke,
  output sdram_clk,
  output sdram_we_n,
  output sdram_cs_n,
  input sd_miso,
  output sd_mosi,
  output sd_ss,
  output sd_sclk,
  output rtc_ss,
  input rtc_miso,
  output rtc_mosi,
  output rtc_sclk,
  input serial0_rx,
  output serial0_tx,
  output serial1_tx,
  output vga_hs,
  output vga_vs,
  output [3:0] vga_r,
  output [3:0] vga_g,
  output [3:0] vga_b,
  input ps2kbd_clk,
  input ps2kbd_data,
  output [21:0] fl_addrbus,
  inout [7:0] fl_databus,
  output fl_oe_n,
  output fl_rst_n,
  output fl_we_n,
  output fl_ce_n);

// System clock
wire sysclock, locked, rst_i;

assign rst_i = ~locked;

sysclock pll0(.inclk0(raw_clock_50), .c0(sysclock), .areset(~KEY[0]), .locked(locked));

// SPI wiring
wire [7:0] spi_selects;
wire miso, mosi, sclk;

assign fl_rst_n = ~rst_i;
assign rtc_ss = spi_selects[4];
assign sd_ss = spi_selects[0];
assign sd_mosi = mosi;
assign rtc_mosi = mosi;
assign miso = (~spi_selects[0] ? sd_miso : 1'b0) |
              (~spi_selects[4] ? rtc_miso : 1'b0);
assign sd_sclk = sclk;
assign rtc_sclk = sclk;

wire [15:0] sdram_dataout, ssram_dataout;
wire [1:0] cache_hitmiss;
wire mmu_fault;
wire [3:0] cpu_be;
wire int_en, cpu_ack, cpu_halt, cpu_cyc, cpu_we;
wire [7:0] exception;
wire [3:0] cpu_interrupt;
wire [31:0] cpu_address, cpu_readdata, cpu_writedata, sdram_readdata, fl_readdata, v_readdata;
wire sdram_ack, fl_ack, fl_stb, v_stb, sdram_stb;
wire [7:0] fl_dataout;

// External SDRAM, SSRAM & flash bus wiring
assign sdram_databus = (~sdram_we_n ? sdram_dataout : 16'hzzzz);
assign sram_databus = (~sram_we_n ? ssram_dataout : 16'hzzzz);
assign fl_databus = (~fl_we_n ? fl_dataout : 8'hzz);

// System Blinknlights
assign LEDR = { SW[9], 4'h0, cache_hitmiss, cpu_halt, mmu_fault, cpu_cyc };
assign LEDG = 8'h0;

hexdisp h3(.in(cpu_address[31:28]), .out(HEX3));
hexdisp h2(.in(cpu_address[11:8]), .out(HEX2));
hexdisp h1(.in(cpu_address[7:4]), .out(HEX1));
hexdisp h0(.in(cpu_address[3:0]), .out(HEX0));

// two cycles for reading onboard memory
reg [2:0] v_ack;

always @(posedge sysclock or posedge rst_i)
begin
  if (rst_i) begin
    v_ack <= 3'h0;
  end else begin
    if (!cpu_cyc) begin
      v_ack <= 3'h0;
    end else begin
      v_ack <= { v_ack[1:0], v_stb };
    end
  end
end

always_comb
begin
  fl_stb = 1'b0;
  v_stb = 1'b0;
  sdram_stb = 1'b0;
  case (cpu_address[31:28])
    4'h7: begin
      fl_stb = 1'b1;
      cpu_readdata = fl_readdata;
      cpu_ack = fl_ack;
    end
    4'hf: begin
      v_stb = 1'b1;
      cpu_readdata = v_readdata;
      cpu_ack = v_ack[2];
    end
    default: begin
      sdram_stb = 1'b1;
      cpu_readdata = sdram_readdata;
      cpu_ack = sdram_ack;
    end
  endcase
end

bexkat2 bexkat0(.clk_i(sysclock), .rst_i(rst_i), .adr_o(cpu_address), .cyc_o(cpu_cyc), .dat_i(cpu_readdata),
  .we_o(cpu_we), .dat_o(cpu_writedata), .sel_o(cpu_be), .ack_i(cpu_ack), .halt(cpu_halt),
  .interrupt(cpu_interrupt), .exception(exception), .int_en(int_en));

flash_controller flash0(.clk_i(sysclock), .rst_i(rst_i), .adr_i(cpu_address[21:2]), .stb_i(fl_stb), .ack_o(fl_ack), .dat_o(fl_readdata),
  .we_i(cpu_we), .cyc_i(cpu_cyc), .sel_i(cpu_be), .databus_in(fl_databus), .databus_out(fl_dataout), .addrbus_out(fl_addrbus),
  .we_n(fl_we_n), .ce_n(fl_ce_n), .oe_n(fl_oe_n));
  
sdram_controller_cache sdram0(.clk_i(sysclock), .mem_clk_o(sdram_clk), .rst_i(rst_i), .adr_i(cpu_address[22:2]),
  .dat_i(cpu_writedata), .dat_o(sdram_readdata), .stb_i(sdram_stb), .cyc_i(cpu_cyc),
  .ack_o(sdram_ack), .sel_i(cpu_be), .we_i(cpu_we), .cache_status(cache_hitmiss),
  .we_n(sdram_we_n), .cs_n(sdram_cs_n), .cke(sdram_cke), .cas_n(sdram_cas_n), .ras_n(sdram_ras_n), .dqm(sdram_dqm), .ba(sdram_ba),
  .addrbus_out(sdram_addrbus), .databus_in(sdram_databus), .databus_out(sdram_dataout), .cache_en(SW[9]));

vectors v0(.clock(sysclock), .address(cpu_address[5:2]), .q(v_readdata));

endmodule
