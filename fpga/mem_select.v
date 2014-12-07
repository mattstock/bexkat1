module mem_select(address, flash, dram, sram, led_matrix, monitor, kbd, encoder, serial0, serial1, invalid);

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
output invalid;

// Simple memory map for now
assign monitor =     (address[31:24] == 'hff && address[23:22] == 2'b11);
assign led_matrix =  (address[31:12] == 'hff401 && address[11:10] == 2'b00);
assign kbd =         (address[31:4]  == 'hff40003);
assign serial1 =     (address[31:4]  == 'hff40002);
assign serial0 =     (address[31:4]  == 'hff40001);
assign encoder =     (address[31:4]  == 'hff40000);
assign flash =       (address[31:24] == 'hfe && address[23:22] == 2'b00);
assign dram =        (address[31:24] == 'h00 && address[23] == 1'b1);
assign sram =        (address[31:20] == 'h000 && address[19:18] == 2'b00);
assign invalid = ~|{monitor, led_matrix, kbd, serial0, serial1, encoder, flash, dram, sram};
endmodule
