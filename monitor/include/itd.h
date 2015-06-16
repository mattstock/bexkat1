#ifndef _ITD_H
#define _ITD_H

extern volatile unsigned int *spi;

extern void itd_backlight(int s);
extern void itd_init();
extern void itd_rect(unsigned short x0,
		     unsigned short y0,
		     unsigned short x1,
		     unsigned short y1,
		     unsigned short color);
extern unsigned short color565(unsigned char r,
			       unsigned char g,
			       unsigned char b);

#endif
