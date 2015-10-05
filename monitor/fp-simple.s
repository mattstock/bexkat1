.globl main
main:
ldi.d %0, 10
ldi %1, 20
cvtis %1, %1
cvtsd %1, %1
push.d %1
mul.d %2, %0, %1
cvtds %2, %2
cvtsi %2, %2
pop.d %2
foo:
jmpd foo
