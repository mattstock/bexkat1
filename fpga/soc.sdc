create_clock -name "clock_50" -period 20ns [get_ports {clock_50} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty

create_generated_clock -name spi_sclk_reg -source clock_50 -divide_by 100 [get_registers {spi_master:spi0|spi_xcvr:xcvr0|sclk}]
create_generated_clock -name spi_sclk_pin -source [get_registers {spi_master:spi0|spi_xcvr:xcvr0|sclk}] [get_ports {sclk}]
