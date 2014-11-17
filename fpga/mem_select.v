module mem_select(address, flash, dram, sram, monitor);

input [31:0] address;
output flash;
output dram;
output sram;
output monitor;

// Simple memory map for now
assign monitor = (address[31:24] == 'hff);
assign flash = (address[31:24] == 'hfe);
assign sram = (address[31:24] == 'h00);
assign dram = (address[31:24] == 'h01);

endmodule
