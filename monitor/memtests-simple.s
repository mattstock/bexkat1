.globl main
main:
ldi %0, 0x11223344
ldi %1, 0x00010000
st.l %0, (%1) 
st.l %0, 3(%1) 
st.l %0, -3(%1) 
ldi %1, 0x55667788
ldi %2, 0x99aabbcc
ldi %3, 0xddeeff00
std.b %0, 0x00000000
std.b %1, 0x00000001
std.b %2, 0x00000002
std.b %3, 0x00000003
ldd.l %3, 0x00000000
std %0, 0x00000000
std %1, 0x00000002
ldd.l %3, 0x00000000
std.l %0, 0x00000000
ldd %1, 0x00000000
ldd %2, 0x00000002
ldd.b %3, 0x00000000
ldd.b %3, 0x00000001
ldd.b %3, 0x00000002
ldd.b %3, 0x00000003
.globl wordy
wordy:
ldi %0,0x00000000
std.l %0, 0x00000000
std.l %0, 0x00000004
std.l %0, 0x00000008
std.l %0, 0x0000000c
std.l %0, 0x00000010
std.l %0, 0x00000014
std.l %0, 0x00000018
std.l %0, 0x0000001c
ldi %1, 0x11223344
std.l %1, 0x00000000
ldd.l %0, 0x00000000
ldd.l %0, 0x00000004
ldd.l %0, 0x00000008
ldd.l %0, 0x0000000c
ldd.l %0, 0x00000010
ldd.l %0, 0x00000014
ldd.l %0, 0x00000018
ldd.l %0, 0x0000001c
ldi %1, 0x55667788
std.l %1, 0x00000004
ldd.l %0, 0x00000000
ldd.l %0, 0x00000004
ldd.l %0, 0x00000008
ldd.l %0, 0x0000000c
ldd.l %0, 0x00000010
ldd.l %0, 0x00000014
ldd.l %0, 0x00000018
ldd.l %0, 0x0000001c
ldi %1, 0x99aabbcc
std.l %1, 0x00000008
ldd.l %0, 0x00000000
ldd.l %0, 0x00000004
ldd.l %0, 0x00000008
ldd.l %0, 0x0000000c
ldd.l %0, 0x00000010
ldd.l %0, 0x00000014
ldd.l %0, 0x00000018
ldd.l %0, 0x0000001c
ldi %1, 0xddeeff00
std.l %1, 0x0000000c
ldd.l %0, 0x00000000
ldd.l %0, 0x00000004
ldd.l %0, 0x00000008
ldd.l %0, 0x0000000c
ldd.l %0, 0x00000010
ldd.l %0, 0x00000014
ldd.l %0, 0x00000018
ldd.l %0, 0x0000001c
foo:
jmpd foo
