..\asxmak\djgpp\exe\asst7 -lo st7gbl.asm
..\asxmak\djgpp\exe\asst7 -gloaxff st7seq.asm
..\asxmak\djgpp\exe\asxscn st7seq.lst
..\asxmak\djgpp\exe\aslink -u st7seq st7gbl st7seq
..\asxmak\djgpp\exe\asxscn -i st7seq.rst

