create_clock -name raw_clock_50 -period 20ns [get_ports {raw_clock_50} ] -waveform {0 500}

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -asynchronous -group { \
  pll0|altpll_component|auto_generated|pll1|clk[0]} -group { altera_reserved_tck }

# JTAG
set_input_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tdi ]
set_input_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tms ]
set_output_delay -clock altera_reserved_tck 20 [ get_ports altera_reserved_tdo ]
  
# all async user input and really slow stuff
set_false_path -from [get_ports {KEY*}] -to *
set_false_path -from [get_ports {SW* irda_rxd ps2kbd*}] -to *
set_false_path -from * -to [get_ports {LED*}]
set_false_path -from * -to [get_ports {HEX*}]
set_false_path -from [get_ports {serial*}] -to *
set_false_path -from * -to [get_ports {serial* vga_b[*] vga_r[*] vga_g[*] vga_blank_n vga_clock vga_hs vga_vs}]
set_false_path -from * -to [get_ports {fan_ctrl lcd_data[*] lcd_e lcd_on lcd_rs lcd_rw}] 

set_input_delay -clock ssram_clk_pin -max 3.2ns [get_ports {fs_databus*}]
set_input_delay -clock ssram_clk_pin -min 0ns [get_ports {fs_databus*}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fs_databus*}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fs_databus*}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fs_addrbus*}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fs_addrbus*}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {ssram*}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {ssram*}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fl_oe_n}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fl_oe_n}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fl_we_n}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fl_we_n}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fl_ce_n}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fl_ce_n}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fl_rst_n}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fl_rst_n}]
set_output_delay -clock ssram_clk_pin -max 1.4ns [get_ports {fl_wp_n}]
set_output_delay -clock ssram_clk_pin -min -0.4ns [get_ports {fl_wp_n}]

set_output_delay -clock sdram_clk_pin -min -0.8ns [get_ports {sdram_*}]
set_output_delay -clock sdram_clk_pin -max 1.5ns [get_ports {sdram_*}]
set_input_delay -clock sdram_clk_pin -min -0.8ns [get_ports {sdram_databus*}]
set_input_delay -clock sdram_clk_pin -max 1.5ns [get_ports {sdram_databus*}]
