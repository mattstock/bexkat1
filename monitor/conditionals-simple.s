.globl main
main:
ldi %0, 0x1
ldi %1, 0x0
ldi %2, 0x50
ldi %3, 0xfffffffe
test1:
cmp %0, %0
bne foo
bgt foo
bgtu foo
blt foo
bltu foo
bltu .+8
test2:
cmp %0, %1
beq foo
blt foo
bltu foo
ble foo
bleu foo
test3:
cmp %0, %2
beq foo
bgt foo
bgtu foo
bge foo
bgeu foo
test4:
cmp %0, %3
beq foo
blt foo
ble foo
bgtu foo
bgeu foo
test5:
cmp %3, %0
beq foo
bgt foo
bge foo
bltu foo
bleu foo
nop
nop
nop
nop
nop
foo:
jmpd foo
