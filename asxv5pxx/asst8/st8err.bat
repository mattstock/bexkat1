..\asxmak\djgpp\exe\asst8 -lov st8gbl.asm
..\asxmak\djgpp\exe\asst8 -glovaxff st8err.asm
..\asxmak\djgpp\exe\asxscn -3 st8err.lst
..\asxmak\djgpp\exe\aslink -u st8err st8gbl st8err
..\asxmak\djgpp\exe\asxscn -3 -i st8err.rst

