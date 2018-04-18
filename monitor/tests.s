	.set seg_base,     0x30000000
	.set serial0_base, 0x3000e000
	
.globl main
main:
	ldi %15, 0x1000
	ldiu %0, 1
l:	std.l %0, seg_base
	lsri %1, %0, 4
	std.l %1, seg_base+4
	lsri %1, %0, 8
	std.l %1, seg_base+8
	lsri %1, %0, 12
	std.l %1, seg_base+12
	lsri %1, %0, 16
	std.l %1, seg_base+16
	lsri %1, %0, 20
	std.l %1, seg_base+20
	addi %0, %0, 1
	bra l
	halt
