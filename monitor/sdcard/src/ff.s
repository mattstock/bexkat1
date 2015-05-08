.text
.align 4
.type mem_cpy,@function
mem_cpy:
push %13
push %14
push %30
movfs %30
ld.l %14, 16(%30)
ld.l %13, 20(%30)
jmpd .LC9
.LC8:
mov %29, %14
ldis %28, 1
add %14, %29, %28
mov %27, %13
add %13, %27, %28
ld.b %28, 0(%27)
st.b %28, 0(%29)
.LC9:
ld.l %29, 24(%30)
subi %28, %29, 1
st.l %28, 24(%30)
ldiu %28, 0
cmp %29, %28
bne .LC8
.LC7:
movts %30
pop %30
pop %14
pop %13
rts
.Lf11:
.size mem_cpy,.Lf11-mem_cpy
.align 4
.type mem_set,@function
mem_set:
push %14
push %30
movfs %30
ld.l %14, 12(%30)
jmpd .LC14
.LC13:
mov %29, %14
ldis %28, 1
add %14, %29, %28
ld.l %28, 16(%30)
st.b %28, 0(%29)
.LC14:
ld.l %29, 20(%30)
subi %28, %29, 1
st.l %28, 20(%30)
ldiu %28, 0
cmp %29, %28
bne .LC13
.LC12:
movts %30
pop %30
pop %14
rts
.Lf16:
.size mem_set,.Lf16-mem_set
.align 4
.type mem_cmp,@function
mem_cmp:
push %12
push %13
push %14
push %30
movfs %30
ld.l %13, 20(%30)
ld.l %12, 24(%30)
ldis %14, 0
.LC18:
.LC19:
ld.l %29, 28(%30)
subi %28, %29, 1
st.l %28, 28(%30)
ldiu %28, 0
cmp %29, %28
beq .LC21
mov %29, %13
ldis %28, 1
add %13, %29, %28
mov %27, %12
add %12, %27, %28
ld.b %29, 0(%29)
ld.b %28, 0(%27)
sub %29, %29, %28
mov %14, %29
ldis %28, 0
cmp %29, %28
beq .LC18
.LC21:
mov %15, %14
.LC17:
movts %30
pop %30
pop %14
pop %13
pop %12
rts
.Lf22:
.size mem_cmp,.Lf22-mem_cmp
.align 4
.type chk_chr,@function
chk_chr:
push %30
movfs %30
jmpd .LC25
.LC24:
ld.l %29, 8(%30)
ldis %28, 1
add %29, %29, %28
st.l %29, 8(%30)
.LC25:
ld.l %29, 8(%30)
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC27
ld.l %28, 12(%30)
cmp %29, %28
bne .LC24
.LC27:
ld.l %29, 8(%30)
ld.b %29, 0(%29)
mov %15, %29
.LC23:
movts %30
pop %30
rts
.Lf28:
.size chk_chr,.Lf28-chk_chr
.align 4
.type sync_window,@function
sync_window:
push %13
push %14
push %30
movfs %30
ld.l %29, 16(%30)
ldis %28, 4
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC30
ld.l %29, 16(%30)
ldis %28, 44
add %28, %29, %28
ld.l %14, 0(%28)
ldiu %28, 1
push %28
push %14
ldis %28, 48
add %28, %29, %28
push %28
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC32
ldis %15, 1
jmpd .LC29
.LC32:
ld.l %29, 16(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 0
st.b %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
sub %28, %14, %28
ldis %27, 24
add %29, %29, %27
ld.l %29, 0(%29)
cmp %28, %29
bgeu .LC34
ld.l %29, 16(%30)
ldis %28, 3
add %29, %29, %28
ld.b %29, 0(%29)
mov %13, %29
jmpd .LC39
.LC36:
ld.l %29, 16(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
add %14, %14, %28
ldiu %28, 1
push %28
push %14
ldis %28, 48
add %28, %29, %28
push %28
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
.LC37:
dec %13
.LC39:
ldiu %29, 2
cmp %13, %29
bgeu .LC36
.LC34:
.LC30:
ldis %15, 0
.LC29:
movts %30
pop %30
pop %14
pop %13
rts
.Lf40:
.size sync_window,.Lf40-sync_window
.align 4
.type move_window,@function
move_window:
push %30
movfs %30
ld.l %29, 12(%30)
ld.l %28, 8(%30)
ldis %27, 44
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
beq .LC42
ld.l %29, 8(%30)
push %29
jsrd sync_window
addsp 4
ldis %28, 0
cmp %15, %28
beq .LC44
ldis %15, 1
jmpd .LC41
.LC44:
ldiu %29, 1
push %29
ld.l %29, 12(%30)
push %29
ld.l %29, 8(%30)
ldis %28, 48
add %28, %29, %28
push %28
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_read
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC46
ldis %15, 1
jmpd .LC41
.LC46:
ld.l %29, 8(%30)
ldis %28, 44
add %29, %29, %28
ld.l %28, 12(%30)
st.l %28, 0(%29)
.LC42:
ldis %15, 0
.LC41:
movts %30
pop %30
rts
.Lf48:
.size move_window,.Lf48-move_window
.align 4
.type sync_fs,@function
sync_fs:
push %14
push %30
movfs %30
ld.l %29, 12(%30)
push %29
jsrd sync_window
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC50
ld.l %29, 12(%30)
ld.b %28, 0(%29)
ldis %27, 3
cmp %28, %27
bne .LC52
ldis %28, 5
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 1
cmp %29, %28
bne .LC52
ldiu %29, 512
push %29
ldis %29, 0
push %29
ld.l %29, 12(%30)
ldis %28, 48
add %29, %29, %28
push %29
jsrd mem_set
addsp 12
ld.l %29, 12(%30)
ldis %28, 558
add %29, %29, %28
ldiu %28, 0xaa55
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 559
add %29, %29, %28
ldiu %28, 170
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 48
add %29, %29, %28
ldi %28, 0x41615252
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 49
add %29, %29, %28
ldi %28, 0x41615252
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 50
add %29, %29, %28
ldiu %28, 16737
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 51
add %29, %29, %28
ldiu %28, 65
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 532
add %29, %29, %28
ldi %28, 0x61417272
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 533
add %29, %29, %28
ldi %28, 0x61417272
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 534
add %29, %29, %28
ldiu %28, 24897
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 535
add %29, %29, %28
ldiu %28, 97
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 536
add %28, %29, %28
ldis %27, 16
add %29, %29, %27
ld.l %29, 0(%29)
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 537
add %28, %29, %28
ldis %27, 16
add %29, %29, %27
ld.l %29, 0(%29)
asri %29, %29, 8
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 16
ldis %27, 538
add %27, %29, %27
add %29, %29, %28
ld.l %29, 0(%29)
lsr %29, %29, %28
st.b %29, 0(%27)
ld.l %29, 12(%30)
ldis %28, 539
add %28, %29, %28
ldis %27, 16
add %29, %29, %27
ld.l %29, 0(%29)
lsri %29, %29, 24
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 540
add %28, %29, %28
ldis %27, 12
add %29, %29, %27
ld.l %29, 0(%29)
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 541
add %28, %29, %28
ldis %27, 12
add %29, %29, %27
ld.l %29, 0(%29)
asri %29, %29, 8
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 542
add %28, %29, %28
ldis %27, 12
add %29, %29, %27
ld.l %29, 0(%29)
lsri %29, %29, 16
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 543
add %28, %29, %28
ldis %27, 12
add %29, %29, %27
ld.l %29, 0(%29)
lsri %29, %29, 24
st.b %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 44
add %28, %29, %28
ldis %27, 28
add %29, %29, %27
ld.l %29, 0(%29)
addi %29, %29, 1
st.l %29, 0(%28)
ldiu %29, 1
push %29
ld.l %29, 12(%30)
ldis %28, 44
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 48
add %28, %29, %28
push %28
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ld.l %29, 12(%30)
ldis %28, 5
add %29, %29, %28
ldiu %28, 0
st.b %28, 0(%29)
.LC52:
ldi %29, 0
push %29
ldis %29, 0
push %29
ld.l %29, 12(%30)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_ioctl
addsp 12
ldis %28, 0
cmp %15, %28
beq .LC54
ldis %14, 1
.LC54:
.LC50:
mov %15, %14
.LC49:
movts %30
pop %30
pop %14
rts
.Lf56:
.size sync_fs,.Lf56-sync_fs
.globl clust2sect
.align 4
.type clust2sect,@function
clust2sect:
push %30
movfs %30
ldiu %29, 2
ld.l %28, 12(%30)
sub %28, %28, %29
st.l %28, 12(%30)
ld.l %28, 12(%30)
ld.l %27, 8(%30)
ldis %26, 20
add %27, %27, %26
ld.l %27, 0(%27)
sub %29, %27, %29
cmp %28, %29
bltu .LC58
ldiu %15, 0
jmpd .LC57
.LC58:
ld.l %29, 8(%30)
ld.l %28, 12(%30)
ldis %27, 2
add %27, %29, %27
ld.b %27, 0(%27)
mulu %28, %28, %27
ldis %27, 40
add %29, %29, %27
ld.l %29, 0(%29)
add %15, %28, %29
.LC57:
movts %30
pop %30
rts
.Lf60:
.size clust2sect,.Lf60-clust2sect
.globl get_fat
.align 4
.type get_fat,@function
get_fat:
push %13
push %14
push %30
movfs %30
subsp 12
ld.l %29, 20(%30)
ldiu %28, 2
cmp %29, %28
bltu .LC64
ld.l %28, 16(%30)
ldis %27, 20
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
bltu .LC62
.LC64:
ldiu %15, 1
jmpd .LC61
.LC62:
ld.l %29, 16(%30)
ld.b %29, 0(%29)
mov %14, %29
ldis %29, 1
cmp %14, %29
beq .LC68
ldis %29, 2
cmp %14, %29
beq .LC76
ldis %29, 3
cmp %14, %29
beq .LC79
jmpd .LC65
.LC68:
ld.l %29, 20(%30)
st.l %29, -4(%30)
ld.l %29, -4(%30)
lsri %28, %29, 1
add %29, %29, %28
st.l %29, -4(%30)
ld.l %29, 16(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, -4(%30)
lsri %27, %27, 9
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
ldis %28, 0
cmp %15, %28
beq .LC69
jmpd .LC66
.LC69:
ld.l %29, -4(%30)
ld.l %28, 16(%30)
andi %27, %29, 511
ldis %26, 48
add %26, %28, %26
add %27, %27, %26
ld.b %27, 0(%27)
st.l %27, -12(%30)
addi %29, %29, 1
st.l %29, -4(%30)
ldis %29, 32
add %29, %28, %29
ld.l %29, 0(%29)
ld.l %27, -4(%30)
lsri %27, %27, 9
add %29, %29, %27
push %29
push %28
jsrd move_window
addsp 8
ldis %28, 0
cmp %15, %28
beq .LC71
jmpd .LC66
.LC71:
ld.l %29, -12(%30)
ld.l %28, -4(%30)
andi %28, %28, 511
ld.l %27, 16(%30)
ldis %26, 48
add %27, %27, %26
add %28, %28, %27
ld.b %28, 0(%28)
lsli %28, %28, 8
or %29, %29, %28
st.l %29, -12(%30)
ld.l %29, 20(%30)
andi %29, %29, 1
ldiu %28, 0
cmp %29, %28
beq .LC74
ld.l %29, -12(%30)
lsri %13, %29, 4
jmpd .LC75
.LC74:
ld.l %29, -12(%30)
andi %13, %29, 4095
.LC75:
mov %15, %13
jmpd .LC61
.LC76:
ld.l %29, 16(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, 20(%30)
lsri %27, %27, 8
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
ldis %28, 0
cmp %15, %28
beq .LC77
jmpd .LC66
.LC77:
ldis %29, 1
ld.l %28, 20(%30)
lsl %28, %28, %29
andi %28, %28, 511
ld.l %27, 16(%30)
ldis %26, 48
add %27, %27, %26
add %28, %28, %27
st.l %28, -8(%30)
ld.l %28, -8(%30)
add %29, %28, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ld.b %28, 0(%28)
or %29, %29, %28
mov %15, %29
jmpd .LC61
.LC79:
ld.l %29, 16(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, 20(%30)
lsri %27, %27, 7
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
ldis %28, 0
cmp %15, %28
beq .LC80
jmpd .LC66
.LC80:
ldis %29, 2
ld.l %28, 20(%30)
lsl %28, %28, %29
andi %28, %28, 511
ld.l %27, 16(%30)
ldis %26, 48
add %27, %27, %26
add %28, %28, %27
st.l %28, -8(%30)
ld.l %28, -8(%30)
ldis %27, 3
add %27, %28, %27
ld.b %27, 0(%27)
lsli %27, %27, 24
add %29, %28, %29
ld.b %29, 0(%29)
lsli %29, %29, 16
or %29, %27, %29
ldis %27, 1
add %27, %28, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %29, %29, %27
ld.b %28, 0(%28)
or %29, %29, %28
ldi %28, 0xfffffff
and %15, %29, %28
jmpd .LC61
.LC65:
ldiu %15, 1
jmpd .LC61
.LC66:
ldi %15, 0xffffffff
.LC61:
movts %30
pop %30
pop %14
pop %13
rts
.Lf82:
.size get_fat,.Lf82-get_fat
.globl put_fat
.align 4
.type put_fat,@function
put_fat:
push %12
push %13
push %14
push %30
movfs %30
subsp 12
ld.l %29, 24(%30)
ldiu %28, 2
cmp %29, %28
bltu .LC86
ld.l %28, 20(%30)
ldis %27, 20
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
bltu .LC84
.LC86:
ldis %29, 2
st.l %29, -4(%30)
jmpd .LC85
.LC84:
ld.l %29, 20(%30)
ld.b %29, 0(%29)
mov %14, %29
ldis %29, 1
cmp %14, %29
beq .LC90
ldis %29, 2
cmp %14, %29
beq .LC101
ldis %29, 3
cmp %14, %29
beq .LC104
jmpd .LC87
.LC90:
ld.l %29, 24(%30)
st.l %29, -12(%30)
ld.l %29, -12(%30)
lsri %28, %29, 1
add %29, %29, %28
st.l %29, -12(%30)
ld.l %29, 20(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, -12(%30)
lsri %27, %27, 9
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldis %28, 0
cmp %29, %28
beq .LC91
jmpd .LC88
.LC91:
ld.l %29, -12(%30)
andi %29, %29, 511
ld.l %28, 20(%30)
ldis %27, 48
add %28, %28, %27
add %29, %29, %28
st.l %29, -8(%30)
ld.l %29, 24(%30)
andi %29, %29, 1
ldiu %28, 0
cmp %29, %28
beq .LC94
ld.l %29, -8(%30)
ld.b %29, 0(%29)
andi %29, %29, 15
ld.l %28, 28(%30)
lsli %28, %28, 4
or %13, %29, %28
jmpd .LC95
.LC94:
ld.l %29, 28(%30)
mov %13, %29
.LC95:
ld.l %29, -8(%30)
mov %28, %13
st.b %28, 0(%29)
ld.l %29, -12(%30)
addi %29, %29, 1
st.l %29, -12(%30)
ld.l %29, 20(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, 20(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, -12(%30)
lsri %27, %27, 9
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldis %28, 0
cmp %29, %28
beq .LC96
jmpd .LC88
.LC96:
ld.l %29, -12(%30)
andi %29, %29, 511
ld.l %28, 20(%30)
ldis %27, 48
add %28, %28, %27
add %29, %29, %28
st.l %29, -8(%30)
ld.l %29, 24(%30)
andi %29, %29, 1
ldiu %28, 0
cmp %29, %28
beq .LC99
ld.l %29, 28(%30)
lsri %29, %29, 4
mov %12, %29
jmpd .LC100
.LC99:
ld.l %29, -8(%30)
ld.b %29, 0(%29)
andi %29, %29, 240
ld.l %28, 28(%30)
lsri %28, %28, 8
andi %28, %28, 15
or %12, %29, %28
.LC100:
ld.l %29, -8(%30)
mov %28, %12
st.b %28, 0(%29)
jmpd .LC88
.LC101:
ld.l %29, 20(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, 24(%30)
lsri %27, %27, 8
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldis %28, 0
cmp %29, %28
beq .LC102
jmpd .LC88
.LC102:
ld.l %29, 24(%30)
lsli %29, %29, 1
andi %29, %29, 511
ld.l %28, 20(%30)
ldis %27, 48
add %28, %28, %27
add %29, %29, %28
st.l %29, -8(%30)
ld.l %29, -8(%30)
ld.l %28, 28(%30)
st.b %28, 0(%29)
ld.l %29, -8(%30)
ldis %28, 1
add %29, %29, %28
ld.l %28, 28(%30)
asri %28, %28, 8
st.b %28, 0(%29)
jmpd .LC88
.LC104:
ld.l %29, 20(%30)
ldis %28, 32
add %28, %29, %28
ld.l %28, 0(%28)
ld.l %27, 24(%30)
lsri %27, %27, 7
add %28, %28, %27
push %28
push %29
jsrd move_window
addsp 8
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldis %28, 0
cmp %29, %28
beq .LC105
jmpd .LC88
.LC105:
ldis %29, 2
ld.l %28, 24(%30)
lsl %28, %28, %29
andi %28, %28, 511
ld.l %27, 20(%30)
ldis %26, 48
add %27, %27, %26
add %28, %28, %27
st.l %28, -8(%30)
ld.l %28, -8(%30)
ld.l %27, 28(%30)
ldis %26, 3
add %26, %28, %26
ld.b %26, 0(%26)
lsli %26, %26, 24
add %29, %28, %29
ld.b %29, 0(%29)
lsli %29, %29, 16
or %29, %26, %29
ldis %26, 1
add %26, %28, %26
ld.b %26, 0(%26)
lsli %26, %26, 8
or %29, %29, %26
ld.b %26, 0(%28)
or %29, %29, %26
ldi %26, 0xf0000000
and %29, %29, %26
or %29, %27, %29
st.l %29, 28(%30)
ld.l %29, 28(%30)
st.b %29, 0(%28)
ld.l %29, -8(%30)
ldis %28, 1
add %29, %29, %28
ld.l %28, 28(%30)
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, -8(%30)
ldis %28, 2
add %29, %29, %28
ld.l %28, 28(%30)
lsri %28, %28, 16
st.b %28, 0(%29)
ld.l %29, -8(%30)
ldis %28, 3
add %29, %29, %28
ld.l %28, 28(%30)
lsri %28, %28, 24
st.b %28, 0(%29)
jmpd .LC88
.LC87:
ldis %29, 2
st.l %29, -4(%30)
.LC88:
ld.l %29, 20(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
.LC85:
ld.l %15, -4(%30)
.LC83:
movts %30
pop %30
pop %14
pop %13
pop %12
rts
.Lf107:
.size put_fat,.Lf107-put_fat
.align 4
.type remove_chain,@function
remove_chain:
push %13
push %14
push %30
movfs %30
ld.l %29, 20(%30)
ldiu %28, 2
cmp %29, %28
bltu .LC111
ld.l %28, 16(%30)
ldis %27, 20
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
bltu .LC109
.LC111:
ldis %13, 2
jmpd .LC110
.LC109:
ldis %13, 0
jmpd .LC113
.LC112:
ld.l %29, 20(%30)
push %29
ld.l %29, 16(%30)
push %29
jsrd get_fat
addsp 8
mov %14, %15
ldiu %29, 0
cmp %14, %29
bne .LC115
jmpd .LC114
.LC115:
ldiu %29, 1
cmp %14, %29
bne .LC117
ldis %13, 2
jmpd .LC114
.LC117:
ldi %29, 0xffffffff
cmp %14, %29
bne .LC119
ldis %13, 1
jmpd .LC114
.LC119:
ldiu %29, 0
push %29
ld.l %29, 20(%30)
push %29
ld.l %29, 16(%30)
push %29
jsrd put_fat
addsp 12
mov %13, %15
ldis %29, 0
cmp %13, %29
beq .LC121
jmpd .LC114
.LC121:
ld.l %29, 16(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
ldi %28, 0xffffffff
cmp %29, %28
beq .LC123
ld.l %29, 16(%30)
ldis %28, 16
add %29, %29, %28
ld.l %28, 0(%29)
addi %28, %28, 1
st.l %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 5
add %29, %29, %28
ld.b %28, 0(%29)
ori %28 %28, 1
st.b %28, 0(%29)
.LC123:
st.l %14, 20(%30)
.LC113:
ld.l %29, 20(%30)
ld.l %28, 16(%30)
ldis %27, 20
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
bltu .LC112
.LC114:
.LC110:
mov %15, %13
.LC108:
movts %30
pop %30
pop %14
pop %13
rts
.Lf125:
.size remove_chain,.Lf125-remove_chain
.align 4
.type create_chain,@function
create_chain:
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
ld.l %29, 32(%30)
ldiu %28, 0
cmp %29, %28
bne .LC127
ld.l %29, 28(%30)
ldis %28, 12
add %29, %29, %28
ld.l %12, 0(%29)
ldiu %29, 0
cmp %12, %29
beq .LC131
ld.l %29, 28(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
cmp %12, %29
bltu .LC128
.LC131:
ldiu %12, 1
jmpd .LC128
.LC127:
ld.l %29, 32(%30)
push %29
ld.l %29, 28(%30)
push %29
jsrd get_fat
addsp 8
mov %13, %15
ldiu %29, 2
cmp %13, %29
bgeu .LC132
ldiu %15, 1
jmpd .LC126
.LC132:
ldi %29, 0xffffffff
cmp %13, %29
bne .LC134
mov %15, %13
jmpd .LC126
.LC134:
ld.l %29, 28(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
cmp %13, %29
bgeu .LC136
mov %15, %13
jmpd .LC126
.LC136:
ld.l %12, 32(%30)
.LC128:
mov %14, %12
.LC138:
inc %14
ld.l %29, 28(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
cmp %14, %29
bltu .LC142
ldiu %14, 2
cmp %14, %12
bleu .LC144
ldiu %15, 0
jmpd .LC126
.LC144:
.LC142:
push %14
ld.l %29, 28(%30)
push %29
jsrd get_fat
addsp 8
mov %13, %15
ldiu %29, 0
cmp %13, %29
bne .LC146
jmpd .LC140
.LC146:
ldi %29, 0xffffffff
cmp %13, %29
beq .LC150
ldiu %29, 1
cmp %13, %29
bne .LC148
.LC150:
mov %15, %13
jmpd .LC126
.LC148:
cmp %14, %12
bne .LC138
ldiu %15, 0
jmpd .LC126
.LC140:
ldi %29, 0xfffffff
push %29
push %14
ld.l %29, 28(%30)
push %29
jsrd put_fat
addsp 12
mov %11, %15
ldis %29, 0
cmp %11, %29
bne .LC153
ld.l %29, 32(%30)
ldiu %28, 0
cmp %29, %28
beq .LC153
push %14
ld.l %29, 32(%30)
push %29
ld.l %29, 28(%30)
push %29
jsrd put_fat
addsp 12
mov %11, %15
.LC153:
ldis %29, 0
cmp %11, %29
bne .LC155
ld.l %29, 28(%30)
ldis %28, 12
add %29, %29, %28
st.l %14, 0(%29)
ld.l %29, 28(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
ldi %28, 0xffffffff
cmp %29, %28
beq .LC156
ld.l %29, 28(%30)
ldis %28, 16
add %29, %29, %28
ld.l %28, 0(%29)
subi %28, %28, 1
st.l %28, 0(%29)
ld.l %29, 28(%30)
ldis %28, 5
add %29, %29, %28
ld.b %28, 0(%29)
ori %28 %28, 1
st.b %28, 0(%29)
jmpd .LC156
.LC155:
ldis %29, 1
cmp %11, %29
bne .LC160
ldi %10, 0xffffffff
jmpd .LC161
.LC160:
ldiu %10, 1
.LC161:
mov %14, %10
.LC156:
mov %15, %14
.LC126:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
rts
.Lf162:
.size create_chain,.Lf162-create_chain
.align 4
.type dir_sdi,@function
dir_sdi:
push %12
push %13
push %14
push %30
movfs %30
ld.l %29, 20(%30)
ldis %28, 6
add %29, %29, %28
ld.l %28, 24(%30)
st %28, 0(%29)
ld.l %29, 20(%30)
ldis %28, 8
add %29, %29, %28
ld.l %14, 0(%29)
ldiu %29, 1
cmp %14, %29
beq .LC166
ld.l %29, 20(%30)
ld.l %29, 0(%29)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
cmp %14, %29
bltu .LC164
.LC166:
ldis %15, 2
jmpd .LC163
.LC164:
ldiu %29, 0
cmp %14, %29
bne .LC167
ld.l %29, 20(%30)
ld.l %29, 0(%29)
ld.b %29, 0(%29)
ldis %28, 3
cmp %29, %28
bne .LC167
ld.l %29, 20(%30)
ld.l %29, 0(%29)
ldis %28, 36
add %29, %29, %28
ld.l %14, 0(%29)
.LC167:
ldiu %29, 0
cmp %14, %29
bne .LC169
ld.l %29, 24(%30)
ld.l %28, 20(%30)
ld.l %28, 0(%28)
ldis %27, 8
add %28, %28, %27
ld %28, 0(%28)
cmp %29, %28
bltu .LC171
ldis %15, 2
jmpd .LC163
.LC171:
ld.l %29, 20(%30)
ld.l %29, 0(%29)
ldis %28, 36
add %29, %29, %28
ld.l %12, 0(%29)
jmpd .LC170
.LC169:
ld.l %29, 20(%30)
ld.l %29, 0(%29)
ldis %28, 2
add %29, %29, %28
ld.b %29, 0(%29)
lsli %13, %29, 4
jmpd .LC174
.LC173:
push %14
ld.l %29, 20(%30)
ld.l %29, 0(%29)
push %29
jsrd get_fat
addsp 8
mov %14, %15
ldi %29, 0xffffffff
cmp %14, %29
bne .LC176
ldis %15, 1
jmpd .LC163
.LC176:
ldiu %29, 2
cmp %14, %29
bltu .LC180
ld.l %29, 20(%30)
ld.l %29, 0(%29)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
cmp %14, %29
bltu .LC178
.LC180:
ldis %15, 2
jmpd .LC163
.LC178:
ld.l %29, 24(%30)
sub %29, %29, %13
st.l %29, 24(%30)
.LC174:
ld.l %29, 24(%30)
cmp %29, %13
bgeu .LC173
push %14
ld.l %29, 20(%30)
ld.l %29, 0(%29)
push %29
jsrd clust2sect
addsp 8
mov %12, %15
.LC170:
ld.l %29, 20(%30)
ldis %28, 12
add %29, %29, %28
st.l %14, 0(%29)
ldiu %29, 0
cmp %12, %29
bne .LC181
ldis %15, 2
jmpd .LC163
.LC181:
ld.l %29, 20(%30)
ldis %28, 16
add %29, %29, %28
ld.l %28, 24(%30)
lsri %28, %28, 4
add %28, %12, %28
st.l %28, 0(%29)
ld.l %29, 20(%30)
ldis %28, 20
add %28, %29, %28
ld.l %27, 24(%30)
andi %27, %27, 15
lsli %27, %27, 5
ld.l %29, 0(%29)
ldis %26, 48
add %29, %29, %26
add %29, %27, %29
st.l %29, 0(%28)
ldis %15, 0
.LC163:
movts %30
pop %30
pop %14
pop %13
pop %12
rts
.Lf183:
.size dir_sdi,.Lf183-dir_sdi
.align 4
.type dir_next,@function
dir_next:
push %14
push %30
movfs %30
subsp 12
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld %29, 0(%29)
addi %29, %29, 1
mov %14, %29
ldi %29, 0xffff
and %29, %14, %29
ldiu %28, 0
cmp %29, %28
beq .LC187
ld.l %29, 12(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC185
.LC187:
ldis %15, 4
jmpd .LC184
.LC185:
andi %29, %14, 15
ldiu %28, 0
cmp %29, %28
bne .LC188
ld.l %29, 12(%30)
ldis %28, 16
add %29, %29, %28
ld.l %28, 0(%29)
addi %28, %28, 1
st.l %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 12
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC190
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 8
add %29, %29, %28
ld %29, 0(%29)
cmp %14, %29
bltu .LC191
ldis %15, 4
jmpd .LC184
.LC190:
lsri %29, %14, 4
ld.l %28, 12(%30)
ld.l %28, 0(%28)
ldis %27, 2
add %28, %28, %27
ld.b %28, 0(%28)
subi %28, %28, 1
and %29, %29, %28
ldiu %28, 0
cmp %29, %28
bne .LC194
ld.l %29, 12(%30)
ldis %28, 12
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd get_fat
addsp 8
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldiu %28, 1
cmp %29, %28
bgtu .LC196
ldis %15, 2
jmpd .LC184
.LC196:
ld.l %29, -4(%30)
ldi %28, 0xffffffff
cmp %29, %28
bne .LC198
ldis %15, 1
jmpd .LC184
.LC198:
ld.l %29, -4(%30)
ld.l %28, 12(%30)
ld.l %28, 0(%28)
ldis %27, 20
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
bltu .LC200
ld.l %29, 16(%30)
ldis %28, 0
cmp %29, %28
bne .LC202
ldis %15, 4
jmpd .LC184
.LC202:
ld.l %29, 12(%30)
ldis %28, 12
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd create_chain
addsp 8
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldiu %28, 0
cmp %29, %28
bne .LC204
ldis %15, 7
jmpd .LC184
.LC204:
ld.l %29, -4(%30)
ldiu %28, 1
cmp %29, %28
bne .LC206
ldis %15, 2
jmpd .LC184
.LC206:
ld.l %29, -4(%30)
ldi %28, 0xffffffff
cmp %29, %28
bne .LC208
ldis %15, 1
jmpd .LC184
.LC208:
ld.l %29, 12(%30)
ld.l %29, 0(%29)
push %29
jsrd sync_window
addsp 4
ldis %28, 0
cmp %15, %28
beq .LC210
ldis %15, 1
jmpd .LC184
.LC210:
ldiu %29, 512
push %29
ldis %29, 0
push %29
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 48
add %29, %29, %28
push %29
jsrd mem_set
addsp 12
ld.l %29, -4(%30)
push %29
ld.l %29, 12(%30)
ld.l %29, 0(%29)
st.l %29, -12(%30)
push %29
jsrd clust2sect
addsp 8
ldis %28, 44
ld.l %27, -12(%30)
add %28, %27, %28
st.l %15, 0(%28)
ldiu %29, 0
st.l %29, -8(%30)
jmpd .LC215
.LC212:
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, 12(%30)
ld.l %29, 0(%29)
push %29
jsrd sync_window
addsp 4
ldis %28, 0
cmp %15, %28
beq .LC216
ldis %15, 1
jmpd .LC184
.LC216:
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 44
add %29, %29, %28
ld.l %28, 0(%29)
addi %28, %28, 1
st.l %28, 0(%29)
.LC213:
ld.l %29, -8(%30)
addi %29, %29, 1
st.l %29, -8(%30)
.LC215:
ld.l %29, -8(%30)
ld.l %28, 12(%30)
ld.l %28, 0(%28)
ldis %27, 2
add %28, %28, %27
ld.b %28, 0(%28)
cmp %29, %28
bltu .LC212
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 44
add %29, %29, %28
ld.l %28, 0(%29)
ld.l %27, -8(%30)
sub %28, %28, %27
st.l %28, 0(%29)
.LC200:
ld.l %29, 12(%30)
ldis %28, 12
add %29, %29, %28
ld.l %28, -4(%30)
st.l %28, 0(%29)
ld.l %29, -4(%30)
push %29
ld.l %29, 12(%30)
st.l %29, -8(%30)
ld.l %28, 0(%29)
push %28
jsrd clust2sect
addsp 8
ldis %28, 16
ld.l %27, -8(%30)
add %28, %27, %28
st.l %15, 0(%28)
.LC194:
.LC191:
.LC188:
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
mov %28, %14
st %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 20
add %28, %29, %28
andi %27, %14, 15
lsli %27, %27, 5
ld.l %29, 0(%29)
ldis %26, 48
add %29, %29, %26
add %29, %27, %29
st.l %29, 0(%28)
ldis %15, 0
.LC184:
movts %30
pop %30
pop %14
rts
.Lf218:
.size dir_next,.Lf218-dir_next
.align 4
.type dir_alloc,@function
dir_alloc:
push %13
push %14
push %30
movfs %30
ldiu %29, 0
push %29
ld.l %29, 16(%30)
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC220
ldiu %13, 0
.LC222:
ld.l %29, 16(%30)
ldis %28, 16
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd move_window
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC225
jmpd .LC224
.LC225:
ld.l %29, 16(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
ld.b %29, 0(%29)
ldis %28, 229
cmp %29, %28
beq .LC229
ldis %28, 0
cmp %29, %28
bne .LC227
.LC229:
addi %29, %13, 1
mov %13, %29
ld.l %28, 20(%30)
cmp %29, %28
bne .LC228
jmpd .LC224
.LC227:
ldiu %13, 0
.LC228:
ldis %29, 1
push %29
ld.l %29, 16(%30)
push %29
jsrd dir_next
addsp 8
mov %14, %15
.LC223:
ldis %29, 0
cmp %14, %29
beq .LC222
.LC224:
.LC220:
ldis %29, 4
cmp %14, %29
bne .LC232
ldis %14, 7
.LC232:
mov %15, %14
.LC219:
movts %30
pop %30
pop %14
pop %13
rts
.Lf234:
.size dir_alloc,.Lf234-dir_alloc
.align 4
.type ld_clust,@function
ld_clust:
push %30
movfs %30
subsp 4
ld.l %29, 12(%30)
ldis %28, 27
add %28, %29, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
ldis %27, 26
add %29, %29, %27
ld.b %29, 0(%29)
or %29, %28, %29
st.l %29, -4(%30)
ld.l %29, 8(%30)
ld.b %29, 0(%29)
ldis %28, 3
cmp %29, %28
bne .LC236
ld.l %29, 12(%30)
ld.l %28, -4(%30)
ldis %27, 21
add %27, %29, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
ldis %26, 20
add %29, %29, %26
ld.b %29, 0(%29)
or %29, %27, %29
lsli %29, %29, 16
or %29, %28, %29
st.l %29, -4(%30)
.LC236:
ld.l %15, -4(%30)
.LC235:
movts %30
pop %30
rts
.Lf238:
.size ld_clust,.Lf238-ld_clust
.align 4
.type st_clust,@function
st_clust:
push %30
movfs %30
ld.l %29, 8(%30)
ldis %28, 26
add %29, %29, %28
ld.l %28, 12(%30)
st.b %28, 0(%29)
ld.l %29, 8(%30)
ldis %28, 27
add %29, %29, %28
ld.l %28, 12(%30)
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, 8(%30)
ldis %28, 20
add %29, %29, %28
ld.l %28, 12(%30)
lsri %28, %28, 16
st.b %28, 0(%29)
ld.l %29, 8(%30)
ldis %28, 21
add %29, %29, %28
ld.l %28, 12(%30)
lsri %28, %28, 16
asri %28, %28, 8
st.b %28, 0(%29)
.LC239:
movts %30
pop %30
rts
.Lf240:
.size st_clust,.Lf240-st_clust
.align 4
.type dir_find,@function
dir_find:
push %12
push %13
push %14
push %30
movfs %30
ldiu %29, 0
push %29
ld.l %29, 20(%30)
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC242
mov %15, %14
jmpd .LC241
.LC242:
.LC244:
ld.l %29, 20(%30)
ldis %28, 16
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd move_window
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC247
jmpd .LC246
.LC247:
ld.l %29, 20(%30)
ldis %28, 20
add %29, %29, %28
ld.l %13, 0(%29)
ld.b %12, 0(%13)
mov %29, %12
ldis %28, 0
cmp %29, %28
bne .LC249
ldis %14, 4
jmpd .LC246
.LC249:
ldis %29, 11
add %29, %13, %29
ld.b %29, 0(%29)
andi %29, %29, 8
ldis %28, 0
cmp %29, %28
bne .LC251
ldiu %29, 11
push %29
ld.l %29, 20(%30)
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
push %29
push %13
jsrd mem_cmp
addsp 12
ldis %28, 0
cmp %15, %28
bne .LC251
jmpd .LC246
.LC251:
ldis %29, 0
push %29
ld.l %29, 20(%30)
push %29
jsrd dir_next
addsp 8
mov %14, %15
.LC245:
ldis %29, 0
cmp %14, %29
beq .LC244
.LC246:
mov %15, %14
.LC241:
movts %30
pop %30
pop %14
pop %13
pop %12
rts
.Lf253:
.size dir_find,.Lf253-dir_find
.align 4
.type dir_read,@function
dir_read:
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
ldis %14, 4
jmpd .LC256
.LC255:
ld.l %29, 28(%30)
ldis %28, 16
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd move_window
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC258
jmpd .LC257
.LC258:
ld.l %29, 28(%30)
ldis %28, 20
add %29, %29, %28
ld.l %11, 0(%29)
ld.b %13, 0(%11)
mov %29, %13
ldis %28, 0
cmp %29, %28
bne .LC260
ldis %14, 4
jmpd .LC257
.LC260:
ldis %29, 11
add %29, %11, %29
ld.b %29, 0(%29)
andi %29, %29, 63
mov %12, %29
mov %29, %13
ldis %28, 229
cmp %29, %28
beq .LC262
ldis %28, 46
cmp %29, %28
beq .LC262
mov %29, %12
ldis %28, 15
cmp %29, %28
beq .LC262
ldis %28, 8
cmp %29, %28
bne .LC265
ldis %10, 1
jmpd .LC266
.LC265:
ldis %10, 0
.LC266:
ld.l %29, 32(%30)
cmp %10, %29
bne .LC262
jmpd .LC257
.LC262:
ldis %29, 0
push %29
ld.l %29, 28(%30)
push %29
jsrd dir_next
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC267
jmpd .LC257
.LC267:
.LC256:
ld.l %29, 28(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC255
.LC257:
ldis %29, 0
cmp %14, %29
beq .LC269
ld.l %29, 28(%30)
ldis %28, 16
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
.LC269:
mov %15, %14
.LC254:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
rts
.Lf271:
.size dir_read,.Lf271-dir_read
.align 4
.type dir_register,@function
dir_register:
push %14
push %30
movfs %30
ldiu %29, 1
push %29
ld.l %29, 12(%30)
push %29
jsrd dir_alloc
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC273
ld.l %29, 12(%30)
ldis %28, 16
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd move_window
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC275
ldiu %29, 32
push %29
ldis %29, 0
push %29
ld.l %29, 12(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
push %29
jsrd mem_set
addsp 12
ldiu %29, 11
push %29
ld.l %29, 12(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
push %29
jsrd mem_cpy
addsp 12
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
.LC275:
.LC273:
mov %15, %14
.LC272:
movts %30
pop %30
pop %14
rts
.Lf277:
.size dir_register,.Lf277-dir_register
.align 4
.type dir_remove,@function
dir_remove:
push %14
push %30
movfs %30
ld.l %29, 12(%30)
ldis %28, 6
add %28, %29, %28
ld %28, 0(%28)
push %28
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC279
ld.l %29, 12(%30)
ldis %28, 16
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd move_window
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC281
ldiu %29, 32
push %29
ldis %29, 0
push %29
ld.l %29, 12(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
push %29
jsrd mem_set
addsp 12
ld.l %29, 12(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 229
st.b %28, 0(%29)
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
.LC281:
.LC279:
mov %15, %14
.LC278:
movts %30
pop %30
pop %14
rts
.Lf283:
.size dir_remove,.Lf283-dir_remove
.align 4
.type get_fileinfo,@function
get_fileinfo:
push %11
push %12
push %13
push %14
push %30
movfs %30
ld.l %29, 28(%30)
ldis %28, 9
add %12, %29, %28
ld.l %29, 24(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
beq .LC285
ld.l %29, 24(%30)
ldis %28, 20
add %29, %29, %28
ld.l %11, 0(%29)
ldiu %13, 0
jmpd .LC288
.LC287:
mov %29, %13
addi %13, %29, 1
add %29, %29, %11
ld.b %14, 0(%29)
mov %29, %14
ldis %28, 32
cmp %29, %28
bne .LC290
jmpd .LC288
.LC290:
mov %29, %14
ldis %28, 5
cmp %29, %28
bne .LC292
ldiu %14, 229
.LC292:
ldiu %29, 9
cmp %13, %29
bne .LC294
mov %29, %12
ldis %28, 1
add %12, %29, %28
ldiu %28, 46
st.b %28, 0(%29)
.LC294:
mov %29, %12
ldis %28, 1
add %12, %29, %28
st.b %14, 0(%29)
.LC288:
ldiu %29, 11
cmp %13, %29
bltu .LC287
ld.l %29, 28(%30)
ldis %28, 8
add %29, %29, %28
ldis %28, 11
add %28, %11, %28
ld.b %28, 0(%28)
st.b %28, 0(%29)
ld.l %29, 28(%30)
ldis %28, 31
add %28, %11, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 30
add %27, %11, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 29
add %27, %11, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %28, %28, %27
ldis %27, 28
add %27, %11, %27
ld.b %27, 0(%27)
or %28, %28, %27
st.l %28, 0(%29)
ld.l %29, 28(%30)
ldis %28, 4
add %29, %29, %28
ldis %28, 25
add %28, %11, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
ldis %27, 24
add %27, %11, %27
ld.b %27, 0(%27)
or %28, %28, %27
st %28, 0(%29)
ld.l %29, 28(%30)
ldis %28, 6
add %29, %29, %28
ldis %28, 23
add %28, %11, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
ldis %27, 22
add %27, %11, %27
ld.b %27, 0(%27)
or %28, %28, %27
st %28, 0(%29)
.LC285:
ldiu %29, 0
st.b %29, 0(%12)
.LC284:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
rts
.Lf296:
.size get_fileinfo,.Lf296-get_fileinfo
.align 4
.type create_name,@function
create_name:
push %6
push %7
push %8
push %9
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
ld.l %29, 48(%30)
ld.l %13, 0(%29)
jmpd .LC301
.LC298:
.LC299:
inc %13
.LC301:
ld.b %29, 0(%13)
ldis %28, 47
cmp %29, %28
beq .LC298
ldis %28, 92
cmp %29, %28
beq .LC298
ld.l %29, 44(%30)
ldis %28, 24
add %29, %29, %28
ld.l %9, 0(%29)
ldiu %29, 11
push %29
ldis %29, 32
push %29
push %9
jsrd mem_set
addsp 12
ldiu %29, 0
mov %8, %29
mov %12, %29
mov %7, %29
ldiu %10, 8
.LC302:
mov %29, %7
addi %7, %29, 1
add %29, %29, %13
ld.b %14, 0(%29)
mov %29, %14
ldis %28, 32
cmp %29, %28
ble .LC309
ldis %28, 47
cmp %29, %28
beq .LC309
ldis %28, 92
cmp %29, %28
bne .LC306
.LC309:
jmpd .LC304
.LC306:
mov %29, %14
ldis %28, 46
cmp %29, %28
beq .LC312
cmp %12, %10
bltu .LC310
.LC312:
ldiu %29, 8
cmp %10, %29
bne .LC315
mov %29, %14
ldis %28, 46
cmp %29, %28
beq .LC313
.LC315:
ldis %15, 6
jmpd .LC297
.LC313:
ldiu %12, 8
ldiu %10, 11
mov %29, %8
lsli %29, %29, 2
mov %8, %29
jmpd .LC302
.LC310:
mov %29, %14
ldis %28, 128
cmp %29, %28
blt .LC316
mov %29, %8
ori %29 %29, 3
mov %8, %29
.LC316:
mov %29, %14
ldis %28, 129
cmp %29, %28
blt .LC321
ldis %28, 159
cmp %29, %28
ble .LC320
.LC321:
mov %29, %14
ldis %28, 224
cmp %29, %28
blt .LC318
ldis %28, 252
cmp %29, %28
bgt .LC318
.LC320:
mov %29, %7
addi %7, %29, 1
add %29, %29, %13
ld.b %11, 0(%29)
mov %29, %11
ldis %28, 64
cmp %29, %28
blt .LC326
ldis %28, 126
cmp %29, %28
ble .LC325
.LC326:
mov %29, %11
ldis %28, 128
cmp %29, %28
blt .LC324
ldis %28, 252
cmp %29, %28
bgt .LC324
.LC325:
subi %29, %10, 1
cmp %12, %29
bltu .LC322
.LC324:
ldis %15, 6
jmpd .LC297
.LC322:
mov %29, %12
addi %12, %29, 1
add %29, %29, %9
st.b %14, 0(%29)
mov %29, %12
addi %12, %29, 1
add %29, %29, %9
st.b %11, 0(%29)
jmpd .LC302
.LC318:
mov %29, %14
push %29
ldi %29, .LC329
push %29
jsrd chk_chr
addsp 8
ldis %28, 0
cmp %15, %28
beq .LC327
ldis %15, 6
jmpd .LC297
.LC327:
mov %29, %14
ldis %28, 65
cmp %29, %28
blt .LC330
ldis %28, 90
cmp %29, %28
bgt .LC330
mov %29, %8
ori %29 %29, 2
mov %8, %29
jmpd .LC331
.LC330:
mov %29, %14
ldis %28, 97
cmp %29, %28
blt .LC332
ldis %28, 122
cmp %29, %28
bgt .LC332
mov %29, %8
ori %29 %29, 1
mov %8, %29
mov %29, %14
subi %29, %29, 32
mov %14, %29
.LC332:
.LC331:
mov %29, %12
addi %12, %29, 1
add %29, %29, %9
st.b %14, 0(%29)
jmpd .LC302
.LC304:
ld.l %29, 48(%30)
add %28, %7, %13
st.l %28, 0(%29)
mov %29, %14
ldis %28, 32
cmp %29, %28
bgt .LC335
ldis %6, 4
jmpd .LC336
.LC335:
ldis %6, 0
.LC336:
mov %29, %6
mov %14, %29
ldiu %29, 0
cmp %12, %29
bne .LC337
ldis %15, 6
jmpd .LC297
.LC337:
ld.b %29, 0(%9)
ldis %28, 229
cmp %29, %28
bne .LC339
ldiu %29, 5
st.b %29, 0(%9)
.LC339:
ldiu %29, 8
cmp %10, %29
bne .LC341
mov %29, %8
lsli %29, %29, 2
mov %8, %29
.LC341:
mov %29, %8
andi %29, %29, 3
ldis %28, 1
cmp %29, %28
bne .LC343
mov %29, %14
ori %29 %29, 16
mov %14, %29
.LC343:
mov %29, %8
andi %29, %29, 12
ldis %28, 4
cmp %29, %28
bne .LC345
mov %29, %14
ori %29 %29, 8
mov %14, %29
.LC345:
ldis %29, 11
add %29, %9, %29
st.b %14, 0(%29)
ldis %15, 0
.LC297:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
pop %9
pop %8
pop %7
pop %6
rts
.Lf347:
.size create_name,.Lf347-create_name
.align 4
.type follow_path,@function
follow_path:
push %12
push %13
push %14
push %30
movfs %30
subsp 4
ld.l %29, 24(%30)
ld.b %29, 0(%29)
ldis %28, 47
cmp %29, %28
beq .LC351
ldis %28, 92
cmp %29, %28
bne .LC349
.LC351:
ld.l %29, 24(%30)
ldis %28, 1
add %29, %29, %28
st.l %29, 24(%30)
.LC349:
ld.l %29, 20(%30)
ldis %28, 8
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
ld.l %29, 24(%30)
ld.b %29, 0(%29)
ldiu %28, 32
cmp %29, %28
bgeu .LC352
ldiu %29, 0
push %29
ld.l %29, 20(%30)
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
ld.l %29, 20(%30)
ldis %28, 20
add %29, %29, %28
ldi %28, 0
st.l %28, 0(%29)
jmpd .LC353
.LC352:
.LC354:
lda %29, 24(%30)
push %29
ld.l %29, 20(%30)
push %29
jsrd create_name
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC358
jmpd .LC356
.LC358:
ld.l %29, 20(%30)
push %29
jsrd dir_find
addsp 4
mov %14, %15
ld.l %29, 20(%30)
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
ldis %28, 11
add %29, %29, %28
ld.b %12, 0(%29)
ldis %29, 0
cmp %14, %29
beq .LC360
ldis %29, 4
cmp %14, %29
bne .LC356
jmpd .LC364
ld.l %29, 20(%30)
ldis %28, 8
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
ld.l %29, 20(%30)
ldis %28, 20
add %29, %29, %28
ldi %28, 0
st.l %28, 0(%29)
mov %29, %12
andi %29, %29, 4
ldis %28, 0
cmp %29, %28
bne .LC366
jmpd .LC354
.LC366:
ldis %14, 0
jmpd .LC356
.LC364:
mov %29, %12
andi %29, %29, 4
ldis %28, 0
cmp %29, %28
bne .LC356
ldis %14, 5
jmpd .LC356
.LC360:
mov %29, %12
andi %29, %29, 4
ldis %28, 0
cmp %29, %28
beq .LC370
jmpd .LC356
.LC370:
ld.l %29, 20(%30)
ldis %28, 20
add %29, %29, %28
ld.l %13, 0(%29)
ldis %29, 11
add %29, %13, %29
ld.b %29, 0(%29)
andi %29, %29, 16
ldis %28, 0
cmp %29, %28
bne .LC372
ldis %14, 5
jmpd .LC356
.LC372:
push %13
ld.l %29, 20(%30)
st.l %29, -4(%30)
ld.l %28, 0(%29)
push %28
jsrd ld_clust
addsp 8
ldis %28, 8
ld.l %27, -4(%30)
add %28, %27, %28
st.l %15, 0(%28)
jmpd .LC354
.LC356:
.LC353:
mov %15, %14
.LC348:
movts %30
pop %30
pop %14
pop %13
pop %12
rts
.Lf374:
.size follow_path,.Lf374-follow_path
.align 4
.type get_ldnumber,@function
get_ldnumber:
push %14
push %30
movfs %30
subsp 12
ldis %29, -1
st.l %29, -4(%30)
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
beq .LC376
ld.l %29, 12(%30)
ld.l %14, 0(%29)
jmpd .LC381
.LC378:
.LC379:
inc %14
.LC381:
ld.b %29, 0(%14)
mov %28, %29
ldiu %27, 33
cmp %28, %27
bltu .LC382
ldis %28, 58
cmp %29, %28
bne .LC378
.LC382:
ld.b %29, 0(%14)
ldis %28, 58
cmp %29, %28
bne .LC383
ld.l %29, 12(%30)
ld.l %29, 0(%29)
st.l %29, -8(%30)
ld.l %29, -8(%30)
ldis %28, 1
add %28, %29, %28
st.l %28, -8(%30)
ld.b %29, 0(%29)
subi %29, %29, 48
st.l %29, -12(%30)
ld.l %29, -12(%30)
ldiu %28, 10
cmp %29, %28
bgeu .LC385
ld.l %29, -8(%30)
mov %28, %14
cmp %29, %28
bne .LC385
ld.l %29, -12(%30)
ldiu %28, 1
cmp %29, %28
bgeu .LC386
ld.l %29, -12(%30)
st.l %29, -4(%30)
ldis %29, 1
add %29, %14, %29
mov %14, %29
ld.l %28, 12(%30)
st.l %29, 0(%28)
.LC385:
.LC386:
ld.l %15, -4(%30)
jmpd .LC375
.LC383:
ldis %29, 0
st.l %29, -4(%30)
.LC376:
ld.l %15, -4(%30)
.LC375:
movts %30
pop %30
pop %14
rts
.Lf389:
.size get_ldnumber,.Lf389-get_ldnumber
.align 4
.type check_fs,@function
check_fs:
push %30
movfs %30
ld.l %29, 8(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 0
st.b %28, 0(%29)
ld.l %29, 8(%30)
ldis %28, 44
add %29, %29, %28
ldi %28, 0xffffffff
st.l %28, 0(%29)
ld.l %29, 12(%30)
push %29
ld.l %29, 8(%30)
push %29
jsrd move_window
addsp 8
ldis %28, 0
cmp %15, %28
beq .LC391
ldis %15, 3
jmpd .LC390
.LC391:
ld.l %29, 8(%30)
ldis %28, 559
add %28, %29, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
ldis %27, 558
add %29, %29, %27
ld.b %29, 0(%29)
or %29, %28, %29
ldi %28, 43605
cmp %29, %28
beq .LC393
ldis %15, 2
jmpd .LC390
.LC393:
ld.l %29, 8(%30)
ldis %28, 105
add %28, %29, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 104
add %27, %29, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 103
add %27, %29, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %28, %28, %27
ldis %27, 102
add %29, %29, %27
ld.b %29, 0(%29)
or %29, %28, %29
ldi %28, 0xffffff
and %29, %29, %28
ldi %28, 0x544146
cmp %29, %28
bne .LC395
ldis %15, 0
jmpd .LC390
.LC395:
ld.l %29, 8(%30)
ldis %28, 133
add %28, %29, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 132
add %27, %29, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 131
add %27, %29, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %28, %28, %27
ldis %27, 130
add %29, %29, %27
ld.b %29, 0(%29)
or %29, %28, %29
ldi %28, 0xffffff
and %29, %29, %28
ldi %28, 0x544146
cmp %29, %28
bne .LC397
ldis %15, 0
jmpd .LC390
.LC397:
ldis %15, 1
.LC390:
movts %30
pop %30
rts
.Lf399:
.size check_fs,.Lf399-check_fs
.align 4
.type find_volume,@function
find_volume:
push %2
push %3
push %4
push %5
push %6
push %7
push %8
push %9
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
subsp 20
ld.l %29, 68(%30)
st.b %29, 68(%30)
ld.l %29, 60(%30)
ldi %28, 0
st.l %28, 0(%29)
ld.l %29, 64(%30)
push %29
jsrd get_ldnumber
addsp 4
mov %7, %15
ldis %29, 0
cmp %7, %29
bge .LC401
ldis %15, 11
jmpd .LC400
.LC401:
lsli %29, %7, 2
ld.l %14, FatFs(%29)
mov %29, %14
ldiu %28, 0
cmp %29, %28
bne .LC403
ldis %15, 12
jmpd .LC400
.LC403:
ld.l %29, 60(%30)
st.l %14, 0(%29)
ld.b %29, 0(%14)
ldis %28, 0
cmp %29, %28
beq .LC405
ldis %29, 1
add %29, %14, %29
ld.b %29, 0(%29)
push %29
jsrd disk_status
addsp 4
mov %29, %15
mov %8, %29
mov %29, %8
andi %29, %29, 1
ldis %28, 0
cmp %29, %28
bne .LC407
ldis %29, 0
ld.b %28, 68(%30)
cmp %28, %29
beq .LC409
mov %28, %8
andi %28, %28, 4
cmp %28, %29
beq .LC409
ldis %15, 10
jmpd .LC400
.LC409:
ldis %15, 0
jmpd .LC400
.LC407:
.LC405:
ldiu %29, 0
st.b %29, 0(%14)
ldis %29, 1
add %29, %14, %29
mov %28, %7
st.b %28, 0(%29)
ldis %29, 1
add %29, %14, %29
ld.b %29, 0(%29)
push %29
jsrd disk_initialize
addsp 4
mov %29, %15
mov %8, %29
mov %29, %8
andi %29, %29, 1
ldis %28, 0
cmp %29, %28
beq .LC411
ldis %15, 3
jmpd .LC400
.LC411:
ldis %29, 0
ld.b %28, 68(%30)
cmp %28, %29
beq .LC413
mov %28, %8
andi %28, %28, 4
cmp %28, %29
beq .LC413
ldis %15, 10
jmpd .LC400
.LC413:
ldiu %13, 0
push %13
push %14
jsrd check_fs
addsp 8
mov %29, %15
mov %12, %29
mov %29, %12
ldis %28, 1
cmp %29, %28
beq .LC417
ldis %28, 0
cmp %29, %28
bne .LC415
jmpd .LC415
.LC417:
ldiu %4, 0
jmpd .LC421
.LC418:
lsli %29, %4, 4
ldis %28, 494
add %28, %14, %28
add %3, %29, %28
ldis %29, 4
add %29, %3, %29
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC423
ldis %29, 8
ldis %28, 11
add %28, %3, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 10
add %27, %3, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 9
add %27, %3, %27
ld.b %27, 0(%27)
lsl %27, %27, %29
or %28, %28, %27
add %29, %3, %29
ld.b %29, 0(%29)
or %2, %28, %29
jmpd .LC424
.LC423:
ldiu %2, 0
.LC424:
lsli %29, %4, 2
lda %28, -20(%30)
add %29, %29, %28
st.l %2, 0(%29)
.LC419:
inc %4
.LC421:
ldiu %29, 4
cmp %4, %29
bltu .LC418
ldiu %29, 0
mov %4, %29
cmp %4, %29
beq .LC425
dec %4
.LC425:
.LC427:
lsli %29, %4, 2
lda %28, -20(%30)
add %29, %29, %28
ld.l %13, 0(%29)
ldiu %29, 0
cmp %13, %29
beq .LC431
push %13
push %14
jsrd check_fs
addsp 8
mov %29, %15
mov %3, %29
jmpd .LC432
.LC431:
ldis %3, 2
.LC432:
mov %29, %3
mov %12, %29
.LC428:
mov %29, %12
ldis %28, 0
cmp %29, %28
beq .LC433
addi %29, %4, 1
mov %4, %29
ldiu %28, 4
cmp %29, %28
bltu .LC427
.LC433:
.LC415:
mov %29, %12
ldis %28, 3
cmp %29, %28
bne .LC434
ldis %15, 1
jmpd .LC400
.LC434:
mov %29, %12
ldis %28, 0
cmp %29, %28
beq .LC436
ldis %15, 13
jmpd .LC400
.LC436:
ldis %29, 60
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ldis %28, 59
add %28, %14, %28
ld.b %28, 0(%28)
or %29, %29, %28
ldiu %28, 512
cmp %29, %28
beq .LC438
ldis %15, 13
jmpd .LC400
.LC438:
ldis %29, 71
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ldis %28, 70
add %28, %14, %28
ld.b %28, 0(%28)
or %29, %29, %28
mov %11, %29
ldiu %29, 0
cmp %11, %29
bne .LC440
ldis %29, 87
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 24
ldis %28, 86
add %28, %14, %28
ld.b %28, 0(%28)
lsli %28, %28, 16
or %29, %29, %28
ldis %28, 85
add %28, %14, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
or %29, %29, %28
ldis %28, 84
add %28, %14, %28
ld.b %28, 0(%28)
or %11, %29, %28
.LC440:
ldis %29, 24
add %29, %14, %29
st.l %11, 0(%29)
ldis %29, 3
add %29, %14, %29
ldis %28, 64
add %28, %14, %28
ld.b %28, 0(%28)
st.b %28, 0(%29)
ldis %29, 3
add %29, %14, %29
ld.b %29, 0(%29)
ldis %28, 1
cmp %29, %28
beq .LC442
ldis %28, 2
cmp %29, %28
beq .LC442
ldis %15, 13
jmpd .LC400
.LC442:
ldis %29, 3
add %29, %14, %29
ld.b %29, 0(%29)
mulu %11, %11, %29
ldis %29, 2
add %29, %14, %29
ldis %28, 61
add %28, %14, %28
ld.b %28, 0(%28)
st.b %28, 0(%29)
ldis %29, 2
add %29, %14, %29
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC446
subi %27, %29, 1
and %29, %29, %27
cmp %29, %28
beq .LC444
.LC446:
ldis %15, 13
jmpd .LC400
.LC444:
ldis %29, 8
add %28, %14, %29
ldis %27, 66
add %27, %14, %27
ld.b %27, 0(%27)
lsl %29, %27, %29
ldis %27, 65
add %27, %14, %27
ld.b %27, 0(%27)
or %29, %29, %27
st %29, 0(%28)
ldis %29, 8
add %29, %14, %29
ld %29, 0(%29)
andi %29, %29, 15
ldiu %28, 0
cmp %29, %28
beq .LC447
ldis %15, 13
jmpd .LC400
.LC447:
ldis %29, 68
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ldis %28, 67
add %28, %14, %28
ld.b %28, 0(%28)
or %29, %29, %28
mov %9, %29
ldiu %29, 0
cmp %9, %29
bne .LC449
ldis %29, 83
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 24
ldis %28, 82
add %28, %14, %28
ld.b %28, 0(%28)
lsli %28, %28, 16
or %29, %29, %28
ldis %28, 81
add %28, %14, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
or %29, %29, %28
ldis %28, 80
add %28, %14, %28
ld.b %28, 0(%28)
or %9, %29, %28
.LC449:
ldis %29, 63
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ldis %28, 62
add %28, %14, %28
ld.b %28, 0(%28)
or %29, %29, %28
mov %5, %29
mov %29, %5
ldis %28, 0
cmp %29, %28
bne .LC451
ldis %15, 13
jmpd .LC400
.LC451:
mov %29, %5
add %29, %29, %11
ldis %28, 8
add %28, %14, %28
ld %28, 0(%28)
lsri %28, %28, 4
add %6, %29, %28
cmp %9, %6
bgeu .LC453
ldis %15, 13
jmpd .LC400
.LC453:
sub %29, %9, %6
ldis %28, 2
add %28, %14, %28
ld.b %28, 0(%28)
divu %10, %29, %28
ldiu %29, 0
cmp %10, %29
bne .LC455
ldis %15, 13
jmpd .LC400
.LC455:
ldiu %12, 1
ldiu %29, 4086
cmp %10, %29
bltu .LC457
ldiu %12, 2
.LC457:
ldiu %29, 0xfff6
cmp %10, %29
bltu .LC459
ldiu %12, 3
.LC459:
ldis %29, 20
add %29, %14, %29
addi %28, %10, 2
st.l %28, 0(%29)
ldis %29, 28
add %29, %14, %29
st.l %13, 0(%29)
ldis %29, 32
add %29, %14, %29
mov %28, %5
add %28, %13, %28
st.l %28, 0(%29)
ldis %29, 40
add %29, %14, %29
add %28, %13, %6
st.l %28, 0(%29)
mov %29, %12
ldis %28, 3
cmp %29, %28
bne .LC461
ldis %29, 8
add %29, %14, %29
ld %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC463
ldis %15, 13
jmpd .LC400
.LC463:
ldis %29, 36
add %29, %14, %29
ldis %28, 95
add %28, %14, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 94
add %27, %14, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 93
add %27, %14, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %28, %28, %27
ldis %27, 92
add %27, %14, %27
ld.b %27, 0(%27)
or %28, %28, %27
st.l %28, 0(%29)
ldis %29, 20
add %29, %14, %29
ld.l %29, 0(%29)
lsli %29, %29, 2
st.l %29, -4(%30)
jmpd .LC462
.LC461:
ldis %29, 8
add %29, %14, %29
ld %29, 0(%29)
ldis %28, 0
cmp %29, %28
bne .LC465
ldis %15, 13
jmpd .LC400
.LC465:
ldis %29, 36
add %29, %14, %29
ldis %28, 32
add %28, %14, %28
ld.l %28, 0(%28)
add %28, %28, %11
st.l %28, 0(%29)
mov %29, %12
ldis %28, 2
cmp %29, %28
bne .LC468
ldis %29, 20
add %29, %14, %29
ld.l %29, 0(%29)
lsli %4, %29, 1
jmpd .LC469
.LC468:
ldis %29, 20
add %29, %14, %29
ld.l %29, 0(%29)
ldiu %28, 3
mulu %28, %28, %29
lsri %28, %28, 1
andi %29, %29, 1
add %4, %28, %29
.LC469:
st.l %4, -4(%30)
.LC462:
ldis %29, 24
add %29, %14, %29
ld.l %29, 0(%29)
ld.l %28, -4(%30)
addi %28, %28, 511
lsri %28, %28, 9
cmp %29, %28
bgeu .LC470
ldis %15, 13
jmpd .LC400
.LC470:
ldi %29, 0xffffffff
ldis %28, 16
add %28, %14, %28
st.l %29, 0(%28)
ldis %28, 12
add %28, %14, %28
st.l %29, 0(%28)
ldis %29, 5
add %29, %14, %29
ldiu %28, 128
st.b %28, 0(%29)
mov %29, %12
ldis %28, 3
cmp %29, %28
bne .LC472
ldis %29, 97
add %29, %14, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ldis %28, 96
add %28, %14, %28
ld.b %28, 0(%28)
or %29, %29, %28
ldis %28, 1
cmp %29, %28
bne .LC472
addi %29, %13, 1
push %29
push %14
jsrd move_window
addsp 8
ldis %28, 0
cmp %15, %28
bne .LC472
ldis %29, 5
add %29, %14, %29
ldiu %28, 0
st.b %28, 0(%29)
ldis %29, 8
ldis %28, 559
add %28, %14, %28
ld.b %28, 0(%28)
lsl %28, %28, %29
ldis %27, 558
add %27, %14, %27
ld.b %27, 0(%27)
or %28, %28, %27
ldi %27, 43605
cmp %28, %27
bne .LC474
ldis %28, 24
ldis %27, 16
ldis %26, 51
add %26, %14, %26
ld.b %26, 0(%26)
lsl %26, %26, %28
ldis %25, 50
add %25, %14, %25
ld.b %25, 0(%25)
lsl %25, %25, %27
or %26, %26, %25
ldis %25, 49
add %25, %14, %25
ld.b %25, 0(%25)
lsl %25, %25, %29
or %26, %26, %25
ldis %25, 48
add %25, %14, %25
ld.b %25, 0(%25)
or %26, %26, %25
ldi %25, 0x41615252
cmp %26, %25
bne .LC474
ldis %26, 535
add %26, %14, %26
ld.b %26, 0(%26)
lsl %28, %26, %28
ldis %26, 534
add %26, %14, %26
ld.b %26, 0(%26)
lsl %27, %26, %27
or %28, %28, %27
ldis %27, 533
add %27, %14, %27
ld.b %27, 0(%27)
lsl %29, %27, %29
or %29, %28, %29
ldis %28, 532
add %28, %14, %28
ld.b %28, 0(%28)
or %29, %29, %28
ldi %28, 0x61417272
cmp %29, %28
bne .LC474
ldis %29, 16
add %28, %14, %29
ldis %27, 539
add %27, %14, %27
ld.b %27, 0(%27)
lsli %27, %27, 24
ldis %26, 538
add %26, %14, %26
ld.b %26, 0(%26)
lsl %29, %26, %29
or %29, %27, %29
ldis %27, 537
add %27, %14, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %29, %29, %27
ldis %27, 536
add %27, %14, %27
ld.b %27, 0(%27)
or %29, %29, %27
st.l %29, 0(%28)
ldis %29, 12
add %29, %14, %29
ldis %28, 543
add %28, %14, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 542
add %27, %14, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 541
add %27, %14, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %28, %28, %27
ldis %27, 540
add %27, %14, %27
ld.b %27, 0(%27)
or %28, %28, %27
st.l %28, 0(%29)
.LC474:
.LC472:
st.b %12, 0(%14)
ldi %29, Fsid
ld %28, 0(%29)
addi %28, %28, 1
st %28, 0(%29)
ldis %29, 6
add %29, %14, %29
st %28, 0(%29)
ldis %15, 0
.LC400:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
pop %9
pop %8
pop %7
pop %6
pop %5
pop %4
pop %3
pop %2
rts
.Lf476:
.size find_volume,.Lf476-find_volume
.align 4
.type validate,@function
validate:
push %14
push %30
movfs %30
ld.l %14, 12(%30)
ldiu %29, 0
mov %28, %14
cmp %28, %29
beq .LC482
ld.l %28, 0(%14)
mov %27, %28
cmp %27, %29
beq .LC482
ld.b %29, 0(%28)
ldis %27, 0
cmp %29, %27
beq .LC482
ldis %29, 6
add %29, %28, %29
ld %29, 0(%29)
ldis %28, 4
add %28, %14, %28
ld %28, 0(%28)
cmp %29, %28
beq .LC478
.LC482:
ldis %15, 9
jmpd .LC477
.LC478:
ld.l %29, 0(%14)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_status
addsp 4
mov %29, %15
andi %29, %29, 1
ldis %28, 0
cmp %29, %28
beq .LC483
ldis %15, 3
jmpd .LC477
.LC483:
ldis %15, 0
.LC477:
movts %30
pop %30
pop %14
rts
.Lf485:
.size validate,.Lf485-validate
.globl f_mount
.align 4
.type f_mount,@function
f_mount:
push %14
push %30
movfs %30
subsp 12
ld.l %29, 20(%30)
st.b %29, 20(%30)
ld.l %29, 16(%30)
st.l %29, -12(%30)
lda %29, -12(%30)
push %29
jsrd get_ldnumber
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bge .LC487
ldis %15, 11
jmpd .LC486
.LC487:
lsli %29, %14, 2
ld.l %29, FatFs(%29)
st.l %29, -4(%30)
ld.l %29, -4(%30)
ldiu %28, 0
cmp %29, %28
beq .LC489
ld.l %29, -4(%30)
ldiu %28, 0
st.b %28, 0(%29)
.LC489:
ld.l %29, 12(%30)
ldiu %28, 0
cmp %29, %28
beq .LC491
ld.l %29, 12(%30)
ldiu %28, 0
st.b %28, 0(%29)
.LC491:
lsli %29, %14, 2
ld.l %28, 12(%30)
st.l %28, FatFs(%29)
ld.l %29, 12(%30)
ldiu %28, 0
cmp %29, %28
beq .LC495
ld.b %29, 20(%30)
ldis %28, 1
cmp %29, %28
beq .LC493
.LC495:
ldis %15, 0
jmpd .LC486
.LC493:
ldis %29, 0
push %29
lda %29, 16(%30)
push %29
lda %29, 12(%30)
push %29
jsrd find_volume
addsp 12
st.l %15, -8(%30)
ld.l %15, -8(%30)
.LC486:
movts %30
pop %30
pop %14
rts
.Lf496:
.size f_mount,.Lf496-f_mount
.globl f_open
.align 4
.type f_open,@function
f_open:
push %13
push %14
push %30
movfs %30
subsp 48
ld.l %29, 24(%30)
st.b %29, 24(%30)
ld.l %29, 16(%30)
ldiu %28, 0
cmp %29, %28
bne .LC498
ldis %15, 9
jmpd .LC497
.LC498:
ld.l %29, 16(%30)
ldi %28, 0
st.l %28, 0(%29)
ld.b %29, 24(%30)
andi %29, %29, 31
st.b %29, 24(%30)
ld.b %29, 24(%30)
andi %29, %29, -2
push %29
lda %29, 20(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC500
lda %29, -40(%30)
st.l %29, -4(%30)
ld.l %29, 20(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
ld.l %13, -8(%30)
ldis %29, 0
cmp %14, %29
bne .LC504
mov %29, %13
ldiu %28, 0
cmp %29, %28
bne .LC506
ldis %14, 6
.LC506:
.LC504:
ld.b %29, 24(%30)
andi %29, %29, 28
ldis %28, 0
cmp %29, %28
beq .LC508
ldis %29, 0
cmp %14, %29
beq .LC510
ldis %29, 4
cmp %14, %29
bne .LC512
lda %29, -28(%30)
push %29
jsrd dir_register
addsp 4
mov %14, %15
.LC512:
ld.b %29, 24(%30)
ori %29 %29, 8
st.b %29, 24(%30)
ld.l %13, -8(%30)
jmpd .LC511
.LC510:
ldis %29, 11
add %29, %13, %29
ld.b %29, 0(%29)
andi %29, %29, 17
ldis %28, 0
cmp %29, %28
beq .LC515
ldis %14, 7
jmpd .LC516
.LC515:
ld.b %29, 24(%30)
andi %29, %29, 4
ldis %28, 0
cmp %29, %28
beq .LC517
ldis %14, 8
.LC517:
.LC516:
.LC511:
ldis %29, 0
cmp %14, %29
bne .LC509
ld.b %28, 24(%30)
andi %28, %28, 8
cmp %28, %29
beq .LC509
jsrd get_fattime
st.l %15, -44(%30)
ldis %29, 14
add %29, %13, %29
ld.l %28, -44(%30)
st.b %28, 0(%29)
ldis %29, 15
add %29, %13, %29
ld.l %28, -44(%30)
asri %28, %28, 8
st.b %28, 0(%29)
ldis %29, 16
add %28, %13, %29
ld.l %27, -44(%30)
lsr %29, %27, %29
st.b %29, 0(%28)
ldis %29, 17
add %29, %13, %29
ld.l %28, -44(%30)
lsri %28, %28, 24
st.b %28, 0(%29)
ldis %29, 11
add %29, %13, %29
ldiu %28, 0
st.b %28, 0(%29)
ldis %29, 28
add %29, %13, %29
ldiu %28, 0
st.b %28, 0(%29)
ldis %29, 29
add %29, %13, %29
ldiu %28, 0
st.b %28, 0(%29)
ldis %29, 30
add %29, %13, %29
ldiu %28, 0
st.b %28, 0(%29)
ldis %29, 31
add %29, %13, %29
ldiu %28, 0
st.b %28, 0(%29)
push %13
ld.l %29, -28(%30)
push %29
jsrd ld_clust
addsp 8
st.l %15, -48(%30)
ldiu %29, 0
push %29
push %13
jsrd st_clust
addsp 8
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, -48(%30)
ldiu %28, 0
cmp %29, %28
beq .LC509
ld.l %29, -28(%30)
ldis %28, 44
add %28, %29, %28
ld.l %28, 0(%28)
st.l %28, -44(%30)
ld.l %28, -48(%30)
push %28
push %29
jsrd remove_chain
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC509
ld.l %29, -28(%30)
ldis %28, 12
add %29, %29, %28
ld.l %28, -48(%30)
subi %28, %28, 1
st.l %28, 0(%29)
ld.l %29, -44(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd move_window
addsp 8
mov %14, %15
jmpd .LC509
.LC508:
ldis %29, 0
cmp %14, %29
bne .LC525
ldis %29, 11
add %29, %13, %29
ld.b %29, 0(%29)
andi %29, %29, 16
ldis %28, 0
cmp %29, %28
beq .LC527
ldis %14, 4
jmpd .LC528
.LC527:
ldis %29, 0
ld.b %28, 24(%30)
andi %28, %28, 2
cmp %28, %29
beq .LC529
ldis %28, 11
add %28, %13, %28
ld.b %28, 0(%28)
andi %28, %28, 1
cmp %28, %29
beq .LC529
ldis %14, 7
.LC529:
.LC528:
.LC525:
.LC509:
ldis %29, 0
cmp %14, %29
bne .LC531
ld.b %29, 24(%30)
andi %29, %29, 8
ldis %28, 0
cmp %29, %28
beq .LC533
ld.b %29, 24(%30)
ori %29 %29, 32
st.b %29, 24(%30)
.LC533:
ld.l %29, 16(%30)
ldis %28, 28
add %29, %29, %28
ld.l %28, -28(%30)
ldis %27, 44
add %28, %28, %27
ld.l %28, 0(%28)
st.l %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 32
add %29, %29, %28
st.l %13, 0(%29)
.LC531:
ldis %29, 0
cmp %14, %29
bne .LC535
ld.l %29, 16(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 24(%30)
st.b %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 0
st.b %28, 0(%29)
push %13
ld.l %29, -28(%30)
push %29
jsrd ld_clust
addsp 8
ld.l %28, 16(%30)
ldis %27, 16
add %28, %28, %27
st.l %15, 0(%28)
ld.l %29, 16(%30)
ldis %28, 12
add %29, %29, %28
ldis %28, 31
add %28, %13, %28
ld.b %28, 0(%28)
lsli %28, %28, 24
ldis %27, 30
add %27, %13, %27
ld.b %27, 0(%27)
lsli %27, %27, 16
or %28, %28, %27
ldis %27, 29
add %27, %13, %27
ld.b %27, 0(%27)
lsli %27, %27, 8
or %28, %28, %27
ldis %27, 28
add %27, %13, %27
ld.b %27, 0(%27)
or %28, %28, %27
st.l %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 8
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 24
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
ld.l %29, 16(%30)
ld.l %28, -28(%30)
st.l %28, 0(%29)
ld.l %29, 16(%30)
ldis %28, 4
add %28, %29, %28
ld.l %29, 0(%29)
ldis %27, 6
add %29, %29, %27
ld %29, 0(%29)
st %29, 0(%28)
.LC535:
.LC500:
mov %15, %14
.LC497:
movts %30
pop %30
pop %14
pop %13
rts
.Lf537:
.size f_open,.Lf537-f_open
.globl f_read
.align 4
.type f_read,@function
f_read:
push %9
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
subsp 8
ld.l %12, 36(%30)
ld.l %29, 44(%30)
ldiu %28, 0
st.l %28, 0(%29)
ld.l %29, 32(%30)
push %29
jsrd validate
addsp 4
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldis %28, 0
cmp %29, %28
beq .LC539
ld.l %15, -4(%30)
jmpd .LC538
.LC539:
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC541
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
mov %15, %29
jmpd .LC538
.LC541:
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 1
ldis %28, 0
cmp %29, %28
bne .LC543
ldis %15, 7
jmpd .LC538
.LC543:
ld.l %29, 32(%30)
ldis %28, 12
add %28, %29, %28
ld.l %28, 0(%28)
ldis %27, 8
add %29, %29, %27
ld.l %29, 0(%29)
sub %29, %28, %29
st.l %29, -8(%30)
ld.l %29, 40(%30)
ld.l %28, -8(%30)
cmp %29, %28
bleu .LC550
ld.l %29, -8(%30)
st.l %29, 40(%30)
jmpd .LC550
.LC547:
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %29, 0(%29)
andi %29, %29, 511
ldiu %28, 0
cmp %29, %28
bne .LC551
ld.l %29, 32(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
lsri %28, %28, 9
ld.l %29, 0(%29)
ldis %27, 2
add %29, %29, %27
ld.b %29, 0(%29)
subi %29, %29, 1
and %29, %28, %29
mov %10, %29
mov %29, %10
ldis %28, 0
cmp %29, %28
bne .LC553
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC555
ld.l %29, 32(%30)
ldis %28, 16
add %29, %29, %28
ld.l %9, 0(%29)
jmpd .LC556
.LC555:
ld.l %29, 32(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd get_fat
addsp 8
mov %9, %15
.LC556:
ldiu %29, 2
cmp %9, %29
bgeu .LC557
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC538
.LC557:
ldi %29, 0xffffffff
cmp %9, %29
bne .LC559
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC538
.LC559:
ld.l %29, 32(%30)
ldis %28, 20
add %29, %29, %28
st.l %9, 0(%29)
.LC553:
ld.l %29, 32(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd clust2sect
addsp 8
mov %13, %15
ldiu %29, 0
cmp %13, %29
bne .LC561
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC538
.LC561:
mov %29, %10
add %13, %13, %29
ld.l %29, 40(%30)
lsri %11, %29, 9
ldiu %29, 0
cmp %11, %29
beq .LC563
mov %29, %10
add %29, %29, %11
ld.l %28, 32(%30)
ld.l %28, 0(%28)
ldis %27, 2
add %28, %28, %27
ld.b %28, 0(%28)
cmp %29, %28
bleu .LC565
ld.l %29, 32(%30)
ld.l %29, 0(%29)
ldis %28, 2
add %29, %29, %28
ld.b %29, 0(%29)
mov %28, %10
sub %29, %29, %28
mov %11, %29
.LC565:
push %11
push %13
push %12
ld.l %29, 32(%30)
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_read
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC567
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC538
.LC567:
ld.l %29, 32(%30)
ldis %28, 6
add %28, %29, %28
ld.b %28, 0(%28)
andi %28, %28, 64
ldis %27, 0
cmp %28, %27
beq .LC569
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
sub %29, %29, %13
cmp %29, %11
bgeu .LC569
ldiu %29, 512
push %29
ld.l %29, 32(%30)
ldis %28, 36
add %28, %29, %28
push %28
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
sub %29, %29, %13
lsli %29, %29, 9
add %29, %29, %12
push %29
jsrd mem_cpy
addsp 12
.LC569:
lsli %14, %11, 9
jmpd .LC548
.LC563:
ld.l %29, 32(%30)
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
cmp %29, %13
beq .LC571
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 64
ldis %28, 0
cmp %29, %28
beq .LC573
ldiu %29, 1
push %29
ld.l %29, 32(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC575
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC538
.LC575:
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -65
st.b %28, 0(%29)
.LC573:
ldiu %29, 1
push %29
push %13
ld.l %29, 32(%30)
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_read
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC577
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC538
.LC577:
.LC571:
ld.l %29, 32(%30)
ldis %28, 24
add %29, %29, %28
st.l %13, 0(%29)
.LC551:
ldiu %29, 512
ld.l %28, 32(%30)
ldis %27, 8
add %28, %28, %27
ld.l %28, 0(%28)
andi %28, %28, 511
sub %14, %29, %28
ld.l %29, 40(%30)
cmp %14, %29
bleu .LC579
ld.l %14, 40(%30)
.LC579:
push %14
ld.l %29, 32(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
andi %28, %28, 511
ldis %27, 36
add %29, %29, %27
add %29, %28, %29
push %29
push %12
jsrd mem_cpy
addsp 12
.LC548:
add %12, %14, %12
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %28, 0(%29)
add %28, %28, %14
st.l %28, 0(%29)
ld.l %29, 44(%30)
ld.l %28, 0(%29)
add %28, %28, %14
st.l %28, 0(%29)
ld.l %29, 40(%30)
sub %29, %29, %14
st.l %29, 40(%30)
.LC550:
ld.l %29, 40(%30)
ldiu %28, 0
cmp %29, %28
bne .LC547
ldis %15, 0
.LC538:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
pop %9
rts
.Lf581:
.size f_read,.Lf581-f_read
.globl f_write
.align 4
.type f_write,@function
f_write:
push %9
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
subsp 4
ld.l %12, 36(%30)
ld.l %29, 44(%30)
ldiu %28, 0
st.l %28, 0(%29)
ld.l %29, 32(%30)
push %29
jsrd validate
addsp 4
st.l %15, -4(%30)
ld.l %29, -4(%30)
ldis %28, 0
cmp %29, %28
beq .LC583
ld.l %15, -4(%30)
jmpd .LC582
.LC583:
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC585
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
mov %15, %29
jmpd .LC582
.LC585:
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 2
ldis %28, 0
cmp %29, %28
bne .LC587
ldis %15, 7
jmpd .LC582
.LC587:
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %29, 0(%29)
ld.l %28, 40(%30)
add %28, %29, %28
cmp %28, %29
bgeu .LC594
ldiu %29, 0
st.l %29, 40(%30)
jmpd .LC594
.LC591:
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %29, 0(%29)
andi %29, %29, 511
ldiu %28, 0
cmp %29, %28
bne .LC595
ld.l %29, 32(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
lsri %28, %28, 9
ld.l %29, 0(%29)
ldis %27, 2
add %29, %29, %27
ld.b %29, 0(%29)
subi %29, %29, 1
and %29, %28, %29
mov %10, %29
mov %29, %10
ldis %28, 0
cmp %29, %28
bne .LC597
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC599
ld.l %29, 32(%30)
ldis %28, 16
add %29, %29, %28
ld.l %9, 0(%29)
ldiu %29, 0
cmp %9, %29
bne .LC600
ldiu %29, 0
push %29
ld.l %29, 32(%30)
ld.l %29, 0(%29)
push %29
jsrd create_chain
addsp 8
mov %9, %15
jmpd .LC600
.LC599:
ld.l %29, 32(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd create_chain
addsp 8
mov %9, %15
.LC600:
ldiu %29, 0
cmp %9, %29
bne .LC603
jmpd .LC593
.LC603:
ldiu %29, 1
cmp %9, %29
bne .LC605
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC582
.LC605:
ldi %29, 0xffffffff
cmp %9, %29
bne .LC607
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC582
.LC607:
ld.l %29, 32(%30)
ldis %28, 20
add %29, %29, %28
st.l %9, 0(%29)
ld.l %29, 32(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC609
ld.l %29, 32(%30)
ldis %28, 16
add %29, %29, %28
st.l %9, 0(%29)
.LC609:
.LC597:
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 64
ldis %28, 0
cmp %29, %28
beq .LC611
ldiu %29, 1
push %29
ld.l %29, 32(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC613
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC582
.LC613:
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -65
st.b %28, 0(%29)
.LC611:
ld.l %29, 32(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd clust2sect
addsp 8
mov %13, %15
ldiu %29, 0
cmp %13, %29
bne .LC615
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC582
.LC615:
mov %29, %10
add %13, %13, %29
ld.l %29, 40(%30)
lsri %11, %29, 9
ldiu %29, 0
cmp %11, %29
beq .LC617
mov %29, %10
add %29, %29, %11
ld.l %28, 32(%30)
ld.l %28, 0(%28)
ldis %27, 2
add %28, %28, %27
ld.b %28, 0(%28)
cmp %29, %28
bleu .LC619
ld.l %29, 32(%30)
ld.l %29, 0(%29)
ldis %28, 2
add %29, %29, %28
ld.b %29, 0(%29)
mov %28, %10
sub %29, %29, %28
mov %11, %29
.LC619:
push %11
push %13
push %12
ld.l %29, 32(%30)
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC621
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC582
.LC621:
ld.l %29, 32(%30)
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
sub %29, %29, %13
cmp %29, %11
bgeu .LC623
ldiu %29, 512
push %29
ld.l %29, 32(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
sub %28, %28, %13
lsli %28, %28, 9
add %28, %28, %12
push %28
ldis %28, 36
add %29, %29, %28
push %29
jsrd mem_cpy
addsp 12
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -65
st.b %28, 0(%29)
.LC623:
lsli %14, %11, 9
jmpd .LC592
.LC617:
ld.l %29, 32(%30)
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
cmp %29, %13
beq .LC625
ld.l %29, 32(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
ldis %27, 12
add %27, %29, %27
ld.l %27, 0(%27)
cmp %28, %27
bgeu .LC627
ldiu %28, 1
push %28
push %13
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_read
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC627
ld.l %29, 32(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC582
.LC627:
.LC625:
ld.l %29, 32(%30)
ldis %28, 24
add %29, %29, %28
st.l %13, 0(%29)
.LC595:
ldiu %29, 512
ld.l %28, 32(%30)
ldis %27, 8
add %28, %28, %27
ld.l %28, 0(%28)
andi %28, %28, 511
sub %14, %29, %28
ld.l %29, 40(%30)
cmp %14, %29
bleu .LC629
ld.l %14, 40(%30)
.LC629:
push %14
push %12
ld.l %29, 32(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
andi %28, %28, 511
ldis %27, 36
add %29, %29, %27
add %29, %28, %29
push %29
jsrd mem_cpy
addsp 12
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
ori %28 %28, 64
st.b %28, 0(%29)
.LC592:
add %12, %14, %12
ld.l %29, 32(%30)
ldis %28, 8
add %29, %29, %28
ld.l %28, 0(%29)
add %28, %28, %14
st.l %28, 0(%29)
ld.l %29, 44(%30)
ld.l %28, 0(%29)
add %28, %28, %14
st.l %28, 0(%29)
ld.l %29, 40(%30)
sub %29, %29, %14
st.l %29, 40(%30)
.LC594:
ld.l %29, 40(%30)
ldiu %28, 0
cmp %29, %28
bne .LC591
.LC593:
ld.l %29, 32(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
ldis %27, 12
add %29, %29, %27
ld.l %29, 0(%29)
cmp %28, %29
bleu .LC631
ld.l %29, 32(%30)
ldis %28, 12
add %28, %29, %28
ldis %27, 8
add %29, %29, %27
ld.l %29, 0(%29)
st.l %29, 0(%28)
.LC631:
ld.l %29, 32(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
ori %28 %28, 32
st.b %28, 0(%29)
ldis %15, 0
.LC582:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
pop %9
rts
.Lf633:
.size f_write,.Lf633-f_write
.globl f_sync
.align 4
.type f_sync,@function
f_sync:
push %14
push %30
movfs %30
subsp 8
ld.l %29, 12(%30)
push %29
jsrd validate
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC635
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 32
ldis %28, 0
cmp %29, %28
beq .LC637
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 64
ldis %28, 0
cmp %29, %28
beq .LC639
ldiu %29, 1
push %29
ld.l %29, 12(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC641
ldis %15, 1
jmpd .LC634
.LC641:
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -65
st.b %28, 0(%29)
.LC639:
ld.l %29, 12(%30)
ldis %28, 28
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd move_window
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC643
ldis %29, 32
ld.l %28, 12(%30)
add %28, %28, %29
ld.l %28, 0(%28)
st.l %28, -4(%30)
ld.l %28, -4(%30)
ldis %27, 11
add %28, %28, %27
ld.b %27, 0(%28)
or %29, %27, %29
st.b %29, 0(%28)
ld.l %29, -4(%30)
ldis %28, 28
add %29, %29, %28
ld.l %28, 12(%30)
ldis %27, 12
add %28, %28, %27
ld.l %28, 0(%28)
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 29
add %29, %29, %28
ld.l %28, 12(%30)
ldis %27, 12
add %28, %28, %27
ld.l %28, 0(%28)
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 30
add %29, %29, %28
ld.l %28, 12(%30)
ldis %27, 12
add %28, %28, %27
ld.l %28, 0(%28)
lsri %28, %28, 16
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 31
add %29, %29, %28
ld.l %28, 12(%30)
ldis %27, 12
add %28, %28, %27
ld.l %28, 0(%28)
lsri %28, %28, 24
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 16
add %29, %29, %28
ld.l %29, 0(%29)
push %29
ld.l %29, -4(%30)
push %29
jsrd st_clust
addsp 8
jsrd get_fattime
st.l %15, -8(%30)
ld.l %29, -4(%30)
ldis %28, 22
add %29, %29, %28
ld.l %28, -8(%30)
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 23
add %29, %29, %28
ld.l %28, -8(%30)
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 24
add %29, %29, %28
ld.l %28, -8(%30)
lsri %28, %28, 16
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 25
add %29, %29, %28
ld.l %28, -8(%30)
lsri %28, %28, 24
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 18
add %29, %29, %28
ldiu %28, 0
st.b %28, 0(%29)
ld.l %29, -4(%30)
ldis %28, 19
add %29, %29, %28
ldiu %28, 0
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -33
st.b %28, 0(%29)
ld.l %29, 12(%30)
ld.l %29, 0(%29)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, 12(%30)
ld.l %29, 0(%29)
push %29
jsrd sync_fs
addsp 4
mov %14, %15
.LC643:
.LC637:
.LC635:
mov %15, %14
.LC634:
movts %30
pop %30
pop %14
rts
.Lf645:
.size f_sync,.Lf645-f_sync
.globl f_close
.align 4
.type f_close,@function
f_close:
push %14
push %30
movfs %30
ld.l %29, 12(%30)
push %29
jsrd f_sync
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC647
ld.l %29, 12(%30)
push %29
jsrd validate
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC649
ld.l %29, 12(%30)
ldi %28, 0
st.l %28, 0(%29)
.LC649:
.LC647:
mov %15, %14
.LC646:
movts %30
pop %30
pop %14
rts
.Lf651:
.size f_close,.Lf651-f_close
.globl f_lseek
.align 4
.type f_lseek,@function
f_lseek:
push %11
push %12
push %13
push %14
push %30
movfs %30
subsp 4
ld.l %29, 24(%30)
push %29
jsrd validate
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC653
mov %15, %14
jmpd .LC652
.LC653:
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC655
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
mov %15, %29
jmpd .LC652
.LC655:
ld.l %29, 24(%30)
ld.l %28, 28(%30)
ldis %27, 12
add %27, %29, %27
ld.l %27, 0(%27)
cmp %28, %27
bleu .LC657
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 2
ldis %28, 0
cmp %29, %28
bne .LC657
ld.l %29, 24(%30)
ldis %28, 12
add %29, %29, %28
ld.l %29, 0(%29)
st.l %29, 28(%30)
.LC657:
ld.l %29, 24(%30)
ldis %28, 8
add %29, %29, %28
ld.l %28, 0(%29)
st.l %28, -4(%30)
ldiu %28, 0
mov %11, %28
st.l %28, 0(%29)
ld.l %29, 28(%30)
ldiu %28, 0
cmp %29, %28
beq .LC659
ld.l %29, 24(%30)
ld.l %29, 0(%29)
ldis %28, 2
add %29, %29, %28
ld.b %29, 0(%29)
lsli %12, %29, 9
ld.l %29, -4(%30)
ldiu %28, 0
cmp %29, %28
beq .LC661
ldiu %28, 1
ld.l %27, 28(%30)
sub %27, %27, %28
divu %27, %27, %12
sub %29, %29, %28
divu %29, %29, %12
cmp %27, %29
bltu .LC661
ldiu %29, 1
ld.l %28, 24(%30)
ldis %27, 8
add %28, %28, %27
ld.l %27, -4(%30)
sub %27, %27, %29
sub %29, %12, %29
com %29, %29
and %29, %27, %29
st.l %29, 0(%28)
ld.l %29, 24(%30)
ld.l %28, 28(%30)
ldis %27, 8
add %27, %29, %27
ld.l %27, 0(%27)
sub %28, %28, %27
st.l %28, 28(%30)
ldis %28, 20
add %29, %29, %28
ld.l %13, 0(%29)
jmpd .LC662
.LC661:
ld.l %29, 24(%30)
ldis %28, 16
add %29, %29, %28
ld.l %13, 0(%29)
ldiu %29, 0
cmp %13, %29
bne .LC663
ldiu %29, 0
push %29
ld.l %29, 24(%30)
ld.l %29, 0(%29)
push %29
jsrd create_chain
addsp 8
mov %13, %15
ldiu %29, 1
cmp %13, %29
bne .LC665
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC652
.LC665:
ldi %29, 0xffffffff
cmp %13, %29
bne .LC667
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC652
.LC667:
ld.l %29, 24(%30)
ldis %28, 16
add %29, %29, %28
st.l %13, 0(%29)
.LC663:
ld.l %29, 24(%30)
ldis %28, 20
add %29, %29, %28
st.l %13, 0(%29)
.LC662:
ldiu %29, 0
cmp %13, %29
beq .LC669
jmpd .LC672
.LC671:
ld.l %29, 24(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 2
ldis %28, 0
cmp %29, %28
beq .LC674
push %13
ld.l %29, 24(%30)
ld.l %29, 0(%29)
push %29
jsrd create_chain
addsp 8
mov %13, %15
ldiu %29, 0
cmp %13, %29
bne .LC675
st.l %12, 28(%30)
jmpd .LC673
.LC674:
push %13
ld.l %29, 24(%30)
ld.l %29, 0(%29)
push %29
jsrd get_fat
addsp 8
mov %13, %15
.LC675:
ldi %29, 0xffffffff
cmp %13, %29
bne .LC678
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC652
.LC678:
ldiu %29, 1
cmp %13, %29
bleu .LC682
ld.l %29, 24(%30)
ld.l %29, 0(%29)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
cmp %13, %29
bltu .LC680
.LC682:
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC652
.LC680:
ld.l %29, 24(%30)
ldis %28, 20
add %29, %29, %28
st.l %13, 0(%29)
ld.l %29, 24(%30)
ldis %28, 8
add %29, %29, %28
ld.l %28, 0(%29)
add %28, %28, %12
st.l %28, 0(%29)
ld.l %29, 28(%30)
sub %29, %29, %12
st.l %29, 28(%30)
.LC672:
ld.l %29, 28(%30)
cmp %29, %12
bgtu .LC671
.LC673:
ld.l %29, 24(%30)
ldis %28, 8
add %29, %29, %28
ld.l %28, 0(%29)
ld.l %27, 28(%30)
add %28, %28, %27
st.l %28, 0(%29)
ld.l %29, 28(%30)
andi %29, %29, 511
ldiu %28, 0
cmp %29, %28
beq .LC683
push %13
ld.l %29, 24(%30)
ld.l %29, 0(%29)
push %29
jsrd clust2sect
addsp 8
mov %11, %15
ldiu %29, 0
cmp %11, %29
bne .LC685
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 2
st.b %28, 0(%29)
ldis %15, 2
jmpd .LC652
.LC685:
ld.l %29, 28(%30)
lsri %29, %29, 9
add %11, %11, %29
.LC683:
.LC669:
.LC659:
ld.l %29, 24(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
andi %28, %28, 511
ldiu %27, 0
cmp %28, %27
beq .LC687
ldis %28, 24
add %29, %29, %28
ld.l %29, 0(%29)
cmp %11, %29
beq .LC687
ld.l %29, 24(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 64
ldis %28, 0
cmp %29, %28
beq .LC689
ldiu %29, 1
push %29
ld.l %29, 24(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC691
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC652
.LC691:
ld.l %29, 24(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -65
st.b %28, 0(%29)
.LC689:
ldiu %29, 1
push %29
push %11
ld.l %29, 24(%30)
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_read
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC693
ld.l %29, 24(%30)
ldis %28, 7
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ldis %15, 1
jmpd .LC652
.LC693:
ld.l %29, 24(%30)
ldis %28, 24
add %29, %29, %28
st.l %11, 0(%29)
.LC687:
ld.l %29, 24(%30)
ldis %28, 8
add %28, %29, %28
ld.l %28, 0(%28)
ldis %27, 12
add %29, %29, %27
ld.l %29, 0(%29)
cmp %28, %29
bleu .LC695
ld.l %29, 24(%30)
ldis %28, 12
add %28, %29, %28
ldis %27, 8
add %29, %29, %27
ld.l %29, 0(%29)
st.l %29, 0(%28)
ld.l %29, 24(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
ori %28 %28, 32
st.b %28, 0(%29)
.LC695:
mov %15, %14
.LC652:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
rts
.Lf697:
.size f_lseek,.Lf697-f_lseek
.globl f_opendir
.align 4
.type f_opendir,@function
f_opendir:
push %14
push %30
movfs %30
subsp 20
ld.l %29, 12(%30)
ldiu %28, 0
cmp %29, %28
bne .LC699
ldis %15, 9
jmpd .LC698
.LC699:
ldis %29, 0
push %29
lda %29, 16(%30)
push %29
lda %29, -4(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC701
ld.l %29, 12(%30)
ld.l %28, -4(%30)
st.l %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 24
add %29, %29, %28
lda %28, -16(%30)
st.l %28, 0(%29)
ld.l %29, 16(%30)
push %29
ld.l %29, 12(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC703
ld.l %29, 12(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
beq .LC705
ld.l %29, 12(%30)
ldis %28, 20
add %29, %29, %28
ld.l %29, 0(%29)
ldis %28, 11
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 16
ldis %28, 0
cmp %29, %28
beq .LC707
ld.l %29, 12(%30)
st.l %29, -20(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %28, -4(%30)
push %28
jsrd ld_clust
addsp 8
ldis %28, 8
ld.l %27, -20(%30)
add %28, %27, %28
st.l %15, 0(%28)
jmpd .LC708
.LC707:
ldis %14, 5
.LC708:
.LC705:
ldis %29, 0
cmp %14, %29
bne .LC709
ld.l %29, 12(%30)
ldis %28, 4
add %29, %29, %28
ld.l %28, -4(%30)
ldis %27, 6
add %28, %28, %27
ld %28, 0(%28)
st %28, 0(%29)
ldiu %29, 0
push %29
ld.l %29, 12(%30)
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
.LC709:
.LC703:
ldis %29, 4
cmp %14, %29
bne .LC711
ldis %14, 5
.LC711:
.LC701:
ldis %29, 0
cmp %14, %29
beq .LC713
ld.l %29, 12(%30)
ldi %28, 0
st.l %28, 0(%29)
.LC713:
mov %15, %14
.LC698:
movts %30
pop %30
pop %14
rts
.Lf715:
.size f_opendir,.Lf715-f_opendir
.globl f_closedir
.align 4
.type f_closedir,@function
f_closedir:
push %14
push %30
movfs %30
ld.l %29, 12(%30)
push %29
jsrd validate
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC717
ld.l %29, 12(%30)
ldi %28, 0
st.l %28, 0(%29)
.LC717:
mov %15, %14
.LC716:
movts %30
pop %30
pop %14
rts
.Lf719:
.size f_closedir,.Lf719-f_closedir
.globl f_readdir
.align 4
.type f_readdir,@function
f_readdir:
push %14
push %30
movfs %30
subsp 12
ld.l %29, 12(%30)
push %29
jsrd validate
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC721
ld.l %29, 16(%30)
ldiu %28, 0
cmp %29, %28
bne .LC723
ldiu %29, 0
push %29
ld.l %29, 12(%30)
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
jmpd .LC724
.LC723:
ld.l %29, 12(%30)
ldis %28, 24
add %29, %29, %28
lda %28, -12(%30)
st.l %28, 0(%29)
ldis %29, 0
push %29
ld.l %29, 12(%30)
push %29
jsrd dir_read
addsp 8
mov %14, %15
ldis %29, 4
cmp %14, %29
bne .LC725
ld.l %29, 12(%30)
ldis %28, 16
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
ldis %14, 0
.LC725:
ldis %29, 0
cmp %14, %29
bne .LC727
ld.l %29, 16(%30)
push %29
ld.l %29, 12(%30)
push %29
jsrd get_fileinfo
addsp 8
ldis %29, 0
push %29
ld.l %29, 12(%30)
push %29
jsrd dir_next
addsp 8
mov %14, %15
ldis %29, 4
cmp %14, %29
bne .LC729
ld.l %29, 12(%30)
ldis %28, 16
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
ldis %14, 0
.LC729:
.LC727:
.LC724:
.LC721:
mov %15, %14
.LC720:
movts %30
pop %30
pop %14
rts
.Lf731:
.size f_readdir,.Lf731-f_readdir
.globl f_stat
.align 4
.type f_stat,@function
f_stat:
push %14
push %30
movfs %30
subsp 40
ldis %29, 0
push %29
lda %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC733
lda %29, -40(%30)
st.l %29, -4(%30)
ld.l %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC736
ld.l %29, -8(%30)
ldiu %28, 0
cmp %29, %28
beq .LC738
ld.l %29, 16(%30)
ldiu %28, 0
cmp %29, %28
beq .LC739
ld.l %29, 16(%30)
push %29
lda %29, -28(%30)
push %29
jsrd get_fileinfo
addsp 8
jmpd .LC739
.LC738:
ldis %14, 6
.LC739:
.LC736:
.LC733:
mov %15, %14
.LC732:
movts %30
pop %30
pop %14
rts
.Lf743:
.size f_stat,.Lf743-f_stat
.globl f_getfree
.align 4
.type f_getfree,@function
f_getfree:
push %9
push %10
push %11
push %12
push %13
push %14
push %30
movfs %30
subsp 12
ldis %29, 0
push %29
lda %29, 32(%30)
push %29
ld.l %29, 40(%30)
push %29
jsrd find_volume
addsp 12
mov %12, %15
ld.l %29, 40(%30)
ld.l %14, 0(%29)
ldis %29, 0
cmp %12, %29
bne .LC745
ldis %29, 16
add %29, %14, %29
ld.l %29, 0(%29)
ldis %28, 20
add %28, %14, %28
ld.l %28, 0(%28)
subi %28, %28, 2
cmp %29, %28
bgtu .LC747
ld.l %29, 36(%30)
ldis %28, 16
add %28, %14, %28
ld.l %28, 0(%28)
st.l %28, 0(%29)
jmpd .LC748
.LC747:
ld.b %29, 0(%14)
st.b %29, -8(%30)
ldiu %29, 0
st.l %29, -4(%30)
ld.b %29, -8(%30)
ldis %28, 1
cmp %29, %28
bne .LC749
ldiu %10, 2
.LC751:
push %10
push %14
jsrd get_fat
addsp 8
mov %11, %15
ldi %29, 0xffffffff
cmp %11, %29
bne .LC754
ldis %12, 1
jmpd .LC750
.LC754:
ldiu %29, 1
cmp %11, %29
bne .LC756
ldis %12, 2
jmpd .LC750
.LC756:
ldiu %29, 0
cmp %11, %29
bne .LC758
ld.l %29, -4(%30)
addi %29, %29, 1
st.l %29, -4(%30)
.LC758:
.LC752:
addi %29, %10, 1
mov %10, %29
ldis %28, 20
add %28, %14, %28
ld.l %28, 0(%28)
cmp %29, %28
bltu .LC751
jmpd .LC750
.LC749:
ldis %29, 20
add %29, %14, %29
ld.l %10, 0(%29)
ldis %29, 32
add %29, %14, %29
ld.l %29, 0(%29)
st.l %29, -12(%30)
ldiu %9, 0
ldi %13, 0
.LC760:
ldiu %29, 0
cmp %9, %29
bne .LC763
ld.l %29, -12(%30)
addi %28, %29, 1
st.l %28, -12(%30)
push %29
push %14
jsrd move_window
addsp 8
mov %12, %15
ldis %29, 0
cmp %12, %29
beq .LC765
jmpd .LC762
.LC765:
ldis %29, 48
add %13, %14, %29
ldiu %9, 512
.LC763:
ld.b %29, -8(%30)
ldis %28, 2
cmp %29, %28
bne .LC767
ldis %29, 1
add %29, %13, %29
ld.b %29, 0(%29)
lsli %29, %29, 8
ld.b %28, 0(%13)
or %29, %29, %28
ldis %28, 0
cmp %29, %28
bne .LC769
ld.l %29, -4(%30)
addi %29, %29, 1
st.l %29, -4(%30)
.LC769:
ldis %29, 2
add %13, %13, %29
subi %9, %9, 2
jmpd .LC768
.LC767:
ldis %29, 3
add %29, %13, %29
ld.b %29, 0(%29)
lsli %29, %29, 24
ldis %28, 2
add %28, %13, %28
ld.b %28, 0(%28)
lsli %28, %28, 16
or %29, %29, %28
ldis %28, 1
add %28, %13, %28
ld.b %28, 0(%28)
lsli %28, %28, 8
or %29, %29, %28
ld.b %28, 0(%13)
or %29, %29, %28
ldi %28, 0xfffffff
and %29, %29, %28
ldiu %28, 0
cmp %29, %28
bne .LC771
ld.l %29, -4(%30)
addi %29, %29, 1
st.l %29, -4(%30)
.LC771:
ldis %29, 4
add %13, %13, %29
subi %9, %9, 4
.LC768:
.LC761:
subi %29, %10, 1
mov %10, %29
ldiu %28, 0
cmp %29, %28
bne .LC760
.LC762:
.LC750:
ldis %29, 16
add %29, %14, %29
ld.l %28, -4(%30)
st.l %28, 0(%29)
ldis %29, 5
add %29, %14, %29
ld.b %28, 0(%29)
ori %28 %28, 1
st.b %28, 0(%29)
ld.l %29, 36(%30)
ld.l %28, -4(%30)
st.l %28, 0(%29)
.LC748:
.LC745:
mov %15, %12
.LC744:
movts %30
pop %30
pop %14
pop %13
pop %12
pop %11
pop %10
pop %9
rts
.Lf773:
.size f_getfree,.Lf773-f_getfree
.globl f_truncate
.align 4
.type f_truncate,@function
f_truncate:
push %14
push %30
movfs %30
subsp 4
ld.l %29, 12(%30)
push %29
jsrd validate
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC775
ld.l %29, 12(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 0
cmp %29, %28
beq .LC777
ld.l %29, 12(%30)
ldis %28, 7
add %29, %29, %28
ld.b %29, 0(%29)
mov %14, %29
jmpd .LC778
.LC777:
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 2
ldis %28, 0
cmp %29, %28
bne .LC779
ldis %14, 7
.LC779:
.LC778:
.LC775:
ldis %29, 0
cmp %14, %29
bne .LC781
ld.l %29, 12(%30)
ldis %28, 12
add %28, %29, %28
ld.l %28, 0(%28)
ldis %27, 8
add %29, %29, %27
ld.l %29, 0(%29)
cmp %28, %29
bleu .LC783
ld.l %29, 12(%30)
ldis %28, 12
add %28, %29, %28
ldis %27, 8
add %29, %29, %27
ld.l %29, 0(%29)
st.l %29, 0(%28)
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
ori %28 %28, 32
st.b %28, 0(%29)
ld.l %29, 12(%30)
ldis %28, 8
add %29, %29, %28
ld.l %29, 0(%29)
ldiu %28, 0
cmp %29, %28
bne .LC785
ld.l %29, 12(%30)
ldis %28, 16
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd remove_chain
addsp 8
mov %14, %15
ld.l %29, 12(%30)
ldis %28, 16
add %29, %29, %28
ldiu %28, 0
st.l %28, 0(%29)
jmpd .LC786
.LC785:
ld.l %29, 12(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd get_fat
addsp 8
st.l %15, -4(%30)
ldis %14, 0
ld.l %29, -4(%30)
ldi %28, 0xffffffff
cmp %29, %28
bne .LC787
ldis %14, 1
.LC787:
ld.l %29, -4(%30)
ldiu %28, 1
cmp %29, %28
bne .LC789
ldis %14, 2
.LC789:
ldis %29, 0
cmp %14, %29
bne .LC791
ld.l %29, -4(%30)
ld.l %28, 12(%30)
ld.l %28, 0(%28)
ldis %27, 20
add %28, %28, %27
ld.l %28, 0(%28)
cmp %29, %28
bgeu .LC791
ldi %29, 0xfffffff
push %29
ld.l %29, 12(%30)
ldis %28, 20
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ld.l %29, 0(%29)
push %29
jsrd put_fat
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC793
ld.l %29, -4(%30)
push %29
ld.l %29, 12(%30)
ld.l %29, 0(%29)
push %29
jsrd remove_chain
addsp 8
mov %14, %15
.LC793:
.LC791:
.LC786:
ldis %29, 0
cmp %14, %29
bne .LC795
ld.l %28, 12(%30)
ldis %27, 6
add %28, %28, %27
ld.b %28, 0(%28)
andi %28, %28, 64
cmp %28, %29
beq .LC795
ldiu %29, 1
push %29
ld.l %29, 12(%30)
ldis %28, 24
add %28, %29, %28
ld.l %28, 0(%28)
push %28
ldis %28, 36
add %28, %29, %28
push %28
ld.l %29, 0(%29)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
push %29
jsrd disk_write
addsp 16
ldis %28, 0
cmp %15, %28
beq .LC797
ldis %14, 1
jmpd .LC798
.LC797:
ld.l %29, 12(%30)
ldis %28, 6
add %29, %29, %28
ld.b %28, 0(%29)
andi %28, %28, -65
st.b %28, 0(%29)
.LC798:
.LC795:
.LC783:
ldis %29, 0
cmp %14, %29
beq .LC799
ld.l %29, 12(%30)
ldis %28, 7
add %29, %29, %28
mov %28, %14
st.b %28, 0(%29)
.LC799:
.LC781:
mov %15, %14
.LC774:
movts %30
pop %30
pop %14
rts
.Lf801:
.size f_truncate,.Lf801-f_truncate
.globl f_unlink
.align 4
.type f_unlink,@function
f_unlink:
push %14
push %30
movfs %30
subsp 76
ldis %29, 1
push %29
lda %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC803
lda %29, -48(%30)
st.l %29, -4(%30)
ld.l %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
jmpd .LC806
ldis %14, 6
.LC806:
ldis %29, 0
cmp %14, %29
bne .LC809
ld.l %29, -8(%30)
st.l %29, -32(%30)
ld.l %29, -32(%30)
ldiu %28, 0
cmp %29, %28
bne .LC812
ldis %14, 6
jmpd .LC813
.LC812:
ld.l %29, -32(%30)
ldis %28, 11
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 1
ldis %28, 0
cmp %29, %28
beq .LC814
ldis %14, 7
.LC814:
.LC813:
ld.l %29, -32(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd ld_clust
addsp 8
st.l %15, -36(%30)
ldis %29, 0
cmp %14, %29
bne .LC816
ld.l %28, -32(%30)
ldis %27, 11
add %28, %28, %27
ld.b %28, 0(%28)
andi %28, %28, 16
cmp %28, %29
beq .LC816
ld.l %29, -36(%30)
ldiu %28, 2
cmp %29, %28
bgeu .LC818
ldis %14, 2
jmpd .LC819
.LC818:
ldiu %29, 28
push %29
lda %29, -28(%30)
push %29
lda %29, -76(%30)
push %29
jsrd mem_cpy
addsp 12
ld.l %29, -36(%30)
st.l %29, -68(%30)
ldiu %29, 2
push %29
lda %29, -76(%30)
push %29
jsrd dir_sdi
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC821
ldis %29, 0
push %29
lda %29, -76(%30)
push %29
jsrd dir_read
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC823
ldis %14, 7
.LC823:
ldis %29, 4
cmp %14, %29
bne .LC825
ldis %14, 0
.LC825:
.LC821:
.LC819:
.LC816:
ldis %29, 0
cmp %14, %29
bne .LC827
lda %29, -28(%30)
push %29
jsrd dir_remove
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC829
ld.l %29, -36(%30)
ldiu %28, 0
cmp %29, %28
beq .LC831
ld.l %29, -36(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd remove_chain
addsp 8
mov %14, %15
.LC831:
ldis %29, 0
cmp %14, %29
bne .LC833
ld.l %29, -28(%30)
push %29
jsrd sync_fs
addsp 4
mov %14, %15
.LC833:
.LC829:
.LC827:
.LC809:
.LC803:
mov %15, %14
.LC802:
movts %30
pop %30
pop %14
rts
.Lf835:
.size f_unlink,.Lf835-f_unlink
.globl f_mkdir
.align 4
.type f_mkdir,@function
f_mkdir:
push %13
push %14
push %30
movfs %30
subsp 60
jsrd get_fattime
st.l %15, -36(%30)
ldis %29, 1
push %29
lda %29, 16(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC837
lda %29, -56(%30)
st.l %29, -4(%30)
ld.l %29, 16(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC840
ldis %14, 8
.LC840:
jmpd .LC842
ldis %14, 6
.LC842:
ldis %29, 4
cmp %14, %29
bne .LC845
ldiu %29, 0
push %29
ld.l %29, -28(%30)
push %29
jsrd create_chain
addsp 8
st.l %15, -40(%30)
ldis %14, 0
ld.l %29, -40(%30)
ldiu %28, 0
cmp %29, %28
bne .LC847
ldis %14, 7
.LC847:
ld.l %29, -40(%30)
ldiu %28, 1
cmp %29, %28
bne .LC849
ldis %14, 2
.LC849:
ld.l %29, -40(%30)
ldi %28, 0xffffffff
cmp %29, %28
bne .LC851
ldis %14, 1
.LC851:
ldis %29, 0
cmp %14, %29
bne .LC853
ld.l %29, -28(%30)
push %29
jsrd sync_window
addsp 4
mov %14, %15
.LC853:
ldis %29, 0
cmp %14, %29
bne .LC855
ld.l %29, -40(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd clust2sect
addsp 8
st.l %15, -44(%30)
ld.l %29, -28(%30)
ldis %28, 48
add %13, %29, %28
ldiu %29, 512
push %29
ldis %29, 0
push %29
push %13
jsrd mem_set
addsp 12
ldiu %29, 11
push %29
ldis %29, 32
push %29
push %13
jsrd mem_set
addsp 12
ldiu %29, 46
st.b %29, 0(%13)
ldis %29, 11
add %29, %13, %29
ldiu %28, 16
st.b %28, 0(%29)
ldis %29, 22
add %29, %13, %29
ld.l %28, -36(%30)
st.b %28, 0(%29)
ldis %29, 23
add %29, %13, %29
ld.l %28, -36(%30)
asri %28, %28, 8
st.b %28, 0(%29)
ldis %29, 24
add %29, %13, %29
ld.l %28, -36(%30)
lsri %28, %28, 16
st.b %28, 0(%29)
ldis %29, 25
add %29, %13, %29
ld.l %28, -36(%30)
lsri %28, %28, 24
st.b %28, 0(%29)
ld.l %29, -40(%30)
push %29
push %13
jsrd st_clust
addsp 8
ldiu %29, 32
push %29
push %13
ldis %29, 32
add %29, %13, %29
push %29
jsrd mem_cpy
addsp 12
ldis %29, 33
add %29, %13, %29
ldiu %28, 46
st.b %28, 0(%29)
ld.l %29, -20(%30)
st.l %29, -60(%30)
ld.l %29, -28(%30)
ld.b %28, 0(%29)
ldis %27, 3
cmp %28, %27
bne .LC858
ld.l %28, -60(%30)
ldis %27, 36
add %29, %29, %27
ld.l %29, 0(%29)
cmp %28, %29
bne .LC858
ldiu %29, 0
st.l %29, -60(%30)
.LC858:
ld.l %29, -60(%30)
push %29
ldis %29, 32
add %29, %13, %29
push %29
jsrd st_clust
addsp 8
ld.l %29, -28(%30)
ldis %28, 2
add %29, %29, %28
ld.b %29, 0(%29)
st.b %29, -32(%30)
jmpd .LC863
.LC860:
ld.l %29, -44(%30)
addi %28, %29, 1
st.l %28, -44(%30)
ld.l %28, -28(%30)
ldis %27, 44
add %28, %28, %27
st.l %29, 0(%28)
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, -28(%30)
push %29
jsrd sync_window
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
beq .LC864
jmpd .LC862
.LC864:
ldiu %29, 512
push %29
ldis %29, 0
push %29
push %13
jsrd mem_set
addsp 12
.LC861:
ld.b %29, -32(%30)
subi %29, %29, 1
st.b %29, -32(%30)
.LC863:
ld.b %29, -32(%30)
ldis %28, 0
cmp %29, %28
bne .LC860
.LC862:
.LC855:
ldis %29, 0
cmp %14, %29
bne .LC866
lda %29, -28(%30)
push %29
jsrd dir_register
addsp 4
mov %14, %15
.LC866:
ldis %29, 0
cmp %14, %29
beq .LC868
ld.l %29, -40(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd remove_chain
addsp 8
jmpd .LC869
.LC868:
ld.l %13, -8(%30)
ldis %29, 11
add %29, %13, %29
ldiu %28, 16
st.b %28, 0(%29)
ldis %29, 22
add %29, %13, %29
ld.l %28, -36(%30)
st.b %28, 0(%29)
ldis %29, 23
add %29, %13, %29
ld.l %28, -36(%30)
asri %28, %28, 8
st.b %28, 0(%29)
ldis %29, 24
add %29, %13, %29
ld.l %28, -36(%30)
lsri %28, %28, 16
st.b %28, 0(%29)
ldis %29, 25
add %29, %13, %29
ld.l %28, -36(%30)
lsri %28, %28, 24
st.b %28, 0(%29)
ld.l %29, -40(%30)
push %29
push %13
jsrd st_clust
addsp 8
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, -28(%30)
push %29
jsrd sync_fs
addsp 4
mov %14, %15
.LC869:
.LC845:
.LC837:
mov %15, %14
.LC836:
movts %30
pop %30
pop %14
pop %13
rts
.Lf871:
.size f_mkdir,.Lf871-f_mkdir
.globl f_chmod
.align 4
.type f_chmod,@function
f_chmod:
push %14
push %30
movfs %30
subsp 44
ld.l %29, 16(%30)
st.b %29, 16(%30)
ld.l %29, 20(%30)
st.b %29, 20(%30)
ldis %29, 1
push %29
lda %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC873
lda %29, -44(%30)
st.l %29, -4(%30)
ld.l %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
jmpd .LC876
ldis %14, 6
.LC876:
ldis %29, 0
cmp %14, %29
bne .LC879
ld.l %29, -8(%30)
st.l %29, -32(%30)
ld.l %29, -32(%30)
ldiu %28, 0
cmp %29, %28
bne .LC882
ldis %14, 6
jmpd .LC883
.LC882:
ld.b %29, 20(%30)
andi %29, %29, 39
st.b %29, 20(%30)
ld.l %29, -32(%30)
ldis %28, 11
add %29, %29, %28
ld.b %28, 20(%30)
ld.b %27, 16(%30)
and %27, %27, %28
ld.b %26, 0(%29)
com %28, %28
and %28, %26, %28
or %28, %27, %28
st.b %28, 0(%29)
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, -28(%30)
push %29
jsrd sync_fs
addsp 4
mov %14, %15
.LC883:
.LC879:
.LC873:
mov %15, %14
.LC872:
movts %30
pop %30
pop %14
rts
.Lf884:
.size f_chmod,.Lf884-f_chmod
.globl f_utime
.align 4
.type f_utime,@function
f_utime:
push %14
push %30
movfs %30
subsp 44
ldis %29, 1
push %29
lda %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC886
lda %29, -44(%30)
st.l %29, -4(%30)
ld.l %29, 12(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
jmpd .LC889
ldis %14, 6
.LC889:
ldis %29, 0
cmp %14, %29
bne .LC892
ld.l %29, -8(%30)
st.l %29, -32(%30)
ld.l %29, -32(%30)
ldiu %28, 0
cmp %29, %28
bne .LC895
ldis %14, 6
jmpd .LC896
.LC895:
ld.l %29, -32(%30)
ldis %28, 22
add %29, %29, %28
ld.l %28, 16(%30)
ldis %27, 6
add %28, %28, %27
ld %28, 0(%28)
st.b %28, 0(%29)
ld.l %29, -32(%30)
ldis %28, 23
add %29, %29, %28
ld.l %28, 16(%30)
ldis %27, 6
add %28, %28, %27
ld %28, 0(%28)
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, -32(%30)
ldis %28, 24
add %29, %29, %28
ld.l %28, 16(%30)
ldis %27, 4
add %28, %28, %27
ld %28, 0(%28)
st.b %28, 0(%29)
ld.l %29, -32(%30)
ldis %28, 25
add %29, %29, %28
ld.l %28, 16(%30)
ldis %27, 4
add %28, %28, %27
ld %28, 0(%28)
asri %28, %28, 8
st.b %28, 0(%29)
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, -28(%30)
push %29
jsrd sync_fs
addsp 4
mov %14, %15
.LC896:
.LC892:
.LC886:
mov %15, %14
.LC885:
movts %30
pop %30
pop %14
rts
.Lf897:
.size f_utime,.Lf897-f_utime
.globl f_rename
.align 4
.type f_rename,@function
f_rename:
push %13
push %14
push %30
movfs %30
subsp 100
ldis %29, 1
push %29
lda %29, 16(%30)
push %29
lda %29, -28(%30)
push %29
jsrd find_volume
addsp 12
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC899
ld.l %29, -28(%30)
st.l %29, -56(%30)
lda %29, -68(%30)
st.l %29, -4(%30)
ld.l %29, 16(%30)
push %29
lda %29, -28(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
jmpd .LC902
ldis %14, 6
.LC902:
ldis %29, 0
cmp %14, %29
bne .LC905
ld.l %29, -8(%30)
ldiu %28, 0
cmp %29, %28
bne .LC907
ldis %14, 4
jmpd .LC908
.LC907:
ldiu %29, 21
push %29
ld.l %29, -8(%30)
ldis %28, 11
add %29, %29, %28
push %29
lda %29, -92(%30)
push %29
jsrd mem_cpy
addsp 12
ldiu %29, 28
push %29
lda %29, -28(%30)
push %29
lda %29, -56(%30)
push %29
jsrd mem_cpy
addsp 12
lda %29, 20(%30)
push %29
jsrd get_ldnumber
addsp 4
ldis %28, 0
cmp %15, %28
blt .LC911
ld.l %29, 20(%30)
push %29
lda %29, -56(%30)
push %29
jsrd follow_path
addsp 8
mov %14, %15
jmpd .LC912
.LC911:
ldis %14, 11
.LC912:
ldis %29, 0
cmp %14, %29
bne .LC913
ldis %14, 8
.LC913:
ldis %29, 4
cmp %14, %29
bne .LC915
lda %29, -56(%30)
push %29
jsrd dir_register
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC917
ld.l %29, -36(%30)
st.l %29, -96(%30)
ldiu %29, 19
push %29
lda %29, -90(%30)
push %29
ld.l %29, -96(%30)
ldis %28, 13
add %29, %29, %28
push %29
jsrd mem_cpy
addsp 12
ld.l %29, -96(%30)
ldis %28, 11
add %29, %29, %28
ld.b %28, -92(%30)
ori %28 %28, 32
st.b %28, 0(%29)
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
ld.l %29, -20(%30)
ld.l %28, -48(%30)
cmp %29, %28
beq .LC921
ld.l %29, -96(%30)
ldis %28, 11
add %29, %29, %28
ld.b %29, 0(%29)
andi %29, %29, 16
ldis %28, 0
cmp %29, %28
beq .LC921
ld.l %29, -96(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd ld_clust
addsp 8
push %15
ld.l %29, -28(%30)
push %29
jsrd clust2sect
addsp 8
st.l %15, -100(%30)
ld.l %29, -100(%30)
ldiu %28, 0
cmp %29, %28
bne .LC925
ldis %14, 2
jmpd .LC926
.LC925:
ld.l %29, -100(%30)
push %29
ld.l %29, -28(%30)
push %29
jsrd move_window
addsp 8
mov %14, %15
ld.l %29, -28(%30)
ldis %28, 80
add %29, %29, %28
st.l %29, -96(%30)
ldis %29, 0
cmp %14, %29
bne .LC927
ld.l %29, -96(%30)
ldis %28, 1
add %29, %29, %28
ld.b %29, 0(%29)
ldis %28, 46
cmp %29, %28
bne .LC927
ld.l %29, -28(%30)
ld.b %28, 0(%29)
ldis %27, 3
cmp %28, %27
bne .LC932
ld.l %28, -48(%30)
ldis %27, 36
add %29, %29, %27
ld.l %29, 0(%29)
cmp %28, %29
bne .LC932
ldiu %13, 0
jmpd .LC933
.LC932:
ld.l %13, -48(%30)
.LC933:
st.l %13, -100(%30)
ld.l %29, -100(%30)
push %29
ld.l %29, -96(%30)
push %29
jsrd st_clust
addsp 8
ld.l %29, -28(%30)
ldis %28, 4
add %29, %29, %28
ldiu %28, 1
st.b %28, 0(%29)
.LC927:
.LC926:
.LC921:
ldis %29, 0
cmp %14, %29
bne .LC934
lda %29, -28(%30)
push %29
jsrd dir_remove
addsp 4
mov %14, %15
ldis %29, 0
cmp %14, %29
bne .LC936
ld.l %29, -28(%30)
push %29
jsrd sync_fs
addsp 4
mov %14, %15
.LC936:
.LC934:
.LC917:
.LC915:
.LC908:
.LC905:
.LC899:
mov %15, %14
.LC898:
movts %30
pop %30
pop %14
pop %13
rts
.Lf938:
.size f_rename,.Lf938-f_rename
.section bss
.align 2
.type Fsid,@object
.size Fsid,2
.comm Fsid,2
.align 4
.type FatFs,@object
.size FatFs,4
.comm FatFs,4
.data
.align 1
.LC329:
.byte 34
.byte 42
.byte 43
.byte 44
.byte 58
.byte 59
.byte 60
.byte 61
.byte 62
.byte 63
.byte 91
.byte 93
.byte 124
.byte 127
.byte 0
.text
.ident "LCC: 4.2"
