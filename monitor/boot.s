.globl _start
_start:
ldiu %sp, 0x4000
ldi %0, _erodata
ldi %1, _data
ldi %2, _edata
jmpd .LC3
.LC2:
ld.l %3, (%0)
addi %0, %0, 4
st.l %3, (%1)
addi %1, %1, 4
.LC3:
cmp %1, %2
bltu .LC2
jmpd main
