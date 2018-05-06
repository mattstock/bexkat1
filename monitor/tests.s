	.set seg_base,     0x30000000
	.set serial0_base, 0x30002000
	.set timers_base,  0x30008000
.globl main
main:
	# config timer0 interrupt
	ldiu %0, 0
	std.l %0, 0x0
	ldi %0, 0x300
	ldi %1, timers_base
	st.l %0, 16(%1)
	ldi %0, 0x11
	st.l %0, (%1)

	ldiu %0, 0x7777
	ldiu %1, 0x1111
	ldiu %2, 0x2222
	
	sti
l:	bsr doathing
	push %0
	ldiu %0, 0x3333
	pop %0
	ldiu %3, 0x7777
	cmp %0, %3
	bne fail
	ldiu %3, 0x1111
	cmp %1, %3
	bne fail
	ldiu %3, 0x2222
	cmp %2, %3
	bne fail
	bra l
	halt

doathing:
	push %0
	mov.l %0, %4
	bsr printhex
	pop %0
	ldiu %3, 0x7777
	cmp %0, %3
	bne fail
	ldiu %3, 0x1111
	cmp %1, %3
	bne fail
	ldiu %3, 0x2222
	cmp %2, %3
	bne fail
	rts
	
.globl _vectors_start
_vectors_start:
	jmpd _start # RESET
	jmpd _start # MMU
	jmpd timer0 # TIMER0
	jmpd _start # TIMER1
	jmpd _start # TIMER2
	jmpd _start # TIMER3
	jmpd _start # UART0_RX
	jmpd _start # UART0_TX
	jmpd _start # ILLOP
	jmpd _start # CPU1
	jmpd _start # CPU2
	jmpd _start # CPU3
	jmpd _start # TRAP0
	jmpd _start # TRAP1
	jmpd _start # TRAP2
	jmpd _start # TRAP3

.globl timer0
timer0:
	push %0
	push %1
	push %2

	addi %4, %4, 1

	ldi %1, timers_base
	ldi %0, 0x300
	ld.l %2, 48(%1)
	add %0, %0, %2
	st.l %0, 16(%1)
	ldiu %0, 0x01
	st.l %0, 4(%1)
	
	pop %2
	pop %1
	pop %0
	rti

.globl printhex
printhex:
	push %1
	push %2
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
	rts

fail:	halt
