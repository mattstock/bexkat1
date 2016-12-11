module sdram_controller(
  input clk_i,
  output mem_clk_o,
  input rst_i,
  input [24:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o,
  output stall_o,
  input stb_i,
  input cyc_i,
  output ack_o,
  input [3:0] sel_i,
  input we_i,
  output we_n,
  output cs_n,
  output cke,
  output cas_n,
  output ras_n,
  output reg [3:0] dqm,
  output reg [1:0] ba,
  output databus_dir,
  output reg [12:0] addrbus_out,
  input [31:0] databus_in,
  output [31:0] databus_out);

parameter width32 = 1'b1;

assign {cs_n, cas_n, ras_n, we_n} = cmd;

localparam [3:0] CMD_DESL = 4'hf, CMD_NOP = 4'h7, CMD_READ = 4'h3, CMD_WRITE = 4'h2, CMD_ACTIVATE = 4'h5, CMD_PRECHARGE = 4'h4, CMD_REFRESH = 4'h1,
  CMD_MRS = 4'h0;
localparam [4:0] S_INIT_WAIT = 'h0, S_INIT_PRECHARGE = 'h1, S_INIT_REFRESH = 'h2, S_INIT_REFRESH_WAIT = 'h3,
  S_INIT_MODE_WAIT = 'h4, S_INIT_MODE = 'h5, S_IDLE = 'h6, S_ACTIVATE = 'h7, S_ACTIVATE_WAIT = 'h8,
  S_READ_WAIT = 'h9, S_READ_OUT = 'ha, S_REFRESH = 'hb, S_READ_OUT2 = 'hc, S_READ_OUT3 = 'hd, S_READ_OUT4 = 'he,
  S_WRITE2 = 'hf, S_WRITE3 = 'h10, S_WRITE4 = 'h11, S_WRITE = 'h12, S_WRITE_WAIT = 'h13, S_WRITE_WAIT2 = 'h14,
  S_WRITE_WAIT3 = 'h15, S_WRITE5 = 'h16, S_WRITE6 = 'h18, S_WRITE7 = 'h19, S_WRITE8 = 'h1a,
  S_READ_OUT5 = 'h1b, S_READ_OUT6 = 'h1c, S_READ_OUT7 = 'h1d, S_READ_OUT8 = 'h17, S_READ = 'h1e;

wire select, write_active, read_active;
wire wordsel;

assign write_active = (state == S_WRITE || state == S_WRITE2 || state == S_WRITE3 || state == S_WRITE4 ||
  state == S_WRITE5 || state == S_WRITE6 || state == S_WRITE7 || state == S_WRITE8);
assign mem_clk_o = clk_i;
assign databus_dir = write_active;
assign read_active = (state == S_READ_OUT || state == S_READ_OUT2 || state == S_READ_OUT3 ||
  state == S_READ_OUT4 || state == S_READ_OUT5 || state == S_READ_OUT6 ||
  state == S_READ_OUT7 || state == S_READ_OUT8);
assign ack_o = write_active || read_active;
assign dat_o = (select & ~we_i ? (width32 ? databus_in : {halfword, databus_in[15:0]}) : 32'h0);
assign cke = ~rst_i;
assign select = cyc_i & stb_i;
assign databus_out = (width32 ? dat_i : (wordsel ? { 16'h0, dat_i[31:16]} : dat_i));

reg [1:0] ba_next;
reg [3:0] cmd, cmd_next;
reg [4:0] state, state_next;
reg [15:0] delay, delay_next;
reg [12:0] addrbus_out_next;
reg [3:0] dqm_next;
reg [15:0] halfword, halfword_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    cmd <= CMD_NOP;
    delay <= 16'd20000;
    state <= S_INIT_WAIT;
    ba <= 2'b00;
    addrbus_out <= 13'h0000;
    dqm <= 4'hf;
	 halfword <= 16'h0000;
  end else begin
    ba <= ba_next;
    cmd <= cmd_next;
    delay <= delay_next;
    state <= state_next;
    addrbus_out <= addrbus_out_next;
    dqm <= dqm_next;
	 halfword <= halfword_next;
  end
end

always @*
begin
  cmd_next = cmd;
  state_next = state;
  delay_next = delay;
  addrbus_out_next = addrbus_out;
  ba_next = ba;
  dqm_next = dqm;
  stall_o = 1'b0;
  wordsel = 1'b1;
  halfword_next = halfword;
  case (state)
    S_INIT_WAIT: begin
      delay_next = delay - 16'h1;
      if (delay == 16'd0) begin
		  cmd_next = CMD_PRECHARGE;
		  delay_next = 16'h3;
        addrbus_out_next[10] = 1'b1; // all banks precharge
        state_next = S_INIT_PRECHARGE;
      end
    end
    S_INIT_PRECHARGE: begin
      delay_next = delay - 16'h1;
      if (delay == 16'h0) begin
        delay_next = 16'd63;
        state_next = S_INIT_REFRESH;
      end
    end
    S_INIT_REFRESH: begin
      cmd_next = CMD_REFRESH;
      state_next = S_INIT_REFRESH_WAIT;
    end
    S_INIT_REFRESH_WAIT: begin
      cmd_next = CMD_NOP;
      delay_next = delay - 1'b1;
      if (delay == 16'h0)
        state_next = S_INIT_MODE;
      else if (delay[2:0] == 3'h0)
        state_next = S_INIT_REFRESH;
    end
    S_INIT_MODE: begin
      ba_next = 2'b00;
      cmd_next = CMD_MRS;
      addrbus_out_next = 13'b0000000100011; // CAS = 2, sequential, write/read burst length = 8
      delay_next = 16'h3;
      state_next = S_INIT_MODE_WAIT;
    end
    S_INIT_MODE_WAIT: begin
      delay_next = delay - 1'b1;
      cmd_next = CMD_NOP;
      if (delay == 16'h0) begin
        state_next = S_IDLE;
      end
    end
    S_IDLE: begin
      if (select) begin
        cmd_next = CMD_ACTIVATE; // address[24:0] [24:23] for bank, [22:10] for row, 
        ba_next = adr_i[24:23];
        addrbus_out_next = adr_i[22:10];  // open row
        dqm_next = ~sel_i;
        state_next = S_ACTIVATE;
      end else begin
        cmd_next = CMD_REFRESH;
        addrbus_out_next[10] = 1'b1; // all banks refresh
        delay_next = 16'h6;
        state_next = S_REFRESH;
      end
    end
    S_REFRESH: begin
      cmd_next = CMD_NOP;
      delay_next = delay - 1'b1;
      if (delay == 16'h0)
        state_next = S_IDLE;
    end
	 S_ACTIVATE: begin
	   cmd_next = CMD_NOP;
		state_next = S_ACTIVATE_WAIT;
	 end
    S_ACTIVATE_WAIT: begin
      cmd_next = (we_i ? CMD_WRITE : CMD_READ);
      ba_next = adr_i[24:23];
      dqm_next = ~sel_i;
      addrbus_out_next[10] = 1'b1; // auto precharge
      addrbus_out_next[9:0] = adr_i[9:0]; // read/write column
      state_next = (we_i ? S_WRITE : S_READ);
    end
    S_READ: begin
      cmd_next = CMD_NOP;
      state_next = S_READ_WAIT;
    end
    S_READ_WAIT: begin
	   state_next = S_READ_OUT;
    end
    S_READ_OUT: begin
	   if (width32) begin
		  state_next = S_READ_OUT3;
		end else begin
	     stall_o = 1'b1;
		  halfword_next = databus_in[15:0];
	     state_next = S_READ_OUT2;
		end
	 end
	 S_READ_OUT2: state_next = S_READ_OUT3;
	 S_READ_OUT3: begin
	   if (width32) begin
		  state_next = S_READ_OUT5;
		end else begin
	     stall_o = 1'b1;
		  halfword_next = databus_in[15:0];
		  state_next = S_READ_OUT4;
		end
	 end
	 S_READ_OUT4: state_next = S_READ_OUT5;
	 S_READ_OUT5: begin
	   if (width32) begin
		  state_next = S_READ_OUT7;
		end else begin
	     stall_o = 1'b1;
		  halfword_next = databus_in[15:0];
		  state_next = S_READ_OUT6;
		end
	 end
	 S_READ_OUT6: state_next = S_READ_OUT7;
	 S_READ_OUT7: begin
	   if (width32) begin
		  state_next = S_IDLE;
		end else begin
	     stall_o = 1'b1;
		  halfword_next = databus_in[15:0];
		  state_next = S_READ_OUT8;
		end
	 end
	 S_READ_OUT8: state_next = S_IDLE;
    S_WRITE: begin
      cmd_next = CMD_NOP;
		if (width32) begin
		  state_next = S_WRITE3;
		end else begin
		  stall_o = 1'b1;
        state_next = S_WRITE2;
		end
	 end
	 S_WRITE2: begin
	   wordsel = 1'b0; // low order half word
	   state_next = S_WRITE3;
	 end
	 S_WRITE3: begin
	   if (width32) begin
		  state_next = S_WRITE5;
		end else begin
	     stall_o = 1'b1;
	     state_next = S_WRITE4;
		end
	 end
	 S_WRITE4: begin
	   wordsel = 1'b0;
	   state_next = S_WRITE5;
	 end
	 S_WRITE5: begin
	   if (width32) begin
		  state_next = S_WRITE7;
		end else begin
	     stall_o = 1'b1;
		  state_next = S_WRITE6;
		end
	 end
	 S_WRITE6: begin
	   wordsel = 1'b0;
		state_next = S_WRITE7;
	 end
	 S_WRITE7: begin
	   if (width32) begin
		  state_next = S_WRITE_WAIT;
		end else begin
	     stall_o = 1'b1;
		  state_next = S_WRITE8;
		end
	 end
	 S_WRITE8: begin
	   wordsel = 1'b0;
		state_next = S_WRITE_WAIT;
	 end
	 S_WRITE_WAIT: state_next = S_WRITE_WAIT2;
	 S_WRITE_WAIT2: state_next = S_WRITE_WAIT3;
	 S_WRITE_WAIT3: state_next = S_IDLE;
    default: state_next = S_IDLE;
  endcase
end

endmodule
