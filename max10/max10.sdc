create_clock -name raw_clock_50 -period 20ns [get_ports {raw_clock_50[0]} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty

create_clock -period 100ns -name led_clk

create_generated_clock -name spi_sclk_reg -source pll0|altpll_component|auto_generated|pll1|clk[0] -divide_by 2 [get_registers {iocontroller:io0|spi_master:spi0|spi_xcvr:xcvr0|sclk}]
create_generated_clock -name sd_sclk_pin -source [get_registers {iocontroller:io0|spi_master:spi0|spi_xcvr:xcvr0|sclk}] [get_ports {sd_sclk}]
create_generated_clock -name rtc_sclk_pin -source [get_registers {iocontroller:io0|spi_master:spi0|spi_xcvr:xcvr0|sclk}] [get_ports {rtc_sclk}]
#create_generated_clock -name accel_sclk_pin -source [get_registers {iocontroller:io0|i2c_master_top:i2c2|i2c_master_byte_ctrl:byte_controller|i2c_master_bit_ctrl:bit_controller|scl_oen}] [get_ports {accel_sclk}]
#create_generated_clock -name codec_sclk_pin -source [get_registers {iocontroller:io0|i2c_master_top:i2c0|i2c_master_byte_ctrl:byte_controller|i2c_master_bit_ctrl:bit_controller|scl_oen}] [get_ports {codec_sclk}]
create_generated_clock -name sdram_clk_pin -source pll0|altpll_component|auto_generated|pll1|clk[0] -invert -add [get_ports sdram_clk]


# 0 - 100MHz

set_clock_groups -asynchronous -group { \
  pll0|altpll_component|auto_generated|pll1|clk[0]} -group { altera_reserved_tck }

# JTAG
set_input_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tdi ]
set_input_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tms ]
set_output_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tdo ]
  
# all async user input and really slow stuff
set_false_path -from [get_ports {key*}] -to *
set_false_path -from [get_ports {sw*}] -to *
set_false_path -from * -to [get_ports {ledr*}]
set_false_path -from * -to [get_ports {hex*}]
set_false_path -from [get_ports {serial*}] -to *
set_false_path -from * -to [get_ports {serial* vga_b[*] vga_r[*] vga_g[*] vga_hs vga_vs}]

set_multicycle_path -from [get_registers {*bexkat0|ir[*]}] -to [get_registers {*bexkat0|mdr[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|ir[*]}] -to [get_registers {*bexkat0|mdr[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|pc[*]}] -to [get_registers {*bexkat0|mdr[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|pc[*]}] -to [get_registers {*bexkat0|mdr[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|mar[*]}] -to [get_registers {*bexkat0|mdr[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|mar[*]}] -to [get_registers {*bexkat0|mdr[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|mdr[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|mdr[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|mar[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|mar[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|ir[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|ir[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|*alu0|out[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|con0|state*}] -to [get_registers {*bexkat0|*alu0|out[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|pc[*]}] -to [get_registers {*bexkat0|mar[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|pc[*]}] -to [get_registers {*bexkat0|mar[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|mar[*]}] -to [get_registers {*bexkat0|mar[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|mar[*]}] -to [get_registers {*bexkat0|mar[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|mar[*]}] -to [get_registers {*bexkat0|ir[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|mar[*]}] -to [get_registers {*bexkat0|ir[*]}] -hold -start 1
set_multicycle_path -from [get_registers {*bexkat0|pc[*]}] -to [get_registers {*bexkat0|ir[*]}] -setup -start 2
set_multicycle_path -from [get_registers {*bexkat0|pc[*]}] -to [get_registers {*bexkat0|ir[*]}] -hold -start 1

set_multicycle_path -through [get_pins -compatibility_mode {*intcalc*}] -setup -start 8
set_multicycle_path -through [get_pins -compatibility_mode {*intcalc*}] -hold -start 7
set_multicycle_path -through [get_pins -compatibility_mode {*fp_*}] -setup -start 8
set_multicycle_path -through [get_pins -compatibility_mode {*fp_*}] -hold -start 7

set_input_delay -clock codec_sclk_pin -min 0ns [get_ports codec_sclk]
set_input_delay -clock codec_sclk_pin -max 0ns [get_ports codec_sclk]
set_output_delay -clock codec_sclk_pin -min 0ns [get_ports codec_sclk]
set_output_delay -clock codec_sclk_pin -max 0ns [get_ports codec_sclk]

set_input_delay -clock sd_sclk_pin -min 0ns [get_ports sd_miso]
set_input_delay -clock sd_sclk_pin -max 0ns [get_ports sd_miso]
set_input_delay -clock rtc_sclk_pin -min 0ns [get_ports rtc_miso]
set_input_delay -clock rtc_sclk_pin -max 0ns [get_ports rtc_miso]
set_output_delay -clock sd_sclk_pin -min 0ns [get_ports sd_mosi]
set_output_delay -clock sd_sclk_pin -max 0ns [get_ports sd_mosi]
set_output_delay -clock rtc_sclk_pin -min 0ns [get_ports rtc_mosi]
set_output_delay -clock rtc_sclk_pin -max 0ns [get_ports rtc_mosi]
set_output_delay -clock sd_sclk_pin -min 0ns [get_ports sd_ss]
set_output_delay -clock sd_sclk_pin -max 0ns [get_ports sd_ss]
set_output_delay -clock rtc_sclk_pin -min 0ns [get_ports rtc_ss]
set_output_delay -clock rtc_sclk_pin -max 0ns [get_ports rtc_ss]
set_output_delay -clock pll0|altpll_component|auto_generated|pll1|clk[0] -max 0ns [get_ports sd_sclk]
set_output_delay -clock pll0|altpll_component|auto_generated|pll1|clk[0] -min 0ns [get_ports sd_sclk]
set_output_delay -clock pll0|altpll_component|auto_generated|pll1|clk[0] -max 0ns [get_ports rtc_sclk]
set_output_delay -clock pll0|altpll_component|auto_generated|pll1|clk[0] -min 0ns [get_ports rtc_sclk]
set_input_delay -clock sd_sclk_pin -min 0ns [get_ports sd_wp_n]
set_input_delay -clock sd_sclk_pin -max 0ns [get_ports sd_wp_n]

set_output_delay -clock sdram_clk_pin -min -0.8ns [get_ports {sdram_*}]
set_output_delay -clock sdram_clk_pin -max 1.5ns [get_ports {sdram_*}]
set_input_delay -clock sdram_clk_pin -min -0.8ns [get_ports {sdram_databus*}]
set_input_delay -clock sdram_clk_pin -max 1.5ns [get_ports {sdram_databus*}]

set_multicycle_path -from * -to [get_ports {matrix0[*] matrix1[*] matrix_a matrix_b matrix_c matrix_clk matrix_oe_n matrix_stb}] -setup -start 3
set_multicycle_path -from * -to [get_ports {matrix0[*] matrix1[*] matrix_a matrix_b matrix_c matrix_clk matrix_oe_n matrix_stb}] -hold -start 2
set_output_delay -clock led_clk -max 0ns [get_ports {matrix0[*]}]
set_output_delay -clock led_clk -min 0ns [get_ports {matrix0[*]}]
set_output_delay -clock led_clk -max 0ns [get_ports {matrix1[*]}]
set_output_delay -clock led_clk -min 0ns [get_ports {matrix1[*]}]
set_output_delay -clock led_clk -max 0ns [get_ports matrix_a]
set_output_delay -clock led_clk -min 0ns [get_ports matrix_a]
set_output_delay -clock led_clk -max 0ns [get_ports matrix_b]
set_output_delay -clock led_clk -min 0ns [get_ports matrix_b]
set_output_delay -clock led_clk -max 0ns [get_ports matrix_c]
set_output_delay -clock led_clk -min 0ns [get_ports matrix_c]
set_output_delay -clock led_clk -max 0ns [get_ports matrix_oe_n]
set_output_delay -clock led_clk -min 0ns [get_ports matrix_oe_n]
set_output_delay -clock led_clk -max 0ns [get_ports matrix_stb]
set_output_delay -clock led_clk -min 0ns [get_ports matrix_stb]
set_output_delay -clock led_clk -max 0ns [get_ports matrix_clk]
set_output_delay -clock led_clk -min 0ns [get_ports matrix_clk]


