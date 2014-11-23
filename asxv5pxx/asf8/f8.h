/* f8.h */

/*
 *  Copyright (C) 2012  Alan R. Baldwin
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
 */

/*)BUILD
	$(PROGRAM) =	ASF8
	$(INCLUDE) = {
		ASXXXX.H
		F8.H
	}
	$(FILES) = {
		F8MCH.C
		F8ADR.C
		F8PST.C
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

struct adsym
{
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Merge Modes
 */

#define	M_3BIT		0x0100
#define	M_4BIT		0x0200

/*
 * Addressing types
 */
#define	S_RAIW	30
#define	S_RSID	31
#define S_RKQ	32
#define	S_R8	33
#define	S_R16	34
#define	S_IMMED	35
#define	S_EXT	36

/*
 * Specific Registers
 */
#define	S_J	0x09
#define	S_HU	0x0A
#define	S_HL	0x0B
#define	S_KU	0x0C
#define	S_KL	0x0D
#define	S_QU	0x0E
#define	S_QL	0x0F

#define	S_P0	0x00
#define	S_P	0x01
#define	S_DC	0x02
#define	S_DC1	0x03
#define	S_H	0x04
#define	S_K	0x05
#define	S_Q	0x06

#define	S_A	0x00
#define	S_IS	0x01
#define	S_W	0x02

/*
 * Instruction types
 */
#define S_IM3	60
#define	S_IM4	61
#define	S_IM8	62
#define	S_IM16	63
#define	S_SLSR	64
#define	S_LR	65
#define	S_ROP	66
#define	S_IO	67
#define	S_IOS	68
#define	S_INH	69

#define	S_BRT	70
#define	S_BRF	71
#define	S_BRA	72

/*
 * Set Direct Pointer
 */
#define	S_SDP	80


	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* f8adr.c */
extern 	int		aindx;
extern	struct	adsym	regaiw[];
extern	struct	adsym	regsid[];
extern	struct	adsym	regkq[];
extern	struct	adsym	reg8[];
extern	struct	adsym	reg16[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* f8mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* f8adr.c */
extern 	int		aindx;
extern	struct	adsym	regaiw[];
extern	struct	adsym	regsid[];
extern	struct	adsym	regkq[];
extern	struct	adsym	reg8[];
extern	struct	adsym	reg16[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* f8mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

