create_clock -name raw_clock_50 -period 20ns [get_ports {raw_clock_50[0]} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty

create_clock -period 100ns -name led_clk

# 0 - 10MHz
# 1 - 25Mhz

set_clock_groups -asynchronous -group { pll0|altpll_component|auto_generated|pll1|clk[0]} -group { pll0|altpl_component|auto_generated|pll|clk[1] } -group { altera_reserved_tck }

# JTAG
set_input_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tdi ]
set_input_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tms ]
set_output_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tdo ]
  
# all async user input and really slow stuff
set_false_path -from [get_ports {key*}] -to *
set_false_path -from [get_ports {sw*}] -to *
set_false_path -from [get_ports {ard_reset_n*}] -to *
set_false_path -from * -to [get_ports {ledr*}]
set_false_path -from * -to [get_ports {hex*}]
set_false_path -from [get_ports {serial*}] -to *
set_false_path -from * -to [get_ports {serial* vga_b[*] vga_r[*] vga_g[*] vga_hs vga_vs}]

set_multicycle_path -through [get_pins -compatibility_mode {*intcalc*}] -setup -start 8
set_multicycle_path -through [get_pins -compatibility_mode {*intcalc*}] -hold -start 7
#set_multicycle_path -through [get_pins -compatibility_mode {*fp_*}] -setup -start 8
#set_multicycle_path -through [get_pins -compatibility_mode {*fp_*}] -hold -start 7
