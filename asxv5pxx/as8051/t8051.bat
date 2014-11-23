as8051 -gloaxff t8051
asxscn t8051.lst
as8051 -gloaxff t8051r
asxscn t8051r.lst
as8051 -gloaxff t8051rl
aslink -u t8051rl
asxscn t8051rl.rst

