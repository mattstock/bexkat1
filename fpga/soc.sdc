create_clock -name clock_50 -period 20ns [get_ports {clock_50} ] -waveform {0 10}

#set_clock_groups -asynchronous -group {clock_50} -group { altera_reserved_tck }

derive_pll_clocks
derive_clock_uncertainty

# all async user input stuff
set_false_path -from [get_ports {KEY*}] -to *
set_false_path -from [get_ports {SW*}] -to *
set_false_path -from * -to [get_ports {LED*}]
set_false_path -from * -to [get_ports {HEX*}]
set_false_path -from [get_ports {serial*}] -to *
set_false_path -from * -to [get_ports {serial*}]
set_false_path -from * -to [get_ports {rgb[*]}]
set_false_path -from [get_ports {pb}] -to *
set_false_path -from [get_ports {quad[*]}] -to *

#set_multicycle_path -from * -to [get_registers {mycpu:cpu0|ccr[*]}] -setup -start 2
#set_multicycle_path -from * -to [get_registers {mycpu:cpu0|ccr[*]}] -hold -start 1

#set_multicycle_path -through [get_pins -compatibility_mode {*intcalc*}] -setup -start 8
#set_multicycle_path -through [get_pins -compatibility_mode {*intcalc*}] -hold -start 7

#create_generated_clock -name spi_sclk_reg -source clock_50 -divide_by 100 [get_registers {spi_master:spi0|spi_xcvr:xcvr0|sclk}]
#create_generated_clock -name spi_sclk_pin -source [get_registers {spi_master:spi0|spi_xcvr:xcvr0|sclk}] [get_ports {sclk}]
#set_output_delay -clock spi_sclk_pin -min 0ns [get_ports mosi]
#set_output_delay -clock spi_sclk_pin -max 0ns [get_ports mosi]
#set_output_delay -clock spi_sclk_pin -min 0ns [get_ports ss_sdcard]
#set_output_delay -clock spi_sclk_pin -max 0ns [get_ports ss_sdcard]
#set_output_delay -clock spi_sclk_pin -min 0ns [get_ports ss_ethernet]
#set_output_delay -clock spi_sclk_pin -max 0ns [get_ports ss_ethernet]
#set_output_delay -clock clock_50 -max 0ns [get_ports sclk]
#set_output_delay -clock clock_50 -min 0ns [get_ports sclk]
#set_input_delay -clock spi_sclk_pin -min 0ns [get_ports miso]
#set_input_delay -clock spi_sclk_pin -max 0ns [get_ports miso]

#create_clock -name ssram_clk -period 10ns
#set_output_delay -clock ssram_clk -max 0ns [get_ports {fs_databus*}]
#set_output_delay -clock ssram_clk -min 0ns [get_ports {fs_databus*}]
#set_output_delay -clock ssram_clk -max 0ns [get_ports {fs_addrbus*}]
#set_output_delay -clock ssram_clk -min 0ns [get_ports {fs_addrbus*}]
#set_output_delay -clock ssram_clk -max 0ns [get_ports ssram0_ce_n]
#set_output_delay -clock ssram_clk -min 0ns [get_ports ssram0_ce_n]
#set_output_delay -clock ssram_clk -max 0ns [get_ports ssram1_ce_n]
#set_output_delay -clock ssram_clk -min 0ns [get_ports ssram1_ce_n]
#set_output_delay -clock ssram_clk -max 0ns [get_ports ssram_gw_n]
#set_output_delay -clock ssram_clk -min 0ns [get_ports ssram_gw_n]
#set_output_delay -clock ssram_clk -max 0ns [get_ports ssram_oe_n]
#set_output_delay -clock ssram_clk -min 0ns [get_ports ssram_oe_n]
#set_output_delay -clock ssram_clk -max 0ns [get_ports ssram_adsp_n]
#set_output_delay -clock ssram_clk -min 0ns [get_ports ssram_adsp_n]

#create_generated_clock -name led_clk -master_clock clock_50 -source clock_50 -divide_by 4 [get_registers {led_matrix:led0|state.STATE_CLOCK} ]
#create_generated_clock -name led_clk_pin -source [get_registers {led_matrix:led0|state.STATE_CLOCK} ] [get_ports {rgb_clk}]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports {rgb0[*]}]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports {rgb0[*]}]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports {rgb1[*]}]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports {rgb1[*]}]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports rgb_a]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports rgb_a]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports rgb_b]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports rgb_b]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports rgb_c]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports rgb_c]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports rgb_oe_n]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports rgb_oe_n]
#set_output_delay -clock led_clk_pin -max 0ns [get_ports rgb_stb]
#set_output_delay -clock led_clk_pin -min 0ns [get_ports rgb_stb]
#set_output_delay -clock clock_50 -max 0ns [get_ports rgb_clk]
#set_output_delay -clock clock_50 -min 0ns [get_ports rgb_clk]


#create_clock -name dram_clk -period 20ns
#set_output_delay -clock dram_clk -max 0ns [get_ports {dram_*}]
#set_output_delay -clock dram_clk -min 0ns [get_ports {dram_*}]
#set_input_delay -clock dram_clk -max 0ns [get_ports {dram_dq[*]}]
#set_input_delay -clock dram_clk -min 0ns [get_ports {dram_dq[*]}]

#create_clock -name flash_clk -period 20ns
#set_output_delay -clock flash_clk -max 0ns [get_ports {fl_*}]
#set_output_delay -clock flash_clk -min 0ns [get_ports {fl_*}]
#set_input_delay -clock flash_clk -max 0ns [get_ports {fl_databus[*]}]
#set_input_delay -clock flash_clk -min 0ns [get_ports {fl_databus[*]}]
#set_multicycle_path -setup -to [get_ports {fl_addrbus[*] fl_databus[*]}] 3
#set_multicycle_path -hold -to [get_ports {fl_addrbus[*] fl_databus[*]}] 2
