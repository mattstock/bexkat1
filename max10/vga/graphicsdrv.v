module graphicsdrv(
  input clk_i,
  input rst_i,
  input pixeldouble,
  input vga_clock,
  input [15:0] x,
  input [15:0] y,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b,
  output cyc_o,
  output [31:0] adr_o,
  input [31:0] dat_i,
  input ack_i,
  input palette_write,
  input [7:0] palette_adr_i,
  input [23:0] palette_dat_i);

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUS = 2'h1, STATE_PALETTE = 2'h2, STATE_STORE = 2'h3;

logic [15:0] x_sync [2:0];
logic [15:0] y_sync [2:0];
logic [1:0] state, state_next;
logic [9:0] idx, idx_next;
logic [31:0] rowval, rowval_next;
logic [31:0] map_idx, map_idx_next;
logic y_double, y_double_next;

wire [23:0] buf0_out, buf1_out, buf2_out, buf3_out;
wire [23:0] map0_out, map1_out, map2_out, map3_out;
wire [15:0] scanaddr;

assign scanaddr = x+1'b1;
assign cyc_o = (state == STATE_BUS);

always_comb
begin
  case ((pixeldouble ? x[2:1] : x[1:0]))
    2'h0: {r,g,b} = buf0_out;
    2'h1: {r,g,b} = buf1_out;
    2'h2: {r,g,b} = buf2_out;
    2'h3: {r,g,b} = buf3_out;
  endcase
end

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
    map_idx <= 32'h0;
    y_double <= 1'b0;
  end else begin
    idx <= idx_next;
    state <= state_next;
    rowval <= rowval_next;
    map_idx <= map_idx_next;
    y_double <= y_double_next;
  end
end

always_comb
begin
  state_next = state;
  idx_next = idx;
  rowval_next = rowval;
  adr_o = 32'h0;
  map_idx_next = map_idx;
  y_double_next = y_double;
  case (state)
    STATE_IDLE: begin
      if (y_sync[2] != y_sync[1]) begin
        state_next = STATE_BUS;
      end
    end
    STATE_BUS: begin
      adr_o = rowval + idx;
      if (ack_i) begin
        state_next = STATE_PALETTE;
        map_idx_next = dat_i;
      end
    end
    STATE_PALETTE: state_next = STATE_STORE;
    STATE_STORE: begin
      if (idx < 10'd640) begin
        state_next = STATE_BUS;
        idx_next = idx + 10'd4;
      end else begin
        y_double_next = ~y_double;
        idx_next = 10'd0;
        if (y_sync[1] == 16'd479) begin
          rowval_next = 32'h0;
          y_double_next = 1'b0;
        end else begin
          rowval_next = (pixeldouble ? (y_double ? rowval + 10'd320 : rowval) : rowval + 10'd640);
        end
        state_next = STATE_IDLE;
      end
    end
  endcase
end

// We duplicate the palette map to allow for parallel handling of the reads later
vga_pallette map0(.clock(clk_i), .wraddress(palette_adr_i), .wren(palette_write),
  .data(palette_dat_i), .rdaddress(map_idx[31:24]), .q(map0_out));
vga_pallette map1(.clock(clk_i), .wraddress(palette_adr_i), .wren(palette_write),
  .data(palette_dat_i), .rdaddress(map_idx[23:16]), .q(map1_out));
vga_pallette map2(.clock(clk_i), .wraddress(palette_adr_i), .wren(palette_write),
  .data(palette_dat_i), .rdaddress(map_idx[15:8]), .q(map2_out));
vga_pallette map3(.clock(clk_i), .wraddress(palette_adr_i), .wren(palette_write),
  .data(palette_dat_i), .rdaddress(map_idx[7:0]), .q(map3_out));
// And we interleave the memory
vgalinebuf scanline0(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map0_out),
  .rdclock(vga_clock), .rdaddress((pixeldouble ? scanaddr[10:3] : scanaddr[9:2])), .q(buf0_out));
vgalinebuf scanline1(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map1_out),
  .rdclock(vga_clock), .rdaddress((pixeldouble ? scanaddr[10:3] : scanaddr[9:2])), .q(buf1_out));
vgalinebuf scanline2(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map2_out),
  .rdclock(vga_clock), .rdaddress((pixeldouble ? scanaddr[10:3] : scanaddr[9:2])), .q(buf2_out));
vgalinebuf scanline3(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map3_out),
  .rdclock(vga_clock), .rdaddress((pixeldouble ? scanaddr[10:3] : scanaddr[9:2])), .q(buf3_out));

endmodule
