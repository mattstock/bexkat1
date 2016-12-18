module mmu(
  input [31:0] adr_i,
  input cyc_i,
  output cache_enable,
  output fault,
  output [3:0] chipselect);

logic [3:0] cs;
logic c, f;

assign cache_enable = (cyc_i ? c : 1'b1);
assign fault = (cyc_i ? f : 1'b0);
assign chipselect = (cyc_i ? cs : 4'h0);

always_comb
begin
  f = 1'b0;
  c = 1'b1;
  
  case (adr_i[31:28])
    4'h0: cs = 4'h7; // 128MB (32M x 32) SDRAM
    4'h2: cs = 4'h5; // LED matrix
    4'h3: begin
      cs = 4'h4; // IO
      c = 1'b0;
    end
    4'h7: cs = 4'h2; // monitor
    4'h8: cs = 4'ha; // VGA controller
    4'hc: cs = 4'h6; // 4MB (1M x 32) SSRAM
    4'hd: cs = 4'h3; // mandelbrot
    4'he: cs = 4'h8; // 64MB (32M x 16) FLASH
    4'hf: cs = 4'h1; // vectors
    default: begin
      cs = 4'h0;
      f = 1'h1;
    end
  endcase
end

endmodule
