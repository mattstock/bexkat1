module textdrv(
  input clk_i,
  input rst_i,
  input vga_clock,
  input [31:0] cursorpos,
  input [3:0] cursormode,
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
wire [95:0] font0_out, font1_out;
wire [31:0] buf_out;
wire [15:0] scanaddr;
wire [15:0] textrow, textcol;
wire [7:0] color0, color1;
wire oncursor;

logic [1:0] state, state_next;
logic [9:0] idx, idx_next;
logic [31:0] rowval, rowval_next;
logic [15:0] x_sync [2:0];
logic [15:0] y_sync [2:0];
logic [31:0] font_idx, font_idx_next;
logic [25:0] blink;

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUS = 2'h1, STATE_FONT = 2'h2, STATE_STORE = 2'h3;

assign cyc_o = (state == STATE_BUS);
assign scanaddr = x+1'b1;
assign textrow = { 3'h0, y[15:3] };
assign textcol = { 3'h0, x[15:3] };
assign oncursor = ({textrow,textcol} == cursorpos) && ((blink[25] & cursormode[3:0] == 4'h1) || (cursormode[3:0] == 4'h2));

// break out the rows of the font elements
always_comb
begin
  case (y[2:0])
    'h7: char = { color0, color1, font0_out[39:32], font1_out[39:32] };
    'h6: char = { color0, color1, font0_out[47:40], font1_out[47:40] };
    'h5: char = { color0, color1, font0_out[55:48], font1_out[55:48] };
    'h4: char = { color0, color1, font0_out[63:56], font1_out[63:56] };
    'h3: char = { color0, color1, font0_out[71:64], font1_out[71:64] };
    'h2: char = { color0, color1, font0_out[79:72], font1_out[79:72] };
    'h1: char = { color0, color1, font0_out[87:80], font1_out[87:80] };
    'h0: char = { color0, color1, font0_out[95:88], font1_out[95:88] };
	 default: char = 16'h0;
  endcase
end  

wire [7:0] red, green, blue;

assign red =   (x[3] ? { buf_out[23:22], 6'h0 } : { buf_out[31:30], 6'h0 });
assign green = (x[3] ? { buf_out[21:19], 5'h0 } : { buf_out[29:27], 5'h0 });
assign blue =  (x[3] ? { buf_out[18:16], 5'h0 } : { buf_out[26:24], 5'h0 });
 
assign {r,g,b} = (buf_out[4'hf-x[3:0]] || oncursor ? { red, green, blue } : 24'h000000);

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
	 blink <= 25'h0;
  end else begin
    idx <= idx_next;
    state <= state_next;
    rowval <= rowval_next;
	 font_idx <= font_idx_next;
	 blink <= blink + 1'h1;
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
      if (idx < 11'd160) begin
        state_next = STATE_BUS;
        idx_next = idx + 10'd4;
      end else begin
        idx_next = 10'd0;
        if (y_sync[1] == 16'd479)
          rowval_next = 32'h0;
		  else
		    if (y_sync[1][2:0] == 16'h7)
            rowval_next = rowval + 10'd160;
        state_next = STATE_IDLE;
      end
    end
  endcase
end

assign color0 = font_idx[31:24];
fontmem font0(.clock(clk_i), .address(font_idx[22:16]), .q(font0_out));
assign color1 = font_idx[15:8];
fontmem font1(.clock(clk_i), .address(font_idx[6:0]), .q(font1_out));

textlinebuf linebuf0(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(char),
  .rdclock(vga_clock), .rdaddress(scanaddr[11:4]), .q(buf_out));

endmodule
