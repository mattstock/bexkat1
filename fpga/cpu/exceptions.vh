`ifndef _EXCEPTIONS_VH
 `define _EXCEPTIONS_VH

 // exception names
localparam EXC_RESET = 4'h0, EXC_MMU = 4'h1, EXC_TIMER0 = 4'h2, EXC_TIMER1 = 4'h3, EXC_TIMER2 = 4'h4, EXC_TIMER3 = 4'h5, EXC_UART0_RX = 4'h6, EXC_UART0_TX = 4'h7,
  EXC_ILLOP = 4'h8, EXC_CPU1 = 4'h9, EXC_CPU2 = 4'ha, EXC_CPU3 = 4'hb, EXC_TRAP0 = 4'hc, EXC_TRAP1 = 4'hd, EXC_TRAP2 = 4'he, EXC_TRAP3 = 4'hf;

`endif
