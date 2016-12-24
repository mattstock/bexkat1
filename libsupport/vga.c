#include "vga.h"

volatile unsigned char * const vga_fb = (unsigned char *)0xc0000000;
volatile unsigned int * const vga_palette0 = (unsigned int *)0x80000000;
volatile unsigned int * const vga_palette1 = (unsigned int *)0x80000400;
volatile unsigned int * const vga_font0    = (unsigned int *)0x80000800;
volatile unsigned int * const vga_control  = (unsigned int *)0x80000c00;

void vga_palette(int pnum, unsigned char idx, unsigned int color) {
  if (pnum == 0)
    vga_palette0[idx] = color;
  else
    vga_palette1[idx] = color;    
}

void vga_point(int x, int y, unsigned char val) {
  if (x < 0 || y < 0 || x > 639 || y > 479)
    return;
  vga_fb[y*640+x] = val;
}

unsigned char vga_mode(void) {
  return (unsigned char)(vga_control[1] & 0xff);
}

void vga_set_mode(unsigned char m) {
  vga_control[1] = (vga_control[1] & 0xffffff00) | m;
}

void vga_text_clear() {
  for (int i=0; i < 80*60*2; i += 4) {
    vga_fb[i] = 0xff;
    vga_fb[i+1] = 0x20;
    vga_fb[i+2] = 0xff;
    vga_fb[i+3] = 0x20;
  }
}

unsigned char vga_color233(unsigned int color) {
  unsigned char cf = (color & 0xe0) >> 5;
  cf |= (color & 0xe000) >> 10;
  cf |= (color & 0xc00000) >> 16;
  return cf;
}

void vga_putchar(unsigned short color233, unsigned char c) {
  unsigned pos = vga_control[2];
  unsigned short x = pos & 0xffff;
  unsigned short y = pos >> 16;
  int base = 2*(y*80+x);

  switch (c) {
    case '\n':
      vga_set_cursor(0,y+1);
      break;
    case '\r':
      vga_set_cursor(x,y+1);
      break;
    case 0x08:
    case 0x7f:
      vga_set_cursor(x-1,y);
      vga_fb[base-2] = color233;
      vga_fb[base-1] = ' ';
      break;
    default:
      vga_fb[base] = color233;
      vga_fb[base+1] = c;
      vga_set_cursor(x+1, y);
      break;
  }
}  

void vga_print(unsigned int color, unsigned char *s) {
  unsigned short color233 = vga_color233(color);
  while (*s != '\0') {
    vga_putchar(color233,*s);
    s++;
  }
}

void vga_set_cursor(unsigned short x, unsigned short y) {
  vga_control[2] = (y << 16) | x;
}
