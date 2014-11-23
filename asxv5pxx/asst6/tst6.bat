..\asxmak\djgpp\exe\asst6 -lo st6gbl.asm
..\asxmak\djgpp\exe\asst6 -gloaxff st6seq.asm
..\asxmak\djgpp\exe\asxscn st6seq.lst
..\asxmak\djgpp\exe\aslink -u st6seq st6gbl st6seq
..\asxmak\djgpp\exe\asxscn -i st6seq.rst

