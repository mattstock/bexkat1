`timescale 1ns / 1ns

module cputest(
  input clk_i,
  input rst_i,
  input [31:0] adr1,
  input cyc1,
  input we1,
  input halt1,
  input int1,
  input [3:0] ex1,
  input [31:0] dat1,
  input [3:0] sel1,
  input [31:0] adr2,
  input cyc2,
  input we2,
  input halt2,
  input int2,
  input [3:0] ex2,
  input [31:0] dat2,
  input [3:0] sel2,
  output reg fail);

// We want the test to only output on a clock cycle, but the tests can be combinatorial
reg fail_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
    fail <= 1'b0;
  else
    fail <= fail_next;
end

wire success = (adr1 == adr2) && (dat1 == dat2) && (sel1 == sel2) &&
               (cyc1 == cyc2) && (we1 == we2) && (halt1 == halt2) &&
               (int1 == int2) && (ex1 == ex2);

assign fail_next = ~success;

endmodule
