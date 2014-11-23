/* f8adr:c */

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

int aindx;

int
addr(esp)
struct expr *esp;
{
	int c;

	aindx = 0;
	if ((c = getnb()) != ',') {
		unget(c);
	}
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else
	if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_EXT;
	} else {
		unget(c);
		if (admode(regaiw)) {
			esp->e_mode = S_RAIW;
		} else
		if (admode(regsid)) {
			esp->e_mode = S_RSID;
		} else
		if (admode(regkq)) {
			esp->e_mode = S_RKQ;
		} else
		if (admode(reg8)) {
			esp->e_mode = S_R8;
		} else
		if (admode(reg16)) {
			esp->e_mode = S_R16;
		} else {
			expr(esp, 0);
			esp->e_mode = S_EXT;
		}
	}
	aindx &= 0x0F;
	return (esp->e_mode);
}

/*
 * Enter admode() to search a specific addressing mode table
 * for a match. Return the addressing value on a match or
 * zero for no match.
 */
int
admode(sp)
struct adsym *sp;
{
	char *ptr;
	int i;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			aindx |= sp[i].a_val;
			return(aindx);
		}
		i++;
	}
	ip = ips;
	return(0);
}

/*
 *      srch --- does string match ?
 */
int
srch(str)
char *str;
{
	char *ptr;
	ptr = ip;

	while (*ptr && *str) {
		if (ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr & 0x007F] == ccase[*str & 0x007F]) {
		ip = ptr;
		return(1);
	}

	if (!*str)
		if (any(*ptr," \t\n,];")) {
			ip = ptr;
			return(1);
		}
	return(0);
}

/*
 *      any --- does str contain c?
 */
int
any(c,str)
int c;
char *str;
{
	while (*str)
		if(*str++ == c)
			return(1);
	return(0);
}

struct adsym	regaiw[] = {
    {	"a",	0x100	},
    {	"is",	0x101	},
    {	"w",	0x102	},
    {	"",	0x000	}
};
struct adsym	regsid[] = {
    {	"s",	0x10C	},
    {	"i",	0x10D	},
    {	"d",	0x10E	},
    {	"",	0x000	}
};

struct adsym	regkq[] = {
    {	"ku",	0x10C	},
    {	"kl",	0x10D	},
    {	"qu",	0x10E	},
    {	"ql",	0x10F	},
    {	"",	0x000	}
};

struct adsym	reg8[] = {
    {	"r0",	0x100	},
    {	"r1",	0x101	},
    {	"r2",	0x102	},
    {	"r3",	0x103	},
    {	"r4",	0x104	},
    {	"r5",	0x105	},
    {	"r6",	0x106	},
    {	"r7",	0x107	},
    {	"r8",	0x108	},
    {	"r9",	0x109	},
    {	"r10",	0x10A	},
    {	"r11",	0x10B	},
    {	"j",	0x109	},
    {	"hu",	0x10A	},
    {	"hl",	0x10B	},
    {	"",	0x000	}
};

struct adsym	reg16[] = {
    {	"pc0",	0x100	},
    {	"p0",	0x100	},
    {	"pc",	0x100	},
    {	"pc1",	0x101	},
    {	"p1",	0x101	},
    {	"p",	0x101	},
    {	"dc0",	0x102	},
    {	"dc",	0x102	},
    {	"d0",	0x102	},
    {	"h",	0x104	},
    {	"k",	0x105	},
    {	"q",	0x106	},
    {	"",	0x000	}
};


