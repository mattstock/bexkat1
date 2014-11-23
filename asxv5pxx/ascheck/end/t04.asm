	.title	.__.end. Testing
	.sbttl	t04.asm

	; Test for correct output file

	.area	Area		(rel,con)
	.area	Area_1		(rel,con)
	.area	Area_2		(rel,con)

	.area	Area
				; t04.---
	.word	.		; 00 00
start::

	.area	Area_1
				; t04.---
	.word	.		; 00 02


	.area	Area_2
				; t04.---
	.word	.		; 00 04


	.end	start

