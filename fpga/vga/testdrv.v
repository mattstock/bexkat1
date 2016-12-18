module textdrv(
  input clk_i,
  input rst_i,
  input vga_clock,
  input [15:0] x,
  input [15:0] y,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b,
  output cyc_o,
  output [31:0] adr_o,
  input [31:0] dat_i,
  input ack_i);

wire [95:0] fontval;
wire [31:0] char;
wire [95:0] font0_out, font1_out, font2_out, font3_out;
wire [31:0] buf_out;
wire [15:0] scanaddr;

logic [1:0] state, state_next;
logic [9:0] idx, idx_next;
logic [31:0] rowval, rowval_next;
logic [15:0] x_sync [2:0];
logic [15:0] y_sync [2:0];
logic [31:0] font_idx, font_idx_next;

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUS = 2'h1, STATE_FONT = 2'h2, STATE_STORE = 2'h3;

assign cyc_o = (state == STATE_BUS);
assign scanaddr = x+1'b1;

// break out the rows of the font elements
always_comb
begin
  case (y % 16'd12)
    'd11: char = { font0_out[7:0], font1_out[7:0], font2_out[7:0], font3_out[7:0] };
    'd10: char = { font0_out[15:8], font1_out[15:8], font2_out[15:8], font3_out[15:8] };
    'd9: char = { font0_out[23:16], font1_out[23:16], font2_out[23:16], font3_out[23:16] };
    'd8: char = { font0_out[31:24], font1_out[31:24], font2_out[31:24], font3_out[31:24] };
    'd7: char = { font0_out[39:32], font1_out[39:32], font2_out[39:32], font3_out[39:32] };
    'd6: char = { font0_out[47:40], font1_out[47:40], font2_out[47:40], font3_out[47:40] };
    'd5: char = { font0_out[55:48], font1_out[55:48], font2_out[55:48], font3_out[55:48] };
    'd4: char = { font0_out[63:56], font1_out[63:56], font2_out[63:56], font3_out[63:56] };
    'd3: char = { font0_out[71:64], font1_out[71:64], font2_out[71:64], font3_out[71:64] };
    'd2: char = { font0_out[79:72], font1_out[79:72], font2_out[79:72], font3_out[79:72] };
    'd1: char = { font0_out[87:80], font1_out[87:80], font2_out[87:80], font3_out[87:80] };
    'd0: char = { font0_out[95:88], font1_out[95:88], font2_out[95:88], font3_out[95:88] };
	 default: char = 32'h0;
  endcase
end  

assign {r,g,b} = (buf_out[5'd31-x[4:0]] ? 24'hffffff : 24'h000000);

always @(posedge clk_i) begin
  x_sync[2] <= x_sync[1];
  x_sync[1] <= x_sync[0];
  x_sync[0] <= x;
  y_sync[2] <= y_sync[1];
  y_sync[1] <= y_sync[0];
  y_sync[0] <= y;
end

// Master state machine
always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
    idx <= 10'h0;
    rowval <= 32'h0;
	 font_idx <= 32'h0;
  end else begin
    idx <= idx_next;
    state <= state_next;
    rowval <= rowval_next;
	 font_idx <= font_idx_next;
  end
end

always_comb
begin
  state_next = state;
  idx_next = idx;
  rowval_next = rowval;
  font_idx_next = font_idx;
  adr_o = 32'h0;
  case (state)
    STATE_IDLE: begin
      if (y_sync[2] != y_sync[1]) begin
        state_next = STATE_BUS;
      end
    end
    STATE_BUS: begin
      adr_o = rowval + idx;
      if (ack_i) begin
        state_next = STATE_FONT;
        font_idx_next = dat_i;
      end
    end
	 STATE_FONT: state_next = STATE_STORE;
    STATE_STORE: begin
      if (idx < 10'd80) begin
        state_next = STATE_BUS;
        idx_next = idx + 10'd4;
      end else begin
        idx_next = 10'd0;
        if (y_sync[1] == 16'd479)
          rowval_next = 32'h0;
		  else
		    if (y_sync[1] % 16'd12 == 16'd11)
            rowval_next = rowval + 10'd80;
        state_next = STATE_IDLE;
      end
    end
  endcase
end

// Font memory x4 so we can decode a word at a time.
// Maybe I should build a single write, 4 read version of my own?
fontmem font0(.clock(clk_i), .address(font_idx[30:24]), .q(font0_out));
fontmem font1(.clock(clk_i), .address(font_idx[22:16]), .q(font1_out));
fontmem font2(.clock(clk_i), .address(font_idx[14:8]), .q(font2_out));
fontmem font3(.clock(clk_i), .address(font_idx[6:0]), .q(font3_out));

testlinebuf linebuf0(.wrclock(clk_i), .wraddress(idx[7:2]), .wren(state == STATE_STORE), .data(char),
  .rdclock(vga_clock), .rdaddress(scanaddr[11:5]), .q(buf_out));

endmodule
