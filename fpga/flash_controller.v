module flash_controller(
  input clock,
  input reset_n,
  input [31:0] databus_in,
  output [31:0] databus_out,
  input read,
  input write,
  output wait_out,
  input [15:0] data_in,
  output [15:0] data_out,
  input [3:0] be_in,
  input [25:0] address_in,
  output [26:0] address_out,
  input ready,
  output wp_n,
  output oe_n,
  output we_n,
  output ce_n);

 // This controller will do the work related to page mode reads, etc.
 // the adapt32to16 will adjust for the bus widths by adding an additional bus cycle.
 assign wait_out = 1'b1;
 assign wp_n = 1'b0;
 assign oe_n = 1'b1;
 assign we_n = 1'b1;
 assign ce_n = 1'b1;
 assign databus_out = 32'h0;
 assign data_out = 16'h0;
 assign address_out = 27'h0;
  
endmodule
