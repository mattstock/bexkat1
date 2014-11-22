module mem_select(address, flash, dram, sram, led_matrix, monitor, kbd);

input [31:0] address;
output flash;
output dram;
output sram;
output monitor;
output led_matrix;
output kbd;

// Simple memory map for now
assign monitor =     (address[31:24] == 'hff);
assign flash =       (address[31:24] == 'hfe);
assign led_matrix =  (address[31:16] == 'hfd00);
assign kbd =         (address[31:16] == 'hfd01); // we have address space to burn 
assign dram =        (address[31:24] == 'h01);
assign sram =        (address[31:24] == 'h00);

endmodule
