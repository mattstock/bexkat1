module sdram_controller(
  input cpu_clk,
  input mem_clk,
  input reset_n,
  output we_n,
  output cs_n,
  output cke,
  output cas_n,
  output ras_n,
  output reg [3:0] dqm,
  input [3:0] be,
  output reg [1:0] ba,
  output reg [12:0] addrbus_out,
  input [31:0] databus_in,
  output [31:0] databus_out,
  input read,
  input write,
  output ready,
  input [24:0] address,
  input [31:0] data_in,
  output [31:0] data_out);


assign databus_out = 32'h0;
assign data_out = data_in;
assign cke = 1'b1;

assign ready = (state == STATE_IDLE); // not even close
assign {cs_n, cas_n, ras_n, we_n} = cmd;

localparam [3:0] CMD_DESL = 4'hf, CMD_NOP = 4'h7, CMD_READ = 4'h3, CMD_WRITE = 4'h2, CMD_ACTIVATE = 4'h5, CMD_PRECHARGE = 4'h4, CMD_REFRESH = 4'h1,
  CMD_MRS = 4'h0;
localparam [4:0] STATE_INIT = 5'h0, STATE_INIT1 = 5'h1, STATE_INIT2 = 5'h2, STATE_INIT3 = 5'h3, STATE_INIT4 = 5'h4, STATE_INIT5 = 5'h5,
  STATE_IDLE = 5'h6, STATE_ACTIVATE = 5'h7, STATE_READ = 5'h8, STATE_WRITE = 5'h9, STATE_PRECHARGE = 5'ha, STATE_INIT6 = 5'hb;

wire samerow = (address[24:10] == address_last[24:10]);
  
reg [1:0] ba_next;
reg [3:0] cmd, cmd_next;
reg [3:0] state, state_next;
reg [15:0] delay, delay_next;
reg [12:0] addrbus_out_next;
reg [3:0] dqm_next;
reg [24:0] address_last;

always @(posedge cpu_clk or negedge reset_n)
begin
  if (!reset_n) begin
    cmd <= CMD_NOP;
    delay <= 16'd20000;
    state <= STATE_INIT;
    ba <= 2'b00;
    addrbus_out <= 13'h0000;
    dqm <= 4'hf;
    address_last <= 25'h00;
  end else begin
    ba <= ba_next;
    cmd <= cmd_next;
    delay <= delay_next;
    state <= state_next;
    addrbus_out <= addrbus_out_next;
    dqm <= dqm_next;
    address_last <= address;
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
  case (state)
    STATE_INIT: begin
      // wait 100us = 1000000ns = 5ns (200MHz)/ tick = 20k ticks
      delay_next = delay - 16'h1;
      if (delay == 16'd0) begin
        state_next = STATE_INIT2;
      end
    end
    STATE_INIT2: begin
      cmd_next = CMD_PRECHARGE;
      addrbus_out_next[10] = 1'b1; // all banks precharge
      delay_next = delay + 16'h1;
      if (delay == 16'h3) begin
        delay_next = 16'd63;
        state_next = STATE_INIT3;
      end
    end
    STATE_INIT3: begin
      cmd_next = CMD_REFRESH;
      state_next = STATE_INIT4;
    end
    STATE_INIT4: begin
      cmd_next = CMD_NOP;
      delay_next = delay - 1'b1;
      if (delay == 16'h0)
        state_next = STATE_INIT5;
      else if (delay[2:0] == 3'h0)
        state_next = STATE_INIT3;
    end
    STATE_INIT5: begin
      ba_next = 2'b00;
      cmd_next = CMD_MRS;
      addrbus_out_next = 13'h0221; // CAS = 2, sequential, read burst length = 2, write single location
      delay_next = 16'h3;
      state_next = STATE_INIT6;
    end
    STATE_INIT6: begin
      delay_next = delay - 1'b1;
      cmd_next = CMD_NOP;
      if (delay == 16'h0)
        state_next = STATE_IDLE;
    end
    STATE_IDLE: begin
      if (read || write) begin
        cmd_next = CMD_ACTIVATE; // address[24:0] [24:23] for bank, [22:10] for row, 
        ba_next = address[24:23];
        addrbus_out_next = address[22:10];
        dqm_next = be;
        delay_next = 16'h4;
        state_next = STATE_ACTIVATE;
      end else begin
        cmd_next = CMD_NOP;
        addrbus_out_next = 13'h0;
        dqm_next = 4'h0;
        ba_next = 2'b00;
      end
    end
    STATE_ACTIVATE: begin
      delay_next = delay - 1'b1;
      if (delay == 16'h0) begin
        cmd_next = (read ? CMD_READ : CMD_WRITE);
        ba_next = address[24:23];
        dqm_next = be;
        addrbus_out_next[10] = 1'b0; // no precharge
        addrbus_out_next[9:0] = address[9:0]; // column
        state_next = (read && samerow ? STATE_READ : STATE_WRITE);
      end
    end
    default: state_next = STATE_IDLE;
  endcase
end

endmodule
