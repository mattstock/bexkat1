.globl main
main:
ldi %1, 0x11223344
ldi %2, 0x00ffff00
std.l %1, 0x00000000
ldd.l %0, 0x00000000
std.l %2, 0x00000000
ldd.l %0, 0x00000000
ldd.l %0, 0x00002000
std.l %1, 0x00002000
ldd.l %0, 0x00000000
ldd.l %0, 0x00002000
.a:
bra .a
