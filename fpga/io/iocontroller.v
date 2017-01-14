module iocontroller(
  input clk_i,
  input rst_i,
	input we_i,
  input cyc_i,
	input stb_i,
	input [14:0] adr_i,
	output [31:0] dat_o,
	input [31:0] dat_i,
	input [3:0] sel_i,
  output ack_o,
	output lcd_e,
  output [7:0] lcd_data,
	output lcd_on,
	output lcd_rw,
	output lcd_rs,
	output tx0,
	input rx0,
	input cts0,
	output rts0,
	output tx1,
	input rx1,
	input miso,
	output mosi,
  output sclk,
  input sd_wp,
	output fan,
	output reg [7:0] spi_selects,
	output [5:0] interrupts,
	input [15:0] sw,
	input [1:0] ps2kbd,
  output codec_pbdat,
  input codec_reclrc,
  input codec_pblrc,
  input codec_recdat,
  input codec_bclk,
  output [2:0] i2c_dataout,
	output [2:0] i2c_scl,
	input [2:0] i2c_datain,
	input [2:0] i2c_clkin,
	output [6:0] hex0,
	output [6:0] hex1,
	output [6:0] hex2,
  output [6:0] hex3,
	output [6:0] hex4,
	output [6:0] hex5,
	output [6:0] hex6,
	output [6:0] hex7,
  output reg [8:0] led,
  output matrix_stb,
  output matrix_oe_n,
  output matrix_clk,
  output [2:0] matrix0,
  output [2:0] matrix1,
  output matrix_a, 
  output matrix_b,
  output matrix_c,  
  input irda);

parameter clkfreq = 100000000;

localparam [4:0] S_IDLE = 'h10, S_DONE = 'h11, S_SEGFAN = 'h0, S_SWLED = 'h1, S_UART0 = 'h2, S_UART1 = 'h3, S_PS2 = 'h4,
  S_CODEC = 'h5, S_LCD = 'h6, S_SPI = 'h7, S_TIMER = 'h8, S_I2C0 = 'h9, S_I2C1 = 'ha, S_I2C2 = 'hb, S_MATRIX = 'hc, S_IRDA = 'hd;

// various programmable registers
logic [31:0] segreg, fanspeed, segreg_next, fanspeed_next, result, result_next;
logic [4:0] state, state_next;
logic [8:0] led_next;

wire [31:0] lcd_out, uart1_out, uart0_out, spi_out, ps2kbd_out, timer_out, matrix_out;
wire [7:0] i2c_out[2:0];
wire lcd_ack, uart0_ack, uart1_ack, spi_ack, ps2kbd_ack, timer_ack, i2c_ack[2:0];
wire matrix_ack;
wire [3:0] timer_interrupts;
wire [1:0] uart0_interrupts;

assign ack_o = (state == S_DONE);
assign dat_o = result;
assign interrupts = { timer_interrupts, uart0_interrupts };

always codec_pbdat = codec_recdat;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    segreg <= 32'h0;
    fanspeed <= 32'h00004000;
    led <= 9'h0;
    result <= 32'h0;
    state <= S_IDLE;
  end else begin
    segreg <= segreg_next;
    led <= led_next;
    fanspeed <= fanspeed_next;
    result <= result_next;
    state <= state_next;
  end
end

always_comb
begin
  segreg_next = segreg;
  led_next = led;
  fanspeed_next = fanspeed;
  result_next = result;
  state_next = state;
  case (state)
    S_IDLE: begin
      if (cyc_i && stb_i)
        state_next = { 1'b0, adr_i[13:10]}; // the state numbers are driven by the address map
    end
    S_SEGFAN: begin // LED and fan in place
      if (we_i) begin
        if (adr_i[0] == 1'b0)
		      segreg_next = dat_i;
        else
		      fanspeed_next = dat_i;
      end else
        result_next = (adr_i[0] ? fanspeed : segreg); 
      state_next = S_DONE;
    end
    S_SWLED: begin // switches and leds
      if (we_i)
        led_next = dat_i[8:0];
      else
        result_next = { 16'h0000, sw };
      state_next = S_DONE;
    end
    S_UART0: begin // UART0
      if (~we_i)
        result_next = uart0_out;
      if (uart0_ack)
        state_next = S_DONE;
    end
    S_UART1: begin // UART1
      if (~we_i)
        result_next = uart1_out;
      if (uart1_ack)
        state_next = S_DONE;
    end
    S_PS2: begin // ps2 kbd
      if (~we_i)
        result_next = ps2kbd_out;
      if (ps2kbd_ack)
        state_next = S_DONE;
    end
    S_CODEC: begin // CODEC
      if (~we_i)
        result_next = 32'h0;
      state_next = S_DONE;
    end
    S_LCD: begin // LCD
      if (~we_i)
        result_next = lcd_out;
      if (lcd_ack)
        state_next = S_DONE;
    end
    S_SPI: begin // SPI
      if (~we_i)
        result_next = spi_out;
      if (spi_ack)
        state_next = S_DONE;
      end
	  S_TIMER: begin // timer
		  if (~we_i)
			  result_next = timer_out;
		  if (timer_ack)
				state_next = S_DONE;
		end
	  S_I2C0: begin // external i2c
		  if (~we_i)
				result_next = {24'h0, i2c_out[0]};
			if (i2c_ack[0])
				state_next = S_DONE;
		end
    S_I2C1: begin // video capture i2c
			if (~we_i)
				result_next = {24'h0, i2c_out[1]};
      if (i2c_ack[1])
        state_next = S_DONE;
    end
    S_I2C2: begin // accelerometer i2c
      if (~we_i)
        result_next = {24'h0, i2c_out[2]};
      if (i2c_ack[2])
        state_next = S_DONE;
    end
    S_MATRIX: begin // matrix
      if (~we_i)
        result_next = matrix_out;
      if (matrix_ack)
        state_next = S_DONE;
    end
    S_IRDA: begin // irda
      if (~we_i)
        result_next = {31'h0, irda};
      state_next = S_DONE;
    end
    S_DONE: state_next = S_IDLE;
    default: state_next = S_DONE;
  endcase  
end

uart #(.baud(115200), .clkfreq(clkfreq)) uart0(.clk_i(clk_i), .rst_i(rst_i), .we_i(we_i),
  .sel_i(sel_i), .stb_i(state == S_UART0), .dat_i(dat_i), .dat_o(uart0_out), .cyc_i(state == S_UART0),
	.adr_i(adr_i[0]), .ack_o(uart0_ack), .rx(rx0), .tx(tx0), .rts(rts0), .cts(cts0),
	.interrupt(uart0_interrupts));

uart #(.clkfreq(clkfreq)) uart1(.clk_i(clk_i), .rst_i(rst_i), .we_i(we_i),
	.sel_i(sel_i), .stb_i(state == S_UART1), .dat_i(dat_i), .dat_o(uart1_out), .cyc_i(state == S_UART1),
	.adr_i(adr_i[0]), .ack_o(uart1_ack), .rx(rx1), .tx(tx1));

led_matrix rgbmatrix0(.clk_i(clk_i), .rst_i(rst_i), .dat_i(dat_i), .dat_o(matrix_out),
  .adr_i(adr_i[9:0]), .sel_i(sel_i), .we_i(we_i), .stb_i(state == S_MATRIX), .cyc_i(state == S_MATRIX), .ack_o(matrix_ack),
  .demux({matrix_a, matrix_b, matrix_c}), .matrix0(matrix0), .matrix1(matrix1), .matrix_stb(matrix_stb), .matrix_clk(matrix_clk), .oe_n(matrix_oe_n));

lcd_module lcd0(.clk_i(clk_i), .rst_i(rst_i), .we_i(we_i), .sel_i(sel_i),
		.stb_i(state == S_LCD), .cyc_i(state == S_LCD), .dat_i(dat_i), .ack_o(lcd_ack),
		.adr_i(adr_i[6:0]), .dat_o(lcd_out), .e(lcd_e),
		.data_out(lcd_data), .rs(lcd_rs), .on(lcd_on), .rw(lcd_rw));

i2c_master_top i2c0(.wb_clk_i(clk_i), .arst_i(1'b1), .wb_rst_i(rst_i), .wb_we_i(we_i),
		.wb_stb_i(state == S_I2C0), .wb_cyc_i(state == S_I2C0), .wb_dat_i(dat_i[7:0]), .wb_ack_o(i2c_ack[0]),
		.wb_adr_i(adr_i[2:0]), .wb_dat_o(i2c_out[0]), .sda_padoen_o(i2c_dataout[0]), .sda_pad_i(i2c_datain[0]), .scl_padoen_o(i2c_scl[0]), .scl_pad_i(i2c_clkin[0]));

i2c_master_top td_i2c1(.wb_clk_i(clk_i), .arst_i(1'b1), .wb_rst_i(rst_i), .wb_we_i(we_i),
		.wb_stb_i(state == S_I2C1), .wb_cyc_i(state == S_I2C1), .wb_dat_i(dat_i[7:0]), .wb_ack_o(i2c_ack[1]),
		.wb_adr_i(adr_i[2:0]), .wb_dat_o(i2c_out[1]), .sda_padoen_o(i2c_dataout[1]), .sda_pad_i(i2c_datain[1]), .scl_padoen_o(i2c_scl[1]), .scl_pad_i(i2c_clkin[1]));

i2c_master_top accel_i2c2(.wb_clk_i(clk_i), .arst_i(1'b1), .wb_rst_i(rst_i), .wb_we_i(we_i),
		.wb_stb_i(state == S_I2C2), .wb_cyc_i(state == S_I2C2), .wb_dat_i(dat_i[7:0]), .wb_ack_o(i2c_ack[2]),
		.wb_adr_i(adr_i[2:0]), .wb_dat_o(i2c_out[2]), .sda_padoen_o(i2c_dataout[2]), .sda_pad_i(i2c_datain[2]), .scl_padoen_o(i2c_scl[2]), .scl_pad_i(i2c_clkin[2]));
		
spi_master #(.clkfreq(clkfreq)) spi0(.clk_i(clk_i), .cyc_i(state == S_SPI), .rst_i(rst_i), .sel_i(sel_i), .we_i(we_i),
		.stb_i(state == S_SPI), .dat_i(dat_i), .dat_o(spi_out), .ack_o(spi_ack),
		.adr_i(adr_i[0]), .miso(miso), .mosi(mosi),
		.sclk(sclk), .selects(spi_selects), .wp(sd_wp));

ps2_kbd ps2kbd0(.clk_i(clk_i), .rst_i(rst_i), .cyc_i(state == S_PS2), .sel_i(sel_i), .we_i(we_i), .stb_i(state == S_PS2),
  .dat_i(dat_i), .dat_o(ps2kbd_out), .ack_o(ps2kbd_ack), .adr_i(adr_i[0]), .ps2_clock(ps2kbd[1]), .ps2_data(ps2kbd[0]));

timerint timerint0(.clk_i(clk_i), .rst_i(rst_i), .cyc_i(state == S_TIMER),
		   .sel_i(sel_i), .we_i(we_i), .stb_i(state == S_TIMER),
		   .dat_i(dat_i), .dat_o(timer_out), .ack_o(timer_ack),
		   .adr_i(adr_i[3:0]), .interrupt(timer_interrupts));

fan_ctrl fan0(.clk_i(clk_i), .rst_i(rst_i), .speed(fanspeed), .fan_pwm(fan));

segdigits segdigits0(.in(segreg), .out0(hex0), .out1(hex1), .out2(hex2), .out3(hex3), .out4(hex4), .out5(hex5), .out6(hex6), .out7(hex7));

endmodule
