.align 4
.type _start,@function
_start:
ldsp 0x00004000
ldi %30, 0xabcdef12
ldi %14, 0x01234567
push %30
push %14
jsrd foo
pop %27
pop %13
.L4:
jmpd .L4
rts
.Lf5:
.size _start,.Lf5-_start
.align 4
.type foo,@function
foo:
push %30
pop %29
rts
.Lf7:
.size foo,.Lf7-foo
