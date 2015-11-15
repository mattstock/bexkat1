module vga_master(
  input clk_i,
  input rst_i,
  input [1:0] sw,
  output reg [31:0] adr_o,
  output cyc_o,
  input [31:0] dat_i,
  output we_o,
  output [31:0] dat_o,
  output [3:0] sel_o,
  input ack_i,
  output stb_o,
  output vs,
  output hs,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b,
  output blank_n,
  output sync_n,
  output vga_clock);

parameter VIDMEM = 32'hc0000000;

wire [15:0] x;
reg [23:0] scandata_out;
wire [7:0] scanpos;

reg [1:0] state, state_next;
/*reg [18:0] pixel, pixel_next;*/
wire [18:0] pixel;
reg [9:0] idx, idx_next;
reg [2:0] hs_sync;
reg scandata_we;

assign dat_o = 32'h00000000;
assign we_o = 1'b0;
assign sel_o = 4'hf;
assign sync_n = 1'b0;
assign cyc_o = (state == STATE_BUS);
assign stb_o = cyc_o;

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUS = 2'h1, STATE_GRAPHICS = 2'h2;

assign r = scandata_out[23:16];
assign g = scandata_out[15:8];
assign b = scandata_out[7:0];

always @(posedge clk_i) begin
  hs_sync = { hs_sync[1:0], hs };
end

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
/*    pixel <= 19'h0;*/
    idx <= 10'h0;
  end else begin
    idx <= idx_next;
    state <= state_next;
/*    pixel <= pixel_next;*/
  end
end

always @(*)
begin
  state_next = state;
/*  pixel_next = pixel;*/
  idx_next = idx;
  scandata_we = 1'b0;
  adr_o = 32'hc0000000;
  case (state)
    STATE_IDLE: begin
      if (hs_sync[2:1] == 2'b10)
        state_next = STATE_BUS;
    end
    STATE_BUS: begin
      scandata_we = 1'b1;
      adr_o = VIDMEM + { pixel + idx, 2'b00 };
      if (ack_i) begin
        state_next = STATE_GRAPHICS;
      end
    end
    STATE_GRAPHICS: begin
      if (idx < 10'd639) begin
        idx_next = idx + 10'd1;
        state_next = STATE_BUS;
      end else begin
        idx_next = 10'd0;
/*        if (pixel < 19'd3000)
          pixel_next = pixel + 19'd640;
        else
          pixel_next = 19'd0;*/
        state_next = STATE_IDLE;
      end
    end
    default: state_next = STATE_IDLE;
  endcase
end

always @*
begin
  case (sw)
    2'h0: scandata_out = 24'h0;
    2'h1: scandata_out = 24'hff0000;
    2'h2: scandata_out = (x < 10'd8 ? 24'h00ff00 : (x > 10'd631 ? 24'h0000ff : 24'h000000));
    2'h3: scandata_out = (pixel == 'd0 ? 24'hff0000 : (pixel == 'd638 ? 24'h00ff00 : (pixel == 'd306560 ? 24'h0000ff : 24'h0)));
  endcase
end

//vgalinebuf scanline0(.wrclock(clk_i), .wraddress(idx), .wren(scandata_we), .data(datain),
//  .rdclock(vga_clock), .rdaddress(x));
vga_controller vga0(.active(blank_n), .vs(vs), .hs(hs), .clock(vga_clock), .reset_n(~rst_i), .x(x), .pixel(pixel));
vgapll vgapll0(.inclk0(clk_i), .c0(vga_clock));

endmodule
