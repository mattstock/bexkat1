module businterface(
  input [3:0] sel,
  input [31:0] cpu_o,
  output [31:0] cpu_i,
  output [31:0] dat_o,
  input [31:0] dat_i);

always_comb
begin
  case (sel)
    4'b1111: begin
      dat_o = cpu_o;
      cpu_i = dat_i;
    end
    4'b0011: begin
      dat_o = cpu_o;
      cpu_i = { 16'h0000, dat_i[15:0] };
    end 
    4'b1100: begin
      dat_o = { cpu_o[15:0], 16'h0000 };
      cpu_i = { 16'h0000, dat_i[31:16] };
    end
    4'b0001: begin
      dat_o = cpu_o;
      cpu_i = { 24'h000000, dat_i[7:0] };
    end
    4'b0010: begin
      dat_o = { 16'h0000, cpu_o[7:0], 8'h00 };
      cpu_i = { 24'h000000, dat_i[15:8] };
    end
    4'b0100: begin
      dat_o = { 8'h00, cpu_o[7:0], 16'h0000 };
      cpu_i = { 24'h000000, dat_i[23:16] };
    end
    4'b1000: begin
      dat_o = { cpu_o[7:0], 24'h000000 };
      cpu_i = { 24'h000000, dat_i[31:24] };
    end
    default: begin // really these are invalid
      dat_o = cpu_o;
      cpu_i = dat_i;
    end
  endcase
end

endmodule
 
