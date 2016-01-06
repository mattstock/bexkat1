#ifndef _ITD_H
#define _ITD_H

extern volatile unsigned int *spi;

void itd_rotation(int r);
void itd_backlight(int s);
void itd_init();
void itd_rect(unsigned short x0,
  unsigned short y0,
  unsigned short x1,
  unsigned short y1,
  unsigned short color);
unsigned short color565(unsigned char r,
  unsigned char g,
  unsigned char b);

#endif
