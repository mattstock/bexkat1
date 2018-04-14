	.set matrix_base,  0x3000c000
	.set seg_base,     0x30000000
	.set ssram_base,   0xc0000000
	.set ssram_test,   0xc0400000
	.set sdram_base,   0x00000000
	.set sdram_test,   0x07ff0000
	.set sw_base,      0x30001000
	.set sp_start,     0x08000000
	.set lcd_base,     0x30006000
	.set serial0_base, 0x30002000
	.set serial2_base, 0x3000e000
	
.globl main
main:
	ldi %15, 0x8000
	ldiu %0, 'a'
	bsr putchar
	halt

foo:
	ldiu %2, 0x8000
	ldiu %3, 0
	ldiu %4, 4
busygc:	ldd.l %1, serial2_base
	and %1, %1, %2
	cmp %1, %2
	bne busygc
	ldd.l %0, serial2_base
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
	ldd.l %1, serial2_base
	ldiu %2, 0x2000
	and %1, %1, %2
	cmp %1, %2
	bne putchar
	std.l %0, serial2_base
	pop %2
	pop %1
	rts
