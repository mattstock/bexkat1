ldiu %30, 0x0003
ldiu %29, 0x0006
ldiu %28, 0x0010
mul %27, %30, %29
div %26, %28, %30
mod %31, %28, %30
foo:
jmpd foo
