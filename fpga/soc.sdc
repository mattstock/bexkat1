create_clock -name "clock_50" -period 20ns [get_ports {clock_50} ] -waveform {0 10}

derive_pll_clocks
derive_clock_uncertainty
