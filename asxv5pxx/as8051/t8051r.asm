; Test relative addressing with "."
; Benny Kim (2011/07/21)
; Test relative addressing with "." across .area boundaries
; Alan Baldwin (2011/07/24)

	.area	Space_01
L1:
	.area	Space_02
	cjne a, #10, L1		; B4 0Ap00
	cjne a, #2, .		; B4 02 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_03
L1_1:
	.area	Space_04
	cjne a, p0, L1_1	; B5 80p00
	cjne a, p1, L2		; B5 90p00
	cjne a, p0, .		; B5 80 FD
	cjne @r0, #7, .		; B6 07 FD
	cjne @r0, #7, L1	; B6 07p00
	cjne @r1, #7, .		; B7 07 FD
	cjne @r1, #7, L2	; B7 07p00
	cjne r7, #7, .		; BF 07 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_05
L1_2:
	.area	Space_06
	cjne r7, #7, L1_2	; BF 07p00
;
; *****-----*****-----*****-----*****
;
	djnz r0, L1		; D8p00
	.area	Space_07
L2:
	.area	Space_08
	djnz r0, L2		; D8p00
	djnz r0, .		; D8 FE
	djnz r0, .+4		; D8 02

	djnz b, L1		; D5 F0p00
;
; *****-----*****-----*****-----*****
;
	.area	Space_09
L3:
	.area	Space_10
	djnz b, L3		; D5 F0p00
	djnz b, .		; D5 F0 FD
	djnz 2+5, .		; D5 07 FD
	djnz 2+5, .+4		; D5 07 01
;
; *****-----*****-----*****-----*****
;
	jz	L1		; 60p00
	.area	Space_11
L4:
	.area	Space_12
	jz	L4		; 60p00
	jz	.		; 60 FE
;
; *****-----*****-----*****-----*****
;
	jnz	.		; 70 FE
	.area	Space_13
L4_1:
	.area	Space_14
	jnz	L4_1		; 70p00
	jnz	.+4		; 70 02
;
; *****-----*****-----*****-----*****
;
	.area	Space_15
L5:
	jc	L5		; 40 FE
	.area	Space_16
	jc	L4		; 40p00
	jc	.		; 40 FE
;
; *****-----*****-----*****-----*****
;
	jnc	.		; 50 FE
	.area	Space_17
L5_1:
	.area	Space_18
	jnc	L5_1		; 50p00
	jnc	.+1		; 50 FF
;
; *****-----*****-----*****-----*****
;
	jb	P0.0, L4	; 20 80p00
	.area	Space_19
L6:
	.area	Space_20
	jb	P0.0, L6	; 20 80p00
	jb	P0.0, .		; 20 80 FD
	jb	P0.0, .+1	; 20 80 FE
;
; *****-----*****-----*****-----*****
;
	.area	Space_21
L7:
	.area	Space_22
	jbc	P0.0, L7	; 10 80p00
	jbc	P0.0, L5	; 10 80p00
	jbc	P0.0, .		; 10 80 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_23
L8:
	.area	Space_24
	jnb	P0.0, L8	; 30 80p00
	jnb	P0.0, .		; 30 80 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_25
LLLL:	NOP			; 00
	SJMP	.		; 80 FE
	AJMP	RN		;n01*0B
	AJMP	.		;n01*05
	AJMP	.+1		;n01*08
	.area	Space_26
	LJMP	LLLL		; 02s00r00
	LJMP	.		; 02s00r03
	LCALL	.		; 12s00r06
	ACALL	.		;n11*09
RN:	RR	A		; 03

	.end

