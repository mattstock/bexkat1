.align 2
.type _start,@function
_start:
ldi %30, 0x55553333
push %30
pop %29
jsrd foo
.L4:
jmpd .L4
rts
.Lf5:
.size _start,.Lf5-_start
.align 2
.type foo,@function
foo:
rts
.Lf7:
.size foo,.Lf7-foo
