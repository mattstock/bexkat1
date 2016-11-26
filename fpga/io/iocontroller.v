module iocontroller(input clk_i,
		    input rst_i,
		    input we_i,
		    input cyc_i,
		    input stb_i,
		    input [16:0] adr_i,
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
          output codec_mclk,
			 output [2:0] i2c_dataout,
			 output [2:0] i2c_scl,
			 input [2:0] i2c_datain,
			 input [2:0] i2c_clkin,
		    output [55:0] hex,
		    output reg [8:0] led,
			 input irda);

// various programmable registers
reg [31:0] segreg, fanspeed, segreg_next, fanspeed_next, result, result_next;
reg [1:0] state, state_next;
reg [8:0] led_next;

wire [31:0] lcd_out, uart1_out, uart0_out, spi_out, ps2kbd_out,
	    timer_out;
wire [7:0] i2c_out[2:0];
wire [3:0] selector;
wire lcd_ack, uart0_ack, uart1_ack, spi_ack, ps2kbd_ack,
     timer_ack, i2c_ack[2:0];
wire [3:0] timer_interrupts;
wire [1:0] uart0_interrupts;

assign ack_o = (state == STATE_DONE);
assign dat_o = result;
assign selector = adr_i[15:12];
assign interrupts = { timer_interrupts, uart0_interrupts };

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUSY = 2'h1, STATE_DONE = 2'h2;

always codec_pbdat = codec_recdat;
codec_pll pll1(.inclk0(clk_i), .c0(codec_mclk), .areset(rst_i));

always @(posedge clk_i or posedge rst_i)
  begin
    if (rst_i) begin
      segreg <= 32'h0;
      fanspeed <= 32'h00010000;
      led <= 9'h0;
      result <= 32'h0;
      state <= STATE_IDLE;
    end else begin
      segreg <= segreg_next;
      led <= led_next;
      fanspeed <= fanspeed_next;
      result <= result_next;
      state <= state_next;
    end
  end

always @*
  begin
    segreg_next = segreg;
    led_next = led;
    fanspeed_next = fanspeed;
    result_next = result;
    state_next = state;
    case (state)
      STATE_IDLE: begin
	     if (cyc_i && stb_i)
          state_next = STATE_BUSY;
        end
      STATE_BUSY: begin
	     case (selector)
          4'h0: begin
            // LED and fan in place
            if (we_i) begin
              if (adr_i[0] == 1'b0)
		          segreg_next = dat_i;
              else
		          fanspeed_next = dat_i;
            end else
              result_next = (adr_i[0] ? fanspeed : segreg); 
            state_next = STATE_DONE;
          end
          4'h1: begin // switches and leds
            if (we_i)
              led_next = dat_i[8:0];
            else
              result_next = { 16'h0000, sw };
            state_next = STATE_DONE;
          end
          4'h2: begin // UART0
            if (~we_i)
              result_next = uart0_out;
            if (uart0_ack)
              state_next = STATE_DONE;
          end
          4'h3: begin // UART1
            if (~we_i)
              result_next = uart1_out;
            if (uart1_ack)
              state_next = STATE_DONE;
          end
          4'h4: begin // ps2 kbd
            if (~we_i)
              result_next = ps2kbd_out;
            if (ps2kbd_ack)
              state_next = STATE_DONE;
          end
          4'h5: begin // CODEC
            if (~we_i)
              result_next = 32'h0;
            state_next = STATE_DONE;
          end
          4'h6: begin // LCD
            if (~we_i)
              result_next = lcd_out;
            if (lcd_ack)
              state_next = STATE_DONE;
          end
          4'h7: begin // SPI
            if (~we_i)
              result_next = spi_out;
            if (spi_ack)
              state_next = STATE_DONE;
          end
	       4'h8: begin // timer
				if (~we_i)
					result_next = timer_out;
				if (timer_ack)
					state_next = STATE_DONE;
			 end
	       4'h9: begin // external i2c
				if (~we_i)
					result_next = {24'h0, i2c_out[0]};
				if (i2c_ack[0])
					state_next = STATE_DONE;
			 end
			 4'ha: begin // video capture i2c
			   if (~we_i)
				  result_next = {24'h0, i2c_out[1]};
				if (i2c_ack[1])
				  state_next = STATE_DONE;
			 end
			 4'hb: begin // accelerometer i2c
			   if (~we_i)
				  result_next = {24'h0, i2c_out[2]};
				if (i2c_ack[2])
				  state_next = STATE_DONE;
			 end
			 4'hc: begin // irda
			   if (~we_i)
				  result_next = {31'h0, irda};
				state_next = STATE_DONE;
			 end
          default: state_next = STATE_DONE;
	     endcase
      end
      STATE_DONE: state_next = STATE_IDLE;
      default: state_next = STATE_IDLE;
    endcase  
  end

wire cyc_o = (state == STATE_BUSY);
wire stb_uart0 = (selector == 4'h2);
wire stb_uart1 = (selector == 4'h3);
wire stb_ps2kbd = (selector == 4'h4);
wire stb_codec = (selector == 4'h5);
wire stb_lcd = (selector == 4'h6);
wire stb_spi = (selector == 4'h7);
wire stb_timer = (selector == 4'h8);
wire stb_i2c[2:0];

assign stb_i2c[0] = (selector == 4'h9);
assign stb_i2c[1] = (selector == 4'ha);
assign stb_i2c[2] = (selector == 4'hb);

uart #(.baud(115200)) uart0(.clk_i(clk_i), .rst_i(rst_i), .we_i(we_i),
			    .sel_i(sel_i), .stb_i(stb_uart0),
			    .dat_i(dat_i), .dat_o(uart0_out), .cyc_i(cyc_o),
			    .adr_i(adr_i[2]), .ack_o(uart0_ack),
			    .rx(rx0), .tx(tx0), .rts(rts0), .cts(cts0),
			    .interrupt(uart0_interrupts));

uart uart1(.clk_i(clk_i), .rst_i(rst_i), .we_i(we_i),
	   .sel_i(sel_i), .stb_i(stb_uart1),
	   .dat_i(dat_i), .dat_o(uart1_out), .cyc_i(cyc_o),
	   .adr_i(adr_i[2]), .ack_o(uart1_ack),
	   .tx(tx1));

lcd_module lcd0(.clk_i(clk_i), .rst_i(rst_i), .we_i(we_i), .sel_i(sel_i),
		.stb_i(stb_lcd), .cyc_i(cyc_o), .dat_i(dat_i), .ack_o(lcd_ack),
		.adr_i(adr_i[8:2]), .dat_o(lcd_out), .e(lcd_e),
		.data_out(lcd_data), .rs(lcd_rs), .on(lcd_on), .rw(lcd_rw));

i2c_master_top i2c0(.wb_clk_i(clk_i), .arst_i(1'b1), .wb_rst_i(rst_i), .wb_we_i(we_i),
		.wb_stb_i(stb_i2c[0]), .wb_cyc_i(cyc_o), .wb_dat_i(dat_i[7:0]), .wb_ack_o(i2c_ack[0]),
		.wb_adr_i(adr_i[4:2]), .wb_dat_o(i2c_out[0]), .sda_padoen_o(i2c_dataout[0]), .sda_pad_i(i2c_datain[0]), .scl_padoen_o(i2c_scl[0]), .scl_pad_i(i2c_clkin[0]));

i2c_master_top i2c1(.wb_clk_i(clk_i), .arst_i(1'b1), .wb_rst_i(rst_i), .wb_we_i(we_i),
		.wb_stb_i(stb_i2c[1]), .wb_cyc_i(cyc_o), .wb_dat_i(dat_i[7:0]), .wb_ack_o(i2c_ack[1]),
		.wb_adr_i(adr_i[4:2]), .wb_dat_o(i2c_out[1]), .sda_padoen_o(i2c_dataout[1]), .sda_pad_i(i2c_datain[1]), .scl_padoen_o(i2c_scl[1]), .scl_pad_i(i2c_clkin[1]));

i2c_master_top i2c2(.wb_clk_i(clk_i), .arst_i(1'b1), .wb_rst_i(rst_i), .wb_we_i(we_i),
		.wb_stb_i(stb_i2c[2]), .wb_cyc_i(cyc_o), .wb_dat_i(dat_i[7:0]), .wb_ack_o(i2c_ack[2]),
		.wb_adr_i(adr_i[4:2]), .wb_dat_o(i2c_out[2]), .sda_padoen_o(i2c_dataout[2]), .sda_pad_i(i2c_datain[2]), .scl_padoen_o(i2c_scl[2]), .scl_pad_i(i2c_clkin[2]));
		
spi_master spi0(.clk_i(clk_i), .cyc_i(cyc_o), .rst_i(rst_i), .sel_i(sel_i), .we_i(we_i),
		.stb_i(stb_spi), .dat_i(dat_i), .dat_o(spi_out), .ack_o(spi_ack),
		.adr_i(adr_i[2]), .miso(miso), .mosi(mosi),
		.sclk(sclk), .selects(spi_selects), .wp(sd_wp));

ps2_kbd ps2kbd0(.clk_i(clk_i), .rst_i(rst_i), .cyc_i(cyc_o), .sel_i(sel_i), .we_i(we_i), .stb_i(stb_ps2kbd),
  .dat_i(dat_i), .dat_o(ps2kbd_out), .ack_o(ps2kbd_ack), .adr_i(adr_i[2]), .ps2_clock(ps2kbd[1]), .ps2_data(ps2kbd[0]));

timerint timerint0(.clk_i(clk_i), .rst_i(rst_i), .cyc_i(cyc_o),
		   .sel_i(sel_i), .we_i(we_i), .stb_i(stb_timer),
		   .dat_i(dat_i), .dat_o(timer_out), .ack_o(timer_ack),
		   .adr_i(adr_i[5:2]), .interrupt(timer_interrupts));

fan_ctrl fan0(.clk_i(clk_i), .rst_i(rst_i), .speed(fanspeed), .fan_pwm(fan));

segdigits segdigits0(.in(segreg), .out0(hex[6:0]), .out1(hex[13:7]), .out2(hex[20:14]), .out3(hex[27:21]), .out4(hex[34:28]), .out5(hex[41:35]), .out6(hex[48:42]), .out7(hex[55:49]));

endmodule
