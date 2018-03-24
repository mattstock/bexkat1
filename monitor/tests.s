	.set matrix_base,  0x3000c000
	.set seg_base,     0x30000000
	.set ssram_base,   0xc0000000
	.set ssram_test,   0xc0400000
	.set sdram_base,   0x00000000
	.set sdram_test,   0x07ff0000
#	.set sdram_test,   0x03ff0000
#	.set sdram_test,   0x00040000
	.set sw_base,      0x30001000
	.set sp_start,     0x08000000
	.set lcd_base,     0x30006000
	.set serial0_base, 0x30002000
	.set serial2_base, 0x3000e000
	
# reserve register 12,13 for the macros
	.macro print_test d,s=0
	ldi %13, \d
	lsli %13, %13, 16
	addi %13, %13, \s
	std.l %13, seg_base
	.endm

	.macro test_branch reg, val, dest
	ldiu %13, \val
	cmp \reg, %13
	beq \dest
	.endm

.globl main
main:
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
busypc:	ldd.l %1, serial2_base
	ldiu %2, 0x2000
	and %1, %1, %2
	cmp %1, %2
	bne busypc
	std.l %0, serial2_base
	addi %3, %3, 1
	cmp %3, %4
	bne wr
done:	halt

	.globl _exit
_exit:
	bra _exit

	.globl putchar
	rts
