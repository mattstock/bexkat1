module max10
(
  input [1:0] raw_clock_50,
  input [9:0] sw,
  input [1:0] key,
  output [9:0] ledr,
  output [7:0] hex0,
  output [7:0] hex1,
  output [7:0] hex2,
  output [7:0] hex3,
  output [7:0] hex4,
  output [7:0] hex5,
  output [12:0] sdram_addrbus,
  inout [15:0] sdram_databus,
  output [1:0] sdram_ba,
  output [1:0] sdram_dqm,
  output sdram_ras_n,
  output sdram_cas_n,
  output sdram_cke,
  output sdram_clk,
  output sdram_we_n,
  output sdram_cs_n
);

parameter clkfreq = 100000000;

wire sysclock, locked, rst_i;
// Internal bus wiring
wire [3:0] chipselect;
wire [26:0] ssram_addrout, flash_addrout;
wire [31:0] cpu_address, vga_address, flash_readdata, ssram_readdata, ssram_dataout, vga_readdata;
wire [15:0] flash_dataout;
wire [31:0] cpu_readdata, cpu_writedata, mon_readdata, mandelbrot_readdata, matrix_readdata, rom_readdata;
wire [31:0] vect_readdata, io_readdata, sdram_readdata, sdram_dataout, vga_writedata, rom2_readdata;
wire [3:0] cpu_be, vga_sel, exception;
wire [5:0] io_interrupts;
wire [2:0] cpu_interrupt;
wire [7:0] lcd_dataout;
wire cpu_write, cpu_cyc, cpu_ack, cpu_halt;
wire vga_we, vga_cyc, vga_stb;
wire arb_cyc, cpu_gnt, vga_gnt;
wire mandelbrot_ack, io_ack;
wire rom_read, vect_read;
wire sdram_ack, vga_slave_ack;
wire [3:0] sdram_den_n;
wire flash_read, flash_write, flash_ready, flash_wait;
wire matrix_read, matrix_write, matrix_ack;
wire ssram_ack;
wire int_en, cache_enable, mmu_fault;
wire [1:0] cache_hitmiss;
wire i2c_tx, i2c_clock;
wire td_tx, td_clock;
wire accel_tx, accel_clock;
  
assign rsi_i = ~locked;
assign ledr = {cpu_cyc, cpu_write, cpu_address[7:0]};

// only need one cycle for reading onboard memory
reg [1:0] rom_ack, vect_ack;

always @(posedge sysclock or posedge rst_i)
begin
  if (rst_i) begin
    rom_ack <= 2'b0;
    vect_ack <= 2'b0;
  end else begin
    if (chipselect == 4'h0) begin
      rom_ack <= 2'b0;
      vect_ack <= 2'b0;
    end else begin
      rom_ack <= { rom_ack[0], rom_read };
      vect_ack <= { vect_ack[0], vect_read };
    end
  end
end

// interrupt priority encoder
always_comb
begin
  cpu_interrupt = 3'h0;
  if (int_en)
    casex ({ mmu_fault, io_interrupts })
      7'b1xxxxxx: cpu_interrupt = 3'h1; // MMU error
      7'b01xxxxx: cpu_interrupt = 3'h5; // timer3
      7'b001xxxx: cpu_interrupt = 3'h4; // timer2
      7'b0001xxx: cpu_interrupt = 3'h3; // timer1
      7'b00001xx: cpu_interrupt = 3'h2; // timer0
      7'b000001x: cpu_interrupt = 3'h6; // uart0 rx
      7'b0000001: cpu_interrupt = 3'h7; // uart0 tx
      7'b0000000: cpu_interrupt = 3'h0;
    endcase
end

assign cpu_readdata = (chipselect == 4'h1 ? vect_readdata : 32'h0) |
                      (chipselect == 4'h2 ? (sw[9] ? rom2_readdata : rom_readdata) : 32'h0) |
                      (chipselect == 4'h4 ? io_readdata : 32'h0) |
                      (chipselect == 4'h5 ? matrix_readdata : 32'h0) |
                      (chipselect == 4'h7 ? sdram_readdata : 32'h0) |
                      (chipselect == 4'ha ? vga_readdata : 32'h0);
assign cpu_ack = (chipselect == 4'h1 ? vect_ack[1] : 1'h0) |
                 (chipselect == 4'h2 ? rom_ack[1] : 1'h0) |
                 (chipselect == 4'h4 ? io_ack : 1'h0) |
                 (chipselect == 4'h5 ? matrix_ack : 1'h0) |
                 (chipselect == 4'h7 ? sdram_ack : 1'h0) |
                 (chipselect == 4'ha ? vga_slave_ack : 1'h0);

assign rom_read = (chipselect == 4'h2 && cpu_cyc && ~cpu_write);
assign vect_read = (chipselect == 4'h1 && cpu_cyc && ~cpu_write);

syspll pll0(.inclk0(raw_clock_50[0]), .c0(sysclock), .areset(~key[0]), .c1(vga_clock), .locked(locked));

bexkat2 bexkat0(.clk_i(sysclock), .rst_i(rst_i), .adr_o(cpu_address), .cyc_o(cpu_cyc), .dat_i(cpu_readdata),
  .we_o(cpu_write), .dat_o(cpu_writedata), .sel_o(cpu_be), .ack_i(cpu_ack), .halt(cpu_halt),
  .interrupt(cpu_interrupt), .exception(exception), .int_en(int_en));

mmu mmu0(.adr_i(cpu_address), .cyc_i(cpu_cyc), .chipselect(chipselect), .fault(mmu_fault));
monitor rom0(.clock(sysclock), .q(rom_readdata), .rden(rom_read), .address(cpu_address[14:2]));
testrom rom1(.clock(sysclock), .q(rom2_readdata), .rden(rom_read), .address(cpu_address[14:2]));

vectors vecram0(.clock(sysclock), .q(vect_readdata), .rden(vect_read), .address(cpu_address[6:2]));

endmodule
