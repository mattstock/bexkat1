create_clock -name CLOCK_50 -period 20ns [get_ports {CLOCK_50} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty

