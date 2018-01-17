`include "../../fpgalib/wb.vh"
module iocontroller
  #(clkfreq=1000000)
  (input 	      clk_i,
   input 	      rst_i,
   if_wb.slave        bus,
   output 	      lcd_e,
   output [7:0]       lcd_data,
   output 	      lcd_on,
   output 	      lcd_rw,
   output 	      lcd_rs,
   output 	      tx0,
   input 	      rx0,
   input 	      cts0,
   output 	      rts0,
   output 	      tx1,
   input 	      rx1,
   output 	      tx2,
   input 	      rx2,
   input 	      cts2,
   output 	      rts2, 
   input 	      miso,
   output 	      mosi,
   output 	      sclk,
   input 	      sd_wp,
   output logic [7:0] spi_selects,
   output [5:0]       interrupts,
   input [15:0]       sw,
   input [1:0] 	      ps2kbd,
   output [6:0]       hex0,
   output [6:0]       hex1,
   output [6:0]       hex2,
   output [6:0]       hex3,
   output [6:0]       hex4,
   output [6:0]       hex5,
   output [6:0]       hex6,
   output [6:0]       hex7,
   output logic [8:0] led,
   output 	      matrix_stb,
   output 	      matrix_oe_n,
   output 	      matrix_clk,
   output [2:0]       matrix0,
   output [2:0]       matrix1,
   output 	      matrix_a, 
   output 	      matrix_b,
   output 	      matrix_c);

  typedef enum 	      bit [4:0] { S_IDLE,
				  S_DONE,
				  S_SWLED,
				  S_UART0,
				  S_UART1,
				  S_PS2,
				  S_LCD,
				  S_SPI,
				  S_TIMER,
				  S_MATRIX,
				  S_SEGFAN, 
				  S_UART2
				  } state_t;
  
  // various programmable registers
  logic [31:0] 	      segreg, segreg_next,
		      result, result_next;
  state_t             state, state_next;
  logic [8:0] 	      led_next;
  
  logic [31:0] 	      lcd_out, uart2_out, uart1_out, uart0_out, 
		      spi_out, ps2kbd_out, timer_out, matrix_out;
  logic 	      lcd_ack, uart0_ack, uart1_ack, uart2_ack,
		      spi_ack, ps2kbd_ack, timer_ack, matrix_ack;
  logic [3:0] 	      timer_interrupts;
  logic [1:0] 	      uart0_interrupts;

  assign bus.ack = (state == S_DONE);
  assign bus.dat_o = result;
  assign bus.stall = 1'b0;
  
  assign interrupts = { timer_interrupts, uart0_interrupts };

  always @(posedge clk_i or posedge rst_i)
    begin
      if (rst_i)
	begin
	  segreg <= 32'h0;
	  led <= 9'h0;
	  result <= 32'h0;
	  state <= S_IDLE;
	end 
      else
	begin
	  segreg <= segreg_next;
	  led <= led_next;
	  result <= result_next;
	  state <= state_next;
	end
    end
  
  always_comb
    begin
      segreg_next = segreg;
      led_next = led;
      result_next = result;
      state_next = state;
      case (state)
	S_IDLE:
	  if (bus.cyc && bus.stb)
            state_next = state_t'({ 1'b0, bus.adr[13:10]}); // the state numbers are driven by the address map
	S_SEGFAN: // LED and fan in place
	  begin
	    if (bus.we)
	      begin
		if (bus.adr[0] == 1'b0)
		  segreg_next = bus.dat_i;
	      end
	    else
              result_next = (bus.adr[0] ? 32'h0 : segreg); 
	    state_next = S_DONE;
	  end
	S_SWLED: // switches and leds
	  begin 
	    if (bus.we)
              led_next = bus.dat_i[8:0];
	    else
              result_next = { 16'h0000, sw };
	    state_next = S_DONE;
	  end
	S_UART0: 
	  begin
	    if (~bus.we)
              result_next = uart0_out;
	    if (uart0_ack)
              state_next = S_DONE;
	  end
	S_UART1:
	  begin // UART1
	    if (~bus.we)
              result_next = uart1_out;
	    if (uart1_ack)
              state_next = S_DONE;
	  end
	S_UART2:
	  begin // UART2
	    if (~bus.we)
              result_next = uart2_out;
	    if (uart2_ack)
              state_next = S_DONE;
	  end
	S_PS2:
	  begin // ps2 kbd
	    if (~bus.we)
              result_next = ps2kbd_out;
	    if (ps2kbd_ack)
              state_next = S_DONE;
	  end
	S_LCD:
	  begin // LCD
	    if (~bus.we)
              result_next = lcd_out;
	    if (lcd_ack)
              state_next = S_DONE;
	  end
	S_SPI:
	  begin // SPI
	    if (~bus.we)
              result_next = spi_out;
	    if (spi_ack)
              state_next = S_DONE;
	  end
	S_TIMER: 
	  begin // timer
	    if (~bus.we)
	      result_next = timer_out;
	    if (timer_ack)
	      state_next = S_DONE;
	  end
	S_MATRIX:
	  begin // matrix
	    if (~bus.we)
              result_next = matrix_out;
	    if (matrix_ack)
              state_next = S_DONE;
	  end
	S_DONE:
	  state_next = S_IDLE;
	default: 
	  state_next = S_DONE;
      endcase  
    end
  
  uart #(.baud(115200),
	 .clkfreq(clkfreq)) uart0(.clk_i(clk_i), .rst_i(rst_i), 
				  .we_i(bus.we),
				  .sel_i(bus.sel),
				  .stb_i(state == S_UART0),
				  .dat_i(bus.dat_i),
				  .dat_o(uart0_out),
				  .cyc_i(bus.cyc),
				  .adr_i(bus.adr[0]),
				  .ack_o(uart0_ack),
				  .rx(rx0), 
				  .tx(tx0),
				  .rts(rts0),
				  .cts(cts0),
				  .interrupt(uart0_interrupts));
  
  uart #(.clkfreq(clkfreq)) uart1(.clk_i(clk_i), .rst_i(rst_i), 
				  .we_i(bus.we),
				  .sel_i(bus.sel),
				  .stb_i(state == S_UART1),
				  .dat_i(bus.dat_i),
				  .dat_o(uart1_out),
				  .cyc_i(bus.cyc),
				  .adr_i(bus.adr[0]),
				  .ack_o(uart1_ack),
				  .rx(rx1),
				  .tx(tx1));

  uart #(.baud(115200),
	 .clkfreq(clkfreq)) uart2(.clk_i(clk_i), .rst_i(rst_i), 
				  .we_i(bus.we),
				  .sel_i(bus.sel),
				  .stb_i(state == S_UART2),
				  .dat_i(bus.dat_i),
				  .dat_o(uart2_out),
				  .cyc_i(bus.cyc),
				  .adr_i(bus.adr[0]),
				  .ack_o(uart2_ack),
				  .rx(rx2),
				  .tx(tx2),
				  .rts(rts2),
				  .cts(cts2));

  led_matrix rgbmatrix0(.clk_i(clk_i), .rst_i(rst_i),
			.dat_i(bus.dat_i),
			.dat_o(matrix_out),
			.adr_i(bus.adr[9:0]),
			.sel_i(bus.sel),
			.we_i(bus.we),
			.stb_i(state == S_MATRIX),
			.cyc_i(bus.cyc),
			.ack_o(matrix_ack),
			.demux({matrix_a, matrix_b, matrix_c}),
			.matrix0(matrix0), 
			.matrix1(matrix1),
			.matrix_stb(matrix_stb),
			.matrix_clk(matrix_clk),
			.oe_n(matrix_oe_n));

  lcd_module lcd0(.clk_i(clk_i), .rst_i(rst_i),
		  .we_i(bus.we),
		  .sel_i(bus.sel),
		  .stb_i(state == S_LCD),
		  .cyc_i(bus.cyc),
		  .dat_i(bus.dat_i),
		  .ack_o(lcd_ack),
		  .adr_i(bus.adr[6:0]),
		  .dat_o(lcd_out),
		  .e(lcd_e),
		  .data_out(lcd_data),
		  .rs(lcd_rs),
		  .on(lcd_on),
		  .rw(lcd_rw));

  spi_master #(.clkfreq(clkfreq)) spi0(.clk_i(clk_i),
				       .cyc_i(bus.cyc), 
				       .rst_i(rst_i), 
				       .sel_i(bus.sel),
				       .we_i(bus.we),
				       .stb_i(state == S_SPI),
				       .dat_i(bus.dat_i),
				       .dat_o(spi_out),
				       .ack_o(spi_ack),
				       .adr_i(bus.adr[0]),
				       .miso(miso),
				       .mosi(mosi),
				       .sclk(sclk),
				       .selects(spi_selects),
				       .wp(sd_wp));

  ps2_kbd ps2kbd0(.clk_i(clk_i), .rst_i(rst_i),
		  .cyc_i(bus.cyc),
		  .sel_i(bus.sel),
		  .we_i(bus.we),
		  .stb_i(state == S_PS2),
		  .dat_i(bus.dat_i),
		  .dat_o(ps2kbd_out),
		  .ack_o(ps2kbd_ack),
		  .adr_i(bus.adr[0]),
		  .ps2_clock(ps2kbd[1]),
		  .ps2_data(ps2kbd[0]));

timerint timerint0(.clk_i(clk_i), .rst_i(rst_i),
		   .cyc_i(bus.cyc),
		   .sel_i(bus.sel),
		   .we_i(bus.we),
		   .stb_i(state == S_TIMER),
		   .dat_i(bus.dat_i),
		   .dat_o(timer_out),
		   .ack_o(timer_ack),
		   .adr_i(bus.adr[3:0]),
		   .interrupt(timer_interrupts));

  segdigits segdigits0(.in((sw[10] ? segreg : bus.adr)), 
		       .out0(hex0),
		       .out1(hex1),
		       .out2(hex2),
		       .out3(hex3),
		       .out4(hex4),
		       .out5(hex5),
		       .out6(hex6),
		       .out7(hex7));

endmodule
