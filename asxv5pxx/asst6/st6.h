/* ST7.h */

/*
 *  Copyright (C) 2010  Alan R. Baldwin
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 * 
 */

/*)BUILD
	$(PROGRAM) =	ASST6
	$(INCLUDE) = {
		ASXXXX.H
		ST6.H
	}
	$(FILES) = {
		ST6MCH.C
		ST6ADR.C
		ST6PST.C
		ASMAIN.C
		ASMCRO.C
		ASDBG.C
		ASLEX.C
		ASSYM.C
		ASSUBR.C
		ASEXPR.C
		ASDATA.C
		ASLIST.C
		ASOUT.C
	}
	$(STACK) = 3000
*/

/*
 * Registers
 */
#define A		 0xFF
#define X		 0x80
#define Y		 0x81
#define V		 0x82
#define W		 0x83

/*
 * Addressing Modes
 */
#define	S_REG		 0
#define	S_VAL		 1
#define	S_IMM		 2
#define	S_IX		 3

/*
 * Instruction types
 */
#define	S_CLJP		60
#define	S_JR		61
#define	S_JRB		62
#define	S_BRS		63
#define	S_LD		64
#define	S_LDI		65
#define	S_AOP		66
#define	S_OPI		67
#define	S_BOP		68
#define	S_INHA		69
#define	S_INH		70

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* 3 Bit Addressing Mode */
#define	R_5BIT	0x0200		/* 5 Bit Addressing Mode */
#define R_CLJP	0x0300		/* CALL/ JP 12 Bit Addressing Mode */

struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	REG[];

extern	int	rcode;

	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
        /* ST6adr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* ST6mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);
extern	VOID		opcy_aerr(void);
extern	VOID		valu_aerr(struct expr *e, int n);

#else

	/* ST6adr.c */
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* ST6mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();
extern	VOID		opcy_aerr();
extern	VOID		valu_aerr();

#endif

