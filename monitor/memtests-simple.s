.globl main
main:
ldi %29,0x00000000
std.l %29, 0x00000000
std.l %29, 0x00000004
std.l %29, 0x00000008
std.l %29, 0x0000000c
std.l %29, 0x00000010
std.l %29, 0x00000014
std.l %29, 0x00000018
std.l %29, 0x0000001c
ldi %30, 0x11223344
std.l %30, 0x00000000
ldd.l %31, 0x00000000
ldd.l %31, 0x00000004
ldd.l %31, 0x00000008
ldd.l %31, 0x0000000c
ldd.l %31, 0x00000010
ldd.l %31, 0x00000014
ldd.l %31, 0x00000018
ldd.l %31, 0x0000001c
ldi %30, 0x55667788
std.l %30, 0x00000004
ldd.l %31, 0x00000000
ldd.l %31, 0x00000004
ldd.l %31, 0x00000008
ldd.l %31, 0x0000000c
ldd.l %31, 0x00000010
ldd.l %31, 0x00000014
ldd.l %31, 0x00000018
ldd.l %31, 0x0000001c
ldi %30, 0x99aabbcc
std.l %30, 0x00000008
ldd.l %31, 0x00000000
ldd.l %31, 0x00000004
ldd.l %31, 0x00000008
ldd.l %31, 0x0000000c
ldd.l %31, 0x00000010
ldd.l %31, 0x00000014
ldd.l %31, 0x00000018
ldd.l %31, 0x0000001c
ldi %30, 0xddeeff00
std.l %30, 0x0000000c
ldd.l %31, 0x00000000
ldd.l %31, 0x00000004
ldd.l %31, 0x00000008
ldd.l %31, 0x0000000c
ldd.l %31, 0x00000010
ldd.l %31, 0x00000014
ldd.l %31, 0x00000018
ldd.l %31, 0x0000001c
foo:
jmpd foo
