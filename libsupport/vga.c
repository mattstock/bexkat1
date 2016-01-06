#include "vga.h"

volatile unsigned char *vga_fb = (unsigned char *)0xc0000000;
volatile unsigned int *vga_palette0 = (unsigned int *)0x80000000;
volatile unsigned int *vga_palette1 = (unsigned int *)0x80000400;
volatile unsigned int *vga_font0    = (unsigned int *)0x80000800;
volatile unsigned int *vga_control  = (unsigned int *)0x80000c00;

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

vga_mode_t vga_mode(void) {
  return (vga_mode_t)(vga_control[1] & 0x3);
}

void vga_set_mode(vga_mode_t m) {
  vga_control[1] = (vga_control[1] & 0xfffffffc) | (m & 0x3);
}
