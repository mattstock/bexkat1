module vga_master(
  input clk_i,
  input rst_i,
  output reg [31:0] master_adr_o,
  output master_cyc_o,
  input [31:0] master_dat_i,
  output master_we_o,
  output [31:0] master_dat_o,
  output [3:0] master_sel_o,
  input master_ack_i,
  output master_stb_o,
  input [7:0] slave_adr_i,
  input [31:0] slave_dat_i,
  output [31:0] slave_dat_o,
  input slave_cyc_i,
  input slave_we_i,
  input [3:0] slave_sel_i,
  output slave_ack_o,
  input slave_stb_i,
  output vs,
  output hs,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b,
  output blank_n,
  output sync_n,
  output vga_clock);

parameter VIDMEM = 32'hc0000000;

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUS = 2'h1, STATE_PALETTE = 2'h2, STATE_STORE = 2'h3;

wire [23:0] buf0_out, buf1_out, buf2_out, buf3_out;
wire [23:0] map0_out, map1_out, map2_out, map3_out;
wire [15:0] x_raw, y_raw;
wire [15:0] scanaddr;

reg [1:0] state, state_next;
reg [9:0] idx, idx_next;
reg [15:0] x_sync [2:0];
reg [15:0] y_sync [2:0];
reg [31:0] rowval, rowval_next;
reg [31:0] map_idx, map_idx_next;
reg slave_state, slave_state_next;
reg y_double, y_double_next;

assign scanaddr = x_raw+1'b1;
assign master_dat_o = 32'h0;
assign slave_dat_o = 32'h0;
assign slave_ack_o = slave_state;
assign master_we_o = 1'b0;
assign master_sel_o = 4'hf;
assign master_cyc_o = (state == STATE_BUS);
assign master_stb_o = master_cyc_o;

assign sync_n = 1'b0;

always @* begin
  case (x_raw[2:1])
    2'h0: {r,g,b} = buf0_out;
    2'h1: {r,g,b} = buf1_out;
    2'h2: {r,g,b} = buf2_out;
    2'h3: {r,g,b} = buf3_out;
  endcase
end

always @(posedge clk_i) begin
  x_sync[2] <= x_sync[1];
  x_sync[1] <= x_sync[0];
  x_sync[0] <= x_raw;
  y_sync[2] <= y_sync[1];
  y_sync[1] <= y_sync[0];
  y_sync[0] <= y_raw;
end

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
    idx <= 10'h0;
    rowval <= 32'h0;
    map_idx <= 32'h0;
    slave_state <= 1'b0;
    y_double <= 1'b0;
  end else begin
    idx <= idx_next;
    state <= state_next;
    rowval <= rowval_next;
    map_idx <= map_idx_next;
    slave_state <= slave_state_next;
    y_double <= y_double_next;
  end
end

always @(*)
begin
  state_next = state;
  idx_next = idx;
  rowval_next = rowval;
  master_adr_o = 32'hc0000000;
  map_idx_next = map_idx;
  slave_state_next = slave_state;
  y_double_next = y_double;
  if (slave_state == 1'b0) begin
    if (slave_cyc_i & slave_stb_i) begin
      slave_state_next = 1'b1;
    end
  end else begin
    slave_state_next = 1'b0;
  end
  case (state)
    STATE_IDLE: begin
      if (y_sync[2] != y_sync[1]) begin
        state_next = STATE_BUS;
      end
    end
    STATE_BUS: begin
      master_adr_o = VIDMEM + rowval + idx;
      if (master_ack_i) begin
        state_next = STATE_PALETTE;
        map_idx_next = master_dat_i;
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
          if (y_double)
            rowval_next = rowval + 10'd320;
        end
        state_next = STATE_IDLE;
      end
    end
  endcase
end

// We duplicate the palette map to allow for parallel handling of the reads later
vga_pallette map0(.clock(clk_i), .wraddress(slave_adr_i[7:0]), .wren(slave_cyc_i & slave_stb_i & slave_we_i),
  .data(slave_dat_i[23:0]), .rdaddress(map_idx[31:24]), .q(map0_out));
vga_pallette map1(.clock(clk_i), .wraddress(slave_adr_i[7:0]), .wren(slave_cyc_i & slave_stb_i & slave_we_i),
  .data(slave_dat_i[23:0]), .rdaddress(map_idx[23:16]), .q(map1_out));
vga_pallette map2(.clock(clk_i), .wraddress(slave_adr_i[7:0]), .wren(slave_cyc_i & slave_stb_i & slave_we_i),
  .data(slave_dat_i[23:0]), .rdaddress(map_idx[15:8]), .q(map2_out));
vga_pallette map3(.clock(clk_i), .wraddress(slave_adr_i[7:0]), .wren(slave_cyc_i & slave_stb_i & slave_we_i),
  .data(slave_dat_i[23:0]), .rdaddress(map_idx[7:0]), .q(map3_out));
// And we interleave the memory
vgalinebuf scanline0(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map0_out),
  .rdclock(vga_clock), .rdaddress(scanaddr[10:3]), .q(buf0_out));
vgalinebuf scanline1(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map1_out),
  .rdclock(vga_clock), .rdaddress(scanaddr[10:3]), .q(buf1_out));
vgalinebuf scanline2(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map2_out),
  .rdclock(vga_clock), .rdaddress(scanaddr[10:3]), .q(buf2_out));
vgalinebuf scanline3(.wrclock(clk_i), .wraddress(idx[9:2]), .wren(state == STATE_STORE), .data(map3_out),
  .rdclock(vga_clock), .rdaddress(scanaddr[10:3]), .q(buf3_out));

vga_controller vga0(.active(blank_n), .vs(vs), .hs(hs), .clock(vga_clock), .reset_n(~rst_i), .x(x_raw), .y(y_raw));
vgapll vgapll0(.inclk0(clk_i), .c0(vga_clock));

endmodule
