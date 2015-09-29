.globl main
main:
ldi %0, 10
ldi %1, 20
cvtis %0, %0
cvtis %1, %1
mul.s %2, %0, %1
cvtsi %2, %2
push.s %2
div.s %2, %1, %0
cvtsi %2, %2
add.s %2, %1, %0
cvtsi %2, %2
sub.s %2, %1, %0
cvtsi %2, %2
pop.s %2
foo:
jmpd foo
