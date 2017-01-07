#include <unistd.h>
#include <stdio.h>
#include <stdarg.h>
#include "vga.h"

volatile unsigned char * const vga_fb = (unsigned char *)VGA_FB_BASE;
volatile unsigned int * const vga_palette0 = (unsigned int *)VGA_P0_BASE;
volatile unsigned int * const vga_palette1 = (unsigned int *)VGA_P1_BASE;
volatile unsigned int * const vga_font0    = (unsigned int *)VGA_F0_BASE;
volatile unsigned int * const vga_control  = (unsigned int *)VGA_CTL_BASE;

void vga_palette(int pnum, unsigned char idx, unsigned int color) {
  if (pnum == 0)
    vga_palette0[idx] = color;
  else
    vga_palette1[idx] = color;    
}

short vga_getline(unsigned int color, char *str, unsigned short *len) {
  unsigned short i=0;
  unsigned char c;
  unsigned char buf[1];
  unsigned char c233 = vga_color233(color);

  while (i < *len-1) {
    read(0, buf, 1);
    c = buf[0];
    if (c >= ' ' && c <= '~') {
      vga_putchar(c233,c);
      str[i++] = c;
    }
    if (c == '\r' || c == '\n') {
      str[i] = '\0';
      return i;
    }
    if (c == 0x03) {
      str[0] = '\0';
      return -1;
    }
    if ((c == 0x7f || c == 0x08) && i > 0) {
      vga_putchar(vga_color233(VGA_TEXT_WHITE),c);
      i--;
    }
  }
  str[i+1] = '\0';
  return i;
}

void vga_point(int x, int y, unsigned char val) {
  if (x < 0 || y < 0 || x >= VGA_MAX_X || y >= VGA_MAX_Y)
    return;
  vga_fb[y*VGA_MAX_X+x] = val;
}

unsigned char vga_mode(void) {
  return (unsigned char)(vga_control[1] & 0xff);
}

void vga_set_mode(unsigned char m) {
  vga_control[1] = (vga_control[1] & 0xffffff00) | m;
}

void vga_text_clear() {
  for (int i=0; i < VGA_TEXT_MAX_X*VGA_TEXT_MAX_Y*2; i += 4) {
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
  int base = 2*(y*VGA_TEXT_MAX_X+x);

  switch (c) {
    case '\n':
      x=0;
      y++;
      vga_set_cursor(x,y);
      break;
    case '\r':
      y++;
      vga_set_cursor(x,y);
      break;
    case 0x08:
    case 0x7f:
      x++;
      vga_set_cursor(x,y);
      vga_fb[base-2] = color233;
      vga_fb[base-1] = ' ';
      break;
    default:
      x++;
      vga_fb[base] = color233;
      vga_fb[base+1] = c;
      vga_set_cursor(x, y);
      break;
  }
  if (y >= VGA_TEXT_MAX_Y-1) {
    vga_scroll(1);
    vga_set_cursor(x,VGA_TEXT_MAX_Y-2);
  }
}  

void vga_copy(int to, int from) {
  int to_base = 2*to*VGA_TEXT_MAX_X;
  int from_base = 2*from*VGA_TEXT_MAX_X;
  
  for (int x=0; x < VGA_TEXT_MAX_X; x++) {
    vga_fb[to_base+2*x] = vga_fb[from_base+2*x];
    vga_fb[to_base+2*x+1] = vga_fb[from_base+2*x+1];
  }
}

// positive means shift up the screen, negative is shift down.
void vga_scroll(int offset) {
  if (offset > 0) {
    for (int y=offset; y < VGA_TEXT_MAX_Y; y++)
      vga_copy(y-offset, y);
    for (int y=VGA_TEXT_MAX_Y-offset; y < VGA_TEXT_MAX_Y; y++)
      for (int x=0; x < VGA_TEXT_MAX_X; x++) {
	int base = 2*(y*VGA_TEXT_MAX_X+x);
	vga_fb[base] = 0xff;
	vga_fb[base+1] = 0x20;
      }
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
