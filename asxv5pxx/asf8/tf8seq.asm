	.title	F8  Sequential Test

	.area	Prog(rel,con)


	abyt	=	0x0010		; Absolute 1-Byte Value
	awrd	=	0x0430		; Absolute 2-Byte Value

	.globl	extb, extw		; External Global Values

	.define	xbyt,/extb + 0x0010/	; External Relocatable 1-Byte Value
	.define	xwrd,/extw + 0x0430/	; External Relocatable 2-Byte Value


	.page
	.sbttl	Sequential With Absolutes

	lr	a,ku		; 00
	lr	a,kl		; 01
	lr	a,qu		; 02
	lr	a,ql		; 03
	lr	ku,a		; 04
	lr	kl,a		; 05
	lr	qu,a		; 06
	lr	ql,a		; 07
	lr	k,p		; 08
	lr	p,k		; 09
	lr	a,is		; 0A
	lr	is,a		; 0B
	pk			; 0C
	lr	p0,q		; 0D
	lr	q,dc		; 0E
	lr	dc,q		; 0F

	lr	dc,h		; 10
	lr	h,dc		; 11
	sr	#1		; 12
	sl	#1		; 13
	sr	#4		; 14
	sl	#4		; 15
	lm			; 16
	st			; 17
	com			; 18
	lnk			; 19
	di			; 1A
	ei			; 1B
	pop			; 1C
	lr	w,j		; 1D
	lr	j,w		; 1E
	inc			; 1F

	li	#abyt		; 20 10
	ni	#abyt		; 21 10
	oi	#abyt		; 22 10
	xi	#abyt		; 23 10
	ai	#abyt		; 24 10
	ci	#abyt		; 25 10
	in	#4		; 26 04
	out	#5		; 27 05
	pi	#awrd		; 28 04 30
	jmp	awrd		; 29 04 30
	dci	#awrd		; 2A 04 30
	nop			; 2B
	xdc			; 2C
				; 2D
				; 2E
				; 2F

	ds	r0		; 30
	ds	r1		; 31
	ds	r2		; 32
	ds	r3		; 33
	ds	r4		; 34
	ds	r5		; 35
	ds	r6		; 36
	ds	r7		; 37
	ds	r8		; 38
	ds	j		; 39
	ds	hu		; 3A
	ds	hl		; 3B
	ds	s		; 3C
	ds	i		; 3D
	ds	d		; 3E
				; 3F

	lr	a,r0		; 40
	lr	a,r1		; 41
	lr	a,r2		; 42
	lr	a,r3		; 43
	lr	a,r4		; 44
	lr	a,r5		; 45
	lr	a,r6		; 46
	lr	a,r7		; 47
	lr	a,r8		; 48
	lr	a,r9		; 49
	lr	a,r10		; 4A
	lr	a,r11		; 4B
	lr	a,s		; 4C
	lr	a,i		; 4D
	lr	a,d		; 4E
				; 4F

	lr	r0,a		; 50
	lr	r1,a		; 51
	lr	r2,a		; 52
	lr	r3,a		; 53
	lr	r4,a		; 54
	lr	r5,a		; 55
	lr	r6,a		; 56
	lr	r7,a		; 57
	lr	r8,a		; 58
	lr	r9,a		; 59
	lr	r10,a		; 5A
	lr	r11,a		; 5B
	lr	s,a		; 5C
	lr	i,a		; 5D
	lr	d,a		; 5E
				; 5F

	lisl	#0		; 60
	lisl	#1		; 61
	lisl	#2		; 62
	lisl	#3		; 63
	lisl	#4		; 64
	lisl	#5		; 65
	lisl	#6		; 66
	lisl	#7		; 67
	lisu	#0		; 68
	lisu	#1		; 69
	lisu	#2		; 6A
	lisu	#3		; 6B
	lisu	#4		; 6C
	lisu	#5		; 6D
	lisu	#6		; 6E
	lisu	#7		; 6F

	clr			; 70
	lis	#0x01		; 71
	lis	#0x02		; 72
	lis	#0x03		; 73
	lis	#0x04		; 74
	lis	#0x05		; 75
	lis	#0x06		; 76
	lis	#0x07		; 77
	lis	#0x08		; 78
	lis	#0x09		; 79
	lis	#0x0A		; 7A
	lis	#0x0B		; 7B
	lis	#0x0C		; 7C
	lis	#0x0D		; 7D
	lis	#0x0E		; 7E
	lis	#0x0F		; 7F

	bt	#0x00,.		; 80 FE
	bp	.		; 81 FE
	bc	.		; 82 FE
	bt	#0x03,.		; 83 FE
	bz	.		; 84 FE
	bt	#0x05,.		; 85 FE
	bt	#0x06,.		; 86 FE
	bt	#0x07,.		; 87 FE
	am			; 88
	amd			; 89
	nm			; 8A
	om			; 8B
	xm			; 8C
	cm			; 8D
	adc			; 8E
	br7	.		; 8F FE

	br	.		; 90 FE
	bm	.		; 91 FE
	bnc	.		; 92 FE
	bf	#0x03,.		; 93 FE
	bnz	.		; 94 FE
	bf	#0x05,.		; 95 FE
	bf	#0x06,.		; 96 FE
	bf	#0x07,.		; 97 FE
	bno	.		; 98 FE
	bf	#0x09,.		; 99 FE
	bf	#0x0A,.		; 9A FE
	bf	#0x0B,.		; 9B FE
	bf	#0x0C,.		; 9C FE
	bf	#0x0D,.		; 9D FE
	bf	#0x0E,.		; 9E FE
	bf	#0x0F,.		; 9F FE

	ins	#0x00		; A0
	ins	#0x01		; A1
	ins	#0x02		; A2
	ins	#0x03		; A3
	ins	#0x04		; A4
	ins	#0x05		; A5
	ins	#0x06		; A6
	ins	#0x07		; A7
	ins	#0x08		; A8
	ins	#0x09		; A9
	ins	#0x0A		; AA
	ins	#0x0B		; AB
	ins	#0x0C		; AC
	ins	#0x0D		; AD
	ins	#0x0E		; AE
	ins	#0x0F		; AF

	outs	#0x00		; B0
	outs	#0x01		; B1
	outs	#0x02		; B2
	outs	#0x03		; B3
	outs	#0x04		; B4
	outs	#0x05		; B5
	outs	#0x06		; B6
	outs	#0x07		; B7
	outs	#0x08		; B8
	outs	#0x09		; B9
	outs	#0x0A		; BA
	outs	#0x0B		; BB
	outs	#0x0C		; BC
	outs	#0x0D		; BD
	outs	#0x0E		; BE
	outs	#0x0F		; BF

	as	r0		; C0
	as	r1		; C1
	as	r2		; C2
	as	r3		; C3
	as	r4		; C4
	as	r5		; C5
	as	r6		; C6
	as	r7		; C7
	as	r8		; C8
	as	j		; C9
	as	hu		; CA
	as	hl		; CB
	as	s		; CC
	as	i		; CD
	as	d		; CE
				; CF

	asd	r0		; D0
	asd	r1		; D1
	asd	r2		; D2
	asd	r3		; D3
	asd	r4		; D4
	asd	r5		; D5
	asd	r6		; D6
	asd	r7		; D7
	asd	r8		; D8
	asd	j		; D9
	asd	hu		; DA
	asd	hl		; DB
	asd	s		; DC
	asd	i		; DD
	asd	d		; DE
				; DF

	xs	r0		; E0
	xs	r1		; E1
	xs	r2		; E2
	xs	r3		; E3
	xs	r4		; E4
	xs	r5		; E5
	xs	r6		; E6
	xs	r7		; E7
	xs	r8		; E8
	xs	j		; E9
	xs	hu		; EA
	xs	hl		; EB
	xs	s		; EC
	xs	i		; ED
	xs	d		; EE
				; EF

	ns	r0		; F0
	ns	r1		; F1
	ns	r2		; F2
	ns	r3		; F3
	ns	r4		; F4
	ns	r5		; F5
	ns	r6		; F6
	ns	r7		; F7
	ns	r8		; F8
	ns	j		; F9
	ns	hu		; FA
	ns	hl		; FB
	ns	s		; FC
	ns	i		; FD
	ns	d		; FE
				; FF


	.page
	.sbttl	Sequential With Relocatables

	lr	a,ku		; 00
	lr	a,kl		; 01
	lr	a,qu		; 02
	lr	a,ql		; 03
	lr	ku,a		; 04
	lr	kl,a		; 05
	lr	qu,a		; 06
	lr	ql,a		; 07
	lr	k,p		; 08
	lr	p,k		; 09
	lr	a,is		; 0A
	lr	is,a		; 0B
	pk			; 0C
	lr	p0,q		; 0D
	lr	q,dc		; 0E
	lr	dc,q		; 0F

	lr	dc,h		; 10
	lr	h,dc		; 11
	sr1			; 12
	sl1			; 13
	sr4			; 14
	sl4			; 15
	lm			; 16
	st			; 17
	com			; 18
	lnk			; 19
	di			; 1A
	ei			; 1B
	pop			; 1C
	lr	w,j		; 1D
	lr	j,w		; 1E
	inc			; 1F

	li	#xbyt		; 20r10
	ni	#xbyt		; 21r10
	oi	#xbyt		; 22r10
	xi	#xbyt		; 23r10
	ai	#xbyt		; 24r10
	ci	#xbyt		; 25r10
	in	#4		; 26 04
	out	#5		; 27 05
	pi	#xwrd		; 28s04r30
	jmp	xwrd		; 29s04r30
	dci	#xwrd		; 2As04r30
	nop			; 2B
	xdc			; 2C
				; 2D
				; 2E
				; 2F

	ds	r0		; 30
	ds	r1		; 31
	ds	r2		; 32
	ds	r3		; 33
	ds	r4		; 34
	ds	r5		; 35
	ds	r6		; 36
	ds	r7		; 37
	ds	r8		; 38
	ds	j		; 39
	ds	hu		; 3A
	ds	hl		; 3B
	ds	s		; 3C
	ds	i		; 3D
	ds	d		; 3E
				; 3F

	lr	a,r0		; 40
	lr	a,r1		; 41
	lr	a,r2		; 42
	lr	a,r3		; 43
	lr	a,r4		; 44
	lr	a,r5		; 45
	lr	a,r6		; 46
	lr	a,r7		; 47
	lr	a,r8		; 48
	lr	a,r9		; 49
	lr	a,r10		; 4A
	lr	a,r11		; 4B
	lr	a,s		; 4C
	lr	a,i		; 4D
	lr	a,d		; 4E
				; 4F

	lr	r0,a		; 50
	lr	r1,a		; 51
	lr	r2,a		; 52
	lr	r3,a		; 53
	lr	r4,a		; 54
	lr	r5,a		; 55
	lr	r6,a		; 56
	lr	r7,a		; 57
	lr	r8,a		; 58
	lr	r9,a		; 59
	lr	r10,a		; 5A
	lr	r11,a		; 5B
	lr	s,a		; 5C
	lr	i,a		; 5D
	lr	d,a		; 5E
				; 5F

	lisl	#0		; 60
	lisl	#1		; 61
	lisl	#2		; 62
	lisl	#3		; 63
	lisl	#4		; 64
	lisl	#5		; 65
	lisl	#6		; 66
	lisl	#7		; 67
	lisu	#0		; 68
	lisu	#1		; 69
	lisu	#2		; 6A
	lisu	#3		; 6B
	lisu	#4		; 6C
	lisu	#5		; 6D
	lisu	#6		; 6E
	lisu	#7		; 6F

	clr			; 70
	lis	#0x01		; 71
	lis	#0x02		; 72
	lis	#0x03		; 73
	lis	#0x04		; 74
	lis	#0x05		; 75
	lis	#0x06		; 76
	lis	#0x07		; 77
	lis	#0x08		; 78
	lis	#0x09		; 79
	lis	#0x0A		; 7A
	lis	#0x0B		; 7B
	lis	#0x0C		; 7C
	lis	#0x0D		; 7D
	lis	#0x0E		; 7E
	lis	#0x0F		; 7F

	bt	#0x00,.		; 80 FE
	bp	.		; 81 FE
	bc	.		; 82 FE
	bt	#0x03,.		; 83 FE
	bz	.		; 84 FE
	bt	#0x05,.		; 85 FE
	bt	#0x06,.		; 86 FE
	bt	#0x07,.		; 87 FE
	am			; 88
	amd			; 89
	nm			; 8A
	om			; 8B
	xm			; 8C
	cm			; 8D
	adc			; 8E
	br7	.		; 8F FE

	br	.		; 90 FE
	bm	.		; 91 FE
	bnc	.		; 92 FE
	bf	#0x03,.		; 93 FE
	bnz	.		; 94 FE
	bf	#0x05,.		; 95 FE
	bf	#0x06,.		; 96 FE
	bf	#0x07,.		; 97 FE
	bno	.		; 98 FE
	bf	#0x09,.		; 99 FE
	bf	#0x0A,.		; 9A FE
	bf	#0x0B,.		; 9B FE
	bf	#0x0C,.		; 9C FE
	bf	#0x0D,.		; 9D FE
	bf	#0x0E,.		; 9E FE
	bf	#0x0F,.		; 9F FE

	ins	#0x00		; A0
	ins	#0x01		; A1
	ins	#0x02		; A2
	ins	#0x03		; A3
	ins	#0x04		; A4
	ins	#0x05		; A5
	ins	#0x06		; A6
	ins	#0x07		; A7
	ins	#0x08		; A8
	ins	#0x09		; A9
	ins	#0x0A		; AA
	ins	#0x0B		; AB
	ins	#0x0C		; AC
	ins	#0x0D		; AD
	ins	#0x0E		; AE
	ins	#0x0F		; AF

	outs	#0x00		; B0
	outs	#0x01		; B1
	outs	#0x02		; B2
	outs	#0x03		; B3
	outs	#0x04		; B4
	outs	#0x05		; B5
	outs	#0x06		; B6
	outs	#0x07		; B7
	outs	#0x08		; B8
	outs	#0x09		; B9
	outs	#0x0A		; BA
	outs	#0x0B		; BB
	outs	#0x0C		; BC
	outs	#0x0D		; BD
	outs	#0x0E		; BE
	outs	#0x0F		; BF

	as	r0		; C0
	as	r1		; C1
	as	r2		; C2
	as	r3		; C3
	as	r4		; C4
	as	r5		; C5
	as	r6		; C6
	as	r7		; C7
	as	r8		; C8
	as	j		; C9
	as	hu		; CA
	as	hl		; CB
	as	s		; CC
	as	i		; CD
	as	d		; CE
				; CF

	asd	r0		; D0
	asd	r1		; D1
	asd	r2		; D2
	asd	r3		; D3
	asd	r4		; D4
	asd	r5		; D5
	asd	r6		; D6
	asd	r7		; D7
	asd	r8		; D8
	asd	j		; D9
	asd	hu		; DA
	asd	hl		; DB
	asd	s		; DC
	asd	i		; DD
	asd	d		; DE
				; DF

	xs	r0		; E0
	xs	r1		; E1
	xs	r2		; E2
	xs	r3		; E3
	xs	r4		; E4
	xs	r5		; E5
	xs	r6		; E6
	xs	r7		; E7
	xs	r8		; E8
	xs	j		; E9
	xs	hu		; EA
	xs	hl		; EB
	xs	s		; EC
	xs	i		; ED
	xs	d		; EE
				; EF

	ns	r0		; F0
	ns	r1		; F1
	ns	r2		; F2
	ns	r3		; F3
	ns	r4		; F4
	ns	r5		; F5
	ns	r6		; F6
	ns	r7		; F7
	ns	r8		; F8
	ns	j		; F9
	ns	hu		; FA
	ns	hl		; FB
	ns	s		; FC
	ns	i		; FD
	ns	d		; FE
				; FF


	.page
	.sbttl	Sequential With Absolutes (Alternate Modes)

	lr	a,ku		; 00
	lr	a,kl		; 01
	lr	a,qu		; 02
	lr	a,ql		; 03
	lr	ku,a		; 04
	lr	kl,a		; 05
	lr	qu,a		; 06
	lr	ql,a		; 07
	lr	k,p		; 08
	lr	p,k		; 09
	lr	a,is		; 0A
	lr	is,a		; 0B
	pk			; 0C
	lr	p0,q		; 0D
	lr	q,dc		; 0E
	lr	dc,q		; 0F

	lr	dc,h		; 10
	lr	h,dc		; 11
	sr	1		; 12
	sl	1		; 13
	sr	4		; 14
	sl	4		; 15
	lm			; 16
	st			; 17
	com			; 18
	lnk			; 19
	di			; 1A
	ei			; 1B
	pop			; 1C
	lr	w,j		; 1D
	lr	j,w		; 1E
	inc			; 1F

	li	abyt		; 20 10
	ni	abyt		; 21 10
	oi	abyt		; 22 10
	xi	abyt		; 23 10
	ai	abyt		; 24 10
	ci	abyt		; 25 10
	in	4		; 26 04
	out	5		; 27 05
	pi	awrd		; 28 04 30
	jmp	awrd		; 29 04 30
	dci	awrd		; 2A 04 30
	nop			; 2B
	xdc			; 2C
				; 2D
				; 2E
				; 2F

	ds	r0		; 30
	ds	r1		; 31
	ds	r2		; 32
	ds	r3		; 33
	ds	r4		; 34
	ds	r5		; 35
	ds	r6		; 36
	ds	r7		; 37
	ds	r8		; 38
	ds	r9		; 39
	ds	r10		; 3A
	ds	r11		; 3B
	ds	s		; 3C
	ds	i		; 3D
	ds	d		; 3E
				; 3F

	lr	a,r0		; 40
	lr	a,r1		; 41
	lr	a,r2		; 42
	lr	a,r3		; 43
	lr	a,r4		; 44
	lr	a,r5		; 45
	lr	a,r6		; 46
	lr	a,r7		; 47
	lr	a,r8		; 48
	lr	a,r9		; 49
	lr	a,r10		; 4A
	lr	a,r11		; 4B
	lr	a,s		; 4C
	lr	a,i		; 4D
	lr	a,d		; 4E
				; 4F

	lr	r0,a		; 50
	lr	r1,a		; 51
	lr	r2,a		; 52
	lr	r3,a		; 53
	lr	r4,a		; 54
	lr	r5,a		; 55
	lr	r6,a		; 56
	lr	r7,a		; 57
	lr	r8,a		; 58
	lr	r9,a		; 59
	lr	r10,a		; 5A
	lr	r11,a		; 5B
	lr	s,a		; 5C
	lr	i,a		; 5D
	lr	d,a		; 5E
				; 5F

	lisl	0		; 60
	lisl	1		; 61
	lisl	2		; 62
	lisl	3		; 63
	lisl	4		; 64
	lisl	5		; 65
	lisl	6		; 66
	lisl	7		; 67
	lisu	0		; 68
	lisu	1		; 69
	lisu	2		; 6A
	lisu	3		; 6B
	lisu	4		; 6C
	lisu	5		; 6D
	lisu	6		; 6E
	lisu	7		; 6F

	clr			; 70
	lis	0x01		; 71
	lis	0x02		; 72
	lis	0x03		; 73
	lis	0x04		; 74
	lis	0x05		; 75
	lis	0x06		; 76
	lis	0x07		; 77
	lis	0x08		; 78
	lis	0x09		; 79
	lis	0x0A		; 7A
	lis	0x0B		; 7B
	lis	0x0C		; 7C
	lis	0x0D		; 7D
	lis	0x0E		; 7E
	lis	0x0F		; 7F

	bt	0x00,.		; 80 FE
	bp	.		; 81 FE
	bc	.		; 82 FE
	bt	0x03,.		; 83 FE
	bz	.		; 84 FE
	bt	0x05,.		; 85 FE
	bt	0x06,.		; 86 FE
	bt	0x07,.		; 87 FE
	am			; 88
	amd			; 89
	nm			; 8A
	om			; 8B
	xm			; 8C
	cm			; 8D
	adc			; 8E
	br7	.		; 8F FE

	br	.		; 90 FE
	bm	.		; 91 FE
	bnc	.		; 92 FE
	bf	0x03,.		; 93 FE
	bnz	.		; 94 FE
	bf	0x05,.		; 95 FE
	bf	0x06,.		; 96 FE
	bf	0x07,.		; 97 FE
	bno	.		; 98 FE
	bf	0x09,.		; 99 FE
	bf	0x0A,.		; 9A FE
	bf	0x0B,.		; 9B FE
	bf	0x0C,.		; 9C FE
	bf	0x0D,.		; 9D FE
	bf	0x0E,.		; 9E FE
	bf	0x0F,.		; 9F FE

	ins	0x00		; A0
	ins	0x01		; A1
	ins	0x02		; A2
	ins	0x03		; A3
	ins	0x04		; A4
	ins	0x05		; A5
	ins	0x06		; A6
	ins	0x07		; A7
	ins	0x08		; A8
	ins	0x09		; A9
	ins	0x0A		; AA
	ins	0x0B		; AB
	ins	0x0C		; AC
	ins	0x0D		; AD
	ins	0x0E		; AE
	ins	0x0F		; AF

	outs	0x00		; B0
	outs	0x01		; B1
	outs	0x02		; B2
	outs	0x03		; B3
	outs	0x04		; B4
	outs	0x05		; B5
	outs	0x06		; B6
	outs	0x07		; B7
	outs	0x08		; B8
	outs	0x09		; B9
	outs	0x0A		; BA
	outs	0x0B		; BB
	outs	0x0C		; BC
	outs	0x0D		; BD
	outs	0x0E		; BE
	outs	0x0F		; BF

	as	r0		; C0
	as	r1		; C1
	as	r2		; C2
	as	r3		; C3
	as	r4		; C4
	as	r5		; C5
	as	r6		; C6
	as	r7		; C7
	as	r8		; C8
	as	r9		; C9
	as	r10		; CA
	as	r11		; CB
	as	s		; CC
	as	i		; CD
	as	d		; CE
				; CF

	asd	r0		; D0
	asd	r1		; D1
	asd	r2		; D2
	asd	r3		; D3
	asd	r4		; D4
	asd	r5		; D5
	asd	r6		; D6
	asd	r7		; D7
	asd	r8		; D8
	asd	r9		; D9
	asd	r10		; DA
	asd	r11		; DB
	asd	s		; DC
	asd	i		; DD
	asd	d		; DE
				; DF

	xs	r0		; E0
	xs	r1		; E1
	xs	r2		; E2
	xs	r3		; E3
	xs	r4		; E4
	xs	r5		; E5
	xs	r6		; E6
	xs	r7		; E7
	xs	r8		; E8
	xs	r9		; E9
	xs	r10		; EA
	xs	r11		; EB
	xs	s		; EC
	xs	i		; ED
	xs	d		; EE
				; EF

	ns	r0		; F0
	ns	r1		; F1
	ns	r2		; F2
	ns	r3		; F3
	ns	r4		; F4
	ns	r5		; F5
	ns	r6		; F6
	ns	r7		; F7
	ns	r8		; F8
	ns	r9		; F9
	ns	r10		; FA
	ns	r11		; FB
	ns	s		; FC
	ns	i		; FD
	ns	d		; FE
				; FF


	.page
	.sbttl	Sequential With Relocatables (Alternate Modes)

	lr	a,ku		; 00
	lr	a,kl		; 01
	lr	a,qu		; 02
	lr	a,ql		; 03
	lr	ku,a		; 04
	lr	kl,a		; 05
	lr	qu,a		; 06
	lr	ql,a		; 07
	lr	k,p		; 08
	lr	p,k		; 09
	lr	a,is		; 0A
	lr	is,a		; 0B
	pk			; 0C
	lr	p0,q		; 0D
	lr	q,dc		; 0E
	lr	dc,q		; 0F

	lr	dc,h		; 10
	lr	h,dc		; 11
	sr1			; 12
	sl1			; 13
	sr4			; 14
	sl4			; 15
	lm			; 16
	st			; 17
	com			; 18
	lnk			; 19
	di			; 1A
	ei			; 1B
	pop			; 1C
	lr	w,j		; 1D
	lr	j,w		; 1E
	inc			; 1F

	li	xbyt		; 20r10
	ni	xbyt		; 21r10
	oi	xbyt		; 22r10
	xi	xbyt		; 23r10
	ai	xbyt		; 24r10
	ci	xbyt		; 25r10
	in	4		; 26 04
	out	5		; 27 05
	pi	xwrd		; 28s04r30
	jmp	xwrd		; 29s04r30
	dci	xwrd		; 2As04r30
	nop			; 2B
	xdc			; 2C
				; 2D
				; 2E
				; 2F

	ds	r0		; 30
	ds	r1		; 31
	ds	r2		; 32
	ds	r3		; 33
	ds	r4		; 34
	ds	r5		; 35
	ds	r6		; 36
	ds	r7		; 37
	ds	r8		; 38
	ds	r9		; 39
	ds	r10		; 3A
	ds	r11		; 3B
	ds	s		; 3C
	ds	i		; 3D
	ds	d		; 3E
				; 3F

	lr	a,r0		; 40
	lr	a,r1		; 41
	lr	a,r2		; 42
	lr	a,r3		; 43
	lr	a,r4		; 44
	lr	a,r5		; 45
	lr	a,r6		; 46
	lr	a,r7		; 47
	lr	a,r8		; 48
	lr	a,r9		; 49
	lr	a,r10		; 4A
	lr	a,r11		; 4B
	lr	a,s		; 4C
	lr	a,i		; 4D
	lr	a,d		; 4E
				; 4F

	lr	r0,a		; 50
	lr	r1,a		; 51
	lr	r2,a		; 52
	lr	r3,a		; 53
	lr	r4,a		; 54
	lr	r5,a		; 55
	lr	r6,a		; 56
	lr	r7,a		; 57
	lr	r8,a		; 58
	lr	r9,a		; 59
	lr	r10,a		; 5A
	lr	r11,a		; 5B
	lr	s,a		; 5C
	lr	i,a		; 5D
	lr	d,a		; 5E
				; 5F

	lisl	0		; 60
	lisl	1		; 61
	lisl	2		; 62
	lisl	3		; 63
	lisl	4		; 64
	lisl	5		; 65
	lisl	6		; 66
	lisl	7		; 67
	lisu	0		; 68
	lisu	1		; 69
	lisu	2		; 6A
	lisu	3		; 6B
	lisu	4		; 6C
	lisu	5		; 6D
	lisu	6		; 6E
	lisu	7		; 6F

	clr			; 70
	lis	0x01		; 71
	lis	0x02		; 72
	lis	0x03		; 73
	lis	0x04		; 74
	lis	0x05		; 75
	lis	0x06		; 76
	lis	0x07		; 77
	lis	0x08		; 78
	lis	0x09		; 79
	lis	0x0A		; 7A
	lis	0x0B		; 7B
	lis	0x0C		; 7C
	lis	0x0D		; 7D
	lis	0x0E		; 7E
	lis	0x0F		; 7F

	bt	0x00,.		; 80 FE
	bp	.		; 81 FE
	bc	.		; 82 FE
	bt	0x03,.		; 83 FE
	bz	.		; 84 FE
	bt	0x05,.		; 85 FE
	bt	0x06,.		; 86 FE
	bt	0x07,.		; 87 FE
	am			; 88
	amd			; 89
	nm			; 8A
	om			; 8B
	xm			; 8C
	cm			; 8D
	adc			; 8E
	br7	.		; 8F FE

	br	.		; 90 FE
	bm	.		; 91 FE
	bnc	.		; 92 FE
	bf	0x03,.		; 93 FE
	bnz	.		; 94 FE
	bf	0x05,.		; 95 FE
	bf	0x06,.		; 96 FE
	bf	0x07,.		; 97 FE
	bno	.		; 98 FE
	bf	0x09,.		; 99 FE
	bf	0x0A,.		; 9A FE
	bf	0x0B,.		; 9B FE
	bf	0x0C,.		; 9C FE
	bf	0x0D,.		; 9D FE
	bf	0x0E,.		; 9E FE
	bf	0x0F,.		; 9F FE

	ins	0x00		; A0
	ins	0x01		; A1
	ins	0x02		; A2
	ins	0x03		; A3
	ins	0x04		; A4
	ins	0x05		; A5
	ins	0x06		; A6
	ins	0x07		; A7
	ins	0x08		; A8
	ins	0x09		; A9
	ins	0x0A		; AA
	ins	0x0B		; AB
	ins	0x0C		; AC
	ins	0x0D		; AD
	ins	0x0E		; AE
	ins	0x0F		; AF

	outs	0x00		; B0
	outs	0x01		; B1
	outs	0x02		; B2
	outs	0x03		; B3
	outs	0x04		; B4
	outs	0x05		; B5
	outs	0x06		; B6
	outs	0x07		; B7
	outs	0x08		; B8
	outs	0x09		; B9
	outs	0x0A		; BA
	outs	0x0B		; BB
	outs	0x0C		; BC
	outs	0x0D		; BD
	outs	0x0E		; BE
	outs	0x0F		; BF

	as	r0		; C0
	as	r1		; C1
	as	r2		; C2
	as	r3		; C3
	as	r4		; C4
	as	r5		; C5
	as	r6		; C6
	as	r7		; C7
	as	r8		; C8
	as	r9		; C9
	as	r10		; CA
	as	r11		; CB
	as	s		; CC
	as	i		; CD
	as	d		; CE
				; CF

	asd	r0		; D0
	asd	r1		; D1
	asd	r2		; D2
	asd	r3		; D3
	asd	r4		; D4
	asd	r5		; D5
	asd	r6		; D6
	asd	r7		; D7
	asd	r8		; D8
	asd	r9		; D9
	asd	r10		; DA
	asd	r11		; DB
	asd	s		; DC
	asd	i		; DD
	asd	d		; DE
				; DF

	xs	r0		; E0
	xs	r1		; E1
	xs	r2		; E2
	xs	r3		; E3
	xs	r4		; E4
	xs	r5		; E5
	xs	r6		; E6
	xs	r7		; E7
	xs	r8		; E8
	xs	r9		; E9
	xs	r10		; EA
	xs	r11		; EB
	xs	s		; EC
	xs	i		; ED
	xs	d		; EE
				; EF

	ns	r0		; F0
	ns	r1		; F1
	ns	r2		; F2
	ns	r3		; F3
	ns	r4		; F4
	ns	r5		; F5
	ns	r6		; F6
	ns	r7		; F7
	ns	r8		; F8
	ns	r9		; F9
	ns	r10		; FA
	ns	r11		; FB
	ns	s		; FC
	ns	i		; FD
	ns	d		; FE
				; FF


	.end
