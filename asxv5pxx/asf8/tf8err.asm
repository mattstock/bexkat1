	.title	F8  Error Testing

	.area	Prog(rel,con)

	.globl	extb, extw		; External Global Values

	.page
	.sbttl	S_IM3 Instruction Type

	;lisl
	;lisu
	lisl	0		;  ; 60

	; 'a' errors for values > 7
	lisl	8		;a ; 60
	lisl	9		;a ; 61
	lisl	18		;a ; 62
	lisl	35		;a ; 63
	lisl	68		;a ; 64
	lisl	133		;a ; 65
	lisl	262		;a ; 66
	lisl	519		;a ; 67

	; link time errors for values > 7
	lisl	extb + 8	;l ;u60
	lisl	extb + 9	;l ;u61
	lisl	extb + 18	;l ;u62
	lisl	extb + 35	;l ;u63
	lisl	extb + 68	;l ;u64
	lisl	extb + 133	;l ;u65
	lisl	extb + 262	;l ;u66
	lisl	extb + 519	;l ;u67


	.page
	.sbttl	S_IM4 Instruction Type

	;lis
	lis	0		;  ; 70

	; 'a' errors for values > 15
	lis	16		;a ; 70
	lis	17		;a ; 71
	lis	34		;a ; 72
	lis	67		;a ; 73
	lis	132		;a ; 74
	lis	261		;a ; 75
	lis	518		;a ; 76
	lis	1031		;a ; 77

	; link time errors for values > 15
	lis	extb + 16	;l ;u70
	lis	extb + 17	;l ;u71
	lis	extb + 34	;l ;u72
	lis	extb + 67	;l ;u73
	lis	extb + 132	;l ;u74
	lis	extb + 261	;l ;u75
	lis	extb + 518	;l ;u76
	lis	extb + 1031	;l ;u77


	.page
	.sbttl	S_SLSR Instruction Type

	;sl
	;sr

	; 'a' errors for arg != 1 and arg !=4
	sr	0		;a ; 12
	sr	1		;  ; 12
	sr	2		;a ; 12
	sr	3		;a ; 12
	sr	4		;  ; 14
	sr	5		;a ; 12
	sr	6		;a ; 12
	sr	7		;a ; 12
	sr	8		;a ; 12


	.page
	.sbttl	S_IOS Instruction Type

	;ins
	;outs

	ins	0x0F		;  ; AF

	; 'a' errors for values > 0x0F
	ins	0x0010		;a ; A0
	ins	0x0011		;a ; A1
	ins	0x0012		;a ; A2
	ins	0x0013		;a ; A3
	ins	0x0014		;a ; A4
	ins	0x0035		;a ; A5
	ins	0x0076		;a ; A6
	ins	0x00F7		;a ; A7
	ins	0x01F8		;a ; A8
	ins	0x03F9		;a ; A9
	ins	0x07FA		;a ; AA
	ins	0x0FFB		;a ; AB
	ins	0x1FFC		;a ; AC
	ins	0x3FFD		;a ; AD
	ins	0x7FFE		;a ; AE
	ins	0xFFFF		;a ; AF

	; link time errors for values > 15
	ins	extw + 0x0010	;l ;uA0
	ins	extw + 0x0011	;l ;uA1
	ins	extw + 0x0012	;l ;uA2
	ins	extw + 0x0013	;l ;uA3
	ins	extw + 0x0014	;l ;uA4
	ins	extw + 0x0035	;l ;uA5
	ins	extw + 0x0076	;l ;uA6
	ins	extw + 0x00F7	;l ;uA7
	ins	extw + 0x01F8	;l ;uA8
	ins	extw + 0x03F9	;l ;uA9
	ins	extw + 0x07FA	;l ;uAA
	ins	extw + 0x0FFB	;l ;uAB
	ins	extw + 0x1FFC	;l ;uAC
	ins	extw + 0x3FFD	;l ;uAD
	ins	extw + 0x7FFE	;l ;uAE
	ins	extw + 0xFFFF	;l ;uAF


	.page
	.sbttl	S_BRA Instruction Type

	; 'a' errors for Out-of-Range Branching
S_BRA1: .blkb	3		; Out-of-Range
S_BRA2:	.blkb	124		; In-Range
	br	S_BRA1		;a ; 90 7F
	br	S_BRA2		;  ; 90 80
	br	S_BRA3		;  ; 90 7F
	br	S_BRA4		;a ; 90 80
	.blkb	125
S_BRA3:	.blkb	3		; In-Range
S_BRA4:				; Out-of-Range


	.page
	.sbttl	S_BRT Instruction Type

	; 'a' errors for Out-of-Range Branching
S_BT1: .blkb	3		; Out-of-Range
S_BT2:	.blkb	124		; In-Range
	bt	0x00,S_BT1	;a ; 80 7F
	bt	0x01,S_BT2	;  ; 81 80
	bt	0x02,S_BT3	;  ; 82 7F
	bt	0x04,S_BT4	;a ; 84 80
	.blkb	125
S_BT3:	.blkb	3		; In-Range
S_BT4:				; Out-of-Range

	; 'a' errors for Out-of-Range Test Bits
S_BT5:	.blkb	2		; In-Range
S_BT6:	.blkb	124		; In-Range
	bt	0x08,S_BT5	;a ; 80 80
	bt	0x01,S_BT6	;  ; 81 80
	bt	0x02,S_BT7	;  ; 82 7F
	bt	0x04,S_BT8	;  ; 84 7F
	.blkb	125
S_BT7:	.blkb	2		; In-Range
S_BT8:				; In-Range

	; link time errors for Out-of-Range Test Bits
S_BT10:	.blkb	2		; In-Range
S_BT11:	.blkb	124		; In-Range
	bt	0x08 + extb,S_BT10	;l ; 80 80
	bt	0x01 + extb,S_BT11	;  ; 81 80
	bt	0x02 + extb,S_BT12	;  ; 82 7F
	bt	0x04 + extb,S_BT13	;  ; 84 7F
	.blkb	125
S_BT12:	.blkb	2		; In-Range
S_BT13:				; In-Range


	.page
	.sbttl	S_BRF Instruction Type

	; 'a' errors for Out-of-Range Branching
S_BF1: .blkb	3		; Out-of-Range
S_BF2:	.blkb	124		; In-Range
	bf	0x00,S_BF1	;a ; 90 7F
	bf	0x04,S_BF2	;  ; 94 80
	bf	0x08,S_BF3	;  ; 98 7F
	bf	0x0C,S_BF4	;a ; 9C 80
	.blkb	125
S_BF3:	.blkb	3		; In-Range
S_BF4:				; Out-of-Range

	; 'a' errors for Out-of-Range Test Bits
S_BF5:	.blkb	2		; In-Range
S_BF6:	.blkb	124		; In-Range
	bf	0x10,S_BF5	;a ; 90 80
	bf	0x04,S_BF6	;  ; 94 80
	bf	0x08,S_BF7	;  ; 98 7F
	bf	0x0C,S_BF8	;  ; 9C 7F
	.blkb	125
S_BF7:	.blkb	2		; In-Range
S_BF8:				; In-Range

	; link time errors for Out-of-Range Test Bits
S_BF10:	.blkb	2		; In-Range
S_BF11:	.blkb	124		; In-Range
	bf	0x10 + extb,S_BF10	;l ; 90 80
	bf	0x04 + extb,S_BF11	;  ; 94 80
	bf	0x08 + extb,S_BF12	;  ; 98 7F
	bf	0x0C + extb,S_BF13	;  ; 9C 7F
	.blkb	125
S_BF12:	.blkb	2		; In-Range
S_BF13:				; In-Range

	.end

