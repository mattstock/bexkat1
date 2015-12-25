.globl main
main:
ldi %0, foo
nop
jsr (%0)
nop
nop
.a:
bra .a

.globl foo
foo:
nop
rts

