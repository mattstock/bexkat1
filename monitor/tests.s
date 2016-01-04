.globl main
main:
	ldi %sp, 0x08000000	# reset to known stack
	ldi %14, 0x20000000	# base matrix
	ldi %13, 0x00000100     # test number
	ldiu %0, 0x0
	std.l %0, 0x20000000
	std.l %0, 0x20000004
	std.l %0, 0x20000008
	std.l %0, 0x20000010
	std.l %0, 0x20000018
	std.l %0, 0x2000001c

# register based tests
	
# mov.l, com, neg
t1:	std.l %13, 0x30000000
	ldi %0, 0xff00ff00
	mov.l %1, %0
	cmp %0, %1
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	com %1, %0
	ldi %2, 0x00ff00ff
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %0, 0x12f8
	ldi %2, 0xffffed08
	neg %1, %0
	cmp %1, %2
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# ext.b, mov.b
t2:	std.l %13, 0x30000000
	ldi %0, 0x123454f5
	ldi %2, 0xfffffff5
	ext.b %1, %0
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %2, 0x000000f5
	mov.b %1, %0
	cmp %1, %2
	bne fail
	ldi %0, 0x12345465
	ldi %2, 0x00000065
	ext.b %1, %0
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	mov.b %1, %0
	cmp %1, %2
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# ext, mov
t3:	std.l %13, 0x30000000
	ldi %0, 0x123484f5
	ldi %2, 0xffff84f5
	ext %1, %0
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %2, 0x000084f5
	mov %1, %0
	cmp %1, %2
	bne fail
	ldi %0, 0x12345465
	ldi %2, 0x00005465
	ext %1, %0
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	mov %1, %0
	cmp %1, %2
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# ALU reg ops

# add, sub, lsl, asr, lsr
t4:	std.l %13, 0x30000000
	ldi %0, 0x30005006
	ldi %1, 0x00000004
	add %2, %0, %1
	ldi %3, 0x3000500a
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	sub %2, %0, %1
	ldi %3, 0x30005002
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	lsl %2, %0, %1
	ldi %3, 0x00050060
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	asr %2, %0, %1
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	lsr %2, %0, %1
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %0, 0x90040500
	asr %2, %0, %1
	ldi %3, 0xf9004050
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	lsr %2, %0, %1
	ldi %3, 0x09004050
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000	
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# or, and, xor
t5:	std.l %13, 0x30000000
	ldi %0, 0x30f05006
	ldi %1, 0x00ff0004
	or %2, %0, %1
	ldi %3, 0x30ff5006
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	and %2, %0, %1
	ldi %3, 0x00f00004
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	xor %2, %0, %1
	ldi %3, 0x300f5002
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# add, sub, lsl, asr, lsr immediate
t6:	std.l %13, 0x30000000
	ldi %0, 0x30005006
	addi %2, %0, 4
	ldi %3, 0x3000500a
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	subi %2, %0, 4
	ldi %3, 0x30005002
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	lsli %2, %0, 4
	ldi %3, 0x00050060
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	asri %2, %0, 4
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	lsri %2, %0, 4
	ldi %3, 0x03000500
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %0, 0x90040500
	asri %2, %0, 4
	ldi %3, 0xf9004050
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	lsri %2, %0, 4
	ldi %3, 0x09004050
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000	
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# or, and, xor
t7:	std.l %13, 0x30000000
	ldi %0, 0x30f05006
	ori %2, %0, 0x00f4
	ldi %3, 0x30f050f6
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	andi %2, %0, 0x00f4
	ldi %3, 0x00000004
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	xori %2, %0, 0x00f4
	ldi %3, 0x30f050f2
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100
	
# register/memory tests

# relative read/write word with 0 offset
t8:	std.l %13, 0x30000000
	ldi %1, 0x00001000
	ldi %2, 0xaabb33dd
	st.l %2, (%1)
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	addi %13, %13, 0x100

# relative r/w word with pos offset
t9:	std.l %13, 0x30000000
	ldi %1, 0x00001000
	ldi %2, 0x5533ddf3
	st.l %2, 8(%1)
	ld.l %0, 8(%1)
	cmp %2, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	addi %1, %1, 8
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100
	
# relative r/w word with neg offset
ta:	std.l %13, 0x30000000
	ldi %1, 0x00001000
	ldi %2, 0x6627df87
	st.l %2, -12(%1)
	ld.l %0, -12(%1)
	cmp %2, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	subi %1, %1, 12
	ld.l %0, (%1)
	cmp %2, %0
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# relative r/w half word with offsets
tb:	std.l %13, 0x30000000
	ldi %1, 0x00002000
	ldi %2, 0x6627df87
	ldi %3, 0x0000df87
	ldi %4, 0x11223344
	st.l %4, (%1)
	st %2, (%1)
	ld %0, (%1)
	cmp %3, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ld.l %0, (%1)
	ldi %4, 0xdf873344
	cmp %4, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	st %2, 2(%1)
	ld.l %0, (%1)
	ldi %4, 0xdf87df87
	cmp %4, %0
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# relative r/w byte with offsets
tc:	std.l %13, 0x30000000
	ldi %1, 0x00003000
	ldi %2, 0x6627df87
	ldi %4, 0x11223344
	st.l %4, (%1)
	st.b %2, (%1)
	ld.b %0, (%1)
	ldi %3, 0x00000087
	cmp %3, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ld.l %0, (%1)
	ldi %3, 0x87223344
	cmp %3, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	st.b %2, 1(%1)
	ld.l %0, (%1)
	ldi %3, 0x87873344
	cmp %3, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	st.b %2, 2(%1)
	ld.l %0, (%1)
	ldi %3, 0x87878744
	cmp %3, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	st.b %2, 3(%1)
	ld.l %0, (%1)
	ldi %3, 0x87878787
	cmp %3, %0
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100
	
# push/pop stack test
td:	std.l %13, 0x30000000
	ldi %0, 0x00ffff00
	ldi %1, 0x07fffff8
	push %0
	push %1
	cmp %sp, %1
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	pop %2
	cmp %2, %1
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	pop %2
	cmp %2, %0
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %1, 0x08000000
	cmp %sp, %1
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# jmp, jmpd, jsr, jsrd, rts
te:	std.l %13, 0x30000000
	ldi %0, jmppos
	ldi %1, jsrpos
	jmp (%0)
	bra fail
jmppos:	addi %13, %13, 1
	std.l %13, 0x30000000
	jmpd j2pos
	bra fail
j2pos:	addi %13, %13, 1
	std.l %13, 0x30000000
	jsr (%1)
	ldi %2, 0x08000000
	cmp %sp, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	jsrd jsrpos
	ldi %2, 0x08000000
	cmp %sp, %2
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# mul, div, mod
tf:	std.l %13, 0x30000000
	ldi %0, 154780
	ldi %1, 4039
	mulu %2, %1, %0
	ldi %3, 625156420
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	divu %2, %0, %1
	ldi %3, 38
	cmp %2, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	modu %2, %0, %1
	ldi %3, 1298
	cmp %2, %3
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# cvtis, cvtsi
t10:	std.l %13, 0x30000000
	ldi %0, -30
	cvtis %1, %0
	ldi %2, 0xc1f00000
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldiu %0, 25
	cvtis %1, %0
	ldi %2, 0x41c80000
	cmp %1, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %0, 0xc0c11687
	cvtsi %1, %0
	ldi %2, -6
	cmp %1, %2
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# float math
t11:	std.l %13, 0x30000000
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
	addi %13, %13, 1
	std.l %13, 0x30000000
	mul.s %10, %0, %1
	cmp.s %10, %2
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	div.s %10, %0, %1
	cmp.s %10, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	add.s %10, %0, %1
	cmp.s %10, %4
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	sub.s %10, %0, %1
	cmp.s %10, %5
	bne fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# branch tests 
t12:	std.l %13, 0x30000000
	ldi %0, -10
	ldi %1, 20
	ldi %2, 6
	ldi %3, -8
	cmp %0, %1
	brn fail
	addi %13, %13, 1
	std.l %13, 0x30000000
# (-10 and 20)	
	beq fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bleu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bltu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bge fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bgt fail
	addi %13, %13, 1
	std.l %13, 0x30000000
# (20 and 6)
	cmp %1, %2
	beq fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bleu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bltu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ble fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	blt fail
	addi %13, %13, 1
	std.l %13, 0x30000000
# (6 and -8)
	cmp %2, %3
	beq fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bgeu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bgtu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ble fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	blt fail
	addi %13, %13, 1
	std.l %13, 0x30000000

# (-8 and -20)
	cmp %3, %0
	beq fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bleu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bltu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	ble fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	blt fail
	addi %13, %13, 1
	std.l %13, 0x30000000

# (-8 and -8)
	cmp %3, %3
	bne fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	blt fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bltu fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bgt fail
	addi %13, %13, 1
	std.l %13, 0x30000000
	bgtu fail
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# block memory test
t13:	std.l %13, 0x30000000
	ldi %0, 0xff
	std.l %0, 0x20000000
	ldi %0, 0x01234567
	ldi %1, 0x00000000
	ldi %2, 0x08000000
loop1:	st.l %0, (%1)
	addi %1, %1, 4
	addi %0, %0, 3
	cmp %1, %2
	bne loop1
	ldi %0, 0xff00
	std.l %0, 0x20000000
	ldi %0, 0x01234567
	ldi %1, 0x00000000
	ldi %2, 0x08000000
loop2:	ld.l %3, (%1)
	cmp %0, %3
	bne fail
	addi %1, %1, 4
	addi %0, %0, 3
	cmp %1, %2
	bne loop2
	
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100

# individual memory test
t14:	std.l %13, 0x30000000
	ldi %0, 0xff
	std.l %0, 0x20000004
	ldi %0, 0x01234567
	ldi %1, 0x00000000
	ldi %2, 0x08000000
loop3:	st.l %0, (%1)
	ld.l %3, (%1)
	cmp %0, %3
	bne fail
	addi %1, %1, 4
	addi %0, %0, 7
	cmp %1, %2
	bne loop3
	ldi %0, 0xffffff00
	and %13, %13, %0
	addi %13, %13, 0x100
	ldi %0, 0xff00
	std.l %0, 0x20000004	

# semi-random cache memory test
t15:	std.l %13, 0x30000000
	ldi %0, 0xff
	std.l %0, 0x20000010
	ldi %1, 0x00000000
	ldi %2, 0x00001000
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
	ldi %0, 0xff00
	std.l %0, 0x20000010
	ldi %0, 0xff
	std.l %0, 0x20000014
	ldi %1, 0x00000000
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
	ldi %0, 0xff00
	std.l %0, 0x20000014
	ldi %0, 0xff
	std.l %0, 0x20000018
	ldi %1, 0x00000000
	ldi %4, 0x00002000
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
	ldi %0, 0xff00
	std.l %0, 0x20000018
	ldi %0, 0xff
	std.l %0, 0x2000001c
	ldi %1, 0x00000000
	ldi %4, 0x00002000
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
	ldi %0, 0xff00
	std.l %0, 0x2000001c
	
	bra pass
	
jsrpos:	addi %13, %13, 1
	std.l %13, 0x30000000
	ldi %2, 0x07fffffc
	cmp %sp, %2
	bne fail
	rts
	bra fail
	
fail:	ldi %0, 0xff0000
	std.l %0, 0x20000008
	bra fail

pass:	ldiu %0, 0xff
	std.l %0, 0x20000008
	bra pass	
	
