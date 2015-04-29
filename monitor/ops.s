foo:
ldis %29, 0xf000
ldiu %30, 0xa000
or %28, %30, %29
and %28, %30, %29
sub %28, %30, %29
xor %28, %30, %29
ldiu %29, 0x0003
lsl %28, %30, %29
lsr %28, %30, %29
asr %28, %30, %29
div %28, %30, %29
mod %28, %30, %29
mulu %28, %30, %29
divu %28, %30, %29
modu %28, %30, %29
andi %28, %30, 0xffff
ori %28, %30, 0xffff
addi %28, %30, 0x20000000
subi %28, %30, 0x20000000
lsli %28, %30, 0x2
asri %28, %29, 0x3
lsri %28, %29, 0x3
xori %28, %29, 0xffff
muli %28, %30, 0x0002
divi %28, %30, 0x0002
modi %28, %30, 0x0002
muliu %28, %29, 0x0002
diviu %28, %29, 0x0002
modiu %28, %29, 0x0002
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
