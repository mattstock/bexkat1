	.set seg_base,     0x30000000
	.set serial0_base, 0x30002000
	.set timers_base,  0x30008000
.globl main
main:
	# config timer0 interrupt
	ldi %0, 0x70
	ldi %1, timers_base
	st.l %0, 16(%1)
	ldi %0, 0x11
	st.l %0, (%1)

	# Set up for stack tests
	ldiu %0, 0x0
	mov.l %14, %15
	subi %13, %14, 4
	subi %12, %13, 4
	subi %11, %12, 4
	subi %10, %11, 4
	subi %9, %10, 4
	subi %8, %9, 4
	
	# enable timer interrupt
	sti
	
l:	bsr doop
	addi %0, %0, 1
	# should be at the top of the stack
	cmp %15, %14
	bne fail
	push %1
	# one more deep
	cmp %15, %13
	bne fail
	bsr printhex
	# one more deep
	cmp %15, %13
	bne fail
	pop %1
	# should be at the top of the stack
	cmp %15, %14
	bne fail

	bra l
	halt

fail:	halt
	
doop:	# we should be one deep in the stack
	cmp %15, %13
	bne fail
	rts
	
.globl _vectors_start
_vectors_start:
	jmpd fail # RESET
	jmpd fail # MMU
	jmpd timer0 # TIMER0
	jmpd fail # TIMER1
	jmpd fail # TIMER2
	jmpd fail # TIMER3
	jmpd fail # UART0_RX
	jmpd fail # UART0_TX
	jmpd fail # ILLOP
	jmpd fail # CPU1
	jmpd fail # CPU2
	jmpd fail # CPU3
	jmpd fail # TRAP0
	jmpd fail # TRAP1
	jmpd fail # TRAP2
	jmpd fail # TRAP3

.globl timer0
timer0:
	ldi %6, timers_base
	ldi %5, 0x70
	ld.l %4, 48(%6)
	add %5, %5, %4
	st.l %5, 16(%6)
	ldiu %5, 0x01
	st.l %5, 4(%6)
	rti
	halt
	halt
	halt

.globl printhex
printhex:
	cmp %15, %12
	bne fail
	push %1
	push %2
	cmp %15, %10
	bne fail
	ldi %2, seg_base
	andi %1, %0, 0xf
	st.l %1, (%2)
	lsri %1, %0, 4
	andi %1, %1, 0xf
	st.l %1, 4(%2)
	lsri %1, %0, 8
	andi %1, %1, 0xf
	st.l %1, 8(%2)
	lsri %1, %0, 12
	andi %1, %1, 0xf
	st.l %1, 12(%2)
	lsri %1, %0, 16
	andi %1, %1, 0xf
	st.l %1, 16(%2)
	lsri %1, %0, 20
	andi %1, %1, 0xf
	st.l %1, 20(%2)
	pop %2
	pop %1
	cmp %15, %12
	bne fail
	rts

	halt
	halt
	halt
	
getchar:
	push %1
	push %2
	push %3
	ldi %2, 0x8000
gc_l:	ldd.l %1, serial0_base
	and %3, %1, %2
	cmp %3, %2
	bne gc_l
	andi %0, %1, 0xff
	pop %3
	pop %2
	pop %1
	rts

	halt
	halt
putchar:
	push %1
	push %2
	ldiu %2, 0x2000
pc_l:	ldd.l %1, serial0_base
	and %1, %1, %2
	cmp %1, %2
	bne pc_l
	std.l %0, serial0_base
	pop %2
	pop %1
	rts

	halt
	halt
	
