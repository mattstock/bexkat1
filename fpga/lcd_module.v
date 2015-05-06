module lcd_module(
  input clk,
  input rst_n,
  input read,
  input write,
  input [5:0] address,
  input [31:0] readdata,
  input [31:0] writedata,
  input [3:0] be,
  output reg e,
  output reg [7:0] data_out,
  output reg on,
  output reg rw,
  output reg rs);

reg rs_next;
reg e_next;
reg [2:0] state, state_next;
reg [2:0] cmd, cmd_next;
reg lcd_send, lcd_send_next;
reg [19:0] tick, tick_next;
reg [7:0] data_out_next;

wire lcd_busy;

localparam CMD_IDLE = 3'h0, CMD_WAIT_RS = 3'h1, CMD_WRITE = 3'h2, CMD_WAIT_INTER = 3'h3;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    state <= CMD_IDLE;
    cmd <= 3'h0;
    rs <= 1'b0;
    lcd_send <= 1'b0;
    tick <= 20'h0;
    data_out <= 8'h00;
    e <= 1'b0;
  end else begin
    state <= state_next;
    cmd <= cmd_next;
    rs <= rs_next;
    e <= e_next;
    lcd_send <= lcd_send_next;
    tick <= tick_next;
    data_out <= data_out_next;
  end
end

always @*
begin
  state_next = state;
  rs_next = rs;
  e_next = e;
  data_out_next = data_out;
  cmd_next = cmd;
  lcd_send_next = lcd_send;
  tick_next = tick;
  case (state)
    CMD_IDLE:
      if (cmd != 4'hc) begin
        rs_next = 1'b0;
        state_next = CMD_WRITE;
        e_next = 1'b1;
        tick_next = 20'h40000;
        case (cmd)
          3'h0: data_out_next = 8'h3c;
          3'h1: data_out_next = 8'h3c;
          3'h2: data_out_next = 8'h3c; 
          3'h3: data_out_next = 8'h3c;
          3'h4: data_out_next = 8'h08;
          3'h5: data_out_next = 8'h01;
          3'h6: data_out_next = 8'h06;
          3'h7: data_out_next = 8'h0c;
        endcase
      end
    CMD_WRITE:
      if (tick == 12'h00) begin
        state_next = CMD_WAIT_INTER;
        e_next = 1'b0;
        tick_next = 12'h200;
      end else
        tick_next = tick - 1'b1;
    CMD_WAIT_INTER:
      if (tick == 12'h0) begin
        cmd_next = cmd + 1'b1;
        state_next = CMD_IDLE;
      end else
        tick_next = tick - 1'b1;
  endcase
end

endmodule
