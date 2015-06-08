.globl _start
_start:
ldiu %31, 0x4000
ldi %13, _erodata
ldi %14, _data
jmpd .LC3
.LC2:
mov %29, %14
ldiu %28, 4
add %14, %29, %28
mov %27, %13
add %13, %27, %28
ld.l %28, (%27)
st.l %28, (%29)
.LC3:
mov %29, %14
ldi %28, _edata
cmp %29, %28
bltu .LC2
jmpd main
