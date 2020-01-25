create_clock -name CLOCK_50 -period 20ns [get_ports {CLOCK_50} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -asynchronous -group { \
  pll0|syspll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -group { altera_reserved_tck }

# all async user input and really slow stuff
set_false_path -from [get_ports {KEY*}] -to *
set_false_path -from [get_ports {SW* PS2*}] -to *
set_false_path -from * -to [get_ports {LED*}]
set_false_path -from * -to [get_ports {HEX* matrix*}]
set_false_path -from [get_ports {serial*}] -to *
set_false_path -from * -to [get_ports {serial* VGA_B[*] VGA_R[*] VGA_G[*] VGA_BLANK_N VGA_CLK VGA_HS VGA_VS}]

create_clock -name sdram_clk_pin -period 100ns

set_output_delay -clock sdram_clk_pin -min -0.8ns [get_ports {DRAM_ADDR*}]
set_output_delay -clock sdram_clk_pin -max 1.5ns [get_ports {DRAM_ADDR*}]
set_output_delay -clock sdram_clk_pin -min -0.8ns [get_ports {DRAM_DQ*}]
set_output_delay -clock sdram_clk_pin -max 1.5ns [get_ports {DRAM_DQ*}]
set_input_delay -clock sdram_clk_pin -min -0.8ns [get_ports {DRAM_DQ*}]
set_input_delay -clock sdram_clk_pin -max 1.5ns [get_ports {DRAM_DQ*}]
