	.title	.__.end. Testing
	.sbttl	t06.asm

	; Test for correct output file

	.bank	Bank		(base=0x0000)
	.bank	Bank_1		(base=0x0100,fsfx=_B1)
	.bank	Bank_2		(base=0x0200,fsfx=_B2)

	.area	Area		(rel,con,bank=Bank)
	.area	Area_1		(rel,con,bank=Bank_1)
	.area	Area_2		(rel,con,bank=Bank_2)


	.area	Area
				; t06.---
	.word	.		; 00 00


	.area	Area_1
				; t06_B1.---
	.word	.		; 01 00
start::

	.area	Area_2
				; t06_B2.---
	.word	.		; 02 00


	.end	start

