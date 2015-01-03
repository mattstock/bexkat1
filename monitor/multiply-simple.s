ldi %13, 0x00000003
ldi %14, 0x00000006
mul %31, %13, %14
mul %31, %31, 0x4000
mul %13, 0x2000
foo:
jmp foo
