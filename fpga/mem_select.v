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
assign monitor =     (address >= 'hffc00000);
assign led_matrix =  (address >= 'hff400100 && address <= 'hff4013ff);
assign kbd =         (address >= 'hff400030 && address <= 'hff40003f);
assign serial1 =     (address >= 'hff400020 && address <= 'hff40002f);
assign serial0 =     (address >= 'hff400010 && address <= 'hff40001f);
assign encoder =     (address >= 'hff400000 && address <= 'hff40000f);
assign flash =       (address >= 'hfe000000 && address <= 'hfe3fffff);
assign dram =        (address >= 'h00800000 && address <= 'h00ffffff);
assign sram =        (address >= 'h00000000 && address <= 'h0007ffff);
assign invalid = ~|{monitor, led_matrix, kbd, serial0, serial1, encoder, flash, dram, sram};
endmodule
