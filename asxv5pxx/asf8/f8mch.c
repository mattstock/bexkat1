/* f8mch.c */

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

#include "asxxxx.h"
#include "f8.h"

char	*cpu	= "Fairchild F8";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * F8 Cycle Count
 *
 *	opcycles = f8cyc[opcode]
 */
char f8cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4, 4, 4, 4, 4, 4, 4, 4,16,16, 4, 4,16,16,16,16,
/*10*/  16,16, 4, 4, 4, 4,10,10, 4, 4, 8, 8, 8, 8, 4, 4,
/*20*/  10,10,10,10,10,10,16,16,26,22,24, 4, 8,UN,UN,UN,
/*30*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN,
/*40*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,UN,
/*50*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,UN,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*70*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*80*/  14,14,14,14,14,14,14,14,10,10,10,10,10,10,10,14,
/*90*/  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,
/*A0*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*B0*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*C0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,UN,
/*D0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,UN,
/*E0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,UN,
/*F0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,UN
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op;
	struct expr e1, e2;
	int t1, a1, v1;
	int t2, a2, v2;

	clrexpr(&e1);
	clrexpr(&e2);
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_IM3:
		/*
		 * lisu
		 * lisl
		 */
		t1 = addr(&e1);
		outrbm(&e1, M_3BIT | R_MBRU, op);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		break;

	case S_IM4:
		/*
		 * lis
		 */
		t1 = addr(&e1);
		outrbm(&e1, M_4BIT | R_MBRU, op);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		break;

	case S_IM8:
		/*
		 * ai
		 * ni
		 * ci
		 * xi
		 * li
		 * oi
		 */
		t1 = addr(&e1);
		outab(op);
		outrb(&e1, R_NORM);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		break;

	case S_IM16:
		/*
		 * pi
		 * dci
		 */
		t1 = addr(&e1);
		outab(op);
		outrw(&e1, R_NORM);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		break;

	case S_SLSR:
		/*
		 * sl 1
		 * sl 4
		 * sr 1
		 * sr 4
		 */
		t1 = addr(&e1);
		if ((t1 == S_IMMED) || ( t1 == S_EXT)) {
			if (e1.e_addr == (a_uint) 1) {
				outab(op);
			} else
			if (e1.e_addr == (a_uint) 4) {
				outab(op + 2);
			} else {
				outab(op);
				aerr();
			}
			if (!is_abs(&e1)) {
				aerr();
			}
		} else {
			outab(op);
			aerr();
		}
		break;

	case S_LR:
		/*
		 * lr	arg1,arg2
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		t2 = addr(&e2);
		a2 = aindx;
		/*	lr	A,IS	*/
		if (((t1 == S_RAIW) && (a1 == S_A)) && ((t2 == S_RAIW) && (a2 == S_IS))) {
			outab(0x0A);
		} else
		/*	lr	IS,A	*/
		if (((t1 == S_RAIW) && (a1 == S_IS)) && ((t2 == S_RAIW) && (a2 == S_A))) {
			outab(0x0B);
		} else
		/*	lr	W,J	*/
		if (((t1 == S_RAIW) && (a1 == S_W)) && ((t2 == S_R8) && (a2 == S_J))) {
			outab(0x1D);
		} else
		/*	lr	J,W	*/
		if (((t1 == S_R8) && (a1 == S_J)) && ((t2 == S_RAIW) && (a2 == S_W))) {
			outab(0x1E);
		} else
		/*	lr	A,KU	*/
		/*	lr	A,KL	*/
		/*	lr	A,QU	*/
		/*	lr	A,QL	*/
		if (((t1 == S_RAIW) && (a1 == S_A)) && (t2 == S_RKQ)) {
			outab(0x00 | (a2 & 0x03));
		} else
		/*	lr	KU,A	*/
		/*	lr	KL,A	*/
		/*	lr	QU,A	*/
		/*	lr	QL,A	*/
		if ((t1 == S_RKQ) && ((t2 == S_RAIW) && (a2 == S_A))) {
			outab(0x04 | (a1 & 0x03));
		} else
		/*	lr	A,r	*/
		if (((t1 == S_RAIW) && (a1 == S_A)) && ((t2 == S_R8) || (t2 == S_RSID))) {
			outab(0x40 | a2);
		} else
		/*	lr	r,A	*/
		if (((t1 == S_R8) || (t1 == S_RSID)) && ((t2 == S_RAIW) && (a2 == S_A))) {
			outab(0x50 | a1);
		} else
		/*	lr	Q,DC	*/
		if (((t1 == S_R16) && (a1 == S_Q)) && ((t2 == S_R16) && (a2 == S_DC))) {
			outab(0x0E);
		} else
		/*	lr	DC,Q	*/
		if (((t1 == S_R16) && (a1 == S_DC)) && ((t2 == S_R16) && (a2 == S_Q))) {
			outab(0x0F);
		} else
		/*	lr	H,DC	*/
		if (((t1 == S_R16) && (a1 == S_H)) && ((t2 == S_R16) && (a2 == S_DC))) {
			outab(0x11);
		} else
		/*	lr	DC,H	*/
		if (((t1 == S_R16) && (a1 == S_DC)) && ((t2 == S_R16) && (a2 == S_H))) {
			outab(0x10);
		} else
		/*	lr	P,K	*/
		if (((t1 == S_R16) && (a1 == S_P)) && ((t2 == S_R16) && (a2 == S_K))) {
			outab(0x09);
		} else
		/*	lr	K,P	*/
		if (((t1 == S_R16) && (a1 == S_K)) && ((t2 == S_R16) && (a2 == S_P))) {
			outab(0x08);
		} else
		/*	lr	P0,Q	*/
		if (((t1 == S_R16) && (a1 == S_P0)) && ((t2 == S_R16) && (a2 == S_Q))) {
			outab(0x0D);
		} else {
			outab(op);
			aerr();
		}
		break;

	case S_ROP:
		/*
		 * as	r
		 * asd	r
		 * ds	r
		 * ns	r
		 * xs	r
		 */
		t1 = addr(&e1);
		a1 = aindx;
		if ((t1 == S_R8) || (t1 == S_RSID)) {
			outab (op | a1);
		} else {
			outab(op);
			aerr();
		}
		break;

	case S_IO:
		/*
		 * in	port
		 * out	port
		 */
		t1 = addr(&e1);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outab(op);
		outrb(&e1, R_NORM);
		break;

	case S_IOS:
		/*
		 * ins	port
		 * outs	port
		 */
		t1 = addr(&e1);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrbm(&e1, M_4BIT | R_MBRU, op);
		break;

	case S_BRA:
		/*
		 * bp	addr
		 * bc	addr
		 * bz	addr
		 * br7	addr
		 * bm	addr
		 * bnc	addr
		 * bnz	addr
		 * bno	addr
		 */
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 1);
			if ((v1 < -128) || (v1 > 127)) {
				aerr();
			}
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER) {
			rerr();
		}
		break;

	case S_BRT:
		/*
		 * bt	tc,addr
		 */
		t1 = addr(&e1);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		comma(1);
		expr(&e2, 0);
		if (e2.e_mode != S_USER) {
			rerr();
		}
		outrbm(&e1, M_3BIT | R_MBRO, op);
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -128) || (v2 > 127)) {
				aerr();
			}
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		break;

	case S_BRF:
		/*
		 * bf	tc,addr
		 */
		t1 = addr(&e1);
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		comma(1);
		expr(&e2, 0);
		if (e2.e_mode != S_USER) {
			rerr();
		}
		outrbm(&e1, M_4BIT | R_MBRO, op);
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -128) || (v2 > 127)) {
				aerr();
			}
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		break;

	case S_INH:
		/*
                 * adc
                 * am
                 * amd
		 * clr
                 * cm
                 * com
                 * di
                 * ei
                 * inc
                 * lm
                 * lnk
                 * nm
                 * nop
                 * om
                 * pk
                 * pop
                 * sl1
                 * sl4
                 * sr1
                 * sr4
                 * st
                 * xdc
		 * xm
                 */
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = f8cyc[cb[0] & 0xFF];
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
 * Machine dependent initialization
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
