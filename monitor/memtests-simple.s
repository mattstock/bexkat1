ldiu %26, 0x0003
ldiu %29, 0x0006
ldiu %27, 0x0010
push %26
push %27
push %29
pop %26
pop %27
pop %29
foo:
jmpd foo
