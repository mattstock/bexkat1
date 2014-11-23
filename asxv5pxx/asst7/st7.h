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
	$(PROGRAM) =	ASST7
	$(INCLUDE) = {
		ASXXXX.H
		ST7.H
	}
	$(FILES) = {
		ST7MCH.C
		ST7ADR.C
		ST7PST.C
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
#define A		 0
#define X		 1
#define Y		 2
#define	S		 3
#define CC		 4

/*
 * Addressing Modes
 */
#define	S_REG		 0
#define	S_SHORT		 1
#define	S_LONG		 2
/*	Illegal		 3	*/

#define	S_IXO		 4
#define	S_IXB		 5
#define	S_IXW		 6
/*	Illegal		 7	*/

#define	S_IN		 8
#define	S_INB		 9
#define	S_INW		10
/*	Illegal		11	*/

#define	S_INIX		12
#define	S_INIXB		13
#define	S_INIXW		14
/*	Illegal		15	*/

#define	S_IMM		16
#define	S_IX		17

/*
 * Instruction types
 */
#define	S_JR		60
#define	S_JRBT		61
#define	S_BTRS		62
#define	S_LD		63
#define	S_AOP		64
#define	S_CP		65
#define	S_BOP		66
#define	S_MUL		67
#define	S_POP		68
#define	S_PUSH		69
#define	S_CLJP		70
#define	S_CALLR		71
#define	S_INH		72

/*
 * Extended Addressing Modes
 */
#define	R_BITS	0x0100		/* Bit Test Addressing Mode */


struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	REG[];

extern	int	rcode;

	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
        /* ST7adr.c */
extern	int		addr(struct expr *esp);
extern	int		addr1(struct expr *esp);
extern	int		addrsl(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* ST7mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);
extern	VOID		opcy_aerr(void);
extern	VOID		valu_aerr(struct expr *e, int n);
extern	int		ls_mode(struct expr *e);
extern	int		setbit(int b);
extern	int		getbit(void);

#else

	/* ST7adr.c */
extern	int		addr();
extern	int		addr1();
extern	int		addrsl();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* ST7mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();
extern	VOID		opcy_aerr();
extern	VOID		valu_aerr();
extern	int		ls_mode();
extern	int		setbit();
extern	int		getbit();

#endif

