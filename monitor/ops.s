foo:
mov %30, %31
push %30
pop %29
cmp %30,%30
inc %30
cmp %30,%31
dec %29
com %30, %30
neg %29, %29
add %30, %29, %31
mul %30, %29, %31
ldiu %30, 0xf234
bra bar
nop
nop
bar:
ldis %29, 0xf234
addi %29, %29, 0x10
muli %30, %29, 0x12345678
jsrd fooble
jmpd foo

fooble:
ldi %30, 0x12345678
std.l %30, 0x00000000
ldd.l %29, 0x00000000
rts
