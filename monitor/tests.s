	.set seg_base,     0x30000000
	.set serial0_base, 0x30002000
	.set timers_base,  0x30008000
.globl main
main:
	# config timer0 interrupt
	ldiu %0, 0
	std.l %0, 0x0
	ldi %0, 0x63
	ldi %1, timers_base
	st.l %0, 16(%1)
	ldi %0, 0x11
	st.l %0, (%1)
	
	# enable timer interrupt
	sti
l:	ldiu %0, 0x1111
	bsr doop
	ldiu %0, 0x3333
	ldiu %0, 0x4444
	ldiu %0, 0x5555
	ldiu %0, 0x6666
	halt

doop:	ldiu %0, 0x2222
	ldiu %1, 0x1111
	ldiu %1, 0x2222
	ldiu %1, 0x3333
	ldiu %1, 0x4444
	ldiu %1, 0x5555
	ldiu %1, 0x6666
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

#	addi %4, %4, 1
#	mov.l %0, %4
#	bsr printhex

	ldi %1, timers_base
	ldi %0, 0x0
	st.l %0, (%1)
#	ldi %0, 0x100
#	ld.l %2, 48(%1)
#	add %0, %0, %2
#	st.l %0, 16(%1)
#	ldiu %0, 0x01
#	st.l %0, 4(%1)
	
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
