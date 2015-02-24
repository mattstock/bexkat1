ldi %30, 0x00ffffff
std.l %30, 0x00800000
std.b %30, 0x00800004
std.b %30, 0x00800006
foo:
jmpd foo
