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
	ldiu %0, 0x2000
	ldiu %6, 'a'
busy:	ldd.l %1, serial2_base
	and %1, %1, %0
	cmp %1, %0
	bne busy
	std.l %6, serial2_base
done:	bra busy

	.globl _exit
_exit:
	bra _exit
