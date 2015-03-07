.align 4
.type _start,@function
_start:
ldi %30, 0xabcdef12
ldi %14, 0x01234567
push %30
push %14
jsrd foo
.L4:
jmpd .L4
rts
.Lf5:
.size _start,.Lf5-_start
.align 4
.type foo,@function
foo:
pop %29
pop %28
pop %27
pop %13
.L10:
bra .L10
.Lf7:
.size foo,.Lf7-foo
