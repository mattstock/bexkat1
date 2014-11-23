	.title	st7  Sequential Test

	.area	Prog(rel,con)


	abyt	=	0x0010		; Absolute 1-Byte Value
	awrd	=	0x5432		; Absolute 2-Byte Value

	rbyt	=	. + 0x0010	; Relocatable 1-Byte Value
	rwrd	=	. + 0x5432	; Relocatable 2-Byte Value


	.page
	.sbttl	Base ST7 Instructions in Numerical Order (Absolute)

agrp0:
	btjt	abyt,#0,1$	; 00 10 15
	btjf	abyt,#0,1$	; 01 10 12
	btjt	abyt,#1,1$	; 02 10 0F
	btjf	abyt,#1,1$	; 03 10 0C
	btjt	abyt,#2,1$	; 04 10 09
	btjf	abyt,#2,1$	; 05 10 06
	btjt	abyt,#3,1$	; 06 10 03
	btjf	abyt,#3,1$	; 07 10 00
1$:	btjt	abyt,#4,1$	; 08 10 FD
	btjf	abyt,#4,1$	; 09 10 FA
	btjt	abyt,#5,1$	; 0A 10 F7
	btjf	abyt,#5,1$	; 0B 10 F4
	btjt	abyt,#6,1$	; 0C 10 F1
	btjf	abyt,#6,1$	; 0D 10 EE
	btjt	abyt,#7,1$	; 0E 10 EB
	btjf	abyt,#7,1$	; 0F 10 E8

agrp1:
	bset	abyt,#0		; 10 10
	bres	abyt,#0		; 11 10
	bset	abyt,#1		; 12 10
	bres	abyt,#1		; 13 10
	bset	abyt,#2		; 14 10
	bres	abyt,#2		; 15 10
	bset	abyt,#3		; 16 10
	bres	abyt,#3		; 17 10
	bset	abyt,#4		; 18 10
	bres	abyt,#4		; 19 10
	bset	abyt,#5		; 1A 10
	bres	abyt,#5		; 1B 10
	bset	abyt,#6		; 1C 10
	bres	abyt,#6		; 1D 10
	bset	abyt,#7		; 1E 10
	bres	abyt,#7		; 1F 10

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
1$:	jrnh	1$		; 28 FE
	jrh	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrnm	1$		; 2C F6
	jrm	1$		; 2D F4
	jril	1$		; 2E F2
	jrih	1$		; 2F F0

agrp3:
	neg	abyt		; 30 10
				; 31
				; 32
	cpl	abyt		; 33 10
	srl	abyt		; 34 10
				; 35
	rrc	abyt		; 36 10
	sra	abyt		; 37 10
	sla	abyt		; 38 10
	rlc	abyt		; 39 10
	dec	abyt		; 3A 10
				; 3B
	inc	abyt		; 3C 10
	tnz	abyt		; 3D 10
	swap	abyt		; 3E 10
	clr	abyt		; 3F 10

	.page

agrp4:
	neg	a		; 40
				; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
				; 45
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
				; 4B
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

agrp5:
	neg	x		; 50
				; 51
				; 52
	cpl	x		; 53
	srl	x		; 54
				; 55
	rrc	x		; 56
	sra	x		; 57
	sla	x		; 58
	rlc	x		; 59
	dec	x		; 5A
				; 5B
	inc	x		; 5C
	tnz	x		; 5D
	swap	x		; 5E
	clr	x		; 5F

	.page

agrp6:
	neg	(abyt,x)	; 60 10
				; 61
				; 62
	cpl	(abyt,x)	; 63 10
	srl	(abyt,x)	; 64 10
				; 65
	rrc	(abyt,x)	; 66 10
	sra	(abyt,x)	; 67 10
	sla	(abyt,x)	; 68 10
	rlc	(abyt,x)	; 69 10
	dec	(abyt,x)	; 6A 10
				; 6B
	inc	(abyt,x)	; 6C 10
	tnz	(abyt,x)	; 6D 10
	swap	(abyt,x)	; 6E 10
	clr	(abyt,x)	; 6F 10

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
				; 7B
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
	pop	x		; 85
	pop	cc		; 86
				; 87
	push	a		; 88
	push	x		; 89
	push	cc		; 8A
				; 8B
				; 8C
				; 8D
	halt			; 8E
	wfi			; 8F

agrp9:
				; 90
				; 91
				; 92
	ld	x,y		; 93
	ld	s,x		; 94
	ld	s,a		; 95
	ld	x,s		; 96
	ld	x,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rsp			; 9C
	nop			; 9D
	ld	a,s		; 9E
	ld	a,x		; 9F

	.page

agrpA:
	sub	a,#abyt		; A0 10
	cp	a,#abyt		; A1 10
	sbc	a,#abyt		; A2 10
	cp	x,#abyt		; A3 10
	and	a,#abyt		; A4 10
	bcp	a,#abyt		; A5 10
	ld	a,#abyt		; A6 10
				; A7
	xor	a,#abyt		; A8 10
	adc	a,#abyt		; A9 10
	or	a,#abyt		; AA 10
	add	a,#abyt		; AB 10
				; AC
1$:	callr	1$		; AD FE
	ld	x,#abyt		; AE 10
				; AF BA

agrpB:
	sub	a,abyt		; B0 10
	cp	a,abyt		; B1 10
	sbc	a,abyt		; B2 10
	cp	x,abyt		; B3 10
	and	a,abyt		; B4 10
	bcp	a,abyt		; B5 10
	ld	a,abyt		; B6 10
	ld	abyt,a		; B7 10
	xor	a,abyt		; B8 10
	adc	a,abyt		; B9 10
	or	a,abyt		; BA 10
	add	a,abyt		; BB 10
	jp	*abyt		; BC 10
	call	*abyt		; BD 10
	ld	x,abyt		; BE 10
	ld	abyt,x		; BF 10

	.page

agrpC:
	sub	a,awrd		; C0 54 32
	cp	a,awrd		; C1 54 32
	sbc	a,awrd		; C2 54 32
	cp	x,awrd		; C3 54 32
	and	a,awrd		; C4 54 32
	bcp	a,awrd		; C5 54 32
	ld	a,awrd		; C6 54 32
	ld	awrd,a		; C7 54 32
	xor	a,awrd		; C8 54 32
	adc	a,awrd		; C9 54 32
	or	a,awrd		; CA 54 32
	add	a,awrd		; CB 54 32
	jp	awrd		; CC 54 32
	call	awrd		; CD 54 32
	ld	x,awrd		; CE 54 32
	ld	awrd,x		; CF 54 32

agrpD:
	sub	a,(awrd,x)	; D0 54 32
	cp	a,(awrd,x)	; D1 54 32
	sbc	a,(awrd,x)	; D2 54 32
	cp	x,(awrd,x)	; D3 54 32
	and	a,(awrd,x)	; D4 54 32
	bcp	a,(awrd,x)	; D5 54 32
	ld	a,(awrd,x)	; D6 54 32
	ld	(awrd,x),a	; D7 54 32
	xor	a,(awrd,x)	; D8 54 32
	adc	a,(awrd,x)	; D9 54 32
	or	a,(awrd,x)	; DA 54 32
	add	a,(awrd,x)	; DB 54 32
	jp	(awrd,x)	; DC 54 32
	call	(awrd,x)	; DD 54 32
	ld	x,(awrd,x)	; DE 54 32
	ld	(awrd,x),x	; DF 54 32

	.page

agrpE:
	sub	a,(abyt,x)	; E0 10
	cp	a,(abyt,x)	; E1 10
	sbc	a,(abyt,x)	; E2 10
	cp	x,(abyt,x)	; E3 10
	and	a,(abyt,x)	; E4 10
	bcp	a,(abyt,x)	; E5 10
	ld	a,(abyt,x)	; E6 10
	ld	(abyt,x),a	; E7 10
	xor	a,(abyt,x)	; E8 10
	adc	a,(abyt,x)	; E9 10
	or	a,(abyt,x)	; EA 10
	add	a,(abyt,x)	; EB 10
	jp	(abyt,x)	; EC 10
	call	(abyt,x)	; ED 10
	ld	x,(abyt,x)	; EE 10
	ld	(abyt,x),x	; EF 10

agrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cp	x,(x)		; F3
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
	ld	x,(x)		; FE
	ld	(x),x		; FF


	.page
	.sbttl	Page 90 ST7 Instructions in Numerical Order (Absolute)

agrp90_0:

agrp90_1:

agrp90_2:

agrp90_3:

agrp90_4:
	mul	y,a		; 90 42

 agrp90_5:
	neg	y		; 90 50
				; 90 51
				; 90 52
	cpl	y		; 90 53
	srl	y		; 90 54
				; 90 55
	rrc	y		; 90 56
	sra	y		; 90 57
	sla	y		; 90 58
	rlc	y		; 90 59
	dec	y		; 90 5A
				; 90 5B
	inc	y		; 90 5C
	tnz	y		; 90 5D
	swap	y		; 90 5E
	clr	y		; 90 5F

.page

agrp90_6:
	neg	(abyt,y)	; 90 60 10
				; 90 61
				; 90 62
	cpl	(abyt,y)	; 90 63 10
	srl	(abyt,y)	; 90 64 10
				; 90 65
	rrc	(abyt,y)	; 90 66 10
	sra	(abyt,y)	; 90 67 10
	sla	(abyt,y)	; 90 68 10
	rlc	(abyt,y)	; 90 69 10
	dec	(abyt,y)	; 90 6A 10
				; 90 6B
	inc	(abyt,y)	; 90 6C 10
	tnz	(abyt,y)	; 90 6D 10
	swap	(abyt,y)	; 90 6E 10
	clr	(abyt,y)	; 90 6F 10

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
	pop	y		; 90 85
	push	y		; 90 89

agrp90_9:
	ld	y,x		; 90 93
	ld	s,y		; 90 94
	ld	y,s		; 90 96
	ld	y,a		; 90 97
	ld	a,y		; 90 9F

agrp90_A:
	cp	y,#abyt		; 90 A3 10
	ld	y,#abyt		; 90 AE 10

agrp90_B:
	cp	y,abyt		; 90 B3 10
	ld	y,abyt		; 90 BE 10
	ld	abyt,y		; 90 BF 10

agrp90_C:
	cp	y,awrd		; 90 C3 54 32
	ld	y,awrd		; 90 CE 54 32
	ld	awrd,y		; 90 CF 54 32

agrp90_D:
	sub	a,(awrd,y)	; 90 D0 54 32
	cp	a,(awrd,y)	; 90 D1 54 32
	sbc	a,(awrd,y)	; 90 D2 54 32
	cp	y,(awrd,y)	; 90 D3 54 32
	and	a,(awrd,y)	; 90 D4 54 32
	bcp	a,(awrd,y)	; 90 D5 54 32
	ld	a,(awrd,y)	; 90 D6 54 32
	ld	(awrd,y),a	; 90 D7 54 32
	xor	a,(awrd,y)	; 90 D8 54 32
	adc	a,(awrd,y)	; 90 D9 54 32
	or	a,(awrd,y)	; 90 DA 54 32
	add	a,(awrd,y)	; 90 DB 54 32
	jp	(awrd,y)	; 90 DC 54 32
	call	(awrd,y)	; 90 DD 54 32
	ld 	y,(awrd,y)	; 90 DE 54 32
	ld 	(awrd,y),y	; 90 DF 54 32

	.page

agrp90_E:
	sub	a,(abyt,y)	; 90 E0 10
	cp	a,(abyt,y)	; 90 E1 10
	sbc	a,(abyt,y)	; 90 E2 10
	cp	y,(abyt,y)	; 90 E3 10
	and	a,(abyt,y)	; 90 E4 10
	bcp	a,(abyt,y)	; 90 E5 10
	ld	a,(abyt,y)	; 90 E6 10
	ld	(abyt,y),a	; 90 E7 10
	xor	a,(abyt,y)	; 90 E8 10
	adc	a,(abyt,y)	; 90 E9 10
	or	a,(abyt,y)	; 90 EA 10
	add	a,(abyt,y)	; 90 EB 10
	jp	(abyt,y)	; 90 EC 10
	call	(abyt,y)	; 90 ED 10
	ld 	y,(abyt,y)	; 90 EE 10
	ld 	(abyt,y),y	; 90 EF 10

agrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cp	y,(y)		; 90 F3
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
	ld 	y,(y)		; 90 FE
	ld 	(y),y		; 90 FF


	.page
	.sbttl	Page 91 ST7 Instructions in Numerical Order (Absolute)

agrp91_0:

agrp91_1:

agrp91_2:

agrp91_3:

agrp91_4:

agrp91_5:

agrp91_6:
	neg	([abyt],y)	; 91 60 10
				; 91 61
				; 91 62
	cpl	([abyt],y)	; 91 63 10
	srl	([abyt],y)	; 91 64 10
				; 91 65
	rrc	([abyt],y)	; 91 66 10
	sra	([abyt],y)	; 91 67 10
	sla	([abyt],y)	; 91 68 10
	rlc	([abyt],y)	; 91 69 10
	dec	([abyt],y)	; 91 6A 10
				; 91 6B
	inc	([abyt],y)	; 91 6C 10
	tnz	([abyt],y)	; 91 6D 10
	swap	([abyt],y)	; 91 6E 10
	clr	([abyt],y)	; 91 6F 10

agrp91_7:

	.page

agrp91_8:

agrp91_9:

agrp91_A:

agrp91_B:
	cp	y,[abyt]	; 91 B3 10
	ld	y,[abyt]	; 91 BE 10
	ld	[abyt],y	; 91 BF 10

agrp91_C:
	cp	y,[abyt].w	; 91 C3 10
	ld	y,[abyt].w	; 91 CE 10
	ld	[abyt].w,y	; 91 CF 10

agrp91_D:
	sub	a,([abyt].w,y)	; 91 D0 10
	cp	a,([abyt].w,y)	; 91 D1 10
	sbc	a,([abyt].w,y)	; 91 D2 10
	cp	y,([abyt].w,y)	; 91 D3 10
	and	a,([abyt].w,y)	; 91 D4 10
	bcp	a,([abyt].w,y)	; 91 D5 10
	ld	a,([abyt].w,y)	; 91 D6 10
	ld	([abyt].w,y),a	; 91 D7 10
	xor	a,([abyt].w,y)	; 91 D8 10
	adc	a,([abyt].w,y)	; 91 D9 10
	or	a,([abyt].w,y)	; 91 DA 10
	add	a,([abyt].w,y)	; 91 DB 10
	jp	([abyt].w,y)	; 91 DC 10
	call	([abyt].w,y)	; 91 DD 10
	ld 	y,([abyt].w,y)	; 91 DE 10
	ld	([abyt].w,y),y	; 91 DF 10

agrp91_E:
	sub	a,([abyt],y)	; 91 E0 10
	cp	a,([abyt],y)	; 91 E1 10
	sbc	a,([abyt],y)	; 91 E2 10
	cp	y,([abyt],y)	; 91 E3 10
	and	a,([abyt],y)	; 91 E4 10
	bcp	a,([abyt],y)	; 91 E5 10
	ld	a,([abyt],y)	; 91 E6 10
	ld	([abyt],y),a	; 91 E7 10
	xor	a,([abyt],y)	; 91 E8 10
	adc	a,([abyt],y)	; 91 E9 10
	or	a,([abyt],y)	; 91 EA 10
	add	a,([abyt],y)	; 91 EB 10
	jp	([abyt],y)	; 91 EC 10
	call	([abyt],y)	; 91 ED 10
	ld 	y,([abyt],y)	; 91 EE 10
	ld 	([abyt],y),y	; 91 EF 10

agrp91_F:


	.page
	.sbttl	Page 92 ST7 Instructions in Numerical Order (Absolute)

agrp92_0:
	btjt	[abyt],#0,1$	; 92 00 10 1C
	btjf	[abyt],#0,1$	; 92 01 10 18
	btjt	[abyt],#1,1$	; 92 02 10 14
	btjf	[abyt],#1,1$	; 92 03 10 10
	btjt	[abyt],#2,1$	; 92 04 10 0C
	btjf	[abyt],#2,1$	; 92 05 10 08
	btjt	[abyt],#3,1$	; 92 06 10 04
	btjf	[abyt],#3,1$	; 92 07 10 00
1$:	btjt	[abyt],#4,1$	; 92 08 10 FC
	btjf	[abyt],#4,1$	; 92 09 10 F8
	btjt	[abyt],#5,1$	; 92 0A 10 F4
	btjf	[abyt],#5,1$	; 92 0B 10 F0
	btjt	[abyt],#6,1$	; 92 0C 10 EC
	btjf	[abyt],#6,1$	; 92 0D 10 E8
	btjt	[abyt],#7,1$	; 92 0E 10 E4
	btjf	[abyt],#7,1$	; 92 0F 10 E0

agrp92_1:
	bset	[abyt],#0	; 92 10 10
	bres	[abyt],#0	; 92 11 10
	bset	[abyt],#1	; 92 12 10
	bres	[abyt],#1	; 92 13 10
	bset	[abyt],#2	; 92 14 10
	bres	[abyt],#2	; 92 15 10
	bset	[abyt],#3	; 92 16 10
	bres	[abyt],#3	; 92 17 10
	bset	[abyt],#4	; 92 18 10
	bres	[abyt],#4	; 92 19 10
	bset	[abyt],#5	; 92 1A 10
	bres	[abyt],#5	; 92 1B 10
	bset	[abyt],#6	; 92 1C 10
	bres	[abyt],#6	; 92 1D 10
	bset	[abyt],#7	; 92 1E 10
	bres	[abyt],#7	; 92 1F 10

	.page

agrp92_2:
	jra	[abyt]		; 92 20 10
	jrf	[abyt]		; 92 21 10
	jrugt	[abyt]		; 92 22 10
	jrule	[abyt]		; 92 23 10
	jrnc	[abyt]		; 92 24 10
	jrc	[abyt]		; 92 25 10
	jrne	[abyt]		; 92 26 10
	jreq	[abyt]		; 92 27 10
	jrnh	[abyt]		; 92 28 10
	jrh	[abyt]		; 92 29 10
	jrpl	[abyt]		; 92 2A 10
	jrmi	[abyt]		; 92 2B 10
	jrnm	[abyt]		; 92 2C 10
	jrm	[abyt]		; 92 2D 10
	jril	[abyt]		; 92 2E 10
	jrih	[abyt]		; 92 2F 10

agrp92_3:
	neg	[abyt]		; 92 30 10
				; 92 31
				; 92 32
	cpl	[abyt]		; 92 33 10
	srl	[abyt]		; 92 34 10
				; 92 35
	rrc	[abyt]		; 92 36 10
	sra	[abyt]		; 92 37 10
	sla	[abyt]		; 92 38 10
	rlc	[abyt]		; 92 39 10
	dec	[abyt]		; 92 3A 10
				; 92 3B
	inc	[abyt]		; 92 3C 10
	tnz	[abyt]		; 92 3D 10
	swap	[abyt]		; 92 3E 10
	clr	[abyt]		; 92 3F 10

	.page

agrp92_4:

agrp92_5:

agrp92_6:
	neg	([abyt],x)	; 92 60 10
				; 92 61
				; 92 62
	cpl	([abyt],x)	; 92 63 10
	srl	([abyt],x)	; 92 64 10
				; 92 65
	rrc	([abyt],x)	; 92 66 10
	sra	([abyt],x)	; 92 67 10
	sla	([abyt],x)	; 92 68 10
	rlc	([abyt],x)	; 92 69 10
	dec	([abyt],x)	; 92 6A 10
				; 92 6B
	inc	([abyt],x)	; 92 6C 10
	tnz	([abyt],x)	; 92 6D 10
	swap	([abyt],x)	; 92 6E 10
	clr	([abyt],x)	; 92 6F 10

agrp92_7:

agrp92_8:

agrp92_9:

agrp92_A:

	.page

agrp92_B:
	sub	a,[abyt]	; 92 B0 10
	cp	a,[abyt]	; 92 B1 10
	sbc	a,[abyt]	; 92 B2 10
	cp	x,[abyt]	; 92 B3 10
	and	a,[abyt]	; 92 B4 10
	bcp	a,[abyt]	; 92 B5 10
	ld	a,[abyt]	; 92 B6 10
	ld	[abyt],a	; 92 B7 10
	xor	a,[abyt]	; 92 B8 10
	adc	a,[abyt]	; 92 B9 10
	or	a,[abyt]	; 92 BA 10
	add	a,[abyt]	; 92 BB 10
	jp	[abyt]		; 92 BC 10
	call	[abyt]		; 92 BD 10
	ld 	x,[abyt]	; 92 BE 10
	ld 	[abyt],x	; 92 BF 10

agrp92_C:
	sub	a,[abyt].w	; 92 C0 10
	cp	a,[abyt].w	; 92 C1 10
	sbc	a,[abyt].w	; 92 C2 10
	cp	x,[abyt].w	; 92 C3 10
	and	a,[abyt].w	; 92 C4 10
	bcp	a,[abyt].w	; 92 C5 10
	ld	a,[abyt].w	; 92 C6 10
	ld	[abyt].w,a	; 92 C7 10
	xor	a,[abyt].w	; 92 C8 10
	adc	a,[abyt].w	; 92 C9 10
	or	a,[abyt].w	; 92 CA 10
	add	a,[abyt].w	; 92 CB 10
	jp	[abyt].w	; 92 CC 10
	call	[abyt].w	; 92 CD 10
	ld 	x,[abyt].w	; 92 CE 10
	ld 	[abyt].w,x	; 92 CF 10

	.page

agrp92_D:
	sub	a,([abyt].w,x)	; 92 D0 10
	cp	a,([abyt].w,x)	; 92 D1 10
	sbc	a,([abyt].w,x)	; 92 D2 10
	cp	x,([abyt].w,x)	; 92 D3 10
	and	a,([abyt].w,x)	; 92 D4 10
	bcp	a,([abyt].w,x)	; 92 D5 10
	ld	a,([abyt].w,x)	; 92 D6 10
	ld	([abyt].w,x),a	; 92 D7 10
	xor	a,([abyt].w,x)	; 92 D8 10
	adc	a,([abyt].w,x)	; 92 D9 10
	or	a,([abyt].w,x)	; 92 DA 10
	add	a,([abyt].w,x)	; 92 DB 10
	jp	([abyt].w,x)	; 92 DC 10
	call	([abyt].w,x)	; 92 DD 10
	ld 	x,([abyt].w,x)	; 92 DE 10
	ld 	([abyt].w,x),x	; 92 DF 10

agrp92_E:
	sub	a,([abyt],x)	; 92 E0 10
	cp	a,([abyt],x)	; 92 E1 10
	sbc	a,([abyt],x)	; 92 E2 10
	cp	x,([abyt],x)	; 92 E3 10
	and	a,([abyt],x)	; 92 E4 10
	bcp	a,([abyt],x)	; 92 E5 10
	ld	a,([abyt],x)	; 92 E6 10
	ld	([abyt],x),a	; 92 E7 10
	xor	a,([abyt],x)	; 92 E8 10
	adc	a,([abyt],x)	; 92 E9 10
	or	a,([abyt],x)	; 92 EA 10
	add	a,([abyt],x)	; 92 EB 10
	jp	([abyt],x)	; 92 EC 10
	call	([abyt],x)	; 92 ED 10
	ld 	x,([abyt],x)	; 92 EE 10
	ld 	([abyt],x),x	; 92 EF 10

agrp92_F:


	.page
	.sbttl	Base ST7 Instructions in Numerical Order (Relocatable)

rgrp0:
	btjt	*rbyt,#0,1$	; 00u10 15
	btjf	*rbyt,#0,1$	; 01u10 12
	btjt	*rbyt,#1,1$	; 02u10 0F
	btjf	*rbyt,#1,1$	; 03u10 0C
	btjt	*rbyt,#2,1$	; 04u10 09
	btjf	*rbyt,#2,1$	; 05u10 06
	btjt	*rbyt,#3,1$	; 06u10 03
	btjf	*rbyt,#3,1$	; 07u10 00
1$:	btjt	*rbyt,#4,1$	; 08u10 FD
	btjf	*rbyt,#4,1$	; 09u10 FA
	btjt	*rbyt,#5,1$	; 0Au10 F7
	btjf	*rbyt,#5,1$	; 0Bu10 F4
	btjt	*rbyt,#6,1$	; 0Cu10 F1
	btjf	*rbyt,#6,1$	; 0Du10 EE
	btjt	*rbyt,#7,1$	; 0Eu10 EB
	btjf	*rbyt,#7,1$	; 0Fu10 E8

rgrp1:
	bset	*rbyt,#0	; 10u10
	bres	*rbyt,#0	; 11u10
	bset	*rbyt,#1	; 12u10
	bres	*rbyt,#1	; 13u10
	bset	*rbyt,#2	; 14u10
	bres	*rbyt,#2	; 15u10
	bset	*rbyt,#3	; 16u10
	bres	*rbyt,#3	; 17u10
	bset	*rbyt,#4	; 18u10
	bres	*rbyt,#4	; 19u10
	bset	*rbyt,#5	; 1Au10
	bres	*rbyt,#5	; 1Bu10
	bset	*rbyt,#6	; 1Cu10
	bres	*rbyt,#6	; 1Du10
	bset	*rbyt,#7	; 1Eu10
	bres	*rbyt,#7	; 1Fu10

	.page

rgrp2:
	jra	1$		; 20 0E
	jrf	1$		; 21 0C
	jrugt	1$		; 22 0A
	jrule	1$		; 23 08
	jrnc	1$		; 24 06
	jrc	1$		; 25 04
	jrne	1$		; 26 02
	jreq	1$		; 27 00
1$:	jrnh	1$		; 28 FE
	jrh	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrnm	1$		; 2C F6
	jrm	1$		; 2D F4
	jril	1$		; 2E F2
	jrih	1$		; 2F F0

rgrp3:
	neg	*rbyt		; 30u10
				; 31
				; 32
	cpl	*rbyt		; 33u10
	srl	*rbyt		; 34u10
				; 35
	rrc	*rbyt		; 36u10
	sra	*rbyt		; 37u10
	sla	*rbyt		; 38u10
	rlc	*rbyt		; 39u10
	dec	*rbyt		; 3Au10
				; 3B
	inc	*rbyt		; 3Cu10
	tnz	*rbyt		; 3Du10
	swap	*rbyt		; 3Eu10
	clr	*rbyt		; 3Fu10

	.page

rgrp4:
	neg	a		; 40
				; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
				; 45
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
				; 4B
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

rgrp5:
	neg	x		; 50
				; 51
				; 52
	cpl	x		; 53
	srl	x		; 54
				; 55
	rrc	x		; 56
	sra	x		; 57
	sla	x		; 58
	rlc	x		; 59
	dec	x		; 5A
				; 5B
	inc	x		; 5C
	tnz	x		; 5D
	swap	x		; 5E
	clr	x		; 5F

	.page

rgrp6:
	neg	(*rbyt,x)	; 60u10
				; 61
				; 62
	cpl	(*rbyt,x)	; 63u10
	srl	(*rbyt,x)	; 64u10
				; 65
	rrc	(*rbyt,x)	; 66u10
	sra	(*rbyt,x)	; 67u10
	sla	(*rbyt,x)	; 68u10
	rlc	(*rbyt,x)	; 69u10
	dec	(*rbyt,x)	; 6Au10
				; 6B
	inc	(*rbyt,x)	; 6Cu10
	tnz	(*rbyt,x)	; 6Du10
	swap	(*rbyt,x)	; 6Eu10
	clr	(*rbyt,x)	; 6Fu10

rgrp7:
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
				; 7B
	inc	(x)		; 7C
	tnz	(x)		; 7D
	swap	(x)		; 7E
	clr	(x)		; 7F

	.page

rgrp8:
	iret			; 80
	ret			; 81
				; 82
	trap			; 83
	pop	a		; 84
	pop	x		; 85
	pop	cc		; 86
				; 87
	push	a		; 88
	push	x		; 89
	push	cc		; 8A
				; 8B
				; 8C
				; 8D
	halt			; 8E
	wfi			; 8F

rgrp9:
				; 90
				; 91
				; 92
	ld	x,y		; 93
	ld	s,x		; 94
	ld	s,a		; 95
	ld	x,s		; 96
	ld	x,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rsp			; 9C
	nop			; 9D
	ld	a,s		; 9E
	ld	a,x		; 9F

	.page

rgrpA:
	sub	a,#rbyt		; A0r10
	cp	a,#rbyt		; A1r10
	sbc	a,#rbyt		; A2r10
	cp	x,#rbyt		; A3r10
	and	a,#rbyt		; A4r10
	bcp	a,#rbyt		; A5r10
	ld	a,#rbyt		; A6r10
				; A7
	xor	a,#rbyt		; A8r10
	adc	a,#rbyt		; A9r10
	or	a,#rbyt		; AAr10
	add	a,#rbyt		; ABr10
				; AC
1$:	callr	1$		; AD FE
	ld	x,#rbyt		; AEr10

rgrpB:
	sub	a,*rbyt		; B0u10
	cp	a,*rbyt		; B1u10
	sbc	a,*rbyt		; B2u10
	cp	x,*rbyt		; B3u10
	and	a,*rbyt		; B4u10
	bcp	a,*rbyt		; B5u10
	ld	a,*rbyt		; B6u10
	ld	*rbyt,a		; B7u10
	xor	a,*rbyt		; B8u10
	adc	a,*rbyt		; B9u10
	or	a,*rbyt		; BAu10
	add	a,*rbyt		; BBu10
	jp	*rbyt		; BCu10
	call	*rbyt		; BDu10
	ld	x,*rbyt		; BEu10
	ld	*rbyt,x		; BFu10

	.page

rgrpC:
	sub	a,rwrd		; C0v54u32
	cp	a,rwrd		; C1v54u32
	sbc	a,rwrd		; C2v54u32
	cp	x,rwrd		; C3v54u32
	and	a,rwrd		; C4v54u32
	bcp	a,rwrd		; C5v54u32
	ld	a,rwrd		; C6v54u32
	ld	rwrd,a		; C7v54u32
	xor	a,rwrd		; C8v54u32
	adc	a,rwrd		; C9v54u32
	or	a,rwrd		; CAv54u32
	add	a,rwrd		; CBv54u32
	jp	rwrd		; CCv54u32
	call	rwrd		; CDv54u32
	ld	x,rwrd		; CEv54u32
	ld	rwrd,x		; CFv54u32

rgrpD:
	sub	a,(rwrd,x)	; D0v54u32
	cp	a,(rwrd,x)	; D1v54u32
	sbc	a,(rwrd,x)	; D2v54u32
	cp	x,(rwrd,x)	; D3v54u32
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
	ld	x,(rwrd,x)	; DEv54u32
	ld	(rwrd,x),x	; DFv54u32

	.page

rgrpE:
	sub	a,(*rbyt,x)	; E0u10
	cp	a,(*rbyt,x)	; E1u10
	sbc	a,(*rbyt,x)	; E2u10
	cp	x,(*rbyt,x)	; E3u10
	and	a,(*rbyt,x)	; E4u10
	bcp	a,(*rbyt,x)	; E5u10
	ld	a,(*rbyt,x)	; E6u10
	ld	(*rbyt,x),a	; E7u10
	xor	a,(*rbyt,x)	; E8u10
	adc	a,(*rbyt,x)	; E9u10
	or	a,(*rbyt,x)	; EAu10
	add	a,(*rbyt,x)	; EBu10
	jp	(*rbyt,x)	; ECu10
	call	(*rbyt,x)	; EDu10
	ld	x,(*rbyt,x)	; EEu10
	ld	(*rbyt,x),x	; EFu10

rgrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cp	x,(x)		; F3
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
	ld	x,(x)		; FE
	ld	(x),x		; FF


	.page
	.sbttl	Page 90 ST7 Instructions in Numerical Order (Relocatable)

rgrp90_0:

rgrp90_1:

rgrp90_2:

rgrp90_3:

rgrp90_4:
	mul	y,a		; 90 42

rgrp90_5:
	neg	y		; 90 50
				; 90 51
				; 90 52
	cpl	y		; 90 53
	srl	y		; 90 54
				; 90 55
	rrc	y		; 90 56
	sra	y		; 90 57
	sla	y		; 90 58
	rlc	y		; 90 59
	dec	y		; 90 5A
				; 90 5B
	inc	y		; 90 5C
	tnz	y		; 90 5D
	swap	y		; 90 5E
	clr	y		; 90 5F

.page

rgrp90_6:
	neg	(*rbyt,y)	; 90 60u10
				; 90 61
				; 90 62
	cpl	(*rbyt,y)	; 90 63u10
	srl	(*rbyt,y)	; 90 64u10
				; 90 65
	rrc	(*rbyt,y)	; 90 66u10
	sra	(*rbyt,y)	; 90 67u10
	sla	(*rbyt,y)	; 90 68u10
	rlc	(*rbyt,y)	; 90 69u10
	dec	(*rbyt,y)	; 90 6Au10
				; 90 6B
	inc	(*rbyt,y)	; 90 6Cu10
	tnz	(*rbyt,y)	; 90 6Du10
	swap	(*rbyt,y)	; 90 6Eu10
	clr	(*rbyt,y)	; 90 6Fu10

 rgrp90_7:
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

rgrp90_8:
	pop	y		; 90 85
	push	y		; 90 89

rgrp90_9:
	ld	y,x		; 90 93
	ld	s,y		; 90 94
	ld	y,s		; 90 96
	ld	y,a		; 90 97
	ld	a,y		; 90 9F

rgrp90_A:
	cp	y,#rbyt		; 90 A3r10
	ld	y,#rbyt		; 90 AEr10

rgrp90_B:
	cp	y,*rbyt		; 90 B3u10
	ld	y,*rbyt		; 90 BEu10
	ld	*rbyt,y		; 90 BFu10

rgrp90_C:
	cp	y,rwrd		; 90 C3v54u32
	ld	y,rwrd		; 90 CEv54u32
	ld	rwrd,y		; 90 CFv54u32

rgrp90_D:
	sub	a,(rwrd,y)	; 90 D0v54u32
	cp	a,(rwrd,y)	; 90 D1v54u32
	sbc	a,(rwrd,y)	; 90 D2v54u32
	cp	y,(rwrd,y)	; 90 D3v54u32
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
	ld 	y,(rwrd,y)	; 90 DEv54u32
	ld 	(rwrd,y),y	; 90 DFv54u32

	.page

rgrp90_E:
	sub	a,(*rbyt,y)	; 90 E0u10
	cp	a,(*rbyt,y)	; 90 E1u10
	sbc	a,(*rbyt,y)	; 90 E2u10
	cp	y,(*rbyt,y)	; 90 E3u10
	and	a,(*rbyt,y)	; 90 E4u10
	bcp	a,(*rbyt,y)	; 90 E5u10
	ld	a,(*rbyt,y)	; 90 E6u10
	ld	(*rbyt,y),a	; 90 E7u10
	xor	a,(*rbyt,y)	; 90 E8u10
	adc	a,(*rbyt,y)	; 90 E9u10
	or	a,(*rbyt,y)	; 90 EAu10
	add	a,(*rbyt,y)	; 90 EBu10
	jp	(*rbyt,y)	; 90 ECu10
	call	(*rbyt,y)	; 90 EDu10
	ld 	y,(*rbyt,y)	; 90 EEu10
	ld 	(*rbyt,y),y	; 90 EFu10

rgrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cp	y,(y)		; 90 F3
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
	ld 	y,(y)		; 90 FE
	ld 	(y),y		; 90 FF


	.page
	.sbttl	Page 91 ST7 Instructions in Numerical Order (Relocatable)

rgrp91_0:

rgrp91_1:

rgrp91_2:

rgrp91_3:

rgrp91_4:

rgrp91_5:

rgrp91_6:
	neg	([*rbyt],y)	; 91 60u10
				; 91 61
				; 91 62
	cpl	([*rbyt],y)	; 91 63u10
	srl	([*rbyt],y)	; 91 64u10
				; 91 65
	rrc	([*rbyt],y)	; 91 66u10
	sra	([*rbyt],y)	; 91 67u10
	sla	([*rbyt],y)	; 91 68u10
	rlc	([*rbyt],y)	; 91 69u10
	dec	([*rbyt],y)	; 91 6Au10
				; 91 6B
	inc	([*rbyt],y)	; 91 6Cu10
	tnz	([*rbyt],y)	; 91 6Du10
	swap	([*rbyt],y)	; 91 6Eu10
	clr	([*rbyt],y)	; 91 6Fu10

rgrp91_7:

	.page

rgrp91_8:

rgrp91_9:

rgrp91_A:

rgrp91_B:
	cp	y,[*rbyt]	; 91 B3u10
	ld	y,[*rbyt]	; 91 BEu10
	ld	[*rbyt],y	; 91 BFu10

rgrp91_C:
	cp	y,[rbyt]	; 91 C3u10
	ld	y,[rbyt]	; 91 CEu10
	ld	[rbyt],y	; 91 CFu10

rgrp91_D:
	sub	a,([rbyt],y)	; 91 D0u10
	cp	a,([rbyt],y)	; 91 D1u10
	sbc	a,([rbyt],y)	; 91 D2u10
	cp	y,([rbyt],y)	; 91 D3u10
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
	ld 	y,([rbyt],y)	; 91 DEu10
	ld 	([rbyt],y),y	; 91 DFu10

rgrp91_E:
	sub	a,([*rbyt],y)	; 91 E0u10
	cp	a,([*rbyt],y)	; 91 E1u10
	sbc	a,([*rbyt],y)	; 91 E2u10
	cp	y,([*rbyt],y)	; 91 E3u10
	and	a,([*rbyt],y)	; 91 E4u10
	bcp	a,([*rbyt],y)	; 91 E5u10
	ld	a,([*rbyt],y)	; 91 E6u10
	ld	([*rbyt],y),a	; 91 E7u10
	xor	a,([*rbyt],y)	; 91 E8u10
	adc	a,([*rbyt],y)	; 91 E9u10
	or	a,([*rbyt],y)	; 91 EAu10
	add	a,([*rbyt],y)	; 91 EBu10
	jp	([*rbyt],y)	; 91 ECu10
	call	([*rbyt],y)	; 91 EDu10
	ld 	y,([*rbyt],y)	; 91 EEu10
	ld 	([*rbyt],y),y	; 91 EFu10

rgrp91_F:


	.page
	.sbttl	Page 92 ST7 Instructions in Numerical Order (Relocatable)

rgrp92_0:
	btjt	[rbyt],#0,1$	; 92 00u10 1C
	btjf	[rbyt],#0,1$	; 92 01u10 18
	btjt	[rbyt],#1,1$	; 92 02u10 14
	btjf	[rbyt],#1,1$	; 92 03u10 10
	btjt	[rbyt],#2,1$	; 92 04u10 0C
	btjf	[rbyt],#2,1$	; 92 05u10 08
	btjt	[rbyt],#3,1$	; 92 06u10 04
	btjf	[rbyt],#3,1$	; 92 07u10 00
1$:	btjt	[rbyt],#4,1$	; 92 08u10 FC
	btjf	[rbyt],#4,1$	; 92 09u10 F8
	btjt	[rbyt],#5,1$	; 92 0Au10 F4
	btjf	[rbyt],#5,1$	; 92 0Bu10 F0
	btjt	[rbyt],#6,1$	; 92 0Cu10 EC
	btjf	[rbyt],#6,1$	; 92 0Du10 E8
	btjt	[rbyt],#7,1$	; 92 0Eu10 E4
	btjf	[rbyt],#7,1$	; 92 0Fu10 E0

rgrp92_1:
	bset	[rbyt],#0	; 92 10u10
	bres	[rbyt],#0	; 92 11u10
	bset	[rbyt],#1	; 92 12u10
	bres	[rbyt],#1	; 92 13u10
	bset	[rbyt],#2	; 92 14u10
	bres	[rbyt],#2	; 92 15u10
	bset	[rbyt],#3	; 92 16u10
	bres	[rbyt],#3	; 92 17u10
	bset	[rbyt],#4	; 92 18u10
	bres	[rbyt],#4	; 92 19u10
	bset	[rbyt],#5	; 92 1Au10
	bres	[rbyt],#5	; 92 1Bu10
	bset	[rbyt],#6	; 92 1Cu10
	bres	[rbyt],#6	; 92 1Du10
	bset	[rbyt],#7	; 92 1Eu10
	bres	[rbyt],#7	; 92 1Fu10

	.page

rgrp92_2:
	jra	[rbyt]		; 92 20u10
	jrf	[rbyt]		; 92 21u10
	jrugt	[rbyt]		; 92 22u10
	jrule	[rbyt]		; 92 23u10
	jrnc	[rbyt]		; 92 24u10
	jrc	[rbyt]		; 92 25u10
	jrne	[rbyt]		; 92 26u10
	jreq	[rbyt]		; 92 27u10
	jrnh	[rbyt]		; 92 28u10
	jrh	[rbyt]		; 92 29u10
	jrpl	[rbyt]		; 92 2Au10
	jrmi	[rbyt]		; 92 2Bu10
	jrnm	[rbyt]		; 92 2Cu10
	jrm	[rbyt]		; 92 2Du10
	jril	[rbyt]		; 92 2Eu10
	jrih	[rbyt]		; 92 2Fu10

rgrp92_3:
	neg	[rbyt]		; 92 30u10
				; 92 31
				; 92 32
	cpl	[rbyt]		; 92 33u10
	srl	[rbyt]		; 92 34u10
				; 92 35
	rrc	[rbyt]		; 92 36u10
	sra	[rbyt]		; 92 37u10
	sla	[rbyt]		; 92 38u10
	rlc	[rbyt]		; 92 39u10
	dec	[rbyt]		; 92 3Au10
				; 92 3B
	inc	[rbyt]		; 92 3Cu10
	tnz	[rbyt]		; 92 3Du10
	swap	[rbyt]		; 92 3Eu10
	clr	[rbyt]		; 92 3Fu10

	.page

rgrp92_4:

rgrp92_5:

rgrp92_6:
	neg	([rbyt],x)	; 92 60u10
				; 92 61
				; 92 62
	cpl	([rbyt],x)	; 92 63u10
	srl	([rbyt],x)	; 92 64u10
				; 92 65
	rrc	([rbyt],x)	; 92 66u10
	sra	([rbyt],x)	; 92 67u10
	sla	([rbyt],x)	; 92 68u10
	rlc	([rbyt],x)	; 92 69u10
	dec	([rbyt],x)	; 92 6Au10
				; 92 6B
	inc	([rbyt],x)	; 92 6Cu10
	tnz	([rbyt],x)	; 92 6Du10
	swap	([rbyt],x)	; 92 6Eu10
	clr	([rbyt],x)	; 92 6Fu10

rgrp92_7:

rgrp92_8:

rgrp92_9:

rgrp92_A:
	callr	[rbyt]		; 92 ADu10

	.page

rgrp92_B:
	sub	a,[*rbyt]	; 92 B0u10
	cp	a,[*rbyt]	; 92 B1u10
	sbc	a,[*rbyt]	; 92 B2u10
	cp	x,[*rbyt]	; 92 B3u10
	and	a,[*rbyt]	; 92 B4u10
	bcp	a,[*rbyt]	; 92 B5u10
	ld	a,[*rbyt]	; 92 B6u10
	ld	[*rbyt],a	; 92 B7u10
	xor	a,[*rbyt]	; 92 B8u10
	adc	a,[*rbyt]	; 92 B9u10
	or	a,[*rbyt]	; 92 BAu10
	add	a,[*rbyt]	; 92 BBu10
	jp	[*rbyt]		; 92 BCu10
	call	[*rbyt]		; 92 BDu10
	ld 	x,[*rbyt]	; 92 BEu10
	ld 	[*rbyt],x	; 92 BFu10

rgrp92_C:
	sub	a,[rbyt]	; 92 C0u10
	cp	a,[rbyt]	; 92 C1u10
	sbc	a,[rbyt]	; 92 C2u10
	cp	x,[rbyt]	; 92 C3u10
	and	a,[rbyt]	; 92 C4u10
	bcp	a,[rbyt]	; 92 C5u10
	ld	a,[rbyt]	; 92 C6u10
	ld	[rbyt],a	; 92 C7u10
	xor	a,[rbyt]	; 92 C8u10
	adc	a,[rbyt]	; 92 C9u10
	or	a,[rbyt]	; 92 CAu10
	add	a,[rbyt]	; 92 CBu10
	jp	[rbyt]		; 92 CCu10
	call	[rbyt]		; 92 CDu10
	ld 	x,[rbyt]	; 92 CEu10
	ld 	[rbyt],x	; 92 CFu10

		.page

rgrp92_D:
	sub	a,([rbyt],x)	; 92 D0u10
	cp	a,([rbyt],x)	; 92 D1u10
	sbc	a,([rbyt],x)	; 92 D2u10
	cp	x,([rbyt],x)	; 92 D3u10
	and	a,([rbyt],x)	; 92 D4u10
	bcp	a,([rbyt],x)	; 92 D5u10
	ld	a,([rbyt],x)	; 92 D6u10
	ld	([rbyt],x),a	; 92 D7u10
	xor	a,([rbyt],x)	; 92 D8u10
	adc	a,([rbyt],x)	; 92 D9u10
	or	a,([rbyt],x)	; 92 DAu10
	add	a,([rbyt],x)	; 92 DBu10
	jp	([rbyt],x)	; 92 DCu10
	call	([rbyt],x)	; 92 DDu10
	ld 	x,([rbyt],x)	; 92 DEu10
	ld 	([rbyt],x),x	; 92 DFu10

rgrp92_E:
	sub	a,([*rbyt],x)	; 92 E0u10
	cp	a,([*rbyt],x)	; 92 E1u10
	sbc	a,([*rbyt],x)	; 92 E2u10
	cp	x,([*rbyt],x)	; 92 E3u10
	and	a,([*rbyt],x)	; 92 E4u10
	bcp	a,([*rbyt],x)	; 92 E5u10
	ld	a,([*rbyt],x)	; 92 E6u10
	ld	([*rbyt],x),a	; 92 E7u10
	xor	a,([*rbyt],x)	; 92 E8u10
	adc	a,([*rbyt],x)	; 92 E9u10
	or	a,([*rbyt],x)	; 92 EAu10
	add	a,([*rbyt],x)	; 92 EBu10
	jp	([*rbyt],x)	; 92 ECu10
	call	([*rbyt],x)	; 92 EDu10
	ld 	x,([*rbyt],x)	; 92 EEu10
	ld 	([*rbyt],x),x	; 92 EFu10

rgrp92_F:


	.page
	.sbttl	Base ST7 Instructions in Numerical Order (Alternate)

	; Alternate 1-Byte Designation

mgrp0:
	btjt	*rbyt,#0,1$	; 00u10 15
	btjf	*rbyt,#0,1$	; 01u10 12
	btjt	*rbyt,#1,1$	; 02u10 0F
	btjf	*rbyt,#1,1$	; 03u10 0C
	btjt	*rbyt,#2,1$	; 04u10 09
	btjf	*rbyt,#2,1$	; 05u10 06
	btjt	*rbyt,#3,1$	; 06u10 03
	btjf	*rbyt,#3,1$	; 07u10 00
1$:	btjt	*rbyt,#4,1$	; 08u10 FD
	btjf	*rbyt,#4,1$	; 09u10 FA
	btjt	*rbyt,#5,1$	; 0Au10 F7
	btjf	*rbyt,#5,1$	; 0Bu10 F4
	btjt	*rbyt,#6,1$	; 0Cu10 F1
	btjf	*rbyt,#6,1$	; 0Du10 EE
	btjt	*rbyt,#7,1$	; 0Eu10 EB
	btjf	*rbyt,#7,1$	; 0Fu10 E8

mgrp1:
	bset	*rbyt,#0	; 10u10
	bres	*rbyt,#0	; 11u10
	bset	*rbyt,#1	; 12u10
	bres	*rbyt,#1	; 13u10
	bset	*rbyt,#2	; 14u10
	bres	*rbyt,#2	; 15u10
	bset	*rbyt,#3	; 16u10
	bres	*rbyt,#3	; 17u10
	bset	*rbyt,#4	; 18u10
	bres	*rbyt,#4	; 19u10
	bset	*rbyt,#5	; 1Au10
	bres	*rbyt,#5	; 1Bu10
	bset	*rbyt,#6	; 1Cu10
	bres	*rbyt,#6	; 1Du10
	bset	*rbyt,#7	; 1Eu10
	bres	*rbyt,#7	; 1Fu10

	.page

mgrp2:
	jra	1$		; 20 0E
	jrf	1$		; 21 0C
	jrugt	1$		; 22 0A
	jrule	1$		; 23 08
	jrnc	1$		; 24 06
	jrc	1$		; 25 04
	jrne	1$		; 26 02
	jreq	1$		; 27 00
1$:	jrnh	1$		; 28 FE
	jrh	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrnm	1$		; 2C F6
	jrm	1$		; 2D F4
	jril	1$		; 2E F2
	jrih	1$		; 2F F0

mgrp3:
	neg	*rbyt		; 30u10
				; 31
				; 32
	cpl	*rbyt		; 33u10
	srl	*rbyt		; 34u10
				; 35
	rrc	*rbyt		; 36u10
	sra	*rbyt		; 37u10
	sla	*rbyt		; 38u10
	rlc	*rbyt		; 39u10
	dec	*rbyt		; 3Au10
				; 3B
	inc	*rbyt		; 3Cu10
	tnz	*rbyt		; 3Du10
	swap	*rbyt		; 3Eu10
	clr	*rbyt		; 3Fu10

	.page

mgrp4:
	neg	a		; 40
				; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
				; 45
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
				; 4B
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

mgrp5:
	neg	x		; 50
				; 51
				; 52
	cpl	x		; 53
	srl	x		; 54
				; 55
	rrc	x		; 56
	sra	x		; 57
	sla	x		; 58
	rlc	x		; 59
	dec	x		; 5A
				; 5B
	inc	x		; 5C
	tnz	x		; 5D
	swap	x		; 5E
	clr	x		; 5F

	.page

mgrp6:
	neg	(rbyt,x).b	; 60u10
				; 61
				; 62
	cpl	(rbyt,x).b	; 63u10
	srl	(rbyt,x).b	; 64u10
				; 65
	rrc	(rbyt,x).b	; 66u10
	sra	(rbyt,x).b	; 67u10
	sla	(rbyt,x).b	; 68u10
	rlc	(rbyt,x).b	; 69u10
	dec	(rbyt,x).b	; 6Au10
				; 6B
	inc	(rbyt,x).b	; 6Cu10
	tnz	(rbyt,x).b	; 6Du10
	swap	(rbyt,x).b	; 6Eu10
	clr	(rbyt,x).b	; 6Fu10

mgrp7:
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
				; 7B
	inc	(x)		; 7C
	tnz	(x)		; 7D
	swap	(x)		; 7E
	clr	(x)		; 7F

	.page

mgrp8:
	iret			; 80
	ret			; 81
				; 82
	trap			; 83
	pop	a		; 84
	pop	x		; 85
	pop	cc		; 86
				; 87
	push	a		; 88
	push	x		; 89
	push	cc		; 8A
				; 8B
				; 8C
				; 8D
	halt			; 8E
	wfi			; 8F

mgrp9:
				; 90
				; 91
				; 92
	ld	x,y		; 93
	ld	s,x		; 94
	ld	s,a		; 95
	ld	x,s		; 96
	ld	x,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rsp			; 9C
	nop			; 9D
	ld	a,s		; 9E
	ld	a,x		; 9F

	.page

mgrpA:
	sub	a,#rbyt		; A0r10
	cp	a,#rbyt		; A1r10
	sbc	a,#rbyt		; A2r10
	cp	x,#rbyt		; A3r10
	and	a,#rbyt		; A4r10
	bcp	a,#rbyt		; A5r10
	ld	a,#rbyt		; A6r10
				; A7
	xor	a,#rbyt		; A8r10
	adc	a,#rbyt		; A9r10
	or	a,#rbyt		; AAr10
	add	a,#rbyt		; ABr10
				; AC
1$:	callr	1$		; AD FE
	ld	x,#rbyt		; AEr10

mgrpB:
	sub	a,*rbyt		; B0u10
	cp	a,*rbyt		; B1u10
	sbc	a,*rbyt		; B2u10
	cp	x,*rbyt		; B3u10
	and	a,*rbyt		; B4u10
	bcp	a,*rbyt		; B5u10
	ld	a,*rbyt		; B6u10
	ld	*rbyt,a		; B7u10
	xor	a,*rbyt		; B8u10
	adc	a,*rbyt		; B9u10
	or	a,*rbyt		; BAu10
	add	a,*rbyt		; BBu10
	jp	*rbyt		; BCu10
	call	*rbyt		; BDu10
	ld	x,*rbyt		; BEu10
	ld	*rbyt,x		; BFu10

	.page

mgrpC:
	sub	a,rwrd		; C0v54u32
	cp	a,rwrd		; C1v54u32
	sbc	a,rwrd		; C2v54u32
	cp	x,rwrd		; C3v54u32
	and	a,rwrd		; C4v54u32
	bcp	a,rwrd		; C5v54u32
	ld	a,rwrd		; C6v54u32
	ld	rwrd,a		; C7v54u32
	xor	a,rwrd		; C8v54u32
	adc	a,rwrd		; C9v54u32
	or	a,rwrd		; CAv54u32
	add	a,rwrd		; CBv54u32
	jp	rwrd		; CCv54u32
	call	rwrd		; CDv54u32
	ld	x,rwrd		; CEv54u32
	ld	rwrd,x		; CFv54u32

mgrpD:
	sub	a,(rwrd,x).w	; D0v54u32
	cp	a,(rwrd,x).w	; D1v54u32
	sbc	a,(rwrd,x).w	; D2v54u32
	cp	x,(rwrd,x).w	; D3v54u32
	and	a,(rwrd,x).w	; D4v54u32
	bcp	a,(rwrd,x).w	; D5v54u32
	ld	a,(rwrd,x).w	; D6v54u32
	ld	(rwrd,x).w,a	; D7v54u32
	xor	a,(rwrd,x).w	; D8v54u32
	adc	a,(rwrd,x).w	; D9v54u32
	or	a,(rwrd,x).w	; DAv54u32
	add	a,(rwrd,x).w	; DBv54u32
	jp	(rwrd,x).w	; DCv54u32
	call	(rwrd,x).w	; DDv54u32
	ld	x,(rwrd,x).w	; DEv54u32
	ld	(rwrd,x).w,x	; DFv54u32

	.page

mgrpE:
	sub	a,(rbyt,x).b	; E0u10
	cp	a,(rbyt,x).b	; E1u10
	sbc	a,(rbyt,x).b	; E2u10
	cp	x,(rbyt,x).b	; E3u10
	and	a,(rbyt,x).b	; E4u10
	bcp	a,(rbyt,x).b	; E5u10
	ld	a,(rbyt,x).b	; E6u10
	ld	(rbyt,x).b,a	; E7u10
	xor	a,(rbyt,x).b	; E8u10
	adc	a,(rbyt,x).b	; E9u10
	or	a,(rbyt,x).b	; EAu10
	add	a,(rbyt,x).b	; EBu10
	jp	(rbyt,x).b	; ECu10
	call	(rbyt,x).b	; EDu10
	ld	x,(rbyt,x).b	; EEu10
	ld	(rbyt,x).b,x	; EFu10

mgrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cp	x,(x)		; F3
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
	ld	x,(x)		; FE
	ld	(x),x		; FF


	.page
	.sbttl	Page 90 ST7 Instructions in Numerical Order (Alternate)

mgrp90_0:

mgrp90_1:

mgrp90_2:

mgrp90_3:

mgrp90_4:
	mul	y,a		; 90 42

mgrp90_5:
	neg	y		; 90 50
				; 90 51
				; 90 52
	cpl	y		; 90 53
	srl	y		; 90 54
				; 90 55
	rrc	y		; 90 56
	sra	y		; 90 57
	sla	y		; 90 58
	rlc	y		; 90 59
	dec	y		; 90 5A
				; 90 5B
	inc	y		; 90 5C
	tnz	y		; 90 5D
	swap	y		; 90 5E
	clr	y		; 90 5F

.page

mgrp90_6:
	neg	(rbyt,y).b	; 90 60u10
				; 90 61
				; 90 62
	cpl	(rbyt,y).b	; 90 63u10
	srl	(rbyt,y).b	; 90 64u10
				; 90 65
	rrc	(rbyt,y).b	; 90 66u10
	sra	(rbyt,y).b	; 90 67u10
	sla	(rbyt,y).b	; 90 68u10
	rlc	(rbyt,y).b	; 90 69u10
	dec	(rbyt,y).b	; 90 6Au10
				; 90 6B
	inc	(rbyt,y).b	; 90 6Cu10
	tnz	(rbyt,y).b	; 90 6Du10
	swap	(rbyt,y).b	; 90 6Eu10
	clr	(rbyt,y).b	; 90 6Fu10

 mgrp90_7:
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

mgrp90_8:
	pop	y		; 90 85
	push	y		; 90 89

mgrp90_9:
	ld	y,x		; 90 93
	ld	s,y		; 90 94
	ld	y,s		; 90 96
	ld	y,a		; 90 97
	ld	a,y		; 90 9F

mgrp90_A:
	cp	y,#rbyt		; 90 A3r10
	ld	y,#rbyt		; 90 AEr10

mgrp90_B:
	cp	y,*rbyt		; 90 B3u10
	ld	y,*rbyt		; 90 BEu10
	ld	*rbyt,y		; 90 BFu10

mgrp90_C:
	cp	y,rwrd		; 90 C3v54u32
	ld	y,rwrd		; 90 CEv54u32
	ld	rwrd,y		; 90 CFv54u32

mgrp90_D:
	sub	a,(rwrd,y).w	; 90 D0v54u32
	cp	a,(rwrd,y).w	; 90 D1v54u32
	sbc	a,(rwrd,y).w	; 90 D2v54u32
	cp	y,(rwrd,y).w	; 90 D3v54u32
	and	a,(rwrd,y).w	; 90 D4v54u32
	bcp	a,(rwrd,y).w	; 90 D5v54u32
	ld	a,(rwrd,y).w	; 90 D6v54u32
	ld	(rwrd,y).w,a	; 90 D7v54u32
	xor	a,(rwrd,y).w	; 90 D8v54u32
	adc	a,(rwrd,y).w	; 90 D9v54u32
	or	a,(rwrd,y).w	; 90 DAv54u32
	add	a,(rwrd,y).w	; 90 DBv54u32
	jp	(rwrd,y).w	; 90 DCv54u32
	call	(rwrd,y).w	; 90 DDv54u32
	ld 	y,(rwrd,y).w	; 90 DEv54u32
	ld 	(rwrd,y).w,y	; 90 DFv54u32

	.page

mgrp90_E:
	sub	a,(rbyt,y).b	; 90 E0u10
	cp	a,(rbyt,y).b	; 90 E1u10
	sbc	a,(rbyt,y).b	; 90 E2u10
	cp	y,(rbyt,y).b	; 90 E3u10
	and	a,(rbyt,y).b	; 90 E4u10
	bcp	a,(rbyt,y).b	; 90 E5u10
	ld	a,(rbyt,y).b	; 90 E6u10
	ld	(rbyt,y).b,a	; 90 E7u10
	xor	a,(rbyt,y).b	; 90 E8u10
	adc	a,(rbyt,y).b	; 90 E9u10
	or	a,(rbyt,y).b	; 90 EAu10
	add	a,(rbyt,y).b	; 90 EBu10
	jp	(rbyt,y).b	; 90 ECu10
	call	(rbyt,y).b	; 90 EDu10
	ld 	y,(rbyt,y).b	; 90 EEu10
	ld 	(rbyt,y).b,y	; 90 EFu10

mgrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cp	y,(y)		; 90 F3
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
	ld 	y,(y)		; 90 FE
	ld 	(y),y		; 90 FF


	.page
	.sbttl	Page 91 ST7 Instructions in Numerical Order (Alternate)

mgrp91_0:

mgrp91_1:

mgrp91_2:

mgrp91_3:

mgrp91_4:

mgrp91_5:

mgrp91_6:
	neg	([rbyt].b,y)	; 91 60u10
				; 91 61
				; 91 62
	cpl	([rbyt].b,y)	; 91 63u10
	srl	([rbyt].b,y)	; 91 64u10
				; 91 65
	rrc	([rbyt].b,y)	; 91 66u10
	sra	([rbyt].b,y)	; 91 67u10
	sla	([rbyt].b,y)	; 91 68u10
	rlc	([rbyt].b,y)	; 91 69u10
	dec	([rbyt].b,y)	; 91 6Au10
				; 91 6B
	inc	([rbyt].b,y)	; 91 6Cu10
	tnz	([rbyt].b,y)	; 91 6Du10
	swap	([rbyt].b,y)	; 91 6Eu10
	clr	([rbyt].b,y)	; 91 6Fu10

mgrp91_7:

	.page

mgrp91_8:

mgrp91_9:

mgrp91_A:

mgrp91_B:
	cp	y,[rbyt].b	; 91 B3u10
	ld	y,[rbyt].b	; 91 BEu10
	ld	[rbyt].b,y	; 91 BFu10

mgrp91_C:
	cp	y,[rbyt]	; 91 C3u10
	ld	y,[rbyt]	; 91 CEu10
	ld	[rbyt],y	; 91 CFu10

mgrp91_D:
	sub	a,([rbyt],y)	; 91 D0u10
	cp	a,([rbyt],y)	; 91 D1u10
	sbc	a,([rbyt],y)	; 91 D2u10
	cp	y,([rbyt],y)	; 91 D3u10
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
	ld 	y,([rbyt],y)	; 91 DEu10
	ld 	([rbyt],y),y	; 91 DFu10

mgrp91_E:
	sub	a,([rbyt].b,y)	; 91 E0u10
	cp	a,([rbyt].b,y)	; 91 E1u10
	sbc	a,([rbyt].b,y)	; 91 E2u10
	cp	y,([rbyt].b,y)	; 91 E3u10
	and	a,([rbyt].b,y)	; 91 E4u10
	bcp	a,([rbyt].b,y)	; 91 E5u10
	ld	a,([rbyt].b,y)	; 91 E6u10
	ld	([rbyt].b,y),a	; 91 E7u10
	xor	a,([rbyt].b,y)	; 91 E8u10
	adc	a,([rbyt].b,y)	; 91 E9u10
	or	a,([rbyt].b,y)	; 91 EAu10
	add	a,([rbyt].b,y)	; 91 EBu10
	jp	([rbyt].b,y)	; 91 ECu10
	call	([rbyt].b,y)	; 91 EDu10
	ld 	y,([rbyt].b,y)	; 91 EEu10
	ld 	([rbyt].b,y),y	; 91 EFu10

mgrp91_F:


	.page
	.sbttl	Page 92 ST7 Instructions in Numerical Order (Alternate)

mgrp92_0:
	btjt	[rbyt].b,#0,1$	; 92 00u10 1C
	btjf	[rbyt].b,#0,1$	; 92 01u10 18
	btjt	[rbyt].b,#1,1$	; 92 02u10 14
	btjf	[rbyt].b,#1,1$	; 92 03u10 10
	btjt	[rbyt].b,#2,1$	; 92 04u10 0C
	btjf	[rbyt].b,#2,1$	; 92 05u10 08
	btjt	[rbyt].b,#3,1$	; 92 06u10 04
	btjf	[rbyt].b,#3,1$	; 92 07u10 00
1$:	btjt	[rbyt].b,#4,1$	; 92 08u10 FC
	btjf	[rbyt].b,#4,1$	; 92 09u10 F8
	btjt	[rbyt].b,#5,1$	; 92 0Au10 F4
	btjf	[rbyt].b,#5,1$	; 92 0Bu10 F0
	btjt	[rbyt].b,#6,1$	; 92 0Cu10 EC
	btjf	[rbyt].b,#6,1$	; 92 0Du10 E8
	btjt	[rbyt].b,#7,1$	; 92 0Eu10 E4
	btjf	[rbyt].b,#7,1$	; 92 0Fu10 E0

mgrp92_1:
	bset	[rbyt].b,#0	; 92 10u10
	bres	[rbyt].b,#0	; 92 11u10
	bset	[rbyt].b,#1	; 92 12u10
	bres	[rbyt].b,#1	; 92 13u10
	bset	[rbyt].b,#2	; 92 14u10
	bres	[rbyt].b,#2	; 92 15u10
	bset	[rbyt].b,#3	; 92 16u10
	bres	[rbyt].b,#3	; 92 17u10
	bset	[rbyt].b,#4	; 92 18u10
	bres	[rbyt].b,#4	; 92 19u10
	bset	[rbyt].b,#5	; 92 1Au10
	bres	[rbyt].b,#5	; 92 1Bu10
	bset	[rbyt].b,#6	; 92 1Cu10
	bres	[rbyt].b,#6	; 92 1Du10
	bset	[rbyt].b,#7	; 92 1Eu10
	bres	[rbyt].b,#7	; 92 1Fu10

	.page

mgrp92_2:
	jra	[rbyt].b	; 92 20u10
	jrf	[rbyt].b	; 92 21u10
	jrugt	[rbyt].b	; 92 22u10
	jrule	[rbyt].b	; 92 23u10
	jrnc	[rbyt].b	; 92 24u10
	jrc	[rbyt].b	; 92 25u10
	jrne	[rbyt].b	; 92 26u10
	jreq	[rbyt].b	; 92 27u10
	jrnh	[rbyt].b	; 92 28u10
	jrh	[rbyt].b	; 92 29u10
	jrpl	[rbyt].b	; 92 2Au10
	jrmi	[rbyt].b	; 92 2Bu10
	jrnm	[rbyt].b	; 92 2Cu10
	jrm	[rbyt].b	; 92 2Du10
	jril	[rbyt].b	; 92 2Eu10
	jrih	[rbyt].b	; 92 2Fu10

mgrp92_3:
	neg	[rbyt].b	; 92 30u10
				; 92 31
				; 92 32
	cpl	[rbyt].b	; 92 33u10
	srl	[rbyt].b	; 92 34u10
				; 92 35
	rrc	[rbyt].b	; 92 36u10
	sra	[rbyt].b	; 92 37u10
	sla	[rbyt].b	; 92 38u10
	rlc	[rbyt].b	; 92 39u10
	dec	[rbyt].b	; 92 3Au10
				; 92 3B
	inc	[rbyt].b	; 92 3Cu10
	tnz	[rbyt].b	; 92 3Du10
	swap	[rbyt].b	; 92 3Eu10
	clr	[rbyt].b	; 92 3Fu10

	.page

mgrp92_4:

mgrp92_5:

mgrp92_6:
	neg	([rbyt].b,x)	; 92 60u10
				; 92 61
				; 92 62
	cpl	([rbyt].b,x)	; 92 63u10
	srl	([rbyt].b,x)	; 92 64u10
				; 92 65
	rrc	([rbyt].b,x)	; 92 66u10
	sra	([rbyt].b,x)	; 92 67u10
	sla	([rbyt].b,x)	; 92 68u10
	rlc	([rbyt].b,x)	; 92 69u10
	dec	([rbyt].b,x)	; 92 6Au10
				; 92 6B
	inc	([rbyt].b,x)	; 92 6Cu10
	tnz	([rbyt].b,x)	; 92 6Du10
	swap	([rbyt].b,x)	; 92 6Eu10
	clr	([rbyt].b,x)	; 92 6Fu10

mgrp92_7:

mgrp92_8:

mgrp92_9:

mgrp92_A:
	callr	[rbyt].b		; 92 ADu10

	.page

mgrp92_B:
	sub	a,[rbyt].b	; 92 B0u10
	cp	a,[rbyt].b	; 92 B1u10
	sbc	a,[rbyt].b	; 92 B2u10
	cp	x,[rbyt].b	; 92 B3u10
	and	a,[rbyt].b	; 92 B4u10
	bcp	a,[rbyt].b	; 92 B5u10
	ld	a,[rbyt].b	; 92 B6u10
	ld	[rbyt].b,a	; 92 B7u10
	xor	a,[rbyt].b	; 92 B8u10
	adc	a,[rbyt].b	; 92 B9u10
	or	a,[rbyt].b	; 92 BAu10
	add	a,[rbyt].b	; 92 BBu10
	jp	[rbyt].b		; 92 BCu10
	call	[rbyt].b		; 92 BDu10
	ld 	x,[rbyt].b	; 92 BEu10
	ld 	[rbyt].b,x	; 92 BFu10

mgrp92_C:
	sub	a,[rbyt].w	; 92 C0u10
	cp	a,[rbyt].w	; 92 C1u10
	sbc	a,[rbyt].w	; 92 C2u10
	cp	x,[rbyt].w	; 92 C3u10
	and	a,[rbyt].w	; 92 C4u10
	bcp	a,[rbyt].w	; 92 C5u10
	ld	a,[rbyt].w	; 92 C6u10
	ld	[rbyt].w,a	; 92 C7u10
	xor	a,[rbyt].w	; 92 C8u10
	adc	a,[rbyt].w	; 92 C9u10
	or	a,[rbyt].w	; 92 CAu10
	add	a,[rbyt].w	; 92 CBu10
	jp	[rbyt].w	; 92 CCu10
	call	[rbyt].w	; 92 CDu10
	ld 	x,[rbyt].w	; 92 CEu10
	ld 	[rbyt].w,x	; 92 CFu10

		.page

mgrp92_D:
	sub	a,([rbyt].w,x)	; 92 D0u10
	cp	a,([rbyt].w,x)	; 92 D1u10
	sbc	a,([rbyt].w,x)	; 92 D2u10
	cp	x,([rbyt].w,x)	; 92 D3u10
	and	a,([rbyt].w,x)	; 92 D4u10
	bcp	a,([rbyt].w,x)	; 92 D5u10
	ld	a,([rbyt].w,x)	; 92 D6u10
	ld	([rbyt].w,x),a	; 92 D7u10
	xor	a,([rbyt].w,x)	; 92 D8u10
	adc	a,([rbyt].w,x)	; 92 D9u10
	or	a,([rbyt].w,x)	; 92 DAu10
	add	a,([rbyt].w,x)	; 92 DBu10
	jp	([rbyt].w,x)	; 92 DCu10
	call	([rbyt].w,x)	; 92 DDu10
	ld 	x,([rbyt].w,x)	; 92 DEu10
	ld 	([rbyt].w,x),x	; 92 DFu10

mgrp92_E:
	sub	a,([rbyt].b,x)	; 92 E0u10
	cp	a,([rbyt].b,x)	; 92 E1u10
	sbc	a,([rbyt].b,x)	; 92 E2u10
	cp	x,([rbyt].b,x)	; 92 E3u10
	and	a,([rbyt].b,x)	; 92 E4u10
	bcp	a,([rbyt].b,x)	; 92 E5u10
	ld	a,([rbyt].b,x)	; 92 E6u10
	ld	([rbyt].b,x),a	; 92 E7u10
	xor	a,([rbyt].b,x)	; 92 E8u10
	adc	a,([rbyt].b,x)	; 92 E9u10
	or	a,([rbyt].b,x)	; 92 EAu10
	add	a,([rbyt].b,x)	; 92 EBu10
	jp	([rbyt].b,x)	; 92 ECu10
	call	([rbyt].b,x)	; 92 EDu10
	ld 	x,([rbyt].b,x)	; 92 EEu10
	ld 	([rbyt].b,x),x	; 92 EFu10

mgrp92_F:


	.page
	.sbttl	Base ST7 Instructions with External symbols

	.define	rbyt, /xbyt+0x10/
	.define	rwrd, /xwrd+0x5432/

ngrp0:
	btjt	*rbyt,#0,1$	; 00u10 15
	btjf	*rbyt,#0,1$	; 01u10 12
	btjt	*rbyt,#1,1$	; 02u10 0F
	btjf	*rbyt,#1,1$	; 03u10 0C
	btjt	*rbyt,#2,1$	; 04u10 09
	btjf	*rbyt,#2,1$	; 05u10 06
	btjt	*rbyt,#3,1$	; 06u10 03
	btjf	*rbyt,#3,1$	; 07u10 00
1$:	btjt	*rbyt,#4,1$	; 08u10 FD
	btjf	*rbyt,#4,1$	; 09u10 FA
	btjt	*rbyt,#5,1$	; 0Au10 F7
	btjf	*rbyt,#5,1$	; 0Bu10 F4
	btjt	*rbyt,#6,1$	; 0Cu10 F1
	btjf	*rbyt,#6,1$	; 0Du10 EE
	btjt	*rbyt,#7,1$	; 0Eu10 EB
	btjf	*rbyt,#7,1$	; 0Fu10 E8

ngrp1:
	bset	*rbyt,#0	; 10u10
	bres	*rbyt,#0	; 11u10
	bset	*rbyt,#1	; 12u10
	bres	*rbyt,#1	; 13u10
	bset	*rbyt,#2	; 14u10
	bres	*rbyt,#2	; 15u10
	bset	*rbyt,#3	; 16u10
	bres	*rbyt,#3	; 17u10
	bset	*rbyt,#4	; 18u10
	bres	*rbyt,#4	; 19u10
	bset	*rbyt,#5	; 1Au10
	bres	*rbyt,#5	; 1Bu10
	bset	*rbyt,#6	; 1Cu10
	bres	*rbyt,#6	; 1Du10
	bset	*rbyt,#7	; 1Eu10
	bres	*rbyt,#7	; 1Fu10

	.page

ngrp2:
	jra	1$		; 20 0E
	jrf	1$		; 21 0C
	jrugt	1$		; 22 0A
	jrule	1$		; 23 08
	jrnc	1$		; 24 06
	jrc	1$		; 25 04
	jrne	1$		; 26 02
	jreq	1$		; 27 00
1$:	jrnh	1$		; 28 FE
	jrh	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrnm	1$		; 2C F6
	jrm	1$		; 2D F4
	jril	1$		; 2E F2
	jrih	1$		; 2F F0

ngrp3:
	neg	*rbyt		; 30u10
				; 31
				; 32
	cpl	*rbyt		; 33u10
	srl	*rbyt		; 34u10
				; 35
	rrc	*rbyt		; 36u10
	sra	*rbyt		; 37u10
	sla	*rbyt		; 38u10
	rlc	*rbyt		; 39u10
	dec	*rbyt		; 3Au10
				; 3B
	inc	*rbyt		; 3Cu10
	tnz	*rbyt		; 3Du10
	swap	*rbyt		; 3Eu10
	clr	*rbyt		; 3Fu10

	.page

ngrp4:
	neg	a		; 40
				; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
				; 45
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
				; 4B
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

ngrp5:
	neg	x		; 50
				; 51
				; 52
	cpl	x		; 53
	srl	x		; 54
				; 55
	rrc	x		; 56
	sra	x		; 57
	sla	x		; 58
	rlc	x		; 59
	dec	x		; 5A
				; 5B
	inc	x		; 5C
	tnz	x		; 5D
	swap	x		; 5E
	clr	x		; 5F

	.page

ngrp6:
	neg	(*rbyt,x)	; 60u10
				; 61
				; 62
	cpl	(*rbyt,x)	; 63u10
	srl	(*rbyt,x)	; 64u10
				; 65
	rrc	(*rbyt,x)	; 66u10
	sra	(*rbyt,x)	; 67u10
	sla	(*rbyt,x)	; 68u10
	rlc	(*rbyt,x)	; 69u10
	dec	(*rbyt,x)	; 6Au10
				; 6B
	inc	(*rbyt,x)	; 6Cu10
	tnz	(*rbyt,x)	; 6Du10
	swap	(*rbyt,x)	; 6Eu10
	clr	(*rbyt,x)	; 6Fu10

ngrp7:
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
				; 7B
	inc	(x)		; 7C
	tnz	(x)		; 7D
	swap	(x)		; 7E
	clr	(x)		; 7F

	.page

ngrp8:
	iret			; 80
	ret			; 81
				; 82
	trap			; 83
	pop	a		; 84
	pop	x		; 85
	pop	cc		; 86
				; 87
	push	a		; 88
	push	x		; 89
	push	cc		; 8A
				; 8B
				; 8C
				; 8D
	halt			; 8E
	wfi			; 8F

ngrp9:
				; 90
				; 91
				; 92
	ld	x,y		; 93
	ld	s,x		; 94
	ld	s,a		; 95
	ld	x,s		; 96
	ld	x,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rsp			; 9C
	nop			; 9D
	ld	a,s		; 9E
	ld	a,x		; 9F

	.page

ngrpA:
	sub	a,#rbyt		; A0r10
	cp	a,#rbyt		; A1r10
	sbc	a,#rbyt		; A2r10
	cp	x,#rbyt		; A3r10
	and	a,#rbyt		; A4r10
	bcp	a,#rbyt		; A5r10
	ld	a,#rbyt		; A6r10
				; A7
	xor	a,#rbyt		; A8r10
	adc	a,#rbyt		; A9r10
	or	a,#rbyt		; AAr10
	add	a,#rbyt		; ABr10
				; AC
1$:	callr	1$		; AD FE
	ld	x,#rbyt		; AEr10

ngrpB:
	sub	a,*rbyt		; B0u10
	cp	a,*rbyt		; B1u10
	sbc	a,*rbyt		; B2u10
	cp	x,*rbyt		; B3u10
	and	a,*rbyt		; B4u10
	bcp	a,*rbyt		; B5u10
	ld	a,*rbyt		; B6u10
	ld	*rbyt,a		; B7u10
	xor	a,*rbyt		; B8u10
	adc	a,*rbyt		; B9u10
	or	a,*rbyt		; BAu10
	add	a,*rbyt		; BBu10
	jp	*rbyt		; BCu10
	call	*rbyt		; BDu10
	ld	x,*rbyt		; BEu10
	ld	*rbyt,x		; BFu10

	.page

ngrpC:
	sub	a,rwrd		; C0v54u32
	cp	a,rwrd		; C1v54u32
	sbc	a,rwrd		; C2v54u32
	cp	x,rwrd		; C3v54u32
	and	a,rwrd		; C4v54u32
	bcp	a,rwrd		; C5v54u32
	ld	a,rwrd		; C6v54u32
	ld	rwrd,a		; C7v54u32
	xor	a,rwrd		; C8v54u32
	adc	a,rwrd		; C9v54u32
	or	a,rwrd		; CAv54u32
	add	a,rwrd		; CBv54u32
	jp	rwrd		; CCv54u32
	call	rwrd		; CDv54u32
	ld	x,rwrd		; CEv54u32
	ld	rwrd,x		; CFv54u32

ngrpD:
	sub	a,(rwrd,x)	; D0v54u32
	cp	a,(rwrd,x)	; D1v54u32
	sbc	a,(rwrd,x)	; D2v54u32
	cp	x,(rwrd,x)	; D3v54u32
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
	ld	x,(rwrd,x)	; DEv54u32
	ld	(rwrd,x),x	; DFv54u32

	.page

ngrpE:
	sub	a,(*rbyt,x)	; E0u10
	cp	a,(*rbyt,x)	; E1u10
	sbc	a,(*rbyt,x)	; E2u10
	cp	x,(*rbyt,x)	; E3u10
	and	a,(*rbyt,x)	; E4u10
	bcp	a,(*rbyt,x)	; E5u10
	ld	a,(*rbyt,x)	; E6u10
	ld	(*rbyt,x),a	; E7u10
	xor	a,(*rbyt,x)	; E8u10
	adc	a,(*rbyt,x)	; E9u10
	or	a,(*rbyt,x)	; EAu10
	add	a,(*rbyt,x)	; EBu10
	jp	(*rbyt,x)	; ECu10
	call	(*rbyt,x)	; EDu10
	ld	x,(*rbyt,x)	; EEu10
	ld	(*rbyt,x),x	; EFu10

ngrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cp	x,(x)		; F3
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
	ld	x,(x)		; FE
	ld	(x),x		; FF


	.page
	.sbttl	Page 90 ST7 Instructions with External symbols

ngrp90_0:

ngrp90_1:

ngrp90_2:

ngrp90_3:

ngrp90_4:
	mul	y,a		; 90 42

ngrp90_5:
	neg	y		; 90 50
				; 90 51
				; 90 52
	cpl	y		; 90 53
	srl	y		; 90 54
				; 90 55
	rrc	y		; 90 56
	sra	y		; 90 57
	sla	y		; 90 58
	rlc	y		; 90 59
	dec	y		; 90 5A
				; 90 5B
	inc	y		; 90 5C
	tnz	y		; 90 5D
	swap	y		; 90 5E
	clr	y		; 90 5F

.page

ngrp90_6:
	neg	(*rbyt,y)	; 90 60u10
				; 90 61
				; 90 62
	cpl	(*rbyt,y)	; 90 63u10
	srl	(*rbyt,y)	; 90 64u10
				; 90 65
	rrc	(*rbyt,y)	; 90 66u10
	sra	(*rbyt,y)	; 90 67u10
	sla	(*rbyt,y)	; 90 68u10
	rlc	(*rbyt,y)	; 90 69u10
	dec	(*rbyt,y)	; 90 6Au10
				; 90 6B
	inc	(*rbyt,y)	; 90 6Cu10
	tnz	(*rbyt,y)	; 90 6Du10
	swap	(*rbyt,y)	; 90 6Eu10
	clr	(*rbyt,y)	; 90 6Fu10

 ngrp90_7:
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

ngrp90_8:
	pop	y		; 90 85
	push	y		; 90 89

ngrp90_9:
	ld	y,x		; 90 93
	ld	s,y		; 90 94
	ld	y,s		; 90 96
	ld	y,a		; 90 97
	ld	a,y		; 90 9F

ngrp90_A:
	cp	y,#rbyt		; 90 A3r10
	ld	y,#rbyt		; 90 AEr10

ngrp90_B:
	cp	y,*rbyt		; 90 B3u10
	ld	y,*rbyt		; 90 BEu10
	ld	*rbyt,y		; 90 BFu10

ngrp90_C:
	cp	y,rwrd		; 90 C3v54u32
	ld	y,rwrd		; 90 CEv54u32
	ld	rwrd,y		; 90 CFv54u32

ngrp90_D:
	sub	a,(rwrd,y)	; 90 D0v54u32
	cp	a,(rwrd,y)	; 90 D1v54u32
	sbc	a,(rwrd,y)	; 90 D2v54u32
	cp	y,(rwrd,y)	; 90 D3v54u32
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
	ld 	y,(rwrd,y)	; 90 DEv54u32
	ld 	(rwrd,y),y	; 90 DFv54u32

	.page

ngrp90_E:
	sub	a,(*rbyt,y)	; 90 E0u10
	cp	a,(*rbyt,y)	; 90 E1u10
	sbc	a,(*rbyt,y)	; 90 E2u10
	cp	y,(*rbyt,y)	; 90 E3u10
	and	a,(*rbyt,y)	; 90 E4u10
	bcp	a,(*rbyt,y)	; 90 E5u10
	ld	a,(*rbyt,y)	; 90 E6u10
	ld	(*rbyt,y),a	; 90 E7u10
	xor	a,(*rbyt,y)	; 90 E8u10
	adc	a,(*rbyt,y)	; 90 E9u10
	or	a,(*rbyt,y)	; 90 EAu10
	add	a,(*rbyt,y)	; 90 EBu10
	jp	(*rbyt,y)	; 90 ECu10
	call	(*rbyt,y)	; 90 EDu10
	ld 	y,(*rbyt,y)	; 90 EEu10
	ld 	(*rbyt,y),y	; 90 EFu10

ngrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cp	y,(y)		; 90 F3
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
	ld 	y,(y)		; 90 FE
	ld 	(y),y		; 90 FF


	.page
	.sbttl	Page 91 ST7 Instructions with External symbols

ngrp91_0:

ngrp91_1:

ngrp91_2:

ngrp91_3:

ngrp91_4:

ngrp91_5:

ngrp91_6:
	neg	([*rbyt],y)	; 91 60u10
				; 91 61
				; 91 62
	cpl	([*rbyt],y)	; 91 63u10
	srl	([*rbyt],y)	; 91 64u10
				; 91 65
	rrc	([*rbyt],y)	; 91 66u10
	sra	([*rbyt],y)	; 91 67u10
	sla	([*rbyt],y)	; 91 68u10
	rlc	([*rbyt],y)	; 91 69u10
	dec	([*rbyt],y)	; 91 6Au10
				; 91 6B
	inc	([*rbyt],y)	; 91 6Cu10
	tnz	([*rbyt],y)	; 91 6Du10
	swap	([*rbyt],y)	; 91 6Eu10
	clr	([*rbyt],y)	; 91 6Fu10

ngrp91_7:

	.page

ngrp91_8:

ngrp91_9:

ngrp91_A:

ngrp91_B:
	cp	y,[*rbyt]	; 91 B3u10
	ld	y,[*rbyt]	; 91 BEu10
	ld	[*rbyt],y	; 91 BFu10

ngrp91_C:
	cp	y,[rbyt]	; 91 C3u10
	ld	y,[rbyt]	; 91 CEu10
	ld	[rbyt],y	; 91 CFu10

ngrp91_D:
	sub	a,([rbyt],y)	; 91 D0u10
	cp	a,([rbyt],y)	; 91 D1u10
	sbc	a,([rbyt],y)	; 91 D2u10
	cp	y,([rbyt],y)	; 91 D3u10
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
	ld 	y,([rbyt],y)	; 91 DEu10
	ld 	([rbyt],y),y	; 91 DFu10

ngrp91_E:
	sub	a,([*rbyt],y)	; 91 E0u10
	cp	a,([*rbyt],y)	; 91 E1u10
	sbc	a,([*rbyt],y)	; 91 E2u10
	cp	y,([*rbyt],y)	; 91 E3u10
	and	a,([*rbyt],y)	; 91 E4u10
	bcp	a,([*rbyt],y)	; 91 E5u10
	ld	a,([*rbyt],y)	; 91 E6u10
	ld	([*rbyt],y),a	; 91 E7u10
	xor	a,([*rbyt],y)	; 91 E8u10
	adc	a,([*rbyt],y)	; 91 E9u10
	or	a,([*rbyt],y)	; 91 EAu10
	add	a,([*rbyt],y)	; 91 EBu10
	jp	([*rbyt],y)	; 91 ECu10
	call	([*rbyt],y)	; 91 EDu10
	ld 	y,([*rbyt],y)	; 91 EEu10
	ld 	([*rbyt],y),y	; 91 EFu10

ngrp91_F:


	.page
	.sbttl	Page 92 ST7 Instructions with External symbols
ngrp92_0:
	btjt	[rbyt],#0,1$	; 92 00u10 1C
	btjf	[rbyt],#0,1$	; 92 01u10 18
	btjt	[rbyt],#1,1$	; 92 02u10 14
	btjf	[rbyt],#1,1$	; 92 03u10 10
	btjt	[rbyt],#2,1$	; 92 04u10 0C
	btjf	[rbyt],#2,1$	; 92 05u10 08
	btjt	[rbyt],#3,1$	; 92 06u10 04
	btjf	[rbyt],#3,1$	; 92 07u10 00
1$:	btjt	[rbyt],#4,1$	; 92 08u10 FC
	btjf	[rbyt],#4,1$	; 92 09u10 F8
	btjt	[rbyt],#5,1$	; 92 0Au10 F4
	btjf	[rbyt],#5,1$	; 92 0Bu10 F0
	btjt	[rbyt],#6,1$	; 92 0Cu10 EC
	btjf	[rbyt],#6,1$	; 92 0Du10 E8
	btjt	[rbyt],#7,1$	; 92 0Eu10 E4
	btjf	[rbyt],#7,1$	; 92 0Fu10 E0

ngrp92_1:
	bset	[rbyt],#0	; 92 10u10
	bres	[rbyt],#0	; 92 11u10
	bset	[rbyt],#1	; 92 12u10
	bres	[rbyt],#1	; 92 13u10
	bset	[rbyt],#2	; 92 14u10
	bres	[rbyt],#2	; 92 15u10
	bset	[rbyt],#3	; 92 16u10
	bres	[rbyt],#3	; 92 17u10
	bset	[rbyt],#4	; 92 18u10
	bres	[rbyt],#4	; 92 19u10
	bset	[rbyt],#5	; 92 1Au10
	bres	[rbyt],#5	; 92 1Bu10
	bset	[rbyt],#6	; 92 1Cu10
	bres	[rbyt],#6	; 92 1Du10
	bset	[rbyt],#7	; 92 1Eu10
	bres	[rbyt],#7	; 92 1Fu10

	.page

ngrp92_2:
	jra	[rbyt]		; 92 20u10
	jrf	[rbyt]		; 92 21u10
	jrugt	[rbyt]		; 92 22u10
	jrule	[rbyt]		; 92 23u10
	jrnc	[rbyt]		; 92 24u10
	jrc	[rbyt]		; 92 25u10
	jrne	[rbyt]		; 92 26u10
	jreq	[rbyt]		; 92 27u10
	jrnh	[rbyt]		; 92 28u10
	jrh	[rbyt]		; 92 29u10
	jrpl	[rbyt]		; 92 2Au10
	jrmi	[rbyt]		; 92 2Bu10
	jrnm	[rbyt]		; 92 2Cu10
	jrm	[rbyt]		; 92 2Du10
	jril	[rbyt]		; 92 2Eu10
	jrih	[rbyt]		; 92 2Fu10

ngrp92_3:
	neg	[rbyt]		; 92 30u10
				; 92 31
				; 92 32
	cpl	[rbyt]		; 92 33u10
	srl	[rbyt]		; 92 34u10
				; 92 35
	rrc	[rbyt]		; 92 36u10
	sra	[rbyt]		; 92 37u10
	sla	[rbyt]		; 92 38u10
	rlc	[rbyt]		; 92 39u10
	dec	[rbyt]		; 92 3Au10
				; 92 3B
	inc	[rbyt]		; 92 3Cu10
	tnz	[rbyt]		; 92 3Du10
	swap	[rbyt]		; 92 3Eu10
	clr	[rbyt]		; 92 3Fu10

	.page

ngrp92_4:

ngrp92_5:

ngrp92_6:
	neg	([rbyt],x)	; 92 60u10
				; 92 61
				; 92 62
	cpl	([rbyt],x)	; 92 63u10
	srl	([rbyt],x)	; 92 64u10
				; 92 65
	rrc	([rbyt],x)	; 92 66u10
	sra	([rbyt],x)	; 92 67u10
	sla	([rbyt],x)	; 92 68u10
	rlc	([rbyt],x)	; 92 69u10
	dec	([rbyt],x)	; 92 6Au10
				; 92 6B
	inc	([rbyt],x)	; 92 6Cu10
	tnz	([rbyt],x)	; 92 6Du10
	swap	([rbyt],x)	; 92 6Eu10
	clr	([rbyt],x)	; 92 6Fu10

ngrp92_7:

ngrp92_8:

ngrp92_9:

ngrp92_A:
	callr	[rbyt]		; 92 ADu10

	.page

ngrp92_B:
	sub	a,[*rbyt]	; 92 B0u10
	cp	a,[*rbyt]	; 92 B1u10
	sbc	a,[*rbyt]	; 92 B2u10
	cp	x,[*rbyt]	; 92 B3u10
	and	a,[*rbyt]	; 92 B4u10
	bcp	a,[*rbyt]	; 92 B5u10
	ld	a,[*rbyt]	; 92 B6u10
	ld	[*rbyt],a	; 92 B7u10
	xor	a,[*rbyt]	; 92 B8u10
	adc	a,[*rbyt]	; 92 B9u10
	or	a,[*rbyt]	; 92 BAu10
	add	a,[*rbyt]	; 92 BBu10
	jp	[*rbyt]		; 92 BCu10
	call	[*rbyt]		; 92 BDu10
	ld 	x,[*rbyt]	; 92 BEu10
	ld 	[*rbyt],x	; 92 BFu10

ngrp92_C:
	sub	a,[rbyt]	; 92 C0u10
	cp	a,[rbyt]	; 92 C1u10
	sbc	a,[rbyt]	; 92 C2u10
	cp	x,[rbyt]	; 92 C3u10
	and	a,[rbyt]	; 92 C4u10
	bcp	a,[rbyt]	; 92 C5u10
	ld	a,[rbyt]	; 92 C6u10
	ld	[rbyt],a	; 92 C7u10
	xor	a,[rbyt]	; 92 C8u10
	adc	a,[rbyt]	; 92 C9u10
	or	a,[rbyt]	; 92 CAu10
	add	a,[rbyt]	; 92 CBu10
	jp	[rbyt]		; 92 CCu10
	call	[rbyt]		; 92 CDu10
	ld 	x,[rbyt]	; 92 CEu10
	ld 	[rbyt],x	; 92 CFu10

		.page

ngrp92_D:
	sub	a,([rbyt],x)	; 92 D0u10
	cp	a,([rbyt],x)	; 92 D1u10
	sbc	a,([rbyt],x)	; 92 D2u10
	cp	x,([rbyt],x)	; 92 D3u10
	and	a,([rbyt],x)	; 92 D4u10
	bcp	a,([rbyt],x)	; 92 D5u10
	ld	a,([rbyt],x)	; 92 D6u10
	ld	([rbyt],x),a	; 92 D7u10
	xor	a,([rbyt],x)	; 92 D8u10
	adc	a,([rbyt],x)	; 92 D9u10
	or	a,([rbyt],x)	; 92 DAu10
	add	a,([rbyt],x)	; 92 DBu10
	jp	([rbyt],x)	; 92 DCu10
	call	([rbyt],x)	; 92 DDu10
	ld 	x,([rbyt],x)	; 92 DEu10
	ld 	([rbyt],x),x	; 92 DFu10

ngrp92_E:
	sub	a,([*rbyt],x)	; 92 E0u10
	cp	a,([*rbyt],x)	; 92 E1u10
	sbc	a,([*rbyt],x)	; 92 E2u10
	cp	x,([*rbyt],x)	; 92 E3u10
	and	a,([*rbyt],x)	; 92 E4u10
	bcp	a,([*rbyt],x)	; 92 E5u10
	ld	a,([*rbyt],x)	; 92 E6u10
	ld	([*rbyt],x),a	; 92 E7u10
	xor	a,([*rbyt],x)	; 92 E8u10
	adc	a,([*rbyt],x)	; 92 E9u10
	or	a,([*rbyt],x)	; 92 EAu10
	add	a,([*rbyt],x)	; 92 EBu10
	jp	([*rbyt],x)	; 92 ECu10
	call	([*rbyt],x)	; 92 EDu10
	ld 	x,([*rbyt],x)	; 92 EEu10
	ld 	([*rbyt],x),x	; 92 EFu10

ngrp92_F:

	.undefine	rbyt
	.undefine	rwrd


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

	.define	rbyt, /xbyt+0x10/
	.define	rwrd, /xwrd+0x5432/

xgrp0:
	btjt	rbyt,#0,1$	; 00u10 15
	btjf	rbyt,#0,1$	; 01u10 12
	btjt	rbyt,#1,1$	; 02u10 0F
	btjf	rbyt,#1,1$	; 03u10 0C
	btjt	rbyt,#2,1$	; 04u10 09
	btjf	rbyt,#2,1$	; 05u10 06
	btjt	rbyt,#3,1$	; 06u10 03
	btjf	rbyt,#3,1$	; 07u10 00
1$:	btjt	rbyt,#4,1$	; 08u10 FD
	btjf	rbyt,#4,1$	; 09u10 FA
	btjt	rbyt,#5,1$	; 0Au10 F7
	btjf	rbyt,#5,1$	; 0Bu10 F4
	btjt	rbyt,#6,1$	; 0Cu10 F1
	btjf	rbyt,#6,1$	; 0Du10 EE
	btjt	rbyt,#7,1$	; 0Eu10 EB
	btjf	rbyt,#7,1$	; 0Fu10 E8

xgrp1:
	bset	rbyt,#0		; 10u10
	bres	rbyt,#0		; 11u10
	bset	rbyt,#1		; 12u10
	bres	rbyt,#1		; 13u10
	bset	rbyt,#2		; 14u10
	bres	rbyt,#2		; 15u10
	bset	rbyt,#3		; 16u10
	bres	rbyt,#3		; 17u10
	bset	rbyt,#4		; 18u10
	bres	rbyt,#4		; 19u10
	bset	rbyt,#5		; 1Au10
	bres	rbyt,#5		; 1Bu10
	bset	rbyt,#6		; 1Cu10
	bres	rbyt,#6		; 1Du10
	bset	rbyt,#7		; 1Eu10
	bres	rbyt,#7		; 1Fu10

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
1$:	jrnh	1$		; 28 FE
	jrh	1$		; 29 FC
	jrpl	1$		; 2A FA
	jrmi	1$		; 2B F8
	jrnm	1$		; 2C F6
	jrm	1$		; 2D F4
	jril	1$		; 2E F2
	jrih	1$		; 2F F0

xgrp3:
	neg	rbyt		; 30u10
				; 31
				; 32
	cpl	rbyt		; 33u10
	srl	rbyt		; 34u10
				; 35
	rrc	rbyt		; 36u10
	sra	rbyt		; 37u10
	sla	rbyt		; 38u10
	rlc	rbyt		; 39u10
	dec	rbyt		; 3Au10
				; 3B
	inc	rbyt		; 3Cu10
	tnz	rbyt		; 3Du10
	swap	rbyt		; 3Eu10
	clr	rbyt		; 3Fu10

	.page

xgrp4:
	neg	a		; 40
				; 41
	mul	x,a		; 42
	cpl	a		; 43
	srl	a		; 44
				; 45
	rrc	a		; 46
	sra	a		; 47
	sla	a		; 48
	rlc	a		; 49
	dec	a		; 4A
				; 4B
	inc	a		; 4C
	tnz	a		; 4D
	swap	a		; 4E
	clr	a		; 4F

xgrp5:
	neg	x		; 50
				; 51
				; 52
	cpl	x		; 53
	srl	x		; 54
				; 55
	rrc	x		; 56
	sra	x		; 57
	sla	x		; 58
	rlc	x		; 59
	dec	x		; 5A
				; 5B
	inc	x		; 5C
	tnz	x		; 5D
	swap	x		; 5E
	clr	x		; 5F

	.page

xgrp6:
	neg	(rbyt,x)	; 60u10
				; 61
				; 62
	cpl	(rbyt,x)	; 63u10
	srl	(rbyt,x)	; 64u10
				; 65
	rrc	(rbyt,x)	; 66u10
	sra	(rbyt,x)	; 67u10
	sla	(rbyt,x)	; 68u10
	rlc	(rbyt,x)	; 69u10
	dec	(rbyt,x)	; 6Au10
				; 6B
	inc	(rbyt,x)	; 6Cu10
	tnz	(rbyt,x)	; 6Du10
	swap	(rbyt,x)	; 6Eu10
	clr	(rbyt,x)	; 6Fu10

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
				; 7B
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
	pop	x		; 85
	pop	cc		; 86
				; 87
	push	a		; 88
	push	x		; 89
	push	cc		; 8A
				; 8B
				; 8C
				; 8D
	halt			; 8E
	wfi			; 8F

xgrp9:
				; 90
				; 91
				; 92
	ld	x,y		; 93
	ld	s,x		; 94
	ld	s,a		; 95
	ld	x,s		; 96
	ld	x,a		; 97
	rcf			; 98
	scf			; 99
	rim			; 9A
	sim			; 9B
	rsp			; 9C
	nop			; 9D
	ld	a,s		; 9E
	ld	a,x		; 9F

	.page

xgrpA:
	sub	a,#rbyt		; A0r10
	cp	a,#rbyt		; A1r10
	sbc	a,#rbyt		; A2r10
	cp	x,#rbyt		; A3r10
	and	a,#rbyt		; A4r10
	bcp	a,#rbyt		; A5r10
	ld	a,#rbyt		; A6r10
				; A7
	xor	a,#rbyt		; A8r10
	adc	a,#rbyt		; A9r10
	or	a,#rbyt		; AAr10
	add	a,#rbyt		; ABr10
				; AC
1$:	callr	1$		; AD FE
	ld	x,#rbyt		; AEr10

xgrpB:
	sub	a,rbyt		; C0v00u10
	cp	a,rbyt		; C1v00u10
	sbc	a,rbyt		; C2v00u10
	cp	x,rbyt		; C3v00u10
	and	a,rbyt		; C4v00u10
	bcp	a,rbyt		; C5v00u10
	ld	a,rbyt		; C6v00u10
	ld	rbyt,a		; C7v00u10
	xor	a,rbyt		; C8v00u10
	adc	a,rbyt		; C9v00u10
	or	a,rbyt		; CAv00u10
	add	a,rbyt		; CBv00u10
	jp	rbyt		; CCv00u10
	call	rbyt		; CDv00u10
	ld	x,rbyt		; CEv00u10
	ld	rbyt,x		; CFv00u10

	.page

xgrpC:
	sub	a,rwrd		; C0v54u32
	cp	a,rwrd		; C1v54u32
	sbc	a,rwrd		; C2v54u32
	cp	x,rwrd		; C3v54u32
	and	a,rwrd		; C4v54u32
	bcp	a,rwrd		; C5v54u32
	ld	a,rwrd		; C6v54u32
	ld	rwrd,a		; C7v54u32
	xor	a,rwrd		; C8v54u32
	adc	a,rwrd		; C9v54u32
	or	a,rwrd		; CAv54u32
	add	a,rwrd		; CBv54u32
	jp	rwrd		; CCv54u32
	call	rwrd		; CDv54u32
	ld	x,rwrd		; CEv54u32
	ld	rwrd,x		; CFv54u32

xgrpD:
	sub	a,(rwrd,x)	; D0v54u32
	cp	a,(rwrd,x)	; D1v54u32
	sbc	a,(rwrd,x)	; D2v54u32
	cp	x,(rwrd,x)	; D3v54u32
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
	ld	x,(rwrd,x)	; DEv54u32
	ld	(rwrd,x),x	; DFv54u32

	.page

xgrpE:
	sub	a,(rbyt,x)	; D0v00u10
	cp	a,(rbyt,x)	; D1v00u10
	sbc	a,(rbyt,x)	; D2v00u10
	cp	x,(rbyt,x)	; D3v00u10
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
	ld	x,(rbyt,x)	; DEv00u10
	ld	(rbyt,x),x	; DFv00u10

xgrpF:
	sub	a,(x)		; F0
	cp	a,(x)		; F1
	sbc	a,(x)		; F2
	cp	x,(x)		; F3
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
	ld	x,(x)		; FE
	ld	(x),x		; FF


	.page
	.sbttl	Page 90 ST7 Instructions External 1-Byte Promotion to 2-Byte

xgrp90_0:

xgrp90_1:

xgrp90_2:

xgrp90_3:

xgrp90_4:
	mul	y,a		; 90 42

xgrp90_5:
	neg	y		; 90 50
				; 90 51
				; 90 52
	cpl	y		; 90 53
	srl	y		; 90 54
				; 90 55
	rrc	y		; 90 56
	sra	y		; 90 57
	sla	y		; 90 58
	rlc	y		; 90 59
	dec	y		; 90 5A
				; 90 5B
	inc	y		; 90 5C
	tnz	y		; 90 5D
	swap	y		; 90 5E
	clr	y		; 90 5F

.page

xgrp90_6:
	neg	(rbyt,y)	; 90 60u10
				; 90 61
				; 90 62
	cpl	(rbyt,y)	; 90 63u10
	srl	(rbyt,y)	; 90 64u10
				; 90 65
	rrc	(rbyt,y)	; 90 66u10
	sra	(rbyt,y)	; 90 67u10
	sla	(rbyt,y)	; 90 68u10
	rlc	(rbyt,y)	; 90 69u10
	dec	(rbyt,y)	; 90 6Au10
				; 90 6B
	inc	(rbyt,y)	; 90 6Cu10
	tnz	(rbyt,y)	; 90 6Du10
	swap	(rbyt,y)	; 90 6Eu10
	clr	(rbyt,y)	; 90 6Fu10

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
	pop	y		; 90 85
	push	y		; 90 89

xgrp90_9:
	ld	y,x		; 90 93
	ld	s,y		; 90 94
	ld	y,s		; 90 96
	ld	y,a		; 90 97
	ld	a,y		; 90 9F

xgrp90_A:
	cp	y,#rbyt		; 90 A3r10
	ld	y,#rbyt		; 90 AEr10

xgrp90_B:
	cp	y,rbyt		; 90 C3v00u10
	ld	y,rbyt		; 90 CEv00u10
	ld	rbyt,y		; 90 CFv00u10

xgrp90_C:
	cp	y,rwrd		; 90 C3v54u32
	ld	y,rwrd		; 90 CEv54u32
	ld	rwrd,y		; 90 CFv54u32

xgrp90_D:
	sub	a,(rwrd,y)	; 90 D0v54u32
	cp	a,(rwrd,y)	; 90 D1v54u32
	sbc	a,(rwrd,y)	; 90 D2v54u32
	cp	y,(rwrd,y)	; 90 D3v54u32
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
	ld 	y,(rwrd,y)	; 90 DEv54u32
	ld 	(rwrd,y),y	; 90 DFv54u32

	.page

xgrp90_E:
	sub	a,(rbyt,y)	; 90 D0v00u10
	cp	a,(rbyt,y)	; 90 D1v00u10
	sbc	a,(rbyt,y)	; 90 D2v00u10
	cp	y,(rbyt,y)	; 90 D3v00u10
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
	ld 	y,(rbyt,y)	; 90 DEv00u10
	ld 	(rbyt,y),y	; 90 DFv00u10

xgrp90_F:
	sub	a,(y)		; 90 F0
	cp	a,(y)		; 90 F1
	sbc	a,(y)		; 90 F2
	cp	y,(y)		; 90 F3
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
	ld 	y,(y)		; 90 FE
	ld 	(y),y		; 90 FF


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

xgrp91_B:
	cp	y,[rbyt]	; 91 C3u10
	ld	y,[rbyt]	; 91 CEu10
	ld	[rbyt],y	; 91 CFu10

xgrp91_C:
	cp	y,[rbyt]	; 91 C3u10
	ld	y,[rbyt]	; 91 CEu10
	ld	[rbyt],y	; 91 CFu10

xgrp91_D:
	sub	a,([rbyt],y)	; 91 D0u10
	cp	a,([rbyt],y)	; 91 D1u10
	sbc	a,([rbyt],y)	; 91 D2u10
	cp	y,([rbyt],y)	; 91 D3u10
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
	ld 	y,([rbyt],y)	; 91 DEu10
	ld 	([rbyt],y),y	; 91 DFu10

xgrp91_E:
	sub	a,([rbyt],y)	; 91 D0u10
	cp	a,([rbyt],y)	; 91 D1u10
	sbc	a,([rbyt],y)	; 91 D2u10
	cp	y,([rbyt],y)	; 91 D3u10
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
	ld 	y,([rbyt],y)	; 91 DEu10
	ld 	([rbyt],y),y	; 91 DFu10

xgrp91_F:


	.page
	.sbttl	Page 92 ST7 Instructions External 1-Byte Promotion to 2-Byte

xgrp92_0:
	btjt	[rbyt],#0,1$	; 92 00u10 1C
	btjf	[rbyt],#0,1$	; 92 01u10 18
	btjt	[rbyt],#1,1$	; 92 02u10 14
	btjf	[rbyt],#1,1$	; 92 03u10 10
	btjt	[rbyt],#2,1$	; 92 04u10 0C
	btjf	[rbyt],#2,1$	; 92 05u10 08
	btjt	[rbyt],#3,1$	; 92 06u10 04
	btjf	[rbyt],#3,1$	; 92 07u10 00
1$:	btjt	[rbyt],#4,1$	; 92 08u10 FC
	btjf	[rbyt],#4,1$	; 92 09u10 F8
	btjt	[rbyt],#5,1$	; 92 0Au10 F4
	btjf	[rbyt],#5,1$	; 92 0Bu10 F0
	btjt	[rbyt],#6,1$	; 92 0Cu10 EC
	btjf	[rbyt],#6,1$	; 92 0Du10 E8
	btjt	[rbyt],#7,1$	; 92 0Eu10 E4
	btjf	[rbyt],#7,1$	; 92 0Fu10 E0

xgrp92_1:
	bset	[rbyt],#0	; 92 10u10
	bres	[rbyt],#0	; 92 11u10
	bset	[rbyt],#1	; 92 12u10
	bres	[rbyt],#1	; 92 13u10
	bset	[rbyt],#2	; 92 14u10
	bres	[rbyt],#2	; 92 15u10
	bset	[rbyt],#3	; 92 16u10
	bres	[rbyt],#3	; 92 17u10
	bset	[rbyt],#4	; 92 18u10
	bres	[rbyt],#4	; 92 19u10
	bset	[rbyt],#5	; 92 1Au10
	bres	[rbyt],#5	; 92 1Bu10
	bset	[rbyt],#6	; 92 1Cu10
	bres	[rbyt],#6	; 92 1Du10
	bset	[rbyt],#7	; 92 1Eu10
	bres	[rbyt],#7	; 92 1Fu10

	.page

xgrp92_2:
	jra	[rbyt]		; 92 20u10
	jrf	[rbyt]		; 92 21u10
	jrugt	[rbyt]		; 92 22u10
	jrule	[rbyt]		; 92 23u10
	jrnc	[rbyt]		; 92 24u10
	jrc	[rbyt]		; 92 25u10
	jrne	[rbyt]		; 92 26u10
	jreq	[rbyt]		; 92 27u10
	jrnh	[rbyt]		; 92 28u10
	jrh	[rbyt]		; 92 29u10
	jrpl	[rbyt]		; 92 2Au10
	jrmi	[rbyt]		; 92 2Bu10
	jrnm	[rbyt]		; 92 2Cu10
	jrm	[rbyt]		; 92 2Du10
	jril	[rbyt]		; 92 2Eu10
	jrih	[rbyt]		; 92 2Fu10

xgrp92_3:
	neg	[rbyt]		; 92 30u10
				; 92 31
				; 92 32
	cpl	[rbyt]		; 92 33u10
	srl	[rbyt]		; 92 34u10
				; 92 35
	rrc	[rbyt]		; 92 36u10
	sra	[rbyt]		; 92 37u10
	sla	[rbyt]		; 92 38u10
	rlc	[rbyt]		; 92 39u10
	dec	[rbyt]		; 92 3Au10
				; 92 3B
	inc	[rbyt]		; 92 3Cu10
	tnz	[rbyt]		; 92 3Du10
	swap	[rbyt]		; 92 3Eu10
	clr	[rbyt]		; 92 3Fu10

	.page

xgrp92_4:

xgrp92_5:

xgrp92_6:
	neg	([rbyt],x)	; 92 60u10
				; 92 61
				; 92 62
	cpl	([rbyt],x)	; 92 63u10
	srl	([rbyt],x)	; 92 64u10
				; 92 65
	rrc	([rbyt],x)	; 92 66u10
	sra	([rbyt],x)	; 92 67u10
	sla	([rbyt],x)	; 92 68u10
	rlc	([rbyt],x)	; 92 69u10
	dec	([rbyt],x)	; 92 6Au10
				; 92 6B
	inc	([rbyt],x)	; 92 6Cu10
	tnz	([rbyt],x)	; 92 6Du10
	swap	([rbyt],x)	; 92 6Eu10
	clr	([rbyt],x)	; 92 6Fu10

xgrp92_7:

xgrp92_8:

xgrp92_9:

xgrp92_A:
	callr	[rbyt]		; 92 ADu10

	.page

xgrp92_B:
	sub	a,[rbyt]	; 92 C0u10
	cp	a,[rbyt]	; 92 C1u10
	sbc	a,[rbyt]	; 92 C2u10
	cp	x,[rbyt]	; 92 C3u10
	and	a,[rbyt]	; 92 C4u10
	bcp	a,[rbyt]	; 92 C5u10
	ld	a,[rbyt]	; 92 C6u10
	ld	[rbyt],a	; 92 C7u10
	xor	a,[rbyt]	; 92 C8u10
	adc	a,[rbyt]	; 92 C9u10
	or	a,[rbyt]	; 92 CAu10
	add	a,[rbyt]	; 92 CBu10
	jp	[rbyt]		; 92 CCu10
	call	[rbyt]		; 92 CDu10
	ld 	x,[rbyt]	; 92 CEu10
	ld 	[rbyt],x	; 92 CFu10

xgrp92_C:
	sub	a,[rbyt]	; 92 C0u10
	cp	a,[rbyt]	; 92 C1u10
	sbc	a,[rbyt]	; 92 C2u10
	cp	x,[rbyt]	; 92 C3u10
	and	a,[rbyt]	; 92 C4u10
	bcp	a,[rbyt]	; 92 C5u10
	ld	a,[rbyt]	; 92 C6u10
	ld	[rbyt],a	; 92 C7u10
	xor	a,[rbyt]	; 92 C8u10
	adc	a,[rbyt]	; 92 C9u10
	or	a,[rbyt]	; 92 CAu10
	add	a,[rbyt]	; 92 CBu10
	jp	[rbyt]		; 92 CCu10
	call	[rbyt]		; 92 CDu10
	ld 	x,[rbyt]	; 92 CEu10
	ld 	[rbyt],x	; 92 CFu10

		.page

xgrp92_D:
	sub	a,([rbyt],x)	; 92 D0u10
	cp	a,([rbyt],x)	; 92 D1u10
	sbc	a,([rbyt],x)	; 92 D2u10
	cp	x,([rbyt],x)	; 92 D3u10
	and	a,([rbyt],x)	; 92 D4u10
	bcp	a,([rbyt],x)	; 92 D5u10
	ld	a,([rbyt],x)	; 92 D6u10
	ld	([rbyt],x),a	; 92 D7u10
	xor	a,([rbyt],x)	; 92 D8u10
	adc	a,([rbyt],x)	; 92 D9u10
	or	a,([rbyt],x)	; 92 DAu10
	add	a,([rbyt],x)	; 92 DBu10
	jp	([rbyt],x)	; 92 DCu10
	call	([rbyt],x)	; 92 DDu10
	ld 	x,([rbyt],x)	; 92 DEu10
	ld 	([rbyt],x),x	; 92 DFu10

xgrp92_E:
	sub	a,([rbyt],x)	; 92 D0u10
	cp	a,([rbyt],x)	; 92 D1u10
	sbc	a,([rbyt],x)	; 92 D2u10
	cp	x,([rbyt],x)	; 92 D3u10
	and	a,([rbyt],x)	; 92 D4u10
	bcp	a,([rbyt],x)	; 92 D5u10
	ld	a,([rbyt],x)	; 92 D6u10
	ld	([rbyt],x),a	; 92 D7u10
	xor	a,([rbyt],x)	; 92 D8u10
	adc	a,([rbyt],x)	; 92 D9u10
	or	a,([rbyt],x)	; 92 DAu10
	add	a,([rbyt],x)	; 92 DBu10
	jp	([rbyt],x)	; 92 DCu10
	call	([rbyt],x)	; 92 DDu10
	ld 	x,([rbyt],x)	; 92 DEu10
	ld 	([rbyt],x),x	; 92 DFu10

xgrp92_F:

	.undefine	rbyt
	.undefine	rwrd

	.end

