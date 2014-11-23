..\asxmak\djgpp\exe\asst8 -lo st8gbl.asm
..\asxmak\djgpp\exe\asst8 -gloaxff tst8.asm
..\asxmak\djgpp\exe\asxscn -3 tst8.lst
..\asxmak\djgpp\exe\aslink -u tst8 st8gbl tst8
..\asxmak\djgpp\exe\asxscn -3 -i tst8.rst

