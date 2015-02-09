create_clock -name "clock_50" -period 20ns [get_ports {clock_50} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty

# all async user input stuff
set_false_path -from [get_ports {KEY*}] -to *
set_false_path -from [get_ports {SW*}] -to *

create_generated_clock -name spi_sclk_reg -source clock_50 -divide_by 100 [get_registers {spi_master:spi0|spi_xcvr:xcvr0|sclk}]
create_generated_clock -name spi_sclk_pin -source [get_registers {spi_master:spi0|spi_xcvr:xcvr0|sclk}] [get_ports {sclk}]

create_generated_clock -name sram_write_clk -source [get_fanins {sram_we_n}] [get_ports {sram_we_n}]

create_clock -name sram_clk_in -period 20ns
create_clock -name sram_clk_out -period 20ns

set_output_delay -clock sram_clk_out -max 18ns [get_ports {sram_addrbus*}]
set_output_delay -clock sram_clk_out -min 0ns [get_ports {sram_addrbus*}]
set_input_delay -clock sram_clk_in -max 18ns [get_ports {sram_databus*}]
set_input_delay -clock sram_clk_in -min 12ns [get_ports {sram_databus*}]
set_output_delay -clock sram_write_clk -max 18ns [get_ports {sram_databus*}]
set_output_delay -clock sram_write_clk -min 8ns [get_ports {sram_databus*}] 

