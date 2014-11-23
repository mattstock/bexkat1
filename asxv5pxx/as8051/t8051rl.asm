; Test relative addressing with "."
; Benny Kim (2011/07/21)
; Test relative addressing with "." across .area boundaries
; Alan Baldwin (2011/07/24)

	.area	Space_01
L1:
	.area	Space_02
	cjne a, #10, L1		; B4 0A FD
	cjne a, #2, .		; B4 02 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_03
L1_1:
	.area	Space_04
	cjne a, p0, L1_1	; B5 80 FD
	cjne a, p1, L2		; B5 90 17
	cjne a, p0, .		; B5 80 FD
	cjne @r0, #7, .		; B6 07 FD
	cjne @r0, #7, L1	; B6 07 EB
	cjne @r1, #7, .		; B7 07 FD
	cjne @r1, #7, L2	; B7 07 08
	cjne r7, #7, .		; BF 07 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_05
L1_2:
	.area	Space_06
	cjne r7, #7, L1_2	; BF 07 FD
;
; *****-----*****-----*****-----*****
;
	djnz r0, L1		; D8 DD
	.area	Space_07
L2:
	.area	Space_08
	djnz r0, L2		; D8 FE
	djnz r0, .		; D8 FE
	djnz r0, .+4		; D8 02

	djnz b, L1		; D5 F0 D4
;
; *****-----*****-----*****-----*****
;
	.area	Space_09
L3:
	.area	Space_10
	djnz b, L3		; D5 F0 FD
	djnz b, .		; D5 F0 FD
	djnz 2+5, .		; D5 07 FD
	djnz 2+5, .+4		; D5 07 01
;
; *****-----*****-----*****-----*****
;
	jz	L1		; 60 C6
	.area	Space_11
L4:
	.area	Space_12
	jz	L4		; 60 FE
	jz	.		; 60 FE
;
; *****-----*****-----*****-----*****
;
	jnz	.		; 70 FE
	.area	Space_13
L4_1:
	.area	Space_14
	jnz	L4_1		; 70 FE
	jnz	.+4		; 70 02
;
; *****-----*****-----*****-----*****
;
	.area	Space_15
L5:
	jc	L5		; 40 FE
	.area	Space_16
	jc	L4		; 40 F2
	jc	.		; 40 FE
;
; *****-----*****-----*****-----*****
;
	jnc	.		; 50 FE
	.area	Space_17
L5_1:
	.area	Space_18
	jnc	L5_1		; 50 FE
	jnc	.+1		; 50 FF
;
; *****-----*****-----*****-----*****
;
	jb	P0.0, L4	; 20 80 E7
	.area	Space_19
L6:
	.area	Space_20
	jb	P0.0, L6	; 20 80 FD
	jb	P0.0, .		; 20 80 FD
	jb	P0.0, .+1	; 20 80 FE
;
; *****-----*****-----*****-----*****
;
	.area	Space_21
L7:
	.area	Space_22
	jbc	P0.0, L7	; 10 80 FD
	jbc	P0.0, L5	; 10 80 E2
	jbc	P0.0, .		; 10 80 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_23
L8:
	.area	Space_24
	jnb	P0.0, L8	; 30 80 FD
	jnb	P0.0, .		; 30 80 FD
;
; *****-----*****-----*****-----*****
;
	.area	Space_25
LLLL:	NOP			; 00
	SJMP	.		; 80 FE
	AJMP	RN		; 01 7F
	AJMP	.		; 01 70
	AJMP	.+1		; 01 73
	.area	Space_26
	LJMP	LLLL		; 02 00 6B
	LJMP	.		; 02 00 77
	LCALL	.		; 12 00 7A
	ACALL	.		; 11 7D
RN:	RR	A		; 03

	.end

