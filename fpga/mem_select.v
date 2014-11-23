module mem_select(address, flash, dram, sram, led_matrix, monitor, kbd, encoder, serial0, serial1);

input [31:0] address;
output flash;
output dram;
output sram;
output monitor;
output led_matrix;
output kbd;
output encoder;
output serial0;
output serial1;

// Simple memory map for now
assign monitor =     (address[31:24] == 'hff);
assign flash =       (address[31:24] == 'hfe);
assign led_matrix =  (address[31:16] == 'hfd00);
assign encoder =     (address[31:4]  == 'hfd02000);
assign serial0 =     (address[31:4]  == 'hfd02001);
assign serial1 =     (address[31:4]  == 'hfd02002);
assign kbd =         (address[31:4]  == 'hfd02003);
assign dram =        (address[31:24] == 'h01);
assign sram =        (address[31:24] == 'h00);

endmodule
