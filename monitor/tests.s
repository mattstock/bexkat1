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
	ldiu %0, 0
	movsr %0
	ldi %sp, sp_start	# reset to known stack
	ldd.l %0, sw_base
	ldi %0, 0
	std.l %0, matrix_base
	std.l %0, sw_base
	test_branch %0, 0, reg_tests
	test_branch %0, 2, alu_tests
	test_branch %0, 4, mem_tests
	test_branch %0, 8, fp_tests
	bra main
	
# register based tests
	
reg_tests:	
# mov.l, com, neg
t1:	print_test 1,1
	ldi %0, 0xff00ff00
	mov.l %1, %0
	cmp %0, %1
	bne fail
	print_test 1,2
	com %1, %0
	ldi %2, 0x00ff00ff
	cmp %1, %2
	bne fail
	print_test 1,3
	ldi %0, 0x12f8
	ldi %2, 0xffffed08
	neg %1, %0
	cmp %1, %2
	bne fail

# ext.b, mov.b
t2:	print_test 2,1
	ldi %0, 0x123454f5
	ldi %2, 0xfffffff5
	ext.b %1, %0
	cmp %1, %2
	bne fail
	print_test 2,2
	ldi %2, 0x000000f5
	mov.b %1, %0
	cmp %1, %2
	bne fail
	print_test 2,3
	ldi %0, 0x12345465
	ldi %2, 0x00000065
	ext.b %1, %0
	cmp %1, %2
	bne fail
	print_test 2,4
	mov.b %1, %0
	cmp %1, %2
	bne fail

# ext, mov
t3:	print_test 3,1
	ldi %0, 0x123484f5
	ldi %2, 0xffff84f5
	ext %1, %0
	cmp %1, %2
	bne fail
	print_test 3,2
	ldi %2, 0x000084f5
	mov %1, %0
	cmp %1, %2
	bne fail
	ldi %0, 0x12345465
	ldi %2, 0x00005465
	ext %1, %0
	cmp %1, %2
	bne fail
	print_test 3,2
	mov %1, %0
	cmp %1, %2
	bne fail

# ALU reg ops

alu_tests:
	
# add, sub, lsl, asr, lsr
t4:	print_test 4,1
	ldi %0, 0x30005006
	ldi %1, 0x00000004
	add %2, %0, %1
	ldi %3, 0x3000500a
	cmp %2, %3
	bne fail
	print_test 4,2
	addi %13, %13, 1
	sub %2, %0, %1
	ldi %3, 0x30005002
	cmp %2, %3
	bne fail
	print_test 4,3
	lsl %2, %0, %1
	ldi %3, 0x00050060
	cmp %2, %3
	bne fail
	print_test 4,4
	asr %2, %0, %1
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	print_test 4,5
	lsr %2, %0, %1
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	print_test 4,6
	ldi %0, 0x90040500
	asr %2, %0, %1
	ldi %3, 0xf9004050
	cmp %2, %3
	bne fail
	print_test 4,7
	lsr %2, %0, %1
	ldi %3, 0x09004050
	cmp %2, %3
	bne fail

# or, and, xor
t5:	print_test 5,1
	ldi %0, 0x30f05006
	ldi %1, 0x00ff0004
	or %2, %0, %1
	ldi %3, 0x30ff5006
	cmp %2, %3
	bne fail
	print_test 5,2
	and %2, %0, %1
	ldi %3, 0x00f00004
	cmp %2, %3
	bne fail
	print_test 5,3
	xor %2, %0, %1
	ldi %3, 0x300f5002
	cmp %2, %3
	bne fail

# add, sub, lsl, asr, lsr immediate
t6:	print_test 6,1
	ldi %0, 0x30005006
	addi %2, %0, 4
	ldi %3, 0x3000500a
	cmp %2, %3
	bne fail
	print_test 6,2
	subi %2, %0, 4
	ldi %3, 0x30005002
	cmp %2, %3
	bne fail
	print_test 6,3
	lsli %2, %0, 4
	ldi %3, 0x00050060
	cmp %2, %3
	bne fail
	print_test 6,4
	asri %2, %0, 4
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	print_test 6,5
	lsri %2, %0, 4
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	print_test 6,6
	ldi %0, 0x90040500
	asri %2, %0, 4
	ldi %3, 0xf9004050
	cmp %2, %3
	bne fail
	print_test 6,7
	lsri %2, %0, 4
	ldi %3, 0x09004050
	cmp %2, %3
	bne fail
	print_test 6,8

# or, and, xor
t7:	print_test 7,1
	ldi %0, 0x30f05006
	ori %2, %0, 0x00f4
	ldi %3, 0x30f050f6
	cmp %2, %3
	bne fail
	print_test 7,2
	andi %2, %0, 0x00f4
	ldi %3, 0x00000004
	cmp %2, %3
	bne fail
	print_test 7,3
	xori %2, %0, 0x00f4
	ldi %3, 0x30f050f2
	cmp %2, %3
	bne fail
	
# register/memory tests

mem_tests:	
# relative read/write word with 0 offset
t8:	print_test 8,1
	ldi %1, sdram_base+0x1000
	ldi %2, 0xaabb33dd
	st.l %2, (%1)
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	print_test 8,2
	ldi %1, ssram_base+0x1000
	ldi %2, 0xaabb33dd
	st.l %2, (%1)
	ld.l %0, (%1)
	cmp %2, %0
	bne fail

# relative r/w word with pos offset
t9:	print_test 9,1
	ldi %1, sdram_base+0x200
	ldi %2, 0x5533ddf3
	st.l %2, 8(%1)
	ld.l %0, 8(%1)
	cmp %2, %0
	bne fail
	print_test 9,2
	addi %1, %1, 8
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	print_test 9,3
	ldi %1, ssram_base+0x200
	ldi %2, 0x5533ddf3
	st.l %2, 8(%1)
	ld.l %0, 8(%1)
	cmp %2, %0
	bne fail
	print_test 9,4
	addi %1, %1, 8
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	
# relative r/w word with neg offset
ta:	print_test 10,1
	ldi %1, sdram_base+0x300
	ldi %2, 0x6627df87
	st.l %2, -12(%1)
	ld.l %0, -12(%1)
	cmp %2, %0
	bne fail
	print_test 10,2
	subi %1, %1, 12
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	print_test 10,3
	ldi %1, ssram_base+0x300
	ldi %2, 0x6627df87
	st.l %2, -12(%1)
	ld.l %0, -12(%1)
	cmp %2, %0
	bne fail
	print_test 10,4
	subi %1, %1, 12
	ld.l %0, (%1)
	cmp %2, %0
	bne fail

# relative r/w half word with offsets
tb:	print_test 11,1
	ldi %1, sdram_base+0x400
	ldi %2, 0x6627df87
	ldi %3, 0x0000df87
	ldi %4, 0x11223344
	st.l %4, (%1)
	st %2, (%1)
	ld %0, (%1)
	cmp %3, %0
	bne fail
	print_test 11,2
	ld.l %0, (%1)
	ldi %4, 0xdf873344
	cmp %4, %0
	bne fail
	print_test 11,3
	st %2, 2(%1)
	ld.l %0, (%1)
	ldi %4, 0xdf87df87
	cmp %4, %0
	bne fail
	print_test 11,4
	ldi %1, sdram_base+0x400
	ldi %2, 0x6627df87
	ldi %3, 0x0000df87
	ldi %4, 0x11223344
	st.l %4, (%1)
	st %2, (%1)
	ld %0, (%1)
	cmp %3, %0
	bne fail
	print_test 11,5
	ld.l %0, (%1)
	ldi %4, 0xdf873344
	cmp %4, %0
	bne fail
	print_test 11,6
	st %2, 2(%1)
	ld.l %0, (%1)
	ldi %4, 0xdf87df87
	cmp %4, %0
	bne fail

# relative r/w byte with offsets
tc:	print_test 12,1
	ldi %1, sdram_base+0x500
	ldi %2, 0x6627df87
	ldi %4, 0x11223344
	st.l %4, (%1)
	st.b %2, (%1)
	ld.b %0, (%1)
	ldi %3, 0x00000087
	cmp %3, %0
	bne fail
	print_test 12,2
	ld.l %0, (%1)
	ldi %3, 0x87223344
	cmp %3, %0
	bne fail
	print_test 12,3
	st.b %2, 1(%1)
	ld.l %0, (%1)
	ldi %3, 0x87873344
	cmp %3, %0
	bne fail
	print_test 12,4
	st.b %2, 2(%1)
	ld.l %0, (%1)
	ldi %3, 0x87878744
	cmp %3, %0
	bne fail
	print_test 12,5
	st.b %2, 3(%1)
	ld.l %0, (%1)
	ldi %3, 0x87878787
	cmp %3, %0
	bne fail
	print_test 12,6
	ldi %1, sdram_base+0x500
	ldi %2, 0x6627df87
	ldi %4, 0x11223344
	st.l %4, (%1)
	st.b %2, (%1)
	ld.b %0, (%1)
	ldi %3, 0x00000087
	cmp %3, %0
	bne fail
	print_test 12,7
	ld.l %0, (%1)
	ldi %3, 0x87223344
	cmp %3, %0
	bne fail
	print_test 12,8
	st.b %2, 1(%1)
	ld.l %0, (%1)
	ldi %3, 0x87873344
	cmp %3, %0
	bne fail
	print_test 12,9
	st.b %2, 2(%1)
	ld.l %0, (%1)
	ldi %3, 0x87878744
	cmp %3, %0
	bne fail
	print_test 12,10
	st.b %2, 3(%1)
	ld.l %0, (%1)
	ldi %3, 0x87878787
	cmp %3, %0
	bne fail

# push/pop stack test
td:	print_test 13,1
	ldi %sp, sp_start
	ldi %0, sp_start-4
	ldi %1, sp_start-8
	push %0
	push %1
	cmp %sp, %1
	bne fail
	print_test 13,2
	pop %2
	cmp %2, %1
	bne fail
	print_test 13,3
	pop %2
	cmp %2, %0
	bne fail
	print_test 13,4
	ldi %1, sp_start
	cmp %sp, %1
	bne fail

# jmp, jmpd, jsr, jsrd, rts
te:	print_test 14,1
	ldi %0, jmppos
	ldi %1, jsrpos
	jmp (%0)
	bra fail
jmppos:	print_test 14,2
	jmpd j2pos
	bra fail
j2pos:	print_test 14,3
	jsr (%1)
	ldi %2, 0x08000000
	cmp %sp, %2
	bne fail
	print_test 14,4
	jsrd jsrpos
	ldi %2, 0x08000000
	cmp %sp, %2
	bne fail

# mul, div, mod
tf:	print_test 15,1
	ldi %0, 154780
	ldi %1, 4039
	mulu %2, %1, %0
	ldi %3, 625156420
	cmp %2, %3
	bne fail
	print_test 15,2
	divu %2, %0, %1
	ldi %3, 38
	cmp %2, %3
	bne fail
	print_test 15,3
	modu %2, %0, %1
	ldi %3, 1298
	cmp %2, %3
	bne fail

fp_tests:	
# cvtis, cvtsi
t10:	print_test 16,1
	ldi %0, -30
	cvtis %1, %0
	ldi %2, 0xc1f00000
	cmp %1, %2
	bne fail
	print_test 16,2
	ldiu %0, 25
	cvtis %1, %0
	ldi %2, 0x41c80000
	cmp %1, %2
	bne fail
	print_test 16,3
	ldi %0, 0xc0c11687
	cvtsi %1, %0
	ldi %2, -6
	cmp %1, %2
	bne fail

# float math
t11:	print_test 17,1
	ldi %0, 0x420eaf0a         # 35.670937
	ldi %1, 0x427537cf         # 61.3045
	ldi %2, 0x4508aca0         # 2186.789 (mul)
	ldi %3, 0x3f14f519         # 0.5818649 (div)
	ldi %4, 0x42c1f36c         # 96.97543 (add)
	ldi %5, 0xc1cd118a         # -25.633562 (sub)
	ldi %6, 0xc20eaf0a         # -35.670937 (neg)
	neg.s %10, %0
	cmp.s %10, %6
	bne fail
	print_test 17,2
	mul.s %10, %0, %1
	cmp.s %10, %2
	bne fail
	print_test 17,3
	div.s %10, %0, %1
	cmp.s %10, %3
	bne fail
	print_test 17,4
	add.s %10, %0, %1
	cmp.s %10, %4
	bne fail
	print_test 17,5
	sub.s %10, %0, %1
	cmp.s %10, %5
	bne fail

# branch tests 
t12:	print_test 18,1
	ldi %0, -10
	ldi %1, 20
	ldi %2, 6
	ldi %3, -8
	cmp %0, %1
	brn fail
	print_test 18,2
# (-10 and 20)	
	beq fail
	print_test 18,3
	bleu fail
	print_test 18,4
	bltu fail
	print_test 18,5
	bge fail
	print_test 18,6
	bgt fail
	print_test 18,7
# (20 and 6)
	cmp %1, %2
	beq fail
	print_test 18,8
	bleu fail
	print_test 18,9
	bltu fail
	print_test 18,10
	ble fail
	print_test 18,11
	blt fail
	print_test 18,12
# (6 and -8)
	cmp %2, %3
	beq fail
	print_test 18,13
	bgeu fail
	print_test 18,14
	bgtu fail
	print_test 18,15
	ble fail
	print_test 18,16
	blt fail
	print_test 18,17
# (-8 and -20)
	cmp %3, %0
	beq fail
	print_test 18,18
	bleu fail
	print_test 18,19
	bltu fail
	print_test 18,20
	ble fail
	print_test 18,21
	blt fail
	print_test 18,22
# (-8 and -8)
	cmp %3, %3
	bne fail
	print_test 18,23
	blt fail
	print_test 18,24
	bltu fail
	print_test 18,25
	bgt fail
	print_test 18,26
	bgtu fail
	print_test 18,27

# cache test
t16:    print_test 22,1
	ldi %0, 0x336699aa
	ldi %1, sdram_base
        st.l %0, (%1)
	ldi %0, 0x44008811
	ldi %1, sdram_base+0x8000
        st.l %0, (%1)
	ldi %0, 0xaaeeffcc
	ldi %1, sdram_base+0x10000
        st.l %0, (%1)
	ldi %0, 0xdeadbeef
	ldi %1, sdram_base+0x18000
        st.l %0, (%1)
	ldi %0, 0x01234567
	ldi %1, sdram_base+0x0020
        st.l %0, (%1)
	ldi %0, 0x94837264
	ldi %1, sdram_base+0x10020
        st.l %0, (%1)
	ldi %0, 0x336699aa
	ldi %1, sdram_base
	ld.l %2, (%1)
	cmp %0, %2
	bne fail
	print_test 22,2
	ldi %0, 0x44008811
	ldi %1, sdram_base+0x8000
	ld.l %2, (%1)
	cmp %0, %2
	bne fail
	print_test 22,3
	ldi %0, 0xaaeeffcc
	ldi %1, sdram_base+0x10000
	ld.l %2, (%1)
	cmp %0, %2
	bne fail
	print_test 22,4
	ldi %0, 0xdeadbeef
	ldi %1, sdram_base+0x18000
	ld.l %2, (%1)
	cmp %0, %2
	bne fail
	print_test 22,5
	ldi %0, 0x01234567
	ldi %1, sdram_base+0x0020
	ld.l %2, (%1)
	cmp %0, %2
	bne fail
	print_test 22,6
	ldi %0, 0x94837264
	ldi %1, sdram_base+0x10020
	ld.l %2, (%1)
	cmp %0, %2
	bne fail

# block memory test
t13:	print_test 19,1
	ldi %0, 0x01234567
	ldi %1, sdram_base
	ldi %2, sdram_test
loop1:	st.l %0, (%1)
	addi %1, %1, 4
	addi %0, %0, 3
	cmp %1, %2
	bne loop1
	ldi %0, 0x01234567
	ldi %1, sdram_base
loop2:	ld.l %3, (%1)
	cmp %0, %3
	bne fail
	addi %1, %1, 4
	addi %0, %0, 3
	cmp %1, %2
	bne loop2
	print_test 19,2
	ldi %0, 0x22334447
	ldi %1, ssram_base
	ldi %2, ssram_test
t13l3:	st.l %0, (%1)
	addi %1, %1, 4
	addi %0, %0, 3
	cmp %1, %2
	bne t13l3
	ldi %0, 0x22334447
	ldi %1, ssram_base
t13l4:	ld.l %3, (%1)
	cmp %0, %3
	bne fail
	addi %1, %1, 4
	addi %0, %0, 3
	cmp %1, %2
	bne t13l4

# individual memory test
t14:	print_test 20,1
	ldi %0, 0x01234567
	ldi %1, sdram_base
	ldi %2, sdram_test
loop3:	st.l %0, (%1)
	ld.l %3, (%1)
	cmp %0, %3
	bne fail
	addi %1, %1, 4
	addi %0, %0, 7
	cmp %1, %2
	bne loop3

# semi-random cache memory test
t15:	print_test 21,1
	ldi %1, sdram_base
	ldi %2, sdram_test
	ldi %6, 0xffff
t15l1:	mov.b %3, %1
	mov.b %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	xor %0, %0, %1 
	or %0, %0, %3
	st %0, (%1)
	and %0, %0, %6
	ld %4, (%1)
	cmp %0, %4
	bne fail
	addi %1, %1, 4
	cmp %1, %2
	bne t15l1
	print_test 21,2
	ldi %1, sdram_base
t15l2:	mov.b %3, %1
	mov.b %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	xor %0, %0, %1 
	or %0, %0, %3
	and %0, %0, %6
	ld %4, (%1)
	cmp %0, %4
	bne fail
	addi %1, %1, 4
	cmp %1, %2
	bne t15l2
	print_test 21,3
	ldi %1, sdram_base
	ldi %4, sdram_test
	ldiu %6, 0xff
t15l3:	mov.b %3, %1
	mov.b %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	xor %0, %0, %1 
	or %0, %0, %3
	st.b %0, (%1)
	and %0, %0, %6
	ld.b %2, (%1)
	cmp %0, %2
	bne fail
	addi %1, %1, 4
	cmp %1, %4
	bne t15l3
	print_test 21,4
	ldi %1, sdram_base
	ldi %4, sdram_test
t15l4:	mov.b %3, %1
	mov.b %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	or %0, %0, %3
	lsli %0, %0, 8
	xor %0, %0, %1 
	or %0, %0, %3
	and %0, %0, %6
	ld.b %2, (%1)
	cmp %0, %2
	bne fail
	addi %1, %1, 4
	cmp %1, %4
	bne t15l4
	bra pass
	
jsrpos:	ldi %2, 0x07fffffc
	cmp %sp, %2
	bne fail
	rts
	bra fail
	
fail:	ldi %0, 0x01
	std.l %0, sw_base
	ldi %0, 0xff0000
	std.l %0, matrix_base
	ldi %13, 0x00803010
	jsrd print_matrix
	bra fail

pass:	ldi %0, 0x02
	std.l %0, sw_base
	ldi %0, 0xff00
	std.l %0, matrix_base
	bra pass	

# print %1 in binary on the second line of matrix
# use the contents of %13 as the color
print_matrix:
	push %1
	ldi %13, 0xff
	ldiu %12, 0
	ldi %11, matrix_base+(32*4)
	ldi %10, 32
	lsli %9, %10, 2
	add %9, %11, %9
mp1:	subi %9, %9, 4
	st.l %12, (%9)
	andi %8, %1, 0x1
	cmp  %12, %8
	beq mp2
	st.l %13, (%9)
mp2:	lsri %1, %1, 1
	cmp %9, %11
	bne mp1
	pop %1
	rts
	
putchar:
	ldi %11, 0
busy:	ldd.l %10, serial0_base
	andi %10, %10, 0x2000
	cmp %11, %10
	bne busy
	std.l %0, serial0_base
	rts
