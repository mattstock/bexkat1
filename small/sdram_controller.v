module sdram_controller(
  input clk_i,
  output mem_clk_o,
  input rst_i,
  input [24:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o,
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
  output reg [1:0] dqm,
  output reg [1:0] ba,
  output reg [11:0] addrbus_out,
  input [15:0] databus_in,
  output reg [15:0] databus_out);

assign {cs_n, cas_n, ras_n, we_n} = cmd;

localparam [3:0] CMD_DESL = 4'hf, CMD_NOP = 4'h7, CMD_READ = 4'h3, CMD_WRITE = 4'h2, CMD_ACTIVATE = 4'h5, CMD_PRECHARGE = 4'h4, CMD_REFRESH = 4'h1,
  CMD_MRS = 4'h0;
localparam [4:0] STATE_INIT_WAIT = 5'h0, STATE_INIT_PRECHARGE = 5'h1, STATE_INIT_REFRESH1 = 5'h2, STATE_INIT_REFRESH1_WAIT = 5'h3,
  STATE_INIT_MODE_WAIT = 5'h4, STATE_INIT_MODE = 5'h5, STATE_IDLE = 5'h6, STATE_ACTIVATE = 5'h7, STATE_RW = 5'h8,
  STATE_PRECHARGE = 5'h9, STATE_READ_WAIT = 5'ha, STATE_READ_WAIT2 = 5'hb, STATE_REFRESH = 5'hc;

wire select;

assign mem_clk_o = ~clk_i;
assign ack_o = (state == STATE_RW);
assign dat_o = (select & ~we_i ? databus_in : 32'h0);
assign cke = ~rst_i;
assign select = cyc_i & stb_i;

reg [1:0] ba_next;
reg [3:0] cmd, cmd_next;
reg [3:0] state, state_next;
reg [15:0] delay, delay_next;
reg [11:0] addrbus_out_next;
reg [1:0] dqm_next;
reg [15:0] databus_out_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    cmd <= CMD_NOP;
    delay <= 16'd20000;
    state <= STATE_INIT_WAIT;
    ba <= 2'b00;
    addrbus_out <= 12'h0000;
    dqm <= 2'h3;
    databus_out <= 16'h0;
  end else begin
    ba <= ba_next;
    cmd <= cmd_next;
    delay <= delay_next;
    state <= state_next;
    addrbus_out <= addrbus_out_next;
    dqm <= dqm_next;
    databus_out <= databus_out_next;
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
  databus_out_next = databus_out;
  case (state)
    STATE_INIT_WAIT: begin
      // wait 100us = 1000000ns = 5ns (200MHz)/ tick = 20k ticks
      delay_next = delay - 16'h1;
      if (delay == 16'd0) begin
        state_next = STATE_INIT_PRECHARGE;
      end
    end
    STATE_INIT_PRECHARGE: begin
      cmd_next = CMD_PRECHARGE;
      addrbus_out_next[10] = 1'b1; // all banks precharge
      delay_next = delay + 16'h1;
      if (delay == 16'h3) begin
        delay_next = 16'd63;
        state_next = STATE_INIT_REFRESH1;
      end
    end
    STATE_INIT_REFRESH1: begin
      cmd_next = CMD_REFRESH;
      state_next = STATE_INIT_REFRESH1_WAIT;
    end
    STATE_INIT_REFRESH1_WAIT: begin
      cmd_next = CMD_NOP;
      delay_next = delay - 1'b1;
      if (delay == 16'h0)
        state_next = STATE_INIT_MODE;
      else if (delay[2:0] == 3'h0)
        state_next = STATE_INIT_REFRESH1;
    end
    STATE_INIT_MODE: begin
      ba_next = 2'b00;
      cmd_next = CMD_MRS;
      addrbus_out_next = 12'b000000100001; // CAS = 2, sequential, read burst length = 2, write burst length = 2
      delay_next = 16'h3;
      state_next = STATE_INIT_MODE_WAIT;
    end
    STATE_INIT_MODE_WAIT: begin
      delay_next = delay - 1'b1;
      cmd_next = CMD_NOP;
      if (delay == 16'h0) begin
        cmd_next = CMD_DESL;
        state_next = STATE_IDLE;
      end
    end
    STATE_IDLE: begin
      if (select) begin
        cmd_next = CMD_ACTIVATE; // address[24:0] [24:23] for bank, [22:10] for row, 
        ba_next = adr_i[24:23];
        addrbus_out_next = adr_i[22:10];  // open row
        dqm_next = ~sel_i;
        delay_next = 16'h4;
        state_next = STATE_ACTIVATE;
      end else begin
        cmd_next = CMD_REFRESH;
        addrbus_out_next[10] = 1'b1; // all banks refresh
        delay_next = 16'h8;
        state_next = STATE_REFRESH;
      end
    end
    STATE_REFRESH: begin
      cmd_next = CMD_NOP;
      delay_next = delay - 1'b1;
      if (delay == 16'h0)
        state_next = STATE_IDLE;
    end
    STATE_ACTIVATE: begin
      delay_next = delay - 1'b1;
      if (delay == 16'h0) begin
        cmd_next = (we_i ? CMD_WRITE : CMD_READ);
        ba_next = adr_i[24:23];
        dqm_next = ~sel_i;
        addrbus_out_next[10] = 1'b0; // no precharge
        addrbus_out_next[9:0] = adr_i[9:0]; // read/write column
        if (we_i) begin
          state_next = STATE_RW;
          databus_out_next = dat_i;
        end else begin
          state_next = STATE_READ_WAIT;
        end
      end
    end
    STATE_READ_WAIT: begin
      cmd_next = CMD_NOP;
      state_next = STATE_READ_WAIT2;
    end
    STATE_READ_WAIT2: begin
      state_next = STATE_RW;
    end
    STATE_RW: begin
      cmd_next = CMD_PRECHARGE;
      state_next = STATE_PRECHARGE;
    end
    STATE_PRECHARGE: begin
      cmd_next = CMD_NOP;
      state_next = STATE_IDLE;
    end
    default: state_next = STATE_IDLE;
  endcase
end

endmodule
