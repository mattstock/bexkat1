	.title	.__.end. Testing
	.sbttl	t07.asm

	; Test for correct output file

	.bank	Bank		(base=0x0000)
	.bank	Bank_1		(base=0x0100,fsfx=_B1)
	.bank	Bank_2		(base=0x0200,fsfx=_B2)

	.area	Area		(rel,con,bank=Bank)
	.area	Area_1		(rel,con,bank=Bank_1)
	.area	Area_2		(rel,con,bank=Bank_2)


	.area	Area
				; t07.---
	.word	.		; 00 00


	.area	Area_1
				; t07_B1.---
	.word	.		; 01 00


	.area	Area_2
				; t07_B2.---
	.word	.		; 02 00
start::

	.end	start

