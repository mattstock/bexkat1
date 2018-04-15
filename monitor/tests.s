	.set seg_base,     0x30000000
	.set serial0_base, 0x3000e000
	
.globl main
main:
	ldi %15, 0x8000
	ldiu %0, 1
l2:	std.l %0, seg_base
	nop
	nop
	nop
	nop
	nop
	std.l %0, seg_base+4
	nop
	nop
	nop
	nop
	std.l %0, seg_base+8
	nop
	nop
	nop
	nop
	nop
	std.l %0, seg_base+12
	nop
	nop
	nop
	nop
	std.l %0, seg_base+16
	nop
	nop
	nop
	nop
	nop
	addi %0, %0, 1
	nop
	nop
	nop
	nop
	nop
	nop
	bra l2
	nop
	nop
	nop
	
	
l:	bsr putchar
	nop
	nop
	nop
	nop
	nop
	bra l
	nop
	nop
	nop
	nop
	nop
	nop
	halt

foo:
	ldiu %2, 0x8000
	ldiu %3, 0
	ldiu %4, 4
busygc:	ldd.l %1, serial0_base
	and %1, %1, %2
	cmp %1, %2
	bne busygc
	ldd.l %0, serial0_base
	st.b %0, (%3)
	addi %3, %3, 1
	cmp %3, %4
	bne busygc
	ldiu %3, 0

wr:	ld.b %0, (%3)
	addi %3, %3, 1
	cmp %3, %4
	bne wr
done:	halt

	.globl _exit
_exit:
	bra _exit

.globl putchar
putchar:
	push %1
	push %2
	ldd.l %1, serial0_base
	ldiu %2, 0x2000
	and %1, %1, %2
	cmp %1, %2
	bne putchar
	std.l %0, serial0_base
	pop %2
	pop %1
	rts
