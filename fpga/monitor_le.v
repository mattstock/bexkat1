module monitor_le(
  input csi_clk,
  input rsi_reset_n,
  output [31:0] avs_s0_readdata,
  input [12:0] avs_s0_address);

wire [31:0] readdata_be;

assign avs_s0_readdata = { readdata_be[7:0], readdata_be[15:8], readdata_be[23:16], readdata_be[31:24] };

monitor mem0(.clock(csi_clk), .address(avs_s0_address), .q(readdata_be));
  
endmodule
  