ldi %30, 0x00000003
ldi %29, 0x00000006
mul %28, %30, %29
muli %29, %28, 0x4000
muli %30, %30, 0x2000
divi %30, %30, 0x2000
ldi %28, 0x00001000
modi %30, %28, 0x0006
foo:
jmpd foo
