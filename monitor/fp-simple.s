.globl main
main:
ldi %1, 20
cvtis %1, %1
cvtsi %2, %2
foo:
jmpd foo
