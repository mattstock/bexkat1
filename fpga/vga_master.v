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
  output reg slave_ack_o,
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

localparam [2:0] STATE_IDLE = 3'h0, STATE_BUS = 3'h1, STATE_GRAPHICS = 3'h2,
                 STATE_MAP0 = 3'h3, STATE_MAP1 = 3'h4, STATE_MAP2 = 3'h5, STATE_MAP3 = 3'h6;

wire [7:0] pallette_idx;
wire [23:0] pallette_out, linebuf_out;
wire [15:0] x_raw, y_raw;
wire line_write;

reg [2:0] state, state_next;
reg [9:0] idx, idx_next;
reg [31:0] x_sync [2:0];
reg [31:0] y_sync [2:0];
reg [31:0] rowval, rowval_next;
reg [31:0] tempvals, tempvals_next;

assign master_dat_o = 32'h0;
assign slave_dat_o = 32'h0;
assign master_we_o = 1'b0;
assign master_sel_o = 4'hf;
assign master_cyc_o = (state == STATE_BUS);
assign master_stb_o = master_cyc_o;

assign sync_n = 1'b0;
assign { r,g,b } = linebuf_out;

assign line_write = (state == STATE_MAP0 || state == STATE_MAP1 || state == STATE_MAP2 || state == STATE_MAP3);

always @* begin
  case (state)
    STATE_MAP0: pallette_idx = tempvals[31:24];
    STATE_MAP1: pallette_idx = tempvals[23:16];
    STATE_MAP2: pallette_idx = tempvals[15:8];
    STATE_MAP3: pallette_idx = tempvals[7:0];
    default: pallette_idx = 8'h00;
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
    tempvals <= 32'h0;
  end else begin
    idx <= idx_next;
    state <= state_next;
    rowval <= rowval_next;
    tempvals <= tempvals_next;
  end
end

always @(*)
begin
  state_next = state;
  idx_next = idx;
  rowval_next = rowval;
  master_adr_o = 32'hc0000000;
  slave_ack_o = slave_cyc_i & slave_stb_i; // should be just a single cycle delay
  tempvals_next = tempvals;
  case (state)
    STATE_IDLE: begin
      if (y_sync[2] == 32'h0) begin
        rowval_next = 32'h0;
      end else begin
        if (x_sync[2] == 32'h0) begin
          state_next = STATE_BUS;
        end
      end
    end
    STATE_BUS: begin
      master_adr_o = VIDMEM + rowval + idx;
      if (master_ack_i) begin
        state_next = STATE_MAP0;
        tempvals_next = master_dat_i;
      end
    end
    STATE_MAP0: begin
      idx_next = idx + 1'h1;
      state_next = STATE_MAP1;
    end
    STATE_MAP1: begin
      idx_next = idx + 1'h1;
      state_next = STATE_MAP2;
    end
    STATE_MAP2: begin
      idx_next = idx + 1'h1;
      state_next = STATE_MAP3;
    end
    STATE_MAP3: begin
      idx_next = idx + 1'h1;
      state_next = STATE_GRAPHICS;
    end
    STATE_GRAPHICS: begin
      if (idx < 10'd640) begin
        state_next = STATE_BUS;
      end else begin
        rowval_next = rowval + idx;
        idx_next = 10'd0;
        state_next = STATE_IDLE;
      end
    end
    default: state_next = STATE_IDLE;
  endcase
end

vga_pallette map0(.clock(clk_i), .wraddress(slave_adr_i[7:0]), .wren(slave_cyc_i & slave_stb_i & slave_we_i),
  .data(slave_dat_i[23:0]), .rdaddress(pallette_idx), .q(pallette_out));
vgalinebuf scanline0(.wrclock(clk_i), .wraddress(idx), .wren(line_write), .data(pallette_out),
  .rdclock(vga_clock), .rdaddress(x_raw), .q(linebuf_out));

vga_controller vga0(.active(blank_n), .vs(vs), .hs(hs), .clock(vga_clock), .reset_n(~rst_i), .x(x_raw), .y(y_raw));
vgapll vgapll0(.inclk0(clk_i), .c0(vga_clock));

endmodule
