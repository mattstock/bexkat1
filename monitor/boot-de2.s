	.globl _start
_start:	
	ldi %sp, 0x08000000
	ldi %0, _erodata
	ldi %1, _data_start
	ldi %2, _edata
	bra .LC3
	.LC2:
	ld.l %3, (%0)
	addi %0, %0, 4
	st.l %3, (%1)
	addi %1, %1, 4
.LC3:
	cmp %1, %2
	bltu .LC2
	ldi %0, __bss_start
	ldi %1, _end
	ldi %2, 0
	bra .LC4
.LC5:
	st.l %2, (%0)
	addi %0, %0, 4
.LC4:
	cmp %0, %1
bltu .LC5
	setint _vectors_start
	ldiu %0, 0
	push %0
	push %0
	jsrd main
	jsrd exit
