.globl foo
.text
.align 2
.type foo,@function
foo:
ldi r0, 0xabcd0123
ldi r1, 16
ldi r3, 38
add r2, r1, r3
inc r1
dec r3
st.l r0, 0x00000000
ld.l r1, 0x00000000
