#include "serial.h"
#include "misc.h"

volatile unsigned int *vga = (unsigned int *)0x00c00000;

void vga_fade(void);
void vga_put(unsigned, unsigned, unsigned);

void vga_put(unsigned x, unsigned y, unsigned val) {
  if (y > 480 || x > 640)
    return;
  vga[y*640+x] = val;
}

void vga_fade(void) {
  unsigned short i;
  unsigned a,b;
  unsigned subber;
  for (i=0; i < 16*32; i++) {
    subber=0;
    a = vga[i];
    b = a & 0xff0000;
    if (b >= 0x70000)
      subber += 0x70000;
    else
      subber += b;
    b = a & 0xff00;
    if (b >= 0x700)
      subber += 0x700;
    else
      subber += b;
    b = a & 0xff;
    if (b >= 0x7)
      subber += 0x7;
    else
      subber += b;
    vga[i] -= subber; 
  }
}

void main(void) {
  char c;
  unsigned val;
  unsigned short x, y;

  x = 320;
  y = 240;
  val = 0x00808080;
  for (val=0; val < 640*480; val++)
    vga[val] = 0;
  for (val=0; val < 640; val++)
    vga[640*100+val] = 0x00ffffff;
  while (1);
}
