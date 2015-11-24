#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <math.h>
#include "matrix.h"
#include "misc.h"

unsigned char *vga = (unsigned char *)0xc0000000;
unsigned int *vga_p = (unsigned int *)0xc0400000;
unsigned int *sw = (unsigned *)0x20000810;

void vga_pallette(unsigned char idx, unsigned int color) {
  vga_p[idx] = color;
}

void vga_point(int x, int y, unsigned char val) {
  vga[y*640+x] = val;
}

void mandelbrot(float cx, float cy, float scale) {
  float limit = 4.0f;
  int x,y,lp;
  float ax,ay;
  float a1,b1,a2,b2;
  float res,asq,bsq;

  for (x=-320; x < 320; x++) {
    ax = cx+x*scale;
    for (y=-240; y < 240; y++) {
      ay = cy+y*scale;
      a1 = ax;
      b1 = ay;
      lp = 0; 
      do {
        lp++;
        asq = a1*a1;
        bsq = b1*b1;
        a2 = asq - bsq + ax;
        b2 = 2.0f*a1*b1+ay;
        a1 = a2;
        b1 = b2;
        res = a1*a1 + b1*b1;
      } while ((lp <= 255) && (res <= limit) && (fpclassify(res) != FP_INFINITE));
      if (lp > 255)
        vga_point(x+320, y+240, 0);
      else
        vga_point(x+320, y+240, lp);
    }
  }
}

void clear() {
  int x,y;
  for (y=0; y < 480; y++)
    for (x=0; x < 640; x++)
      vga_point(x,y,0x00);
}

void main(void) {
  int x,y;
  x = 0;

  switch (sw[0]) {
  case 0:
    for (x=0; x < 256; x++)
      vga_pallette(x, 0);
    clear();
    break;
  case 1:
    for (x=0; x < 256; x++)
      vga_pallette(x, 0);
    clear();
    vga_pallette(1,0xff0000);
    vga_pallette(2,0xff00);
    vga_pallette(3,0xff);
    vga_point(0,0,0x01);
    vga_point(1,0,0x02);
    vga_point(2,0,0x03);
    break; 
  default:
    clear();
    for (x=0; x < 256; x++)
      vga_pallette(x, ((x&0xf0) << 12) | (x >> 1));
    for (x=0; x < 640; x++)
      for(y=0; y < 480; y++)
        vga_point(x,y, ((y%16) << 4)|(x%16));
    printf("starting mandelbrot\n");
    mandelbrot(0.36f, 0.1f, 0.0001f);
    break;
  }
  printf("done\n");
  while (1);
}
