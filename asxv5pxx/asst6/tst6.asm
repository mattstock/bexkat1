	.title	ST6  Sequential Test

	.area	Prog(rel,con)


	abyt	=	0x0010		; Absolute 1-Byte Value
	awrd	=	0x0430		; Absolute 2-Byte Value

	rbyt	=	. + 0x0010	; Relocatable 1-Byte Value
	rwrd	=	. + 0x0430	; Relocatable 2-Byte Value


	.page
	.sbttl	ST6 Derived Instructions

	; S_AOP
	;	ADD, AND, CP, SUB
	add	a,a		; 5F FF
	add	a,x		; 5F 80
	add	a,y		; 5F 81
	add	a,v		; 5F 82
	add	a,w		; 5F 83

	; S_BOP
	;	DEC, INC
	dec	a		; FF FF
	inc	a		; 7F FF


	.page
	.sbttl	ST6 Instructions in Numerical Order (Absolute)

agrp0:
	jrnz	.+1		; 00
	call	awrd+0		; 01 43
	jrnc	.+1		; 02
	jrr	#0,abyt,.+3	; 03 10 00
	jrz	.+1		; 04
				; 05
	jrc	.+1		; 06
	ld	a,(x)		; 07
	jrnz	.+2		; 08
	jp	awrd+0		; 09 43
	jrnc	.+2		; 0A
	res	#0,abyt		; 0B 10
	jrz	.+2		; 0C
	ldi	abyt,#abyt	; 0D 10 10
	jrc	.+2		; 0E
	ld	a,(y)		; 0F

agrp1:
	jrnz	.+3		; 10
	call	awrd+1		; 11 43
	jrnc	.+3		; 12
	jrs	#0,abyt,.+3	; 13 10 00
	jrz	.+3		; 14
	inc	x		; 15
	jrc	.+3		; 16
	ld	a,#abyt		; 17 10
	jrnz	.+4		; 18
	jp	awrd+1		; 19 43
	jrnc	.+4		; 1A
	set	#0,abyt		; 1B 10
	jrz	.+4		; 1C
	dec	x		; 1D
	jrc	.+4		; 1E
	ld	a,abyt		; 1F 10

	.page

agrp2:
	jrnz	.+5		; 20
	call	awrd+2		; 21 43
	jrnc	.+5		; 22
	jrr	#1,abyt,.+3	; 23 10 00
	jrz	.+5		; 24
				; 25
	jrc	.+5		; 26
	cp	a,(x)		; 27
	jrnz	.+6		; 28
	jp	awrd+2		; 29 43
	jrnc	.+6		; 2A
	res	#1,abyt		; 2B 10
	jrz	.+6		; 2C
	com	a		; 2D
	jrc	.+6		; 2E
	cp	a,(y)		; 2F

agrp3:
	jrnz	.+7		; 30
	call	awrd+3		; 31 43
	jrnc	.+7		; 32
	jrs	#1,abyt,.+3	; 33 10 00
	jrz	.+7		; 34
	ld	a,x		; 35
	jrc	.+7		; 36
	cpi	a,#abyt		; 37 10
	jrnz	.+8		; 38
	jp	awrd+3		; 39 43
	jrnc	.+8		; 3A
	set	#1,abyt		; 3B 10
	jrz	.+8		; 3C
	ld	x,a		; 3D
	jrc	.+8		; 3E
	cp	a,abyt		; 3F 10

	.page

agrp4:
	jrnz	.+9		; 40
	call	awrd+4		; 41 43
	jrnc	.+9		; 42
	jrr	#2,abyt,.+3	; 43 10 00
	jrz	.+9		; 44
				; 45
	jrc	.+9		; 46
	add	a,(x)		; 47
	jrnz	.+10		; 48
	jp	awrd+4		; 49 43
	jrnc	.+10		; 4A
	res	#2,abyt		; 4B 10
	jrz	.+10		; 4C
	reti			; 4D
	jrc	.+10		; 4E
	add	a,(y)		; 4F

agrp5:
	jrnz	.+11		; 50
	call	awrd+5		; 51 43
	jrnc	.+11		; 52
	jrs	#2,abyt,.+3	; 53 10 00
	jrz	.+11		; 54
	inc	y		; 55
	jrc	.+11		; 56
	addi	a,#abyt		; 57 10
	jrnz	.+12		; 58
	jp	awrd+5		; 59 43
	jrnc	.+12		; 5A
	set	#2,abyt		; 5B 10
	jrz	.+12		; 5C
	dec	y		; 5D
	jrc	.+12		; 5E
	add	a,abyt		; 5F 10

	.page

agrp6:
	jrnz	.+13		; 60
	call	awrd+6		; 61 43
	jrnc	.+13		; 62
	jrr	#3,abyt,.+3	; 63 10 00
	jrz	.+13		; 64
				; 65
	jrc	.+13		; 66
	inc	(x)		; 67
	jrnz	.+14		; 68
	jp	awrd+6		; 69 43
	jrnc	.+14		; 6A
	res	#3,abyt		; 6B 10
	jrz	.+14		; 6C
	stop			; 6D
	jrc	.+14		; 6E
	inc	(y)		; 6F

agrp7:
	jrnz	.+15		; 70
	call	awrd+7		; 71 43
	jrnc	.+15		; 72
	jrs	#3,abyt,.+3	; 73 10 00
	jrz	.+15		; 74
	ld	a,y		; 75
	jrc	.+15		; 76
				; 77
	jrnz	.+16		; 78
	jp	awrd+7		; 79 43
	jrnc	.+16		; 7A
	set	#3,abyt		; 7B 10
	jrz	.+16		; 7C
	ld	y,a		; 7D
	jrc	.+16		; 7E
	inc	abyt		; 7F 10

	.page

agrp8:
	jrnz	.-15		; 80
	call	awrd+8		; 81 43
	jrnc	.-15		; 82
	jrr	#4,abyt,.+3	; 83 10 00
	jrz	.-15		; 84
				; 85
	jrc	.-15		; 86
	ld	(x),a		; 87
	jrnz	.-14		; 88
	jp	awrd+8		; 89 43
	jrnc	.-14		; 8A
	res	#4,abyt		; 8B 10
	jrz	.-14		; 8C
				; 8D
	jrc	.-14		; 8E
	ld	(y),a		; 8F

agrp9:
	jrnz	.-13		; 90
	call	awrd+9		; 91 43
	jrnc	.-13		; 92
	jrs	#4,abyt,.+3	; 93 10 00
	jrz	.-13		; 94
	inc	v		; 95
	jrc	.-13		; 96
				; 97
	jrnz	.-12		; 98
	jp	awrd+9		; 99 43
	jrnc	.-12		; 9A
	set	#4,abyt		; 9B 10
	jrz	.-12		; 9C
	dec	v		; 9D
	jrc	.-12		; 9E
	ld	abyt,a		; 9F 10


	.page

agrpA:
	jrnz	.-11		; A0
	call	awrd+10		; A1 43
	jrnc	.-11		; A2
	jrr	#5,abyt,.+3	; A3 10 00
	jrz	.-11		; A4
				; A5
	jrc	.-11		; A6
	and	a,(x)		; A7
	jrnz	.-10		; A8
	jp	awrd+10		; A9 43
	jrnc	.-10		; AA
	res	#5,abyt		; AB 10
	jrz	.-10		; AC
	rcl	a		; AD
	jrc	.-10		; AE
	and	a,(y)		; AF

agrpB:
	jrnz	.-9		; B0
	call	awrd+11		; B1 43
	jrnc	.-9		; B2
	jrs	#5,abyt,.+3	; B3 10 00
	jrz	.-9		; B4
	ld	a,v		; B5
	jrc	.-9		; B6
	andi	a,#abyt		; B7 10
	jrnz	.-8		; B8
	jp	awrd+11		; B9 43
	jrnc	.-8		; BA
	set	#5,abyt		; BB 10
	jrz	.-8		; BC
	ld	v,a		; BD
	jrc	.-8		; BE
	and	a,abyt		; BF 10

	.page

agrpC:
	jrnz	.-7		; C0
	call	awrd+12		; C1 43
	jrnc	.-7		; C2
	jrr	#6,abyt,.+3	; C3 10 00
	jrz	.-7		; C4
				; C5
	jrc	.-7		; C6
	sub	a,(x)		; C7
	jrnz	.-6		; C8
	jp	awrd+12		; C9 43
	jrnc	.-6		; CA
	res	#6,abyt		; CB 10
	jrz	.-6		; CC
	ret			; CD
	jrc	.-6		; CE
	sub	a,(y)		; CF

agrpD:
	jrnz	.-5		; D0
	call	awrd+13		; D1 43
	jrnc	.-5		; D2
	jrs	#6,abyt,.+3	; D3 10 00
	jrz	.-5		; D4
	inc	w		; D5
	jrc	.-5		; D6
	subi	a,#abyt		; D7 10
	jrnz	.-4		; D8
	jp	awrd+13		; D9 43
	jrnc	.-4		; DA
	set	#6,abyt		; DB 10
	jrz	.-4		; DC
	dec	w		; DD
	jrc	.-4		; DE
	sub	a,abyt		; DF 10

	.page

agrpE:
	jrnz	.-3		; E0
	call	awrd+14		; E1 43
	jrnc	.-3		; E2
	jrr	#7,abyt,.+3	; E3 10 00
	jrz	.-3		; E4
				; E5
	jrc	.-3		; E6
	dec	(x)		; E7
	jrnz	.-2		; E8
	jp	awrd+14		; E9 43
	jrnc	.-2		; EA
	res	#7,abyt		; EB 10
	jrz	.-2		; EC
	wait			; ED
	jrc	.-2		; EE
	dec	(y)		; EF

agrpF:
	jrnz	.-1		; F0
	call	awrd+15		; F1 43
	jrnc	.-1		; F2
	jrs	#7,abyt,.+3	; F3 10 00
	jrz	.-1		; F4
	ld	a,w		; F5
	jrc	.-1		; F6
				; F7
	jrnz	.-0		; F8
	jp	awrd+15		; F9 43
	jrnc	.-0		; FA
	set	#7,abyt		; FB 10
	jrz	.-0		; FC
	ld	w,a		; FD
	jrc	.-0		; FE
	dec	abyt		; FF 10


	.page
	.sbttl	ST6 Instructions in Numerical Order (Relative)

rgrp0:
	jrnz	.+1		; 00
	call	rwrd+0		;s01r43
	jrnc	.+1		; 02
	jrr	#0,rbyt,.+3	; 03u10 00
	jrz	.+1		; 04
				; 05
	jrc	.+1		; 06
	ld	a,(x)		; 07
	jrnz	.+2		; 08
	jp	rwrd+0		;s09r43
	jrnc	.+2		; 0A
	res	#0,rbyt		; 0Bu10
	jrz	.+2		; 0C
	ldi	rbyt,#rbyt	; 0Du10r10
	jrc	.+2		; 0E
	ld	a,(y)		; 0F

rgrp1:
	jrnz	.+3		; 10
	call	rwrd+1		;s11r43
	jrnc	.+3		; 12
	jrs	#0,rbyt,.+3	; 13u10 00
	jrz	.+3		; 14
	inc	x		; 15
	jrc	.+3		; 16
	ld	a,#rbyt		; 17r10
	jrnz	.+4		; 18
	jp	rwrd+1		;s19r43
	jrnc	.+4		; 1A
	set	#0,rbyt		; 1Bu10
	jrz	.+4		; 1C
	dec	x		; 1D
	jrc	.+4		; 1E
	ld	a,rbyt		; 1Fu10

	.page

rgrp2:
	jrnz	.+5		; 20
	call	rwrd+2		;s21r43
	jrnc	.+5		; 22
	jrr	#1,rbyt,.+3	; 23u10 00
	jrz	.+5		; 24
				; 25
	jrc	.+5		; 26
	cp	a,(x)		; 27
	jrnz	.+6		; 28
	jp	rwrd+2		;s29r43
	jrnc	.+6		; 2A
	res	#1,rbyt		; 2Bu10
	jrz	.+6		; 2C
	com	a		; 2D
	jrc	.+6		; 2E
	cp	a,(y)		; 2F

rgrp3:
	jrnz	.+7		; 30
	call	rwrd+3		;s31r43
	jrnc	.+7		; 32
	jrs	#1,rbyt,.+3	; 33u10 00
	jrz	.+7		; 34
	ld	a,x		; 35
	jrc	.+7		; 36
	cpi	a,#rbyt		; 37r10
	jrnz	.+8		; 38
	jp	rwrd+3		;s39r43
	jrnc	.+8		; 3A
	set	#1,rbyt		; 3Bu10
	jrz	.+8		; 3C
	ld	x,a		; 3D
	jrc	.+8		; 3E
	cp	a,rbyt		; 3Fu10

	.page

rgrp4:
	jrnz	.+9		; 40
	call	rwrd+4		;s41r43
	jrnc	.+9		; 42
	jrr	#2,rbyt,.+3	; 43u10 00
	jrz	.+9		; 44
				; 45
	jrc	.+9		; 46
	add	a,(x)		; 47
	jrnz	.+10		; 48
	jp	rwrd+4		;s49r43
	jrnc	.+10		; 4A
	res	#2,rbyt		; 4Bu10
	jrz	.+10		; 4C
	reti			; 4D
	jrc	.+10		; 4E
	add	a,(y)		; 4F

rgrp5:
	jrnz	.+11		; 50
	call	rwrd+5		;s51r43
	jrnc	.+11		; 52
	jrs	#2,rbyt,.+3	; 53u10 00
	jrz	.+11		; 54
	inc	y		; 55
	jrc	.+11		; 56
	addi	a,#rbyt		; 57r10
	jrnz	.+12		; 58
	jp	rwrd+5		;s59r43
	jrnc	.+12		; 5A
	set	#2,rbyt		; 5Bu10
	jrz	.+12		; 5C
	dec	y		; 5D
	jrc	.+12		; 5E
	add	a,rbyt		; 5Fu10

	.page

rgrp6:
	jrnz	.+13		; 60
	call	rwrd+6		;s61r43
	jrnc	.+13		; 62
	jrr	#3,rbyt,.+3	; 63u10 00
	jrz	.+13		; 64
				; 65
	jrc	.+13		; 66
	inc	(x)		; 67
	jrnz	.+14		; 68
	jp	rwrd+6		;s69r43
	jrnc	.+14		; 6A
	res	#3,rbyt		; 6Bu10
	jrz	.+14		; 6C
	stop			; 6D
	jrc	.+14		; 6E
	inc	(y)		; 6F

rgrp7:
	jrnz	.+15		; 70
	call	rwrd+7		;s71r43
	jrnc	.+15		; 72
	jrs	#3,rbyt,.+3	; 73u10 00
	jrz	.+15		; 74
	ld	a,y		; 75
	jrc	.+15		; 76
				; 77
	jrnz	.+16		; 78
	jp	rwrd+7		;s79r43
	jrnc	.+16		; 7A
	set	#3,rbyt		; 7Bu10
	jrz	.+16		; 7C
	ld	y,a		; 7D
	jrc	.+16		; 7E
	inc	rbyt		; 7Fu10

	.page

rgrp8:
	jrnz	.-15		; 80
	call	rwrd+8		;s81r43
	jrnc	.-15		; 82
	jrr	#4,rbyt,.+3	; 83u10 00
	jrz	.-15		; 84
				; 85
	jrc	.-15		; 86
	ld	(x),a		; 87
	jrnz	.-14		; 88
	jp	rwrd+8		;s89r43
	jrnc	.-14		; 8A
	res	#4,rbyt		; 8Bu10
	jrz	.-14		; 8C
				; 8D
	jrc	.-14		; 8E
	ld	(y),a		; 8F

rgrp9:
	jrnz	.-13		; 90
	call	rwrd+9		;s91r43
	jrnc	.-13		; 92
	jrs	#4,rbyt,.+3	; 93u10 00
	jrz	.-13		; 94
	inc	v		; 95
	jrc	.-13		; 96
				; 97
	jrnz	.-12		; 98
	jp	rwrd+9		;s99r43
	jrnc	.-12		; 9A
	set	#4,rbyt		; 9Bu10
	jrz	.-12		; 9C
	dec	v		; 9D
	jrc	.-12		; 9E
	ld	rbyt,a		; 9Fu10


	.page

rgrpA:
	jrnz	.-11		; A0
	call	rwrd+10		;sA1r43
	jrnc	.-11		; A2
	jrr	#5,rbyt,.+3	; A3u10 00
	jrz	.-11		; A4
				; A5
	jrc	.-11		; A6
	and	a,(x)		; A7
	jrnz	.-10		; A8
	jp	rwrd+10		;sA9r43
	jrnc	.-10		; AA
	res	#5,rbyt		; ABu10
	jrz	.-10		; AC
	rcl	a		; AD
	jrc	.-10		; AE
	and	a,(y)		; AF

rgrpB:
	jrnz	.-9		; B0
	call	rwrd+11		;sB1r43
	jrnc	.-9		; B2
	jrs	#5,rbyt,.+3	; B3u10 00
	jrz	.-9		; B4
	ld	a,v		; B5
	jrc	.-9		; B6
	andi	a,#rbyt		; B7r10
	jrnz	.-8		; B8
	jp	rwrd+11		;sB9r43
	jrnc	.-8		; BA
	set	#5,rbyt		; BBu10
	jrz	.-8		; BC
	ld	v,a		; BD
	jrc	.-8		; BE
	and	a,rbyt		; BFu10

	.page

rgrpC:
	jrnz	.-7		; C0
	call	rwrd+12		;sC1r43
	jrnc	.-7		; C2
	jrr	#6,rbyt,.+3	; C3u10 00
	jrz	.-7		; C4
				; C5
	jrc	.-7		; C6
	sub	a,(x)		; C7
	jrnz	.-6		; C8
	jp	rwrd+12		;sC9r43
	jrnc	.-6		; CA
	res	#6,rbyt		; CBu10
	jrz	.-6		; CC
	ret			; CD
	jrc	.-6		; CE
	sub	a,(y)		; CF

rgrpD:
	jrnz	.-5		; D0
	call	rwrd+13		;sD1r43
	jrnc	.-5		; D2
	jrs	#6,rbyt,.+3	; D3u10 00
	jrz	.-5		; D4
	inc	w		; D5
	jrc	.-5		; D6
	subi	a,#rbyt		; D7r10
	jrnz	.-4		; D8
	jp	rwrd+13		;sD9r43
	jrnc	.-4		; DA
	set	#6,rbyt		; DBu10
	jrz	.-4		; DC
	dec	w		; DD
	jrc	.-4		; DE
	sub	a,rbyt		; DFu10

	.page

rgrpE:
	jrnz	.-3		; E0
	call	rwrd+14		;sE1r43
	jrnc	.-3		; E2
	jrr	#7,rbyt,.+3	; E3u10 00
	jrz	.-3		; E4
				; E5
	jrc	.-3		; E6
	dec	(x)		; E7
	jrnz	.-2		; E8
	jp	rwrd+14		;sE9r43
	jrnc	.-2		; EA
	res	#7,rbyt		; EBu10
	jrz	.-2		; EC
	wait			; ED
	jrc	.-2		; EE
	dec	(y)		; EF

rgrpF:
	jrnz	.-1		; F0
	call	rwrd+15		;sF1r43
	jrnc	.-1		; F2
	jrs	#7,rbyt,.+3	; F3u10 00
	jrz	.-1		; F4
	ld	a,w		; F5
	jrc	.-1		; F6
				; F7 10
	jrnz	.-0		; F8
	jp	rwrd+15		;sF9r43
	jrnc	.-0		; FA
	set	#7,rbyt		; FBu10
	jrz	.-0		; FC
	ld	w,a		; FD
	jrc	.-0		; FE
	dec	rbyt		; FFu10


	.page
	.sbttl	ST6 Instructions in Numerical Order (External)

	.define		rbyt,	/xbyt + 0x0010/
	.define		rwrd,	/xwrd + 0x0430/

	.define		bit0,	/xbit0 + 0/
	.define		bit1,	/xbit1 + 1/
	.define		bit2,	/xbit2 + 2/
	.define		bit3,	/xbit3 + 3/
	.define		bit4,	/xbit4 + 4/
	.define		bit5,	/xbit5 + 5/
	.define		bit6,	/xbit6 + 6/
	.define		bit7,	/xbit7 + 7/


xgrp0:
	jrnz	.+1		; 00
	call	rwrd+0		;s01r43
	jrnc	.+1		; 02
	jrr	#bit0,rbyt,.+3	;u03u10 00
	jrz	.+1		; 04
				; 05
	jrc	.+1		; 06
	ld	a,(x)		; 07
	jrnz	.+2		; 08
	jp	rwrd+0		;s09r43
	jrnc	.+2		; 0A
	res	#bit0,rbyt	;u0Bu10
	jrz	.+2		; 0C
	ldi	rbyt,#rbyt	; 0Du10r10
	jrc	.+2		; 0E
	ld	a,(y)		; 0F

xgrp1:
	jrnz	.+3		; 10
	call	rwrd+1		;s11r43
	jrnc	.+3		; 12
	jrs	#bit0,rbyt,.+3	;u13u10 00
	jrz	.+3		; 14
	inc	x		; 15
	jrc	.+3		; 16
	ld	a,#rbyt		; 17r10
	jrnz	.+4		; 18
	jp	rwrd+1		;s19r43
	jrnc	.+4		; 1A
	set	#bit0,rbyt	;u1Bu10
	jrz	.+4		; 1C
	dec	x		; 1D
	jrc	.+4		; 1E
	ld	a,rbyt		; 1Fu10

	.page

xgrp2:
	jrnz	.+5		; 20
	call	rwrd+2		;s21r43
	jrnc	.+5		; 22
	jrr	#bit1,rbyt,.+3	;u23u10 00
	jrz	.+5		; 24
				; 25
	jrc	.+5		; 26
	cp	a,(x)		; 27
	jrnz	.+6		; 28
	jp	rwrd+2		;s29r43
	jrnc	.+6		; 2A
	res	#bit1,rbyt	;u2Bu10
	jrz	.+6		; 2C
	com	a		; 2D
	jrc	.+6		; 2E
	cp	a,(y)		; 2F

xgrp3:
	jrnz	.+7		; 30
	call	rwrd+3		;s31r43
	jrnc	.+7		; 32
	jrs	#bit1,rbyt,.+3	;u33u10 00
	jrz	.+7		; 34
	ld	a,x		; 35
	jrc	.+7		; 36
	cpi	a,#rbyt		; 37r10
	jrnz	.+8		; 38
	jp	rwrd+3		;s39r43
	jrnc	.+8		; 3A
	set	#bit1,rbyt	;u3Bu10
	jrz	.+8		; 3C
	ld	x,a		; 3D
	jrc	.+8		; 3E
	cp	a,rbyt		; 3Fu10

	.page

xgrp4:
	jrnz	.+9		; 40
	call	rwrd+4		;s41r43
	jrnc	.+9		; 42
	jrr	#bit2,rbyt,.+3	;u43u10 00
	jrz	.+9		; 44
				; 45
	jrc	.+9		; 46
	add	a,(x)		; 47
	jrnz	.+10		; 48
	jp	rwrd+4		;s49r43
	jrnc	.+10		; 4A
	res	#bit2,rbyt	;u4Bu10
	jrz	.+10		; 4C
	reti			; 4D
	jrc	.+10		; 4E
	add	a,(y)		; 4F

xgrp5:
	jrnz	.+11		; 50
	call	rwrd+5		;s51r43
	jrnc	.+11		; 52
	jrs	#bit2,rbyt,.+3	;u53u10 00
	jrz	.+11		; 54
	inc	y		; 55
	jrc	.+11		; 56
	addi	a,#rbyt		; 57r10
	jrnz	.+12		; 58
	jp	rwrd+5		;s59r43
	jrnc	.+12		; 5A
	set	#bit2,rbyt	;u5Bu10
	jrz	.+12		; 5C
	dec	y		; 5D
	jrc	.+12		; 5E
	add	a,rbyt		; 5Fu10

	.page

xgrp6:
	jrnz	.+13		; 60
	call	rwrd+6		;s61r43
	jrnc	.+13		; 62
	jrr	#bit3,rbyt,.+3	;u63u10 00
	jrz	.+13		; 64
				; 65
	jrc	.+13		; 66
	inc	(x)		; 67
	jrnz	.+14		; 68
	jp	rwrd+6		;s69r43
	jrnc	.+14		; 6A
	res	#bit3,rbyt	;u6Bu10
	jrz	.+14		; 6C
	stop			; 6D
	jrc	.+14		; 6E
	inc	(y)		; 6F

xgrp7:
	jrnz	.+15		; 70
	call	rwrd+7		;s71r43
	jrnc	.+15		; 72
	jrs	#bit3,rbyt,.+3	;u73u10 00
	jrz	.+15		; 74
	ld	a,y		; 75
	jrc	.+15		; 76
				; 77
	jrnz	.+16		; 78
	jp	rwrd+7		;s79r43
	jrnc	.+16		; 7A
	set	#bit3,rbyt	;u7Bu10
	jrz	.+16		; 7C
	ld	y,a		; 7D
	jrc	.+16		; 7E
	inc	rbyt		; 7Fu10

	.page

xgrp8:
	jrnz	.-15		; 80
	call	rwrd+8		;s81r43
	jrnc	.-15		; 82
	jrr	#bit4,rbyt,.+3	;u83u10 00
	jrz	.-15		; 84
				; 85
	jrc	.-15		; 86
	ld	(x),a		; 87
	jrnz	.-14		; 88
	jp	rwrd+8		;s89r43
	jrnc	.-14		; 8A
	res	#bit4,rbyt	;u8Bu10
	jrz	.-14		; 8C
				; 8D
	jrc	.-14		; 8E
	ld	(y),a		; 8F

xgrp9:
	jrnz	.-13		; 90
	call	rwrd+9		;s91r43
	jrnc	.-13		; 92
	jrs	#bit4,rbyt,.+3	;u93u10 00
	jrz	.-13		; 94
	inc	v		; 95
	jrc	.-13		; 96
				; 97
	jrnz	.-12		; 98
	jp	rwrd+9		;s99r43
	jrnc	.-12		; 9A
	set	#bit4,rbyt	;u9Bu10
	jrz	.-12		; 9C
	dec	v		; 9D
	jrc	.-12		; 9E
	ld	rbyt,a		; 9Fu10


	.page

xgrpA:
	jrnz	.-11		; A0
	call	rwrd+10		;sA1r43
	jrnc	.-11		; A2
	jrr	#bit5,rbyt,.+3	;uA3u10 00
	jrz	.-11		; A4
				; A5
	jrc	.-11		; A6
	and	a,(x)		; A7
	jrnz	.-10		; A8
	jp	rwrd+10		;sA9r43
	jrnc	.-10		; AA
	res	#bit5,rbyt	;uABu10
	jrz	.-10		; AC
	rcl	a		; AD
	jrc	.-10		; AE
	and	a,(y)		; AF

xgrpB:
	jrnz	.-9		; B0
	call	rwrd+11		;sB1r43
	jrnc	.-9		; B2
	jrs	#bit5,rbyt,.+3	;uB3u10 00
	jrz	.-9		; B4
	ld	a,v		; B5
	jrc	.-9		; B6
	andi	a,#rbyt		; B7r10
	jrnz	.-8		; B8
	jp	rwrd+11		;sB9r43
	jrnc	.-8		; BA
	set	#bit5,rbyt	;uBBu10
	jrz	.-8		; BC
	ld	v,a		; BD
	jrc	.-8		; BE
	and	a,rbyt		; BFu10

	.page

xgrpC:
	jrnz	.-7		; C0
	call	rwrd+12		;sC1r43
	jrnc	.-7		; C2
	jrr	#bit6,rbyt,.+3	;uC3u10 00
	jrz	.-7		; C4
				; C5
	jrc	.-7		; C6
	sub	a,(x)		; C7
	jrnz	.-6		; C8
	jp	rwrd+12		;sC9r43
	jrnc	.-6		; CA
	res	#bit6,rbyt	;uCBu10
	jrz	.-6		; CC
	ret			; CD
	jrc	.-6		; CE
	sub	a,(y)		; CF

xgrpD:
	jrnz	.-5		; D0
	call	rwrd+13		;sD1r43
	jrnc	.-5		; D2
	jrs	#bit6,rbyt,.+3	;uD3u10 00
	jrz	.-5		; D4
	inc	w		; D5
	jrc	.-5		; D6
	subi	a,#rbyt		; D7r10
	jrnz	.-4		; D8
	jp	rwrd+13		;sD9r43
	jrnc	.-4		; DA
	set	#bit6,rbyt	;uDBu10
	jrz	.-4		; DC
	dec	w		; DD
	jrc	.-4		; DE
	sub	a,rbyt		; DFu10

	.page

xgrpE:
	jrnz	.-3		; E0
	call	rwrd+14		;sE1r43
	jrnc	.-3		; E2
	jrr	#bit7,rbyt,.+3	;uE3u10 00
	jrz	.-3		; E4
				; E5
	jrc	.-3		; E6
	dec	(x)		; E7
	jrnz	.-2		; E8
	jp	rwrd+14		;sE9r43
	jrnc	.-2		; EA
	res	#bit7,rbyt	;uEBu10
	jrz	.-2		; EC
	wait			; ED
	jrc	.-2		; EE
	dec	(y)		; EF

xgrpF:
	jrnz	.-1		; F0
	call	rwrd+15		;sF1r43
	jrnc	.-1		; F2
	jrs	#bit7,rbyt,.+3	;uF3u10 00
	jrz	.-1		; F4
	ld	a,w		; F5
	jrc	.-1		; F6
				; F7
	jrnz	.-0		; F8
	jp	rwrd+15		;sF9r43
	jrnc	.-0		; FA
	set	#bit7,rbyt	;uFBu10
	jrz	.-0		; FC
	ld	w,a		; FD
	jrc	.-0		; FE
	dec	rbyt		; FFu10

	.undefine	rbyt
	.undefine	rwrd

	.undefine	bit0
	.undefine	bit1
	.undefine	bit2
	.undefine	bit3
	.undefine	bit4
	.undefine	bit5
	.undefine	bit6
	.undefine	bit7

	.end

