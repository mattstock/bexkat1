module mmu(
  input [31:0] adr_i,
  input cyc_i,
  output cache_enable,
  output fault,
  output [3:0] chipselect);

reg [3:0] cs;
reg c, f;

assign cache_enable = (cyc_i ? c : 1'b1);
assign fault = (cyc_i ? f : 1'b0);
assign chipselect = (cyc_i ? cs : 4'h0);

always @*
begin
  f = 1'b0;
  c = 1'b1;
  
  if (adr_i >= 32'h00000000 && adr_i <= 32'h07ffffff)
    cs = 4'h7; // 128MB (32M x 32) SDRAM
  else if (adr_i >= 32'h20000000 && adr_i <= 32'h200007ff)
    cs = 4'h5; // LED matrix
  else if (adr_i >= 32'h20000800 && adr_i <= 32'h20000fff) begin
    cs = 4'h4; // IO
    c = 1'b0;
  end else if (adr_i >= 32'hb0000000 && adr_i <= 32'hbfffffff) begin
    cs = 4'h9; // VGA
    c = 1'b0;
  end else if (adr_i >= 32'hc0000000 && adr_i <= 32'hc03fffff)
    cs = 4'h6; // 4MB (1M x 32) SSRAM
  else if (adr_i >= 32'hc0400000 && adr_i <= 32'hc0400fff)
    cs = 4'ha; // VGA controller
  else if (adr_i >= 32'hd0000000 && adr_i <= 32'hdfffffff)
    cs = 4'h3; // mandelbrot
  else if (adr_i >= 32'he0000000 && adr_i <= 32'hefffffff)
    cs = 4'h8; // 64MB (32M x 16) FLASH
  else if (adr_i >= 32'hffff0000 && adr_i <= 32'hffffffbf)
    cs = 4'h2; // 16k x 32 internal ROM
  else if (adr_i >= 32'hffffffc0 && adr_i <= 32'hffffffff)
    cs = 4'h1; // interrupt vector
  else begin
    f = 1'b1;
    cs = 4'h0;
  end
end

endmodule
