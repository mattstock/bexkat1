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
  input [9:0] slave_adr_i,
  input [31:0] slave_dat_i,
  output reg [31:0] slave_dat_o,
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
  input vga_clock);

// Configuration registers
// 0x000 - palette memory 1
// 0x400 - palette memory 2
// 0x800 - font memory 1
// 0xc00 - video memory base address
// 0xc01 - video mode, palette select

localparam [2:0] SSTATE_IDLE = 3'h0, SSTATE_PALETTE = 3'h1, SSTATE_PALETTE2 = 3'h2, SSTATE_FONT = 3'h3, SSTATE_DONE = 3'h4;

logic [2:0] sstate, sstate_next;
logic [31:0] setupreg, setupreg_next, vgabase, vgabase_next;
logic [31:0] slave_dat_o_next;

wire [7:0] gd_r, gd_g, gd_b, td_r, td_g, td_b;
wire gd_cyc_o, td_cyc_o;
wire [31:0] gd_adr_o, td_adr_o;
wire [15:0] x_raw, y_raw;
wire graphicsdouble, textmode;

assign graphicsdouble = (setupreg[1:0] == 2'b01);
assign textmode = (setupreg[1:0] == 2'b10);
assign master_dat_o = 32'h0;
assign slave_ack_o = (sstate == SSTATE_DONE);
assign master_we_o = 1'b0;
assign master_sel_o = 4'hf;
assign master_cyc_o = (textmode ? td_cyc_o : gd_cyc_o);
assign master_stb_o = master_cyc_o;
assign master_adr_o = vgabase + (textmode ? td_adr_o : gd_adr_o);
assign r = (textmode ? td_r : gd_r);
assign g = (textmode ? td_g : gd_g);
assign b = (textmode ? td_b : gd_b);

assign sync_n = 1'b0;

// Slave state machine
always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    vgabase <= 32'hc0000000;
    setupreg <= 32'h02;
    slave_dat_o <= 32'h0;
    sstate <= SSTATE_IDLE;
  end else begin
    vgabase <= vgabase_next;
    setupreg <= setupreg_next;
    slave_dat_o <= slave_dat_o_next;
    sstate <= sstate_next;
  end
end

always_comb
begin
  sstate_next = sstate;
  setupreg_next = setupreg;
  vgabase_next = vgabase;
  slave_dat_o_next = slave_dat_o;
  
  case (sstate)
    SSTATE_IDLE:
      if (slave_cyc_i & slave_stb_i)
        case (slave_adr_i[9:8])
          2'h0: sstate_next = SSTATE_PALETTE;
          2'h1: sstate_next = SSTATE_PALETTE2;
          2'h2: sstate_next = SSTATE_FONT;
          2'h3: begin
            case (slave_adr_i[7:0])
              8'h0: begin
                if (slave_we_i) begin
                  if (slave_sel_i[3])
                    vgabase_next[31:24] = slave_dat_i[31:24];
                  if (slave_sel_i[2])
                    vgabase_next[23:16] = slave_dat_i[23:16];
                  if (slave_sel_i[1])
                    vgabase_next[15:8] = slave_dat_i[15:8];
                  if (slave_sel_i[0])
                    vgabase_next[7:0] = slave_dat_i[7:0];
                end else
                  slave_dat_o_next = vgabase;
              end
              8'h1: begin
                if (slave_we_i) begin
                  if (slave_sel_i[3])
                    setupreg_next[31:24] = slave_dat_i[31:24];
                  if (slave_sel_i[2])
                    setupreg_next[23:16] = slave_dat_i[23:16];
                  if (slave_sel_i[1])
                    setupreg_next[15:8] = slave_dat_i[15:8];
                  if (slave_sel_i[0])
                    setupreg_next[7:0] = slave_dat_i[7:0];
                end else
                  slave_dat_o_next = setupreg;
              end
              default: begin
                if (~slave_we_i)
                  slave_dat_o_next = 32'h0;
              end
            endcase
            sstate_next = SSTATE_DONE;
          end
          default: sstate_next = SSTATE_DONE;
        endcase
    SSTATE_PALETTE: sstate_next = SSTATE_DONE;
    SSTATE_PALETTE2: sstate_next = SSTATE_DONE;
    SSTATE_FONT: sstate_next = SSTATE_DONE;
    SSTATE_DONE: sstate_next = SSTATE_IDLE;
  endcase
end

graphicsdrv graphicsdriver0(.clk_i(clk_i), .rst_i(rst_i), .pixeldouble(graphicsdouble), .x(x_raw), .y(y_raw),
  .r(gd_r), .g(gd_g), .b(gd_b), .cyc_o(gd_cyc_o), .palette_write((sstate == SSTATE_PALETTE) & slave_we_i),
  .ack_i(master_ack_i), .palette_adr_i(slave_adr_i[7:0]), .palette_dat_i(slave_dat_i[23:0]),
  .adr_o(gd_adr_o), .dat_i(master_dat_i), .vga_clock(vga_clock));
textdrv textdriver0(.clk_i(clk_i), .rst_i(rst_i), .x(x_raw), .y(y_raw),
  .r(td_r), .g(td_g), .b(td_b), .cyc_o(td_cyc_o),
  .ack_i(master_ack_i), .adr_o(td_adr_o), .dat_i(master_dat_i), .vga_clock(vga_clock));

vga_controller vga0(.active(blank_n), .vs(vs), .hs(hs), .clock(vga_clock), .reset_n(~rst_i), .x(x_raw), .y(y_raw));

endmodule
