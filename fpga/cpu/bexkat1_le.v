`timescale 1ns / 1ns

module bexkat1_le(
  input csi_clk,
  input rsi_reset_n,
  input avm_m0_waitrequest,
  output [31:0] avm_m0_address,
  output avm_m0_read,
  input [15:0] avm_m0_readdata,
  output [15:0] avm_m0_writedata,
  output avm_m0_write,
  output [1:0] avm_m0_byteenable);

wire [15:0] readdata_be, writedata_be;
wire [1:0] byteenable_be;

assign avm_m0_byteenable = { byteenable_be[0], byteenable_be[1] };
assign avm_m0_writedata = { writedata_be[7:0], writedata_be[15:8] };
assign readdata_be = { avm_m0_readdata[7:0], avm_m0_readdata[15:8] };

bexkat1 bexkat0(.csi_clk(csi_clk), .rsi_reset_n(rsi_reset_n), .avm_m0_waitrequest(avm_m0_waitrequest),
  .avm_m0_address(avm_m0_address), .avm_m0_read(avm_m0_read), .avm_m0_write(avm_m0_write),
  .avm_m0_readdata(readdata_be), .avm_m0_writedata(writedata_be), .avm_m0_byteenable(byteenable_be));
endmodule
