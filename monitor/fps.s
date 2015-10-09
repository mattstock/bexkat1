.globl main
main:
ldi %0, -1
ldi %1, 1
cvtis %0, %0
cvtis %1, %1
mul.s %2, %0, %1
cvtsi %2, %2
cvtsi %1, %1
cvtsi %0, %0
foo:
jmpd foo
