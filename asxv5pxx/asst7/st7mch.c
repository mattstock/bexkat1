/* st7mch.c */

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

#include "asxxxx.h"
#include "st7.h"

char	*cpu	= "STMicroelectronics ST7";
char	*dsft	= "asm";

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))
#define	OPCY_SKP	((char)	(0xFD))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P1	((char) (OPCY_NONE | 0x01))
#define	P2	((char) (OPCY_NONE | 0x02))
#define	P3	((char) (OPCY_NONE | 0x03))

/*
 * stm8 Opcode Cycle Pages
 */

static char  st7pg[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*10*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   5,UN,UN, 5, 5,UN, 5, 5, 5, 5, 5,UN, 5, 4, 5, 5,
/*40*/   3,UN,11, 3, 3,UN, 3, 3, 3, 3, 3,UN, 3, 3, 3, 3,
/*50*/   3,UN,UN, 3, 3,UN, 3, 3, 3, 3, 3,UN, 3, 3, 3, 3,
/*60*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 5, 6, 6,
/*70*/   5,UN,UN, 5, 5,UN, 5, 5, 5, 5, 5,UN, 5, 4, 5, 5,
/*80*/   9, 9,UN,10, 4, 4, 4,UN, 3, 3, 3,UN,UN,UN, 2, 2,
/*90*/  P1,P2,P3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2,UN, 2, 2, 2, 2,UN, 6, 2,UN,
/*B0*/   3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 2, 5, 3, 4,
/*C0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 6, 4, 5,
/*D0*/   5, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 4, 7, 5, 6,
/*E0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 6, 4, 5,
/*F0*/   3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 2, 5, 3, 4
};

static char  pg90[256] = {  /* P2: PreByte == 90 */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,12,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/   4,UN,UN, 4, 4,UN, 4, 4, 4, 4, 4,UN, 4, 4, 4, 4,
/*60*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 6, 7, 7,
/*70*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 5, 6,
/*80*/  UN,UN,UN,UN,UN, 5,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN, 3, 3,UN, 2, 3,UN,UN,UN,UN,UN,UN,UN, 3,
/*A0*/  UN,UN,UN, 3,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 3,UN,
/*B0*/  UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 4, 5,
/*C0*/  UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 5, 6,
/*D0*/   6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5, 8, 6, 7,
/*E0*/   5, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 4, 7, 5, 6,
/*F0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 6, 4, 5
};

static char  pg91[256] = {  /* P3: PreByte == 91 */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/   8,UN,UN, 8, 8,UN, 8, 8, 8, 8, 8,UN, 8, 8, 8, 8,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*B0*/  UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 5, 6,
/*C0*/  UN,UN,UN, 6,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 7,
/*D0*/   7, 7, 7, 7, 7, 7, 7, 8, 7, 7, 7, 7, 6, 9, 7, 8,
/*E0*/   6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5, 8, 6, 7,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  pg92[256] = {  /* P4: PreByte == 92 */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
/*10*/   7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
/*20*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*30*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 6, 7, 7,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/   8,UN,UN, 8, 8,UN, 8, 8, 8, 8, 8,UN, 8, 7, 8, 8,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 8,UN,UN,
/*B0*/   5, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 4, 7, 5, 6,
/*C0*/   6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5, 8, 6, 7,
/*D0*/   7, 7, 7, 7, 7, 7, 7, 8, 7, 7, 7, 7, 6, 9, 7, 8,
/*E0*/   6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5, 8, 6, 7,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *Page[4] = {
    st7pg, pg90, pg91, pg92
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	struct expr e1, e2, e3;
	char *p1, *p2;
	int t1, t2;
	int v1, v2, v3;
	int op, rf;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	op = (int) mp->m_valu;
	rf = mp->m_type;

	switch (rf) {
	/*
	 * S_AOP:
	 *	SUB,  CP, SBC, AND,
	 *	BCP, XOR, ADC, ADD
	 */
	case S_AOP:
		t2 = addr(&e2);
		v2 = rcode;
		comma(1);
		t1 = addr(&e1);
		v1 = rcode;
		if ((t2 != S_REG) || (v2 != A)) {
			opcy_aerr();
			break;
		}
		switch(t1) {
		case S_REG:	/* A, X, Y, CC */
			opcy_aerr();
			break;
		case S_LONG:	/*  arg */
			if (ls_mode(&e1)) {
				outab(op | 0xC0);
				outrw(&e1, R_USGN);
			} else {
		case S_SHORT:	/* *arg */
				outab(op | 0xB0);
				outrb(&e1, R_USGN);
			}
			break;
		case S_IMM:	/* #arg */
			outab(op | 0xA0);
			outrb(&e1, R_NORM);
			break;
		case S_IXO:	/* (offset,R), R = X, Y */
			if (ls_mode(&e1)) {
		case S_IXW:	/* (offset,R).w, R = X, Y */
				switch(v1) {
				case Y:		outab(0x90);
				case X:		outab(op | 0xD0);
						outrw(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			} else {
		case S_IXB:	/* (offset,R).b, R = X, Y */
				switch(v1) {
				case Y:		outab(0x90);
				case X:		outab(op | 0xE0);
						outrb(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			}
			break;
		case S_IX:	/* (R), R = X, Y */
			switch(v1) {
			case Y:		outab(0x90);
			case X:		outab(op | 0xF0);	break;
			default:	opcy_aerr();		break;
			}
			break;
		case S_IN:	/* [offset] */
			if (ls_mode(&e1)) {
		case S_INW:	/* [offset].w */
				outab(0x92);
				outab(op | 0xC0);
				outrb(&e1, R_USGN);
			} else {
		case S_INB:	/* [offset].b */
				outab(0x92);
				outab(op | 0xB0);
				outrb(&e1, R_USGN);
			}
			break;
		case S_INIX:	/* ([offset],R), R = X, Y */
			if (ls_mode(&e1)) {
		case S_INIXW:	/* ([offset],R).w, R = X, Y */
				switch(v1) {
				case X:
				case Y:		switch(v1) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xD0);
						outrb(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			} else {
		case S_INIXB:	/* ([offset],R).b, R = X, Y */
				switch(v1) {
				case X:
				case Y:		switch(v1) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xE0);
						outrb(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			}
			break;
		default:
			opcy_aerr();
			break;
		}
		break;

	/*
	 * S_CP:
	 *	CP  REG,---
	 */
	case S_CP:
		t1 = addr(&e1);
		v1 = rcode;
		comma(1);
		t2 = addr(&e2);
		v2 = rcode;
		/*
		 * CP  a,# / x,# / y,#
		 */
		if ((t1 == S_REG) && (t2 == S_IMM)) {
			switch(v1) {	/*  CP REG,# */
			case A:		outab(0xA1);
					outrb(&e2, R_NORM);	break;
			case Y:		outab(0x90);
			case X:		outab(0xA3);
					outrb(&e2, R_NORM);	break;
			default:	opcy_aerr();		break;
			}
			break;
		}
		if ((t1 == S_REG) && (v1 == A)) {
			op = 0x01;	/* CP  A,--- */
			switch(t2) {
			case S_LONG:	/*  arg */
				if (ls_mode(&e2)) {
					outab(op | 0xC0);
					outrw(&e2, R_USGN);
				} else {
			case S_SHORT:	/* *arg */
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_IXO:	/* (offset,R), R = X, Y */
				if (ls_mode(&e2)) {
			case S_IXW:	/* (offset,R).w, R = X, Y */
					switch(v2) {
					case Y:		outab(0x90);
					case X:		outab(op | 0xD0);
							outrw(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_IXB:	/* (offset,R).b, R = X, Y */
					switch(v2) {
					case Y:		outab(0x90);
					case X:		outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			case S_IX:	/* (R), R = X, Y */
				switch(v2) {
				case Y:		outab(0x90);
				case X:		outab(op | 0xF0);	break;
				default:	opcy_aerr();		break;
				}
				break;
			case S_IN:	/* [offset] */
				if (ls_mode(&e2)) {
			case S_INW:	/* [offset].w */
					outab(0x92);
					outab(op | 0xC0);
					outrb(&e2, R_USGN);
				} else {
			case S_INB:	/* [offset].b */
					outab(0x92);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_INIX:	/* ([offset],R), R = X, Y */
				if (ls_mode(&e2)) {
			case S_INIXW:	/* ([offset],R).w, R = X, Y */
					switch(v2) {
					case X:
					case Y:
						switch(v2) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xD0);
						outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();	break;
					}
				} else {
			case S_INIXB:	/* ([offset],R).b, R = X, Y */
					switch(v2) {
					case X:
					case Y:
						switch(v2) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xE0);
						outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();			break;
					}
				}
				break;
			default:
				opcy_aerr();
				break;
			}
		} else
		if ((t1 == S_REG) && (v1 == X)) {
			op = 0x03;	/* CP  X,--- */
			switch(t2) {
			case S_LONG:	/*  arg */
				if (ls_mode(&e2)) {
					outab(op | 0xC0);
					outrw(&e2, R_USGN);
				} else {
			case S_SHORT:	/* *arg */
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_IXO:	/* (offset,R), R = X */
				if (ls_mode(&e2)) {
			case S_IXW:	/* (offset,R).w, R = X */
					switch(v2) {
					case X:		outab(op | 0xD0);
							outrw(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_IXB:	/* (offset,R).b, R = X */
					switch(v2) {
					case X:		outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			case S_IX:	/* (R), R = X */
				switch(v2) {
				case X:		outab(op | 0xF0);	break;
				default:	opcy_aerr();		break;
				}
				break;
			case S_IN:	/* [offset] */
				if (ls_mode(&e2)) {
			case S_INW:	/* [offset].w */
					outab(0x92);
					outab(op | 0xC0);
					outrb(&e2, R_USGN);
				} else {
			case S_INB:	/* [offset].b */
					outab(0x92);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_INIX:	/* ([offset],R), R = X */
				if (ls_mode(&e2)) {
			case S_INIXW:	/* ([offset],R).w, R = X */
					switch(v2) {
					case X:		outab(0x92);
							outab(op | 0xD0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_INIXB:	/* ([offset],R).b, R = X */
					switch(v2) {
					case X:		outab(0x92);
							outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			default:
				opcy_aerr();
				break;
			}
			break;
		} else
		if ((t1 == S_REG) && (v1 == Y)) {
			op = 0x03;	/* CP  Y,--- */
			switch(t2) {
			case S_LONG:	/*  arg */
				if (ls_mode(&e2)) {
					outab(0x90);
					outab(op | 0xC0);
					outrw(&e2, R_USGN);
				} else {
			case S_SHORT:	/* *arg */
					outab(0x90);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_IXO:	/* (offset,R), R = Y */
				if (ls_mode(&e2)) {
			case S_IXW:	/* (offset,R).w, R = Y */
					switch(v2) {
					case Y:		outab(0x90);
							outab(op | 0xD0);
							outrw(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_IXB:	/* (offset,R).b, R = Y */
					switch(v2) {
					case Y:		outab(0x90);
							outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			case S_IX:	/* (R), R = Y */
				switch(v2) {
				case Y:		outab(0x90);
						outab(op | 0xF0);	break;
				default:	opcy_aerr();		break;
				}
				break;
			case S_IN:	/* [offset] */
				if (ls_mode(&e2)) {
			case S_INW:	/* [offset].w */
					outab(0x91);
					outab(op | 0xC0);
					outrb(&e2, R_USGN);
				} else {
			case S_INB:	/* [offset].b */
					outab(0x91);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_INIX:	/* ([offset],R), R = Y */
				if (ls_mode(&e2)) {
			case S_INIXW:	/* ([offset],R).w, R = Y */
					switch(v2) {
					case Y:		outab(0x91);
							outab(op | 0xD0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_INIXB:	/* ([offset],R).b, R = Y */
					switch(v2) {
					case Y:		outab(0x91);
							outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			default:
				opcy_aerr();
				break;
			}
		} else {
			opcy_aerr();
		}
		break;

	/*
	 * S_BOP:
	 *	NEG, CPL, SRL, RRC,
	 *	SRA, SLA, SLL, RLC,
	 *	DEC, INC, TNZ, SWAP,
	 *	CLR
	 */
	case S_BOP:
		t1 = addr(&e1);
		v1 = rcode;
		switch(t1) {
		case S_REG:	/* A, X, Y */
			switch(v1) {
			case A:		outab(op | 0x40);	break;
			case Y:		outab(0x90);
			case X:		outab(op | 0x50);	break;
			default:	opcy_aerr();		break;
			}
			break;
		case S_LONG:	/*  arg */
		case S_SHORT:	/* *arg */
			outab(op | 0x30);
			outrb(&e1, R_USGN);
			break;
		case S_IMM:	/* #arg */
			opcy_aerr();
			break;
		case S_IXO:	/* (offset,R), R = X, Y */
		case S_IXB:	/* (offset,R).b, R = X, Y */
			switch(v1) {
			case Y:		outab(0x90);
			case X:		outab(op | 0x60);
					outrb(&e1, R_USGN);	break;
			default:	opcy_aerr();		break;
			}
			break;
		case S_IX:	/* (R), R = X, Y */
			switch(v1) {
			case Y:		outab(0x90);
			case X:		outab(op | 0x70);	break;
			default:	opcy_aerr();		break;
			}
			break;
		case S_IN:	/* [offset] */
		case S_INB:	/* [offset].b */
			outab(0x92);
			outab(op | 0x30);
			outrb(&e1, R_USGN);
			break;
		case S_INIX:	/* ([offset],R), R = X, Y */
		case S_INIXB:	/* ([offset],R).b, R = X, Y */
			switch(rcode) {
			case X:
			case Y:		switch(rcode) {
					case X:		outab(0x92);	break;
					case Y:		outab(0x91);	break;
					default:			break;
					}
					outab(op | 0x60);
					outrb(&e1, R_USGN);	break;
			default:	opcy_aerr();		break;
			}
			break;
		default:
			opcy_aerr();
			break;
		}
		break;

	/*
	 * S_LD:
	 *	LD  REG,---
	 *	LD  ---,REG
	 */
	case S_LD:
		t1 = addr(&e1);
		v1 = rcode;
		comma(1);
		t2 = addr(&e2);
		v2 = rcode;
		/*
		 *  LD  REG,REG
		 */
		if ((t1 == S_REG) && (t2 == S_REG)) {
			switch(v1) {	/* a,--- or x,--- or y,--- or s,--- */
			case A:
				switch(v2) {	/* a,x or a,y or a,s */
				case Y:		outab(0x90);
				case X:		outab(0x9F);	break;
				case S:		outab(0x9E);	break;
				default:	opcy_aerr();	break;
				}
				break;
			case X:
				switch(v2) {	/* x,a or x,y or x,s */
				case A:		outab(0x97);	break;
				case Y:		outab(0x93);	break;
				case S:		outab(0x96);	break;
				default:	opcy_aerr();	break;
				}
				break;
			case Y:
				switch(v2) {	/* y,a or y,x or y,s */
				case A:		outab(0x90);
						outab(0x97);	break;
				case X:	        outab(0x90);
						outab(0x93);	break;
				case S:		outab(0x90);
						outab(0x96);	break;
				default:	opcy_aerr();	break;
				}
				break;
			case S:
				switch(v2) {	/* s,a or s,x or s,y */
				case A:		outab(0x95);	break;
				case Y:		outab(0x90);
				case X:		outab(0x94);	break;
				default:	opcy_aerr();	break;
				}
				break;
			default:	opcy_aerr();	break;
			}
			break;
		}
		/*
		 * LD  a,# / x,# / y,#
		 */
		if ((t1 == S_REG) && (t2 == S_IMM)) {
			switch(v1) {	/*  LD REG,# */
			case A:		outab(0xA6);
					outrb(&e2, R_NORM);	break;
			case Y:		outab(0x90);
			case X:		outab(0xAE);
					outrb(&e2, R_NORM);	break;
			default:	opcy_aerr();		break;
			}
			break;
		}
		if (((t1 == S_REG) && (v1 == A)) ||
		    ((t2 == S_REG) && (v2 == A))) {
			if ((t1 == S_REG) && (v1 == A)) {
				op = 0x06;	/* LD  A,--- */
			} else
			if ((t2 == S_REG) && (v2 == A)) {
				op = 0x07;	/* LD  ---,A */
				p1 = (char *) &e1;
				p2 = (char *) &e2;
				for (v3=0; v3<sizeof(e1); v3++) {
					*p2++ = *p1++;
				}
				t2 = t1;
				v2 = v1;
			}
			switch(t2) {
			case S_LONG:	/*  arg */
				if (ls_mode(&e2)) {
					outab(op | 0xC0);
					outrw(&e2, R_USGN);
				} else {
			case S_SHORT:	/* *arg */
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_IXO:	/* (offset,R), R = X, Y */
				if (ls_mode(&e2)) {
			case S_IXW:	/* (offset,R).w, R = X, Y */
					switch(v2) {
					case Y:		outab(0x90);
					case X:		outab(op | 0xD0);
							outrw(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_IXB:	/* (offset,R).b, R = X, Y */
					switch(v2) {
					case Y:		outab(0x90);
					case X:		outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			case S_IX:	/* (R), R = X, Y */
				switch(v2) {
				case Y:		outab(0x90);
				case X:		outab(op | 0xF0);	break;
				default:	opcy_aerr();		break;
				}
				break;
			case S_IN:	/* [offset] */
				if (ls_mode(&e2)) {
			case S_INW:	/* [offset].w */
					outab(0x92);
					outab(op | 0xC0);
					outrb(&e2, R_USGN);
				} else {
			case S_INB:	/* [offset].b */
					outab(0x92);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_INIX:	/* ([offset],R), R = X, Y */
				if (ls_mode(&e2)) {
			case S_INIXW:	/* ([offset],R).w, R = X, Y */
					switch(v2) {
					case X:
					case Y:
						switch(v2) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xD0);
						outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();	break;
					}
				} else {
			case S_INIXB:	/* ([offset],R).b, R = X, Y */
					switch(v2) {
					case X:
					case Y:
						switch(v2) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xE0);
						outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();			break;
					}
				}
				break;
			default:
				opcy_aerr();
				break;
			}
		} else
		if (((t1 == S_REG) && (v1 == X)) ||
		    ((t2 == S_REG) && (v2 == X))) {
			if ((t1 == S_REG) && (v1 == X)) {
				op = 0x0E;	/* LD  X,--- */
			} else
			if ((t2 == S_REG) && (v2 == X)) {
				op = 0x0F;	/* LD  ---,X */
				p1 = (char *) &e1;
				p2 = (char *) &e2;
				for (v3=0; v3<sizeof(e1); v3++) {
					*p2++ = *p1++;
				}
				t2 = t1;
				v2 = v1;
			}
			switch(t2) {
			case S_LONG:	/*  arg */
				if (ls_mode(&e2)) {
					outab(op | 0xC0);
					outrw(&e2, R_USGN);
				} else {
			case S_SHORT:	/* *arg */
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_IXO:	/* (offset,R), R = X */
				if (ls_mode(&e2)) {
			case S_IXW:	/* (offset,R).w, R = X */
					switch(v2) {
					case X:		outab(op | 0xD0);
							outrw(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_IXB:	/* (offset,R).b, R = X */
					switch(v2) {
					case X:		outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			case S_IX:	/* (R), R = X */
				switch(v2) {
				case X:		outab(op | 0xF0);	break;
				default:	opcy_aerr();		break;
				}
				break;
			case S_IN:	/* [offset] */
				if (ls_mode(&e2)) {
			case S_INW:	/* [offset].w */
					outab(0x92);
					outab(op | 0xC0);
					outrb(&e2, R_USGN);
				} else {
			case S_INB:	/* [offset].b */
					outab(0x92);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_INIX:	/* ([offset],R), R = X */
				if (ls_mode(&e2)) {
			case S_INIXW:	/* ([offset],R).w, R = X */
					switch(v2) {
					case X:		outab(0x92);
							outab(op | 0xD0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_INIXB:	/* ([offset],R).b, R = X */
					switch(v2) {
					case X:		outab(0x92);
							outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			default:
				opcy_aerr();
				break;
			}
			break;
		} else
		if (((t1 == S_REG) && (v1 == Y)) ||
		    ((t2 == S_REG) && (v2 == Y))) {
			if ((t1 == S_REG) && (v1 == Y)) {
				op = 0x0E;	/* LD  Y,--- */
			} else
			if ((t2 == S_REG) && (v2 == Y)) {
				op = 0x0F;	/* LD  ---,Y */
				p1 = (char *) &e1;
				p2 = (char *) &e2;
				for (v3=0; v3<sizeof(e1); v3++) {
					*p2++ = *p1++;
				}
				t2 = t1;
				v2 = v1;
			}
			switch(t2) {
			case S_LONG:	/*  arg */
				if (ls_mode(&e2)) {
					outab(0x90);
					outab(op | 0xC0);
					outrw(&e2, R_USGN);
				} else {
			case S_SHORT:	/* *arg */
					outab(0x90);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_IXO:	/* (offset,R), R = Y */
				if (ls_mode(&e2)) {
			case S_IXW:	/* (offset,R).w, R = Y */
					switch(v2) {
					case Y:		outab(0x90);
							outab(op | 0xD0);
							outrw(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_IXB:	/* (offset,R).b, R = Y */
					switch(v2) {
					case Y:		outab(0x90);
							outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			case S_IX:	/* (R), R = Y */
				switch(v2) {
				case Y:		outab(0x90);
						outab(op | 0xF0);	break;
				default:	opcy_aerr();		break;
				}
				break;
			case S_IN:	/* [offset] */
				if (ls_mode(&e2)) {
			case S_INW:	/* [offset].w */
					outab(0x91);
					outab(op | 0xC0);
					outrb(&e2, R_USGN);
				} else {
			case S_INB:	/* [offset].b */
					outab(0x91);
					outab(op | 0xB0);
					outrb(&e2, R_USGN);
				}
				break;
			case S_INIX:	/* ([offset],R), R = X, Y */
				if (ls_mode(&e2)) {
			case S_INIXW:	/* ([offset],R).w, R = Y */
					switch(v2) {
					case Y:		outab(0x91);
							outab(op | 0xD0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				} else {
			case S_INIXB:	/* ([offset],R).b, R = Y */
					switch(v2) {
					case Y:		outab(0x91);
							outab(op | 0xE0);
							outrb(&e2, R_USGN);	break;
					default:	opcy_aerr();		break;
					}
				}
				break;
			default:
				opcy_aerr();
				break;
			}
		} else {
			opcy_aerr();
		}
		break;

	case S_MUL:
		t1 = addr(&e1);
		v1 = rcode;
		comma(1);
		t2 = addr(&e2);
		v2 = rcode;
		if ((t2 != S_REG) && (v2 != A)) {
			opcy_aerr();
			break;
		}
		if (t1 == S_REG) {
			switch(v1) {
			case Y:		outab(0x90);
			case X:		outab(op);	break;
			default:	opcy_aerr();	break;
			}
		} else {
			opcy_aerr();
		}
		break;

	case S_POP:
		t1 = addr(&e1);
		v1 = rcode;
		switch(t1) {
		case S_REG:
			switch(v1) {
			case A:		outab(0x84);		break;
			case Y:		outab(0x90);
			case X:		outab(0x85);		break;
			case CC:	outab(0x86);		break;
			default:	opcy_aerr();		break;
			}
			break;
		default:		opcy_aerr();		break;
		}
		break;

	case S_PUSH:
		t1 = addr(&e1);
		v1 = rcode;
		switch(t1) {
		case S_REG:
			switch(rcode) {
			case A:		outab(0x88);		break;
			case Y:		outab(0x90);
			case X:		outab(0x89);		break;
			case CC:	outab(0x8A);		break;
			default:	opcy_aerr();		break;
			}
			break;
		default:		opcy_aerr();		break;
		}
		break;

	/*
	 * S_CLJP:
	 *	CALL, JP
	 */
	case S_CLJP:
		t1 = addr(&e1);
		v1 = rcode;
		switch(t1) {
		case S_LONG:	/*  arg */
			outab(op | 0xC0);
			outrw(&e1, R_USGN);
			break;
		case S_SHORT:	/* *arg */
			outab(op | 0xB0);
			outrb(&e1, R_USGN);
			break;
		case S_IXO:	/* (offset,R), R = X, Y */
			if (ls_mode(&e1)) {
		case S_IXW:	/* (offset,R).w, R = X, Y, SP */
				switch(v1) {
				case Y:		outab(0x90);
				case X:		outab(op | 0xD0);
						outrw(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			} else {
		case S_IXB:	/* (offset,R).b, R = X, Y, SP */
				switch(v1) {
				case Y:		outab(0x90);
				case X:		outab(op | 0xE0);
						outrb(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			}
			break;
		case S_IX:	/* (R), R = X, Y */
			switch(rcode) {
			case Y:		outab(0x90);
			case X:		outab(op | 0xF0);	break;
			default:	opcy_aerr();		break;
			}
			break;
		case S_IN:	/* [offset] */
			if (ls_mode(&e1)) {
		case S_INW:	/* [offset].w */
				outab(0x92);
				outab(op | 0xC0);
				outrb(&e1, R_USGN);
			} else {
		case S_INB:	/* [offset].b */
				outab(0x92);
				outab(op | 0xB0);
				outrb(&e1, R_USGN);
			}
			break;
		case S_INIX:	/* ([offset],R), R = X, Y */
			if (ls_mode(&e1)) {
		case S_INIXW:	/* ([offset],R).w, R = X, Y */
				switch(v1) {
				case X:
				case Y:		switch(rcode) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xD0);
						outrb(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			} else {
		case S_INIXB:	/* ([offset],R).b, R = X, Y */
				switch(v1) {
				case X:
				case Y:		switch(rcode) {
						case X:		outab(0x92);	break;
						case Y:		outab(0x91);	break;
						default:			break;
						}
						outab(op | 0xE0);
						outrb(&e1, R_USGN);	break;
				default:	opcy_aerr();		break;
				}
			}
			break;
		default:
			opcy_aerr();
			break;
		}
		break;


	case S_CALLR:
	case S_JR:
		unget((v1 = getnb()));
		if (v1 == '[') {
		/*
		 * op  [s]
		 */
			t1 = addr(&e1);
			v1 = rcode;
			switch(t1) {
			case S_IN:
			case S_INB:
				outab(0x92);
				outab(op);
				outrb(&e1, R_USGN);
				break;
			default:	opcy_aerr();	break;
			}
		} else {
		/*
		 * op   s
		 */
			expr(&e1, 0);
			outab(op);
			if (mchpcr(&e1)) {
				v1 = (int) (e1.e_addr - dot.s_addr - 1);
				if ((v1 < -128) || (v1 > 127))
					aerr();
				outab(v1);
			} else {
				outrb(&e1, R_PCR);
			}
			if (e1.e_mode != S_USER) {
				rerr();
			}
		}
		break;

	case S_JRBT:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		comma(1);
		expr(&e3, 0);
		if (t2 != S_IMM) {
			opcy_aerr();
			break;
		}
		if (is_abs(&e2) && (v2 & ~0x07)) {
			aerr();
		}
		switch(t1) {
		case S_IN:
		case S_INB:	outab(0x92);
		case S_LONG:
		case S_SHORT:
			outrbm(&e2, R_BITS, op);
			outrb(&e1, R_USGN);
			if (mchpcr(&e3)) {
				v3 = (int) (e3.e_addr - dot.s_addr - 1);
				if ((v3 < -128) || (v3 > 127))
					aerr();
				outab(v3);
			} else {
				outrb(&e3, R_PCR);
			}
			if (e3.e_mode != S_USER) {
				rerr();
			}
			break;
		default:	opcy_aerr();	break;
		}
		break;

	case S_BTRS:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if (t2 != S_IMM) {
			opcy_aerr();
			break;
		}
		if (is_abs(&e2) && (v2 & ~0x07)) {
			aerr();
		}
		switch(t1) {
		case S_IN:
		case S_INB:	outab(0x92);
		case S_LONG:
		case S_SHORT:
			outrbm(&e2, R_BITS, op);
			outrb(&e1, R_USGN);
			break;
		default:	opcy_aerr();	break;
		}
		break;

	case S_INH:
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = st7pg[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
	}
}

/*
 * Disable Opcode Cycles with aerr()
 */
VOID
opcy_aerr()
{
	opcycles = OPCY_SKP;
	aerr();
}

/*
 * Select the long or short addressing mode
 * based upon the expression type and value.
 */
int
ls_mode(e)
struct expr *e;
{
	int flag, v;

	v = (int) e->e_addr;
	/*
	 * 1) area based arguments (e_base.e_ap != 0) use longer mode
	 * 2) constant arguments (e_base.e_ap == 0) use
	 * 	shorter mode if (arg & ~0xFF) == 0
	 *	longer  mode if (arg & ~0xFF) != 0
	 */
	if (pass == 0) {
		;
	} else
	if (e->e_base.e_ap) {
		;
	} else
	if (pass == 1) {
		if (e->e_addr >= dot.s_addr) {
			e->e_addr -= fuzz;
		}
		flag = (v & ~0xFF) ? 1 : 0;
		return(setbit(flag) ? 1 : 0);
	} else {
		return(getbit() ? 1 : 0);
	}
	return(1);
}

/*
 * Generate an 'a' error if the absolute
 * value is not a valid unsigned or signed value.
 */
VOID
valu_aerr(e, n)
struct expr *e;
int n;
{
	a_uint v;

	if (is_abs(e)) {
		v = e->e_addr;
		switch(n) {
		default:
#ifdef	LONGINT
		case 1:	if ((v & ~0x000000FFl) && ((v & ~0x000000FFl) != ~0x000000FFl)) aerr();	break;
		case 2:	if ((v & ~0x0000FFFFl) && ((v & ~0x0000FFFFl) != ~0x0000FFFFl)) aerr();	break;
		case 3:	if ((v & ~0x00FFFFFFl) && ((v & ~0x00FFFFFFl) != ~0x00FFFFFFl)) aerr();	break;
		case 4:	if ((v & ~0xFFFFFFFFl) && ((v & ~0xFFFFFFFFl) != ~0xFFFFFFFFl)) aerr();	break;
#else
		case 1:	if ((v & ~0x000000FF) && ((v & ~0x000000FF) != ~0x000000FF)) aerr();	break;
		case 2:	if ((v & ~0x0000FFFF) && ((v & ~0x0000FFFF) != ~0x0000FFFF)) aerr();	break;
		case 3:	if ((v & ~0x00FFFFFF) && ((v & ~0x00FFFFFF) != ~0x00FFFFFF)) aerr();	break;
		case 4:	if ((v & ~0xFFFFFFFF) && ((v & ~0xFFFFFFFF) != ~0xFFFFFFFF)) aerr();	break;
#endif
		}
	}
}

/*
 * Branch/Jump PCR Mode Check
 */
int
mchpcr(esp)
struct expr *esp;
{
	if (esp->e_base.e_ap == dot.s_area) {
		return(1);
	}
	if (esp->e_flag==0 && esp->e_base.e_ap==NULL) {
		/*
		 * Absolute Destination
		 *
		 * Use the global symbol '.__.ABS.'
		 * of value zero and force the assembler
		 * to use this absolute constant as the
		 * base value for the relocation.
		 */
		esp->e_flag = 1;
		esp->e_base.e_sp = &sym[1];
	}
	return(0);
}

/*
 * Machine specific initialization.
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	/*
	 * Reset Bit Table
	 */
	bp = bb;
	bm = 1;
}

/*
 * Store `b' in the next slot of the bit table.
 * If no room, force the longer form of the offset.
 */
int
setbit(b)
int b;
{
	if (bp >= &bb[NB])
		return(1);
	if (b)
		*bp |= bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return(b);
}

/*
 * Get the next bit from the bit table.
 * If none left, return a `1'.
 * This will force the longer form of the offset.
 */
int
getbit()
{
	int f;

	if (bp >= &bb[NB])
		return (1);
	f = *bp & bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return (f);
}

