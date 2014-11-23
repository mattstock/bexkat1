	.title	st7  Assembly Errors Test

	.area	Prog(rel,con)


	abyt	=	0x0110		; Absolute 1-abyte Value
	awrd	=	0x015432	; Absolute 2-abyte Value
	aexa	=	0x01BA9876	; Absolute 3-abyte Value

	rbyt	=	. + 0x0010	; Relocatable 1-abyte Value
	rwrd	=	. + 0x5432	; Relocatable 2-abyte Value
	rexa	=	. + 0xBA9876	; Relocatable 3-abyte Value


	.page
	.sbttl	Base ST7 Instructions in Numerical Order (Absolute)

	; The 1-Byte abyt value has been changed to a 2-Byte value.
	; Those instructions not supporting a 2-Byte mode will
	; report an 'a' error except most immediate mode instructions
	; which simply use the lower 1-Byte value.
	;
	; The 2-Byte awrd value has been changed to a 3-Byte value.
	; All modes with awrd will report 'a' errors except the
	; immediate mode which simply uses the lower 2-Byte value.
	;
	; All 3-Byte instructions simply use the lower 3-Byte value.

agrp0:
	neg	(abyt,sp)	;a00 10
	rrwa	x,a		; 01
	rlwa	x,a		; 02
	cpl	(abyt,sp)	;a03 10
	srl	(abyt,sp)	;a04 10
				; 05
	rrc	(abyt,sp)	;a06 10
	sra	(abyt,sp)	;a07 10
	sla	(abyt,sp)	;a08 10
	rlc	(abyt,sp)	;a09 10
	dec	(abyt,sp)	;a0A 10
				; 0B 10
	inc	(abyt,sp)	;a0C 10
	tnz	(abyt,sp)	;a0D 10
	swap	(abyt,sp)	;a0E 10
	clr	(abyt,sp)	;a0F 10

agrp1:
	sub	a,(abyt,sp)	;a10 10
	cp	a,(abyt,sp)	;a11 10
	sbc	a,(abyt,sp)	;a12 10
	cpw	x,(abyt,sp)	;a13 10
	and	a,(abyt,sp)	;a14 10
	bcp	a,(abyt,sp)	;a15 10
	ldw	y,(abyt,sp)	;a16 10
	ldw	(abyt,sp),y	;a17 10
	xor	a,(abyt,sp)	;a18 10
	adc	a,(abyt,sp)	;a19 10
	or	a,(abyt,sp)	;a1A 10
	add	a,(abyt,sp)	;a1B 10
	addw	x,#awrd		; 1C 54 32
	subw	x,#awrd		; 1D 54 32
	ldw	x,(abyt,sp)	;a1E 10
	ldw	(abyt,sp),x	;a1F 10

	.page

agrp2:
	jra	1$		; 20 0E
	jrf	1$		; 21 0C
	jrugt	1$		; 22 0A
	jrule	1$		; 23 08
	jrnc	1$		; 24 06
	jrc	1$		; 25 04
	jrne	1$		; 26 02
	jreq	1$		; 27 00
1$:	jrnv	1$		; 28 FE
	jrv	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrsgt	1$		; 2C F6
	jrsle	1$		; 2D F4
	jrsge	1$		; 2E F2
	jrslt	1$		; 2F F0

agrp3:
	neg	abyt		; 72 50 01 10
	exg	a,awrd		;a31 54 32
	pop	awrd		;a32 54 32
	cpl	abyt		; 72 53 01 10
	srl	abyt		; 72 54 01 10
	mov	awrd,#abyt	;a35 10 54 32
	rrc	abyt		; 72 56 01 10
	sra	abyt		; 72 57 01 10
	sla	abyt		; 72 58 01 10
	rlc	abyt		; 72 59 01 10
	dec	abyt		; 72 5A 01 10
	push	awrd		;a3B 54 32
	inc	abyt		; 72 5C 01 10
	tnz	abyt		; 72 5D 01 10
	swap	abyt		; 72 5E 01 10
	clr	abyt		; 72 5F 01 10

	.page

agrp4:
	neg	a		; 40
	exg	a,xl		; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
	mov	abyt,abyt+0x11	; 55 01 21 01 10
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
	push	#abyt		; 4B 10
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

agrp5:
	negw	x		; 50
	exgw	x,y		; 51
	sub	sp,#abyt	;a52 10
	cplw	x		; 53
	srlw	x		; 54
	mov	awrd,awrd+0x1111;a55 65 43 54 32
	rrcw	x		; 56
	sraw	x		; 57
	slaw	x		; 58
	rlcw	x		; 59
	decw	x		; 5A
	add	sp,#abyt	;a5B 10
	incw	x		; 5C
	tnzw	x		; 5D
	swapw	x		; 5E
	clrw	x		; 5F

	.page

agrp6:
	neg	(abyt,x)	; 72 40 01 10
	exg	a,yl		; 61
	div	x,a		; 62
	cpl	(abyt,x)	; 72 43 01 10
	srl	(abyt,x)	; 72 44 01 10
	divw	x,y		; 65
	rrc	(abyt,x)	; 72 46 01 10
	sra	(abyt,x)	; 72 47 01 10
	sla	(abyt,x)	; 72 48 01 10
	rlc	(abyt,x)	; 72 49 01 10
	dec	(abyt,x)	; 72 4A 01 10
	ld	(abyt,sp),a	;a6B 10
	inc	(abyt,x)	; 72 4C 01 10
	tnz	(abyt,x)	; 72 4D 01 10
	swap	(abyt,x)	; 72 4E 01 10
	clr	(abyt,x)	; 72 4F 01 10

agrp7:
	neg	(x)		; 70
				; 71
				; 72
	cpl	(x)		; 73
	srl	(x)		; 74
				; 75
	rrc	(x)		; 76
	sra	(x)		; 77
	sla	(x)		; 78
	rlc	(x)		; 79
	dec	(x)		; 7A
	ld	a,(abyt,sp)	;a7B 10
	inc	(x)		; 7C
	tnz	(x)		; 7D
	swap	(x)		; 7E
	clr	(x)		; 7F

	.page

agrp8:
	iret			; 80
	ret			; 81
				; 82
	trap			; 83
	pop	a		; 84
	popw	x		; 85
	pop	cc		; 86
	retf			; 87
	push	a		; 88
	pushw	x		; 89
	push	cc		; 8A
				; 8B
	ccf			; 8C
	callf	aexa		; 8D BA 98 76
	halt			; 8E
	wfi			; 8F

agrp9:
				; 90
				; 91
				; 92
	ldw	x,y		; 93
	ldw	sp,x		; 94
	ld	xh,a		; 95
	ldw	x,sp		; 96
	ld	xl,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rvf			; 9C
	nop			; 9D
	ld	a,xh		; 9E
	ld	a,xl		; 9F

	.page

agrpA:
	sub	a,#abyt		; A0 10
	cp	a,#abyt		; A1 10
	sbc	a,#abyt		; A2 10
	cpw	x,#awrd		; A3 54 32
	and	a,#abyt		; A4 10
	bcp	a,#abyt		; A5 10
	ld	a,#abyt		; A6 10
	ldf	(aexa,x),a	; A7 BA 98 76
	xor	a,#abyt		; A8 10
	adc	a,#abyt		; A9 10
	or	a,#abyt		; AA 10
	add	a,#abyt		; AB 10
	jpf	aexa		; AC BA 98 76
1$:	callr	1$		; AD FE
	ldw	x,#awrd		; AE 54 32
	ldf	a,(aexa,x)	; AF BA 98 76

agrpB:
	sub	a,abyt		; C0 01 10
	cp	a,abyt		; C1 01 10
	sbc	a,abyt		; C2 01 10
	cpw	x,abyt		; C3 01 10
	and	a,abyt		; C4 01 10
	bcp	a,abyt		; C5 01 10
	ld	a,abyt		; C6 01 10
	ld	abyt,a		; C7 01 10
	xor	a,abyt		; C8 01 10
	adc	a,abyt		; C9 01 10
	or	a,abyt		; CA 01 10
	add	a,abyt		; CB 01 10
	ldf	a,aexa		; BC BA 98 76
	ldf	aexa,a		; BD BA 98 76
	ldw	x,abyt		; CE 01 10
	ldw	abyt,x		; CF 01 10

	.page

agrpC:
	sub	a,awrd		;aC0 54 32
	cp	a,awrd		;aC1 54 32
	sbc	a,awrd		;aC2 54 32
	cpw	x,awrd		;aC3 54 32
	and	a,awrd		;aC4 54 32
	bcp	a,awrd		;aC5 54 32
	ld	a,awrd		;aC6 54 32
	ld	awrd,a		;aC7 54 32
	xor	a,awrd		;aC8 54 32
	adc	a,awrd		;aC9 54 32
	or	a,awrd		;aCA 54 32
	add	a,awrd		;aCB 54 32
	jp	awrd		; CC 54 32
	call	awrd		; CD 54 32
	ldw	x,awrd		;aCE 54 32
	ldw	awrd,x		;aCF 54 32

agrpD:
	sub	a,(awrd,x)	;aD0 54 32
	cp	a,(awrd,x)	;aD1 54 32
	sbc	a,(awrd,x)	;aD2 54 32
	cpw	y,(awrd,x)	;aD3 54 32
	and	a,(awrd,x)	;aD4 54 32
	bcp	a,(awrd,x)	;aD5 54 32
	ld	a,(awrd,x)	;aD6 54 32
	ld	(awrd,x),a	;aD7 54 32
	xor	a,(awrd,x)	;aD8 54 32
	adc	a,(awrd,x)	;aD9 54 32
	or	a,(awrd,x)	;aDA 54 32
	add	a,(awrd,x)	;aDB 54 32
	jp	(awrd,x)	;aDC 54 32
	call	(awrd,x)	;aDD 54 32
	ldw	x,(awrd,x)	;aDE 54 32
	ldw	(awrd,x),y	;aDF 54 32

	.page

agrpE:
	sub	a,(abyt,x)	; D0 01 10
	cp	a,(abyt,x)	; D1 01 10
	sbc	a,(abyt,x)	; D2 01 10
	cpw	y,(abyt,x)	; D3 01 10
	and	a,(abyt,x)	; D4 01 10
	bcp	a,(abyt,x)	; D5 01 10
	ld	a,(abyt,x)	; D6 01 10
	ld	(abyt,x),a	; D7 01 10
	xor	a,(abyt,x)	; D8 01 10
	adc	a,(abyt,x)	; D9 01 10
	or	a,(abyt,x)	; DA 01 10
	add	a,(abyt,x)	; DB 01 10
	jp	(abyt,x)	; DC 01 10
	call	(abyt,x)	; DD 01 10
	ldw	x,(abyt,x)	; DE 01 10
	ldw	(abyt,x),y	; DF 01 10

agrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cpw	y,(x)		; F3
	and	a,(x)		; F4
	bcp	a,(x)		; F5
	ld	a,(x)		; F6
	ld	(x),a		; F7
	xor	a,(x)		; F8
	adc	a,(x)		; F9
	or	a,(x)		; FA
	add	a,(x)		; FB
	jp	(x)		; FC
	call	(x)		; FD
	ldw	x,(x)		; FE
	ldw	(x),y		; FF


	.page
	.sbttl	Page 72 ST7 Instructions in Numerical Order (Absolute)

agrp72_0:
	btjt	awrd,#0,1$	;a72 00 54 32 23
	btjf	awrd,#0,1$	;a72 01 54 32 1E
	btjt	awrd,#1,1$	;a72 02 54 32 19
	btjf	awrd,#1,1$	;a72 03 54 32 14
	btjt	awrd,#2,1$	;a72 04 54 32 0F
	btjf	awrd,#2,1$	;a72 05 54 32 0A
	btjt	awrd,#3,1$	;a72 06 54 32 05
	btjf	awrd,#3,1$	;a72 07 54 32 00
1$:	btjt	awrd,#4,1$	;a72 08 54 32 FB
	btjf	awrd,#4,1$	;a72 09 54 32 F6
	btjt	awrd,#5,1$	;a72 0A 54 32 F1
	btjf	awrd,#5,1$	;a72 0B 54 32 EC
	btjt	awrd,#6,1$	;a72 0C 54 32 E7
	btjf	awrd,#6,1$	;a72 0D 54 32 E2
	btjt	awrd,#7,1$	;a72 0E 54 32 DD
	btjf	awrd,#7,1$	;a72 0F 54 32 D8

agrp72_1:
	bset	awrd,#0		;a72 10 54 32
	bres	awrd,#0		;a72 11 54 32
	bset	awrd,#1		;a72 12 54 32
	bres	awrd,#1		;a72 13 54 32
	bset	awrd,#2		;a72 14 54 32
	bres	awrd,#2		;a72 15 54 32
	bset	awrd,#3		;a72 16 54 32
	bres	awrd,#3		;a72 17 54 32
	bset	awrd,#4		;a72 18 54 32
	bres	awrd,#4		;a72 19 54 32
	bset	awrd,#5		;a72 1A 54 32
	bres	awrd,#5		;a72 1B 54 32
	bset	awrd,#6		;a72 1C 54 32
	bres	awrd,#6		;a72 1D 54 32
	bset	awrd,#7		;a72 1E 54 32
	bres	awrd,#7		;a72 1F 54 32

agrp72_2:

	.page

agrp72_3:
	neg	[awrd]		;a72 30 54 32
				; 72 31
				; 72 32
	cpl	[awrd]		;a72 33 54 32
	srl	[awrd]		;a72 34 54 32
				; 72 35
	rrc	[awrd]		;a72 36 54 32
	sra	[awrd]		;a72 37 54 32
	sla	[awrd]		;a72 38 54 32
	rlc	[awrd]		;a72 39 54 32
	dec	[awrd]		;a72 3A 54 32
				; 72 3B
	inc	[awrd]		;a72 3C 54 32
	tnz	[awrd]		;a72 3D 54 32
	swap	[awrd]		;a72 3E 54 32
	clr	[awrd]		;a72 3F 54 32

agrp72_4:
	neg	(awrd,x)	;a72 40 54 32
				; 72 41
				; 72 42
	cpl	(awrd,x)	;a72 43 54 32
	srl	(awrd,x)	;a72 44 54 32
				; 72 45
	rrc	(awrd,x)	;a72 46 54 32
	sra	(awrd,x)	;a72 47 54 32
	sla	(awrd,x)	;a72 48 54 32
	rlc	(awrd,x)	;a72 49 54 32
	dec	(awrd,x)	;a72 4A 54 32
				; 72 4B
	inc	(awrd,x)	;a72 4C 54 32
	tnz	(awrd,x)	;a72 4D 54 32
	swap	(awrd,x)	;a72 4E 54 32
	clr	(awrd,x)	;a72 4F 54 32

	.page

agrp72_5:
	neg	awrd		;a72 50 54 32
				; 72 51
				; 72 52
	cpl	awrd		;a72 53 54 32
	srl	awrd		;a72 54 54 32
				; 72 55
	rrc	awrd		;a72 56 54 32
	sra	awrd		;a72 57 54 32
	sla	awrd		;a72 58 54 32
	rlc	awrd		;a72 59 54 32
	dec	awrd		;a72 5A 54 32
				; 72 5B
	inc	awrd		;a72 5C 54 32
	tnz	awrd		;a72 5D 54 32
	swap	awrd		;a72 5E 54 32
	clr	awrd		;a72 5F 54 32

agrp72_6:
	neg	([awrd],x)	;a72 60 54 32
				; 72 61
				; 72 62
	cpl	([awrd],x)	;a72 63 54 32
	srl	([awrd],x)	;a72 64 54 32
				; 72 65
	rrc	([awrd],x)	;a72 66 54 32
	sra	([awrd],x)	;a72 67 54 32
	sla	([awrd],x)	;a72 68 54 32
	rlc	([awrd],x)	;a72 69 54 32
	dec	([awrd],x)	;a72 6A 54 32
				; 72 6B
	inc	([awrd],x)	;a72 6C 54 32
	tnz	([awrd],x)	;a72 6D 54 32
	swap	([awrd],x)	;a72 6E 54 32
	clr	([awrd],x)	;a72 6F 54 32

	.page

agrp72_7:

agrp72_8:
	wfe			; 72 8F

agrp72_9:

agrp72_A:
	subw	y,#awrd		; 72 A2 54 32
	addw	y,#awrd		; 72 A9 54 32

agrp72_B:
	subw	x,abyt		;a72 B0 10
	subw	y,abyt		;a72 B2 10
	addw	y,abyt		;a72 B9 10
	addw	x,abyt		;a72 BB 10

	.page

agrp72_C:
	sub	a,[awrd]	;a72 C0 54 32
	cp	a,[awrd]	;a72 C1 54 32
	sbc	a,[awrd]	;a72 C2 54 32
	cpw	x,[awrd]	;a72 C3 54 32
	and	a,[awrd]	;a72 C4 54 32
	bcp	a,[awrd]	;a72 C5 54 32
	ld	a,[awrd]	;a72 C6 54 32
	ld	[awrd],a	;a72 C7 54 32
	xor	a,[awrd]	;a72 C8 54 32
	adc	a,[awrd]	;a72 C9 54 32
	or	a,[awrd]	;a72 CA 54 32
	add	a,[awrd]	;a72 CB 54 32
	jp	[awrd]		;a72 CC 54 32
	call	[awrd]		;a72 CD 54 32
	ldw	x,[awrd]	;a72 CE 54 32
	ldw	[awrd],x	;a72 CF 54 32

agrp72_D:
	sub	a,([awrd],x)	;a72 D0 54 32
	cp	a,([awrd],x)	;a72 D1 54 32
	sbc	a,([awrd],x)	;a72 D2 54 32
	cpw	y,([awrd],x)	;a72 D3 54 32
	and	a,([awrd],x)	;a72 D4 54 32
	bcp	a,([awrd],x)	;a72 D5 54 32
	ld	a,([awrd],x)	;a72 D6 54 32
	ld	([awrd],x),a	;a72 D7 54 32
	xor	a,([awrd],x)	;a72 D8 54 32
	adc	a,([awrd],x)	;a72 D9 54 32
	or	a,([awrd],x)	;a72 DA 54 32
	add	a,([awrd],x)	;a72 DB 54 32
	jp	([awrd],x)	;a72 DC 54 32
	call	([awrd],x)	;a72 DD 54 32
	ldw	x,([awrd],x)	;a72 DE 54 32
	ldw	([awrd],x),y	;a72 DF 54 32

agrp72_E:

agrp72_F:
	subw	x,(abyt,sp)	;a72 F0 10
	subw	y,(abyt,sp)	;a72 F2 10
	addw	y,(abyt,sp)	;a72 F9 10
	addw	x,(abyt,sp)	;a72 FB 10


	.page
	.sbttl	Page 90 ST7 Instructions in Numerical Order (Absolute)

agrp90_0:
	rrwa	y,a		; 90 01
	rlwa	y,a		; 90 02

agrp90_1:
	bcpl	awrd,#0		;a90 10 54 32
	bccm	awrd,#0		;a90 11 54 32
	bcpl	awrd,#1		;a90 12 54 32
	bccm	awrd,#1		;a90 13 54 32
	bcpl	awrd,#2		;a90 14 54 32
	bccm	awrd,#2		;a90 15 54 32
	bcpl	awrd,#3		;a90 16 54 32
	bccm	awrd,#3		;a90 17 54 32
	bcpl	awrd,#4		;a90 18 54 32
	bccm	awrd,#4		;a90 19 54 32
	bcpl	awrd,#5		;a90 1A 54 32
	bccm	awrd,#5		;a90 1B 54 32
	bcpl	awrd,#6		;a90 1C 54 32
	bccm	awrd,#6		;a90 1D 54 32
	bcpl	awrd,#7		;a90 1E 54 32
	bccm	awrd,#7		;a90 1F 54 32

agrp90_2:
	jrnh	1$		; 90 28 0C
	jrh	1$		; 90 29 09
	jrnm	1$		; 90 2C 06
	jrm	1$		; 90 2D 03
	jril	1$		; 90 2E 00
1$:	jrih	1$		; 90 2F FD

agrp90_3:

	.page

agrp90_4:
	neg	(awrd,y)	;a90 40 54 32
				; 90 41
	mul	y,a		; 90 42
	cpl	(awrd,y)	;a90 43 54 32
	srl	(awrd,y)	;a90 44 54 32
				; 90 45
	rrc	(awrd,y)	;a90 46 54 32
	sra	(awrd,y)	;a90 47 54 32
	sla	(awrd,y)	;a90 48 54 32
	rlc	(awrd,y)	;a90 49 54 32
	dec	(awrd,y)	;a90 4A 54 32
				; 90 4B
	inc	(awrd,y)	;a90 4C 54 32
	tnz	(awrd,y)	;a90 4D 54 32
	swap	(awrd,y)	;a90 4E 54 32
	clr	(awrd,y)	;a90 4F 54 32

 agrp90_5:
	negw	y		; 90 50
				; 90 51
				; 90 52
	cplw	y		; 90 53
	srlw	y		; 90 54
				; 90 55
	rrcw	y		; 90 56
	sraw	y		; 90 57
	slaw	y		; 90 58
	rlcw	y		; 90 59
	decw	y		; 90 5A
				; 90 5B
	incw	y		; 90 5C
	tnzw	y		; 90 5D
	swapw	y		; 90 5E
	clrw	y		; 90 5F

.page

agrp90_6:
	neg	(abyt,y)	; 90 40 01 10
				; 90 61
	div	y,a		; 90 62
	cpl	(abyt,y)	; 90 43 01 10
	srl	(abyt,y)	; 90 44 01 10
				; 90 65
	rrc	(abyt,y)	; 90 46 01 10
	sra	(abyt,y)	; 90 47 01 10
	sla	(abyt,y)	; 90 48 01 10
	rlc	(abyt,y)	; 90 49 01 10
	dec	(abyt,y)	; 90 4A 01 10
				; 90 6B
	inc	(abyt,y)	; 90 4C 01 10
	tnz	(abyt,y)	; 90 4D 01 10
	swap	(abyt,y)	; 90 4E 01 10
	clr	(abyt,y)	; 90 4F 01 10

 agrp90_7:
	neg	(y)		; 90 70
				; 90 71
				; 90 72
	cpl	(y)		; 90 73
	srl	(y)		; 90 74
				; 90 75
	rrc	(y)		; 90 76
	sra	(y)		; 90 77
	sla	(y)		; 90 78
	rlc	(y)		; 90 79
	dec	(y)		; 90 7A
				; 90 7B
	inc	(y)		; 90 7C
	tnz	(y)		; 90 7D
	swap	(y)		; 90 7E
	clr	(y)		; 90 7F

.page

agrp90_8:
	popw	y		; 90 85
	pushw	y		; 90 89

agrp90_9:
	ldw	y,x		; 90 93
	ldw	sp,y		; 90 94
	ld	yh,a		; 90 95
	ldw	y,sp		; 90 96
	ld	yl,a		; 90 97
	ld	a,yh		; 90 9E
	ld	a,yl		; 90 9F

agrp90_A:
	cpw	y,#awrd		; 90 A3 54 32
	ldf	(aexa,y),a	; 90 A7 BA 98 76
	ldw	y,#awrd		; 90 AE 54 32
	ldf	a,(aexa,y)	; 90 AF BA 98 76

agrp90_B:
	cpw	y,abyt		; 90 C3 01 10
	ldw	y,abyt		; 90 CE 01 10
	ldw	abyt,y		; 90 CF 01 10

agrp90_C:
	cpw	y,awrd		;a90 C3 54 32
	ldw	y,awrd		;a90 CE 54 32
	ldw	awrd,y		;a90 CF 54 32

agrp90_D:
	sub	a,(awrd,y)	;a90 D0 54 32
	cp	a,(awrd,y)	;a90 D1 54 32
	sbc	a,(awrd,y)	;a90 D2 54 32
	cpw	x,(awrd,y)	;a90 D3 54 32
	and	a,(awrd,y)	;a90 D4 54 32
	bcp	a,(awrd,y)	;a90 D5 54 32
	ld	a,(awrd,y)	;a90 D6 54 32
	ld	(awrd,y),a	;a90 D7 54 32
	xor	a,(awrd,y)	;a90 D8 54 32
	adc	a,(awrd,y)	;a90 D9 54 32
	or	a,(awrd,y)	;a90 DA 54 32
	add	a,(awrd,y)	;a90 DB 54 32
	jp	(awrd,y)	;a90 DC 54 32
	call	(awrd,y)	;a90 DD 54 32
	ldw 	y,(awrd,y)	;a90 DE 54 32
	ldw 	(awrd,y),x	;a90 DF 54 32

	.page

agrp90_E:
	sub	a,(abyt,y)	; 90 D0 01 10
	cp	a,(abyt,y)	; 90 D1 01 10
	sbc	a,(abyt,y)	; 90 D2 01 10
	cpw	x,(abyt,y)	; 90 D3 01 10
	and	a,(abyt,y)	; 90 D4 01 10
	bcp	a,(abyt,y)	; 90 D5 01 10
	ld	a,(abyt,y)	; 90 D6 01 10
	ld	(abyt,y),a	; 90 D7 01 10
	xor	a,(abyt,y)	; 90 D8 01 10
	adc	a,(abyt,y)	; 90 D9 01 10
	or	a,(abyt,y)	; 90 DA 01 10
	add	a,(abyt,y)	; 90 DB 01 10
	jp	(abyt,y)	; 90 DC 01 10
	call	(abyt,y)	; 90 DD 01 10
	ldw 	y,(abyt,y)	; 90 DE 01 10
	ldw 	(abyt,y),x	; 90 DF 01 10

agrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cpw	x,(y)		; 90 F3
	and	a,(y)		; 90 F4
	bcp	a,(y)		; 90 F5
	ld	a,(y)		; 90 F6
	ld	(y),a		; 90 F7
	xor	a,(y)		; 90 F8
	adc	a,(y)		; 90 F9
	or	a,(y)		; 90 FA
	add	a,(y)		; 90 FB
	jp	(y)		; 90 FC
	call	(y)		; 90 FD
	ldw 	y,(y)		; 90 FE
	ldw 	(y),x		; 90 FF


	.page
	.sbttl	Page 91 ST7 Instructions in Numerical Order (Absolute)

agrp91_0:

agrp91_1:

agrp91_2:

agrp91_3:

agrp91_4:

agrp91_5:

agrp91_6:
	neg	([abyt],y)	;a91 60 10
				; 91 61
				; 91 62
	cpl	([abyt],y)	;a91 63 10
	srl	([abyt],y)	;a91 64 10
				; 91 65
	rrc	([abyt],y)	;a91 66 10
	sra	([abyt],y)	;a91 67 10
	sla	([abyt],y)	;a91 68 10
	rlc	([abyt],y)	;a91 69 10
	dec	([abyt],y)	;a91 6A 10
				; 91 6B
	inc	([abyt],y)	;a91 6C 10
	tnz	([abyt],y)	;a91 6D 10
	swap	([abyt],y)	;a91 6E 10
	clr	([abyt],y)	;a91 6F 10

agrp91_7:

	.page

agrp91_8:

agrp91_9:

agrp91_A:
	ldf	([awrd],y),a	;a91 A7 54 32
	ldf	a,([awrd],y)	;a91 AF 54 32

agrp91_B:

agrp91_C:
	cpw	y,[abyt]	;a91 C3 10
	ldw	y,[abyt]	;a91 CE 10
	ldw	[abyt],y	;a91 CF 10

agrp91_D:
	sub	a,([abyt],y)	;a91 D0 10
	cp	a,([abyt],y)	;a91 D1 10
	sbc	a,([abyt],y)	;a91 D2 10
	cpw	x,([abyt],y)	;a91 D3 10
	and	a,([abyt],y)	;a91 D4 10
	bcp	a,([abyt],y)	;a91 D5 10
	ld	a,([abyt],y)	;a91 D6 10
	ld	([abyt],y),a	;a91 D7 10
	xor	a,([abyt],y)	;a91 D8 10
	adc	a,([abyt],y)	;a91 D9 10
	or	a,([abyt],y)	;a91 DA 10
	add	a,([abyt],y)	;a91 DB 10
	jp	([abyt],y)	;a91 DC 10
	call	([abyt],y)	;a91 DD 10
	ldw 	y,([abyt],y)	;a91 DE 10
	ldw 	([abyt],y),x	;a91 DF 10

agrp91_E:

agrp91_F:

	.page
	.sbttl	Page 92 ST7 Instructions in Numerical Order (Absolute)

agrp92_0:

agrp92_1:

agrp92_2:

agrp92_3:
	neg	[abyt]		; 72 30 01 10
				; 92 31
				; 92 32
	cpl	[abyt]		; 72 33 01 10
	srl	[abyt]		; 72 34 01 10
				; 92 35
	rrc	[abyt]		; 72 36 01 10
	sra	[abyt]		; 72 37 01 10
	sla	[abyt]		; 72 38 01 10
	rlc	[abyt]		; 72 39 01 10
	dec	[abyt]		; 72 3A 01 10
				; 92 3B
	inc	[abyt]		; 72 3C 01 10
	tnz	[abyt]		; 72 3D 01 10
	swap	[abyt]		; 72 3E 01 10
	clr	[abyt]		; 72 3F 01 10

agrp92_4:

agrp92_5:

agrp92_6:
	neg	([abyt],x)	; 72 60 01 10
				; 92 61
				; 92 62
	cpl	([abyt],x)	; 72 63 01 10
	srl	([abyt],x)	; 72 64 01 10
				; 92 65
	rrc	([abyt],x)	; 72 66 01 10
	sra	([abyt],x)	; 72 67 01 10
	sla	([abyt],x)	; 72 68 01 10
	rlc	([abyt],x)	; 72 69 01 10
	dec	([abyt],x)	; 72 6A 01 10
				; 92 6B
	inc	([abyt],x)	; 72 6C 01 10
	tnz	([abyt],x)	; 72 6D 01 10
	swap	([abyt],x)	; 72 6E 01 10
	clr	([abyt],x)	; 72 6F 01 10

agrp92_7:

	.page

agrp92_8:
	callf	[awrd]		;a92 8D 54 32

agrp92_9:

agrp92_A:
	ldf	([awrd],x),a	;a92 A7 54 32
	jpf	[awrd]		;a92 AC 54 32
	ldf	a,([awrd],x)	;a92 AF 54 32

agrp92_B:
	ldf	a,[awrd]	;a92 BC 54 32
	ldf	[awrd],a	;a92 BD 54 32

agrp92_C:
	sub	a,[abyt]	; 72 C0 01 10
	cp	a,[abyt]	; 72 C1 01 10
	sbc	a,[abyt]	; 72 C2 01 10
	cpw	x,[abyt]	; 72 C3 01 10
	and	a,[abyt]	; 72 C4 01 10
	bcp	a,[abyt]	; 72 C5 01 10
	ld	a,[abyt]	; 72 C6 01 10
	ld	[abyt],a	; 72 C7 01 10
	xor	a,[abyt]	; 72 C8 01 10
	adc	a,[abyt]	; 72 C9 01 10
	or	a,[abyt]	; 72 CA 01 10
	add	a,[abyt]	; 72 CB 01 10
	jp	[abyt]		; 72 CC 01 10
	call	[abyt]		; 72 CD 01 10
	ldw 	x,[abyt]	; 72 CE 01 10
	ldw 	[abyt],x	; 72 CF 01 10

agrp92_D:
	sub	a,([abyt],x)	; 72 D0 01 10
	cp	a,([abyt],x)	; 72 D1 01 10
	sbc	a,([abyt],x)	; 72 D2 01 10
	cpw	y,([abyt],x)	; 72 D3 01 10
	and	a,([abyt],x)	; 72 D4 01 10
	bcp	a,([abyt],x)	; 72 D5 01 10
	ld	a,([abyt],x)	; 72 D6 01 10
	ld	([abyt],x),a	; 72 D7 01 10
	xor	a,([abyt],x)	; 72 D8 01 10
	adc	a,([abyt],x)	; 72 D9 01 10
	or	a,([abyt],x)	; 72 DA 01 10
	add	a,([abyt],x)	; 72 DB 01 10
	jp	([abyt],x)	; 72 DC 01 10
	call	([abyt],x)	; 72 DD 01 10
	ldw 	x,([abyt],x)	; 72 DE 01 10
	ldw 	([abyt],x),y	; 72 DF 01 10

agrp92_E:

agrp92_F:


	.page
	.sbttl	Base ST7 Instructions External 1-Byte Promotion to 2-Byte

	; Note: 1-Byte external references are promoted to
	;	2-Byte references if the  2-Byte addressing
	;	mode is allowed.
	;
	;	If the 1-Byte does not promote to the 2-Byte
	;	mode and the external reference is not within
	;	the range 0x00 - 0xFF the linker will report
	;	an error.
	;
	; The externally defined zbyt, zwrd, and zexa values
	; will result in linker errors for all references to
	; zbyt which cannot be promoted to 2-Byte modes.  All
	; zwrd references will result in linker errors.
	; Immediate references for zbyt and zwrd will simply
	; be truncated to 1-Byte or 2-Byte values respectively.
	; All references to zexa will simply use the lower 3-Byte
	; values.

	.define	rbyt, /zbyt+0x10/
	.define	rwrd, /zwrd+0x5432/
	.define	rexa, /zexa+0xBA9876/

xgrp0:
	neg	(rbyt,sp)	; 00u10
	rrwa	x,a		; 01
	rlwa	x,a		; 02
	cpl	(rbyt,sp)	; 03u10
	srl	(rbyt,sp)	; 04u10
				; 05
	rrc	(rbyt,sp)	; 06u10
	sra	(rbyt,sp)	; 07u10
	sla	(rbyt,sp)	; 08u10
	rlc	(rbyt,sp)	; 09u10
	dec	(rbyt,sp)	; 0Au10
				; 0B
	inc	(rbyt,sp)	; 0Cu10
	tnz	(rbyt,sp)	; 0Du10
	swap	(rbyt,sp)	; 0Eu10
	clr	(rbyt,sp)	; 0Fu10

xgrp1:
	sub	a,(rbyt,sp)	; 10u10
	cp	a,(rbyt,sp)	; 11u10
	sbc	a,(rbyt,sp)	; 12u10
	cpw	x,(rbyt,sp)	; 13u10
	and	a,(rbyt,sp)	; 14u10
	bcp	a,(rbyt,sp)	; 15u10
	ldw	y,(rbyt,sp)	; 16u10
	ldw	(rbyt,sp),y	; 17u10
	xor	a,(rbyt,sp)	; 18u10
	adc	a,(rbyt,sp)	; 19u10
	or	a,(rbyt,sp)	; 1Au10
	add	a,(rbyt,sp)	; 1Bu10
	addw	x,#rwrd		; 1Cs54r32
	subw	x,#rwrd		; 1Ds54r32
	ldw	x,(rbyt,sp)	; 1Eu10
	ldw	(rbyt,sp),x	; 1Fu10

	.page

xgrp2:
	jra	1$		; 20 0E
	jrf	1$		; 21 0C
	jrugt	1$		; 22 0A
	jrule	1$		; 23 08
	jrnc	1$		; 24 06
	jrc	1$		; 25 04
	jrne	1$		; 26 02
	jreq	1$		; 27 00
1$:	jrnv	1$		; 28 FE
	jrv	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrsgt	1$		; 2C F6
	jrsle	1$		; 2D F4
	jrsge	1$		; 2E F2
	jrslt	1$		; 2F F0

xgrp3:
	neg	rbyt		; 72 50v00u10
	exg	a,rwrd		; 31v54u32
	pop	rwrd		; 32v54u32
	cpl	rbyt		; 72 53v00u10
	srl	rbyt		; 72 54v00u10
	mov	rwrd,#rbyt	; 35r10v54u32
	rrc	rbyt		; 72 56v00u10
	sra	rbyt		; 72 57v00u10
	sla	rbyt		; 72 58v00u10
	rlc	rbyt		; 72 59v00u10
	dec	rbyt		; 72 5Av00u10
	push	rwrd		; 3Bv54u32
	inc	rbyt		; 72 5Cv00u10
	tnz	rbyt		; 72 5Dv00u10
	swap	rbyt		; 72 5Ev00u10
	clr	rbyt		; 72 5Fv00u10

	.page

xgrp4:
	neg	a		; 40
	exg	a,xl		; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
	mov	rbyt,rbyt+0x11	; 55v00u21v00u10
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
	push	#rbyt		; 4Br10
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

xgrp5:
	negw	x		; 50
	exgw	x,y		; 51
	sub	sp,#rbyt	; 52u10
	cplw	x		; 53
	srlw	x		; 54
	mov	rwrd,rwrd+0x1111; 55v65u43v54u32
	rrcw	x		; 56
	sraw	x		; 57
	slaw	x		; 58
	rlcw	x		; 59
	decw	x		; 5A
	add	sp,#rbyt	; 5Bu10
	incw	x		; 5C
	tnzw	x		; 5D
	swapw	x		; 5E
	clrw	x		; 5F

	.page

xgrp6:
	neg	(rbyt,x)	; 72 40v00u10
	exg	a,yl		; 61
	div	x,a		; 62
	cpl	(rbyt,x)	; 72 43v00u10
	srl	(rbyt,x)	; 72 44v00u10
	divw	x,y		; 65
	rrc	(rbyt,x)	; 72 46v00u10
	sra	(rbyt,x)	; 72 47v00u10
	sla	(rbyt,x)	; 72 48v00u10
	rlc	(rbyt,x)	; 72 49v00u10
	dec	(rbyt,x)	; 72 4Av00u10
	ld	(rbyt,sp),a	; 6Bu10
	inc	(rbyt,x)	; 72 4Cv00u10
	tnz	(rbyt,x)	; 72 4Dv00u10
	swap	(rbyt,x)	; 72 4Ev00u10
	clr	(rbyt,x)	; 72 4Fv00u10

xgrp7:
	neg	(x)		; 70
				; 71
				; 72
	cpl	(x)		; 73
	srl	(x)		; 74
				; 75
	rrc	(x)		; 76
	sra	(x)		; 77
	sla	(x)		; 78
	rlc	(x)		; 79
	dec	(x)		; 7A
	ld	a,(rbyt,sp)	; 7Bu10
	inc	(x)		; 7C
	tnz	(x)		; 7D
	swap	(x)		; 7E
	clr	(x)		; 7F

	.page

xgrp8:
	iret			; 80
	ret			; 81
				; 82
	trap			; 83
	pop	a		; 84
	popw	x		; 85
	pop	cc		; 86
	retf			; 87
	push	a		; 88
	pushw	x		; 89
	push	cc		; 8A
				; 8B
	ccf			; 8C
	callf	rexa		; 8DRBAs98r76
	halt			; 8E
	wfi			; 8F

xgrp9:
				; 90
				; 91
				; 92
	ldw	x,y		; 93
	ldw	sp,x		; 94
	ld	xh,a		; 95
	ldw	x,sp		; 96
	ld	xl,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rvf			; 9C
	nop			; 9D
	ld	a,xh		; 9E
	ld	a,xl		; 9F

	.page

xgrpA:
	sub	a,#rbyt		; A0r10
	cp	a,#rbyt		; A1r10
	sbc	a,#rbyt		; A2r10
	cpw	x,#rwrd		; A3s54r32
	and	a,#rbyt		; A4r10
	bcp	a,#rbyt		; A5r10
	ld	a,#rbyt		; A6r10
	ldf	(rexa,x),a	; A7RBAs98r76
	xor	a,#rbyt		; A8r10
	adc	a,#rbyt		; A9r10
	or	a,#rbyt		; AAr10
	add	a,#rbyt		; ABr10
	jpf	rexa		; ACRBAs98r76
1$:	callr	1$		; AD FE
	ldw	x,#rwrd		; AEs54r32
	ldf	a,(rexa,x)	; AFRBAs98r76

xgrpB:
	sub	a,rbyt		; C0v00u10
	cp	a,rbyt		; C1v00u10
	sbc	a,rbyt		; C2v00u10
	cpw	x,rbyt		; C3v00u10
	and	a,rbyt		; C4v00u10
	bcp	a,rbyt		; C5v00u10
	ld	a,rbyt		; C6v00u10
	ld	rbyt,a		; C7v00u10
	xor	a,rbyt		; C8v00u10
	adc	a,rbyt		; C9v00u10
	or	a,rbyt		; CAv00u10
	add	a,rbyt		; CBv00u10
	ldf	a,rexa		; BCRBAs98r76
	ldf	rexa,a		; BDRBAs98r76
	ldw	x,rbyt		; CEv00u10
	ldw	rbyt,x		; CFv00u10

	.page

xgrpC:
	sub	a,rwrd		; C0v54u32
	cp	a,rwrd		; C1v54u32
	sbc	a,rwrd		; C2v54u32
	cpw	x,rwrd		; C3v54u32
	and	a,rwrd		; C4v54u32
	bcp	a,rwrd		; C5v54u32
	ld	a,rwrd		; C6v54u32
	ld	rwrd,a		; C7v54u32
	xor	a,rwrd		; C8v54u32
	adc	a,rwrd		; C9v54u32
	or	a,rwrd		; CAv54u32
	add	a,rwrd		; CBv54u32
	jp	rwrd		; CCs54r32
	call	rwrd		; CDs54r32
	ldw	x,rwrd		; CEv54u32
	ldw	rwrd,x		; CFv54u32

xgrpD:
	sub	a,(rwrd,x)	; D0v54u32
	cp	a,(rwrd,x)	; D1v54u32
	sbc	a,(rwrd,x)	; D2v54u32
	cpw	y,(rwrd,x)	; D3v54u32
	and	a,(rwrd,x)	; D4v54u32
	bcp	a,(rwrd,x)	; D5v54u32
	ld	a,(rwrd,x)	; D6v54u32
	ld	(rwrd,x),a	; D7v54u32
	xor	a,(rwrd,x)	; D8v54u32
	adc	a,(rwrd,x)	; D9v54u32
	or	a,(rwrd,x)	; DAv54u32
	add	a,(rwrd,x)	; DBv54u32
	jp	(rwrd,x)	; DCv54u32
	call	(rwrd,x)	; DDv54u32
	ldw	x,(rwrd,x)	; DEv54u32
	ldw	(rwrd,x),y	; DFv54u32

	.page

xgrpE:
	sub	a,(rbyt,x)	; D0v00u10
	cp	a,(rbyt,x)	; D1v00u10
	sbc	a,(rbyt,x)	; D2v00u10
	cpw	y,(rbyt,x)	; D3v00u10
	and	a,(rbyt,x)	; D4v00u10
	bcp	a,(rbyt,x)	; D5v00u10
	ld	a,(rbyt,x)	; D6v00u10
	ld	(rbyt,x),a	; D7v00u10
	xor	a,(rbyt,x)	; D8v00u10
	adc	a,(rbyt,x)	; D9v00u10
	or	a,(rbyt,x)	; DAv00u10
	add	a,(rbyt,x)	; DBv00u10
	jp	(rbyt,x)	; DCv00u10
	call	(rbyt,x)	; DDv00u10
	ldw	x,(rbyt,x)	; DEv00u10
	ldw	(rbyt,x),y	; DFv00u10

xgrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cpw	y,(x)		; F3
	and	a,(x)		; F4
	bcp	a,(x)		; F5
	ld	a,(x)		; F6
	ld	(x),a		; F7
	xor	a,(x)		; F8
	adc	a,(x)		; F9
	or	a,(x)		; FA
	add	a,(x)		; FB
	jp	(x)		; FC
	call	(x)		; FD
	ldw	x,(x)		; FE
	ldw	(x),y		; FF


	.page
	.sbttl	Page 72 ST7 Instructions External 1-Byte Promotion to 2-Byte

xgrp72_0:
	btjt	rwrd,#0,1$	; 72 00v54u32 23
	btjf	rwrd,#0,1$	; 72 01v54u32 1E
	btjt	rwrd,#1,1$	; 72 02v54u32 19
	btjf	rwrd,#1,1$	; 72 03v54u32 14
	btjt	rwrd,#2,1$	; 72 04v54u32 0F
	btjf	rwrd,#2,1$	; 72 05v54u32 0A
	btjt	rwrd,#3,1$	; 72 06v54u32 05
	btjf	rwrd,#3,1$	; 72 07v54u32 00
1$:	btjt	rwrd,#4,1$	; 72 08v54u32 FB
	btjf	rwrd,#4,1$	; 72 09v54u32 F6
	btjt	rwrd,#5,1$	; 72 0Av54u32 F1
	btjf	rwrd,#5,1$	; 72 0Bv54u32 EC
	btjt	rwrd,#6,1$	; 72 0Cv54u32 E7
	btjf	rwrd,#6,1$	; 72 0Dv54u32 E2
	btjt	rwrd,#7,1$	; 72 0Ev54u32 DD
	btjf	rwrd,#7,1$	; 72 0Fv54u32 D8

xgrp72_1:
	bset	rwrd,#0		; 72 10v54u32
	bres	rwrd,#0		; 72 11v54u32
	bset	rwrd,#1		; 72 12v54u32
	bres	rwrd,#1		; 72 13v54u32
	bset	rwrd,#2		; 72 14v54u32
	bres	rwrd,#2		; 72 15v54u32
	bset	rwrd,#3		; 72 16v54u32
	bres	rwrd,#3		; 72 17v54u32
	bset	rwrd,#4		; 72 18v54u32
	bres	rwrd,#4		; 72 19v54u32
	bset	rwrd,#5		; 72 1Av54u32
	bres	rwrd,#5		; 72 1Bv54u32
	bset	rwrd,#6		; 72 1Cv54u32
	bres	rwrd,#6		; 72 1Dv54u32
	bset	rwrd,#7		; 72 1Ev54u32
	bres	rwrd,#7		; 72 1Fv54u32

xgrp72_2:

	.page

xgrp72_3:
	neg	[rwrd]		; 72 30v54u32
				; 72 31
				; 72 32
	cpl	[rwrd]		; 72 33v54u32
	srl	[rwrd]		; 72 34v54u32
				; 72 35
	rrc	[rwrd]		; 72 36v54u32
	sra	[rwrd]		; 72 37v54u32
	sla	[rwrd]		; 72 38v54u32
	rlc	[rwrd]		; 72 39v54u32
	dec	[rwrd]		; 72 3Av54u32
				; 72 3B
	inc	[rwrd]		; 72 3Cv54u32
	tnz	[rwrd]		; 72 3Dv54u32
	swap	[rwrd]		; 72 3Ev54u32
	clr	[rwrd]		; 72 3Fv54u32

xgrp72_4:
	neg	(rwrd,x)	; 72 40v54u32
				; 72 41
				; 72 42
	cpl	(rwrd,x)	; 72 43v54u32
	srl	(rwrd,x)	; 72 44v54u32
				; 72 45
	rrc	(rwrd,x)	; 72 46v54u32
	sra	(rwrd,x)	; 72 47v54u32
	sla	(rwrd,x)	; 72 48v54u32
	rlc	(rwrd,x)	; 72 49v54u32
	dec	(rwrd,x)	; 72 4Av54u32
				; 72 4B
	inc	(rwrd,x)	; 72 4Cv54u32
	tnz	(rwrd,x)	; 72 4Dv54u32
	swap	(rwrd,x)	; 72 4Ev54u32
	clr	(rwrd,x)	; 72 4Fv54u32

	.page

xgrp72_5:
	neg	rwrd		; 72 50v54u32
				; 72 51
				; 72 52
	cpl	rwrd		; 72 53v54u32
	srl	rwrd		; 72 54v54u32
				; 72 55
	rrc	rwrd		; 72 56v54u32
	sra	rwrd		; 72 57v54u32
	sla	rwrd		; 72 58v54u32
	rlc	rwrd		; 72 59v54u32
	dec	rwrd		; 72 5Av54u32
				; 72 5B
	inc	rwrd		; 72 5Cv54u32
	tnz	rwrd		; 72 5Dv54u32
	swap	rwrd		; 72 5Ev54u32
	clr	rwrd		; 72 5Fv54u32

xgrp72_6:
	neg	([rwrd],x)	; 72 60v54u32
				; 72 61
				; 72 62
	cpl	([rwrd],x)	; 72 63v54u32
	srl	([rwrd],x)	; 72 64v54u32
				; 72 65
	rrc	([rwrd],x)	; 72 66v54u32
	sra	([rwrd],x)	; 72 67v54u32
	sla	([rwrd],x)	; 72 68v54u32
	rlc	([rwrd],x)	; 72 69v54u32
	dec	([rwrd],x)	; 72 6Av54u32
				; 72 6B
	inc	([rwrd],x)	; 72 6Cv54u32
	tnz	([rwrd],x)	; 72 6Dv54u32
	swap	([rwrd],x)	; 72 6Ev54u32
	clr	([rwrd],x)	; 72 6Fv54u32

	.page

xgrp72_7:

xgrp72_8:
	wfe			; 72 8F

xgrp72_9:

xgrp72_A:
	subw	y,#rwrd		; 72 A2s54r32
	addw	y,#rwrd		; 72 A9s54r32

xgrp72_B:
	subw	x,rbyt		; 72 B0u10
	subw	y,rbyt		; 72 B2u10
	addw	y,rbyt		; 72 B9u10
	addw	x,rbyt		; 72 BBu10

	.page

xgrp72_C:
	sub	a,[rwrd]	; 72 C0v54u32
	cp	a,[rwrd]	; 72 C1v54u32
	sbc	a,[rwrd]	; 72 C2v54u32
	cpw	x,[rwrd]	; 72 C3v54u32
	and	a,[rwrd]	; 72 C4v54u32
	bcp	a,[rwrd]	; 72 C5v54u32
	ld	a,[rwrd]	; 72 C6v54u32
	ld	[rwrd],a	; 72 C7v54u32
	xor	a,[rwrd]	; 72 C8v54u32
	adc	a,[rwrd]	; 72 C9v54u32
	or	a,[rwrd]	; 72 CAv54u32
	add	a,[rwrd]	; 72 CBv54u32
	jp	[rwrd]		; 72 CCv54u32
	call	[rwrd]		; 72 CDv54u32
	ldw	x,[rwrd]	; 72 CEv54u32
	ldw	[rwrd],x	; 72 CFv54u32

xgrp72_D:
	sub	a,([rwrd],x)	; 72 D0v54u32
	cp	a,([rwrd],x)	; 72 D1v54u32
	sbc	a,([rwrd],x)	; 72 D2v54u32
	cpw	y,([rwrd],x)	; 72 D3v54u32
	and	a,([rwrd],x)	; 72 D4v54u32
	bcp	a,([rwrd],x)	; 72 D5v54u32
	ld	a,([rwrd],x)	; 72 D6v54u32
	ld	([rwrd],x),a	; 72 D7v54u32
	xor	a,([rwrd],x)	; 72 D8v54u32
	adc	a,([rwrd],x)	; 72 D9v54u32
	or	a,([rwrd],x)	; 72 DAv54u32
	add	a,([rwrd],x)	; 72 DBv54u32
	jp	([rwrd],x)	; 72 DCv54u32
	call	([rwrd],x)	; 72 DDv54u32
	ldw	x,([rwrd],x)	; 72 DEv54u32
	ldw	([rwrd],x),y	; 72 DFv54u32

xgrp72_E:

xgrp72_F:
	subw	x,(rbyt,sp)	; 72 F0u10
	subw	y,(rbyt,sp)	; 72 F2u10
	addw	y,(rbyt,sp)	; 72 F9u10
	addw	x,(rbyt,sp)	; 72 FBu10


	.page
	.sbttl	Page 90 ST7 Instructions External 1-Byte Promotion to 2-Byte

xgrp90_0:
	rrwa	y,a		; 90 01
	rlwa	y,a		; 90 02

xgrp90_1:
	bcpl	rwrd,#0		; 90 10v54u32
	bccm	rwrd,#0		; 90 11v54u32
	bcpl	rwrd,#1		; 90 12v54u32
	bccm	rwrd,#1		; 90 13v54u32
	bcpl	rwrd,#2		; 90 14v54u32
	bccm	rwrd,#2		; 90 15v54u32
	bcpl	rwrd,#3		; 90 16v54u32
	bccm	rwrd,#3		; 90 17v54u32
	bcpl	rwrd,#4		; 90 18v54u32
	bccm	rwrd,#4		; 90 19v54u32
	bcpl	rwrd,#5		; 90 1Av54u32
	bccm	rwrd,#5		; 90 1Bv54u32
	bcpl	rwrd,#6		; 90 1Cv54u32
	bccm	rwrd,#6		; 90 1Dv54u32
	bcpl	rwrd,#7		; 90 1Ev54u32
	bccm	rwrd,#7		; 90 1Fv54u32

xgrp90_2:
	jrnh	1$		; 90 28 0C
	jrh	1$		; 90 29 09
	jrnm	1$		; 90 2C 06
	jrm	1$		; 90 2D 03
	jril	1$		; 90 2E 00
1$:	jrih	1$		; 90 2F FD

xgrp90_3:

	.page

xgrp90_4:
	neg	(rwrd,y)	; 90 40v54u32
				; 90 41
	mul	y,a		; 90 42
	cpl	(rwrd,y)	; 90 43v54u32
	srl	(rwrd,y)	; 90 44v54u32
				; 90 45
	rrc	(rwrd,y)	; 90 46v54u32
	sra	(rwrd,y)	; 90 47v54u32
	sla	(rwrd,y)	; 90 48v54u32
	rlc	(rwrd,y)	; 90 49v54u32
	dec	(rwrd,y)	; 90 4Av54u32
				; 90 4B
	inc	(rwrd,y)	; 90 4Cv54u32
	tnz	(rwrd,y)	; 90 4Dv54u32
	swap	(rwrd,y)	; 90 4Ev54u32
	clr	(rwrd,y)	; 90 4Fv54u32

 xgrp90_5:
	negw	y		; 90 50
				; 90 51
				; 90 52
	cplw	y		; 90 53
	srlw	y		; 90 54
				; 90 55
	rrcw	y		; 90 56
	sraw	y		; 90 57
	slaw	y		; 90 58
	rlcw	y		; 90 59
	decw	y		; 90 5A
				; 90 5B
	incw	y		; 90 5C
	tnzw	y		; 90 5D
	swapw	y		; 90 5E
	clrw	y		; 90 5F

.page

xgrp90_6:
	neg	(rbyt,y)	; 90 40v00u10
				; 90 61
	div	y,a		; 90 62
	cpl	(rbyt,y)	; 90 43v00u10
	srl	(rbyt,y)	; 90 44v00u10
				; 90 65
	rrc	(rbyt,y)	; 90 46v00u10
	sra	(rbyt,y)	; 90 47v00u10
	sla	(rbyt,y)	; 90 48v00u10
	rlc	(rbyt,y)	; 90 49v00u10
	dec	(rbyt,y)	; 90 4Av00u10
				; 90 6B
	inc	(rbyt,y)	; 90 4Cv00u10
	tnz	(rbyt,y)	; 90 4Dv00u10
	swap	(rbyt,y)	; 90 4Ev00u10
	clr	(rbyt,y)	; 90 4Fv00u10

 xgrp90_7:
	neg	(y)		; 90 70
				; 90 71
				; 90 72
	cpl	(y)		; 90 73
	srl	(y)		; 90 74
				; 90 75
	rrc	(y)		; 90 76
	sra	(y)		; 90 77
	sla	(y)		; 90 78
	rlc	(y)		; 90 79
	dec	(y)		; 90 7A
				; 90 7B
	inc	(y)		; 90 7C
	tnz	(y)		; 90 7D
	swap	(y)		; 90 7E
	clr	(y)		; 90 7F

.page

xgrp90_8:
	popw	y		; 90 85
	pushw	y		; 90 89

xgrp90_9:
	ldw	y,x		; 90 93
	ldw	sp,y		; 90 94
	ld	yh,a		; 90 95
	ldw	y,sp		; 90 96
	ld	yl,a		; 90 97
	ld	a,yh		; 90 9E
	ld	a,yl		; 90 9F

xgrp90_A:
	cpw	y,#rwrd		; 90 A3s54r32
	ldf	(rexa,y),a	; 90 A7RBAs98r76
	ldw	y,#rwrd		; 90 AEs54r32
	ldf	a,(rexa,y)	; 90 AFRBAs98r76

xgrp90_B:
	cpw	y,rbyt		; 90 C3v00u10
	ldw	y,rbyt		; 90 CEv00u10
	ldw	rbyt,y		; 90 CFv00u10

xgrp90_C:
	cpw	y,rwrd		; 90 C3v54u32
	ldw	y,rwrd		; 90 CEv54u32
	ldw	rwrd,y		; 90 CFv54u32

xgrp90_D:
	sub	a,(rwrd,y)	; 90 D0v54u32
	cp	a,(rwrd,y)	; 90 D1v54u32
	sbc	a,(rwrd,y)	; 90 D2v54u32
	cpw	x,(rwrd,y)	; 90 D3v54u32
	and	a,(rwrd,y)	; 90 D4v54u32
	bcp	a,(rwrd,y)	; 90 D5v54u32
	ld	a,(rwrd,y)	; 90 D6v54u32
	ld	(rwrd,y),a	; 90 D7v54u32
	xor	a,(rwrd,y)	; 90 D8v54u32
	adc	a,(rwrd,y)	; 90 D9v54u32
	or	a,(rwrd,y)	; 90 DAv54u32
	add	a,(rwrd,y)	; 90 DBv54u32
	jp	(rwrd,y)	; 90 DCv54u32
	call	(rwrd,y)	; 90 DDv54u32
	ldw 	y,(rwrd,y)	; 90 DEv54u32
	ldw 	(rwrd,y),x	; 90 DFv54u32

	.page

xgrp90_E:
	sub	a,(rbyt,y)	; 90 D0v00u10
	cp	a,(rbyt,y)	; 90 D1v00u10
	sbc	a,(rbyt,y)	; 90 D2v00u10
	cpw	x,(rbyt,y)	; 90 D3v00u10
	and	a,(rbyt,y)	; 90 D4v00u10
	bcp	a,(rbyt,y)	; 90 D5v00u10
	ld	a,(rbyt,y)	; 90 D6v00u10
	ld	(rbyt,y),a	; 90 D7v00u10
	xor	a,(rbyt,y)	; 90 D8v00u10
	adc	a,(rbyt,y)	; 90 D9v00u10
	or	a,(rbyt,y)	; 90 DAv00u10
	add	a,(rbyt,y)	; 90 DBv00u10
	jp	(rbyt,y)	; 90 DCv00u10
	call	(rbyt,y)	; 90 DDv00u10
	ldw 	y,(rbyt,y)	; 90 DEv00u10
	ldw 	(rbyt,y),x	; 90 DFv00u10

xgrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cpw	x,(y)		; 90 F3
	and	a,(y)		; 90 F4
	bcp	a,(y)		; 90 F5
	ld	a,(y)		; 90 F6
	ld	(y),a		; 90 F7
	xor	a,(y)		; 90 F8
	adc	a,(y)		; 90 F9
	or	a,(y)		; 90 FA
	add	a,(y)		; 90 FB
	jp	(y)		; 90 FC
	call	(y)		; 90 FD
	ldw 	y,(y)		; 90 FE
	ldw 	(y),x		; 90 FF


	.page
	.sbttl	Page 91 ST7 Instructions External 1-Byte Promotion to 2-Byte

xgrp91_0:

xgrp91_1:

xgrp91_2:

xgrp91_3:

xgrp91_4:

xgrp91_5:

xgrp91_6:
	neg	([rbyt],y)	; 91 60u10
				; 91 61
				; 91 62
	cpl	([rbyt],y)	; 91 63u10
	srl	([rbyt],y)	; 91 64u10
				; 91 65
	rrc	([rbyt],y)	; 91 66u10
	sra	([rbyt],y)	; 91 67u10
	sla	([rbyt],y)	; 91 68u10
	rlc	([rbyt],y)	; 91 69u10
	dec	([rbyt],y)	; 91 6Au10
				; 91 6B
	inc	([rbyt],y)	; 91 6Cu10
	tnz	([rbyt],y)	; 91 6Du10
	swap	([rbyt],y)	; 91 6Eu10
	clr	([rbyt],y)	; 91 6Fu10

xgrp91_7:

	.page

xgrp91_8:

xgrp91_9:

xgrp91_A:
	ldf	([rwrd],y),a	; 91 A7v54u32
	ldf	a,([rwrd],y)	; 91 AFv54u32

xgrp91_B:

xgrp91_C:
	cpw	y,[rbyt]	; 91 C3u10
	ldw	y,[rbyt]	; 91 CEu10
	ldw	[rbyt],y	; 91 CFu10

xgrp91_D:
	sub	a,([rbyt],y)	; 91 D0u10
	cp	a,([rbyt],y)	; 91 D1u10
	sbc	a,([rbyt],y)	; 91 D2u10
	cpw	x,([rbyt],y)	; 91 D3u10
	and	a,([rbyt],y)	; 91 D4u10
	bcp	a,([rbyt],y)	; 91 D5u10
	ld	a,([rbyt],y)	; 91 D6u10
	ld	([rbyt],y),a	; 91 D7u10
	xor	a,([rbyt],y)	; 91 D8u10
	adc	a,([rbyt],y)	; 91 D9u10
	or	a,([rbyt],y)	; 91 DAu10
	add	a,([rbyt],y)	; 91 DBu10
	jp	([rbyt],y)	; 91 DCu10
	call	([rbyt],y)	; 91 DDu10
	ldw 	y,([rbyt],y)	; 91 DEu10
	ldw 	([rbyt],y),x	; 91 DFu10

xgrp91_E:

xgrp91_F:

	.page
	.sbttl	Page 92 ST7 Instructions External 1-Byte Promotion to 2-Byte

xgrp92_0:

xgrp92_1:

xgrp92_2:

xgrp92_3:
	neg	[rbyt]		; 72 30v00u10
				; 92 31
				; 92 32
	cpl	[rbyt]		; 72 33v00u10
	srl	[rbyt]		; 72 34v00u10
				; 92 35
	rrc	[rbyt]		; 72 36v00u10
	sra	[rbyt]		; 72 37v00u10
	sla	[rbyt]		; 72 38v00u10
	rlc	[rbyt]		; 72 39v00u10
	dec	[rbyt]		; 72 3Av00u10
				; 92 3B
	inc	[rbyt]		; 72 3Cv00u10
	tnz	[rbyt]		; 72 3Dv00u10
	swap	[rbyt]		; 72 3Ev00u10
	clr	[rbyt]		; 72 3Fv00u10

xgrp92_4:

xgrp92_5:

xgrp92_6:
	neg	([rbyt],x)	; 72 60v00u10
				; 92 61
				; 92 62
	cpl	([rbyt],x)	; 72 63v00u10
	srl	([rbyt],x)	; 72 64v00u10
				; 92 65
	rrc	([rbyt],x)	; 72 66v00u10
	sra	([rbyt],x)	; 72 67v00u10
	sla	([rbyt],x)	; 72 68v00u10
	rlc	([rbyt],x)	; 72 69v00u10
	dec	([rbyt],x)	; 72 6Av00u10
				; 92 6B
	inc	([rbyt],x)	; 72 6Cv00u10
	tnz	([rbyt],x)	; 72 6Dv00u10
	swap	([rbyt],x)	; 72 6Ev00u10
	clr	([rbyt],x)	; 72 6Fv00u10

xgrp92_7:

	.page

xgrp92_8:
	callf	[rwrd]		; 92 8Dv54u32

xgrp92_9:

xgrp92_A:
	ldf	([rwrd],x),a	; 92 A7v54u32
	jpf	[rwrd]		; 92 ACv54u32
	ldf	a,([rwrd],x)	; 92 AFv54u32

xgrp92_B:
	ldf	a,[rwrd]	; 92 BCv54u32
	ldf	[rwrd],a	; 92 BDv54u32

xgrp92_C:
	sub	a,[rbyt]	; 72 C0v00u10
	cp	a,[rbyt]	; 72 C1v00u10
	sbc	a,[rbyt]	; 72 C2v00u10
	cpw	x,[rbyt]	; 72 C3v00u10
	and	a,[rbyt]	; 72 C4v00u10
	bcp	a,[rbyt]	; 72 C5v00u10
	ld	a,[rbyt]	; 72 C6v00u10
	ld	[rbyt],a	; 72 C7v00u10
	xor	a,[rbyt]	; 72 C8v00u10
	adc	a,[rbyt]	; 72 C9v00u10
	or	a,[rbyt]	; 72 CAv00u10
	add	a,[rbyt]	; 72 CBv00u10
	jp	[rbyt]		; 72 CCv00u10
	call	[rbyt]		; 72 CDv00u10
	ldw 	x,[rbyt]	; 72 CEv00u10
	ldw 	[rbyt],x	; 72 CFv00u10

xgrp92_D:
	sub	a,([rbyt],x)	; 72 D0v00u10
	cp	a,([rbyt],x)	; 72 D1v00u10
	sbc	a,([rbyt],x)	; 72 D2v00u10
	cpw	y,([rbyt],x)	; 72 D3v00u10
	and	a,([rbyt],x)	; 72 D4v00u10
	bcp	a,([rbyt],x)	; 72 D5v00u10
	ld	a,([rbyt],x)	; 72 D6v00u10
	ld	([rbyt],x),a	; 72 D7v00u10
	xor	a,([rbyt],x)	; 72 D8v00u10
	adc	a,([rbyt],x)	; 72 D9v00u10
	or	a,([rbyt],x)	; 72 DAv00u10
	add	a,([rbyt],x)	; 72 DBv00u10
	jp	([rbyt],x)	; 72 DCv00u10
	call	([rbyt],x)	; 72 DDv00u10
	ldw 	x,([rbyt],x)	; 72 DEv00u10
	ldw 	([rbyt],x),y	; 72 DFv00u10

xgrp92_E:

xgrp92_F:

	.undefine	zbyt
	.undefine	zwrd
	.undefine	zexa

	.end

