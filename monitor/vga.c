#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <math.h>
#include "matrix.h"
#include "misc.h"

unsigned char *vga = (unsigned char *)0xc0000000;
unsigned int *vga_p = (unsigned int *)0x80000000;

void vga_pallette(unsigned char idx, unsigned int color) {
  vga_p[idx] = color;
}

void vga_point(int x, int y, unsigned char val) {
  vga[y*320+x] = val;
}

void mandelbrot(float cx, float cy, float scale) {
  float limit = 4.0f;
  int x,y,lp;
  float ax,ay;
  float a1,b1,a2,b2;
  float res,asq,bsq;

  for (x=-160; x < 160; x++) {
    ax = cx+x*scale;
    for (y=-120; y < 120; y++) {
      ay = cy+y*scale;
      a1 = ax;
      b1 = ay;
      lp = 0; 
      sysctrl[0] = ((x & 0xffff)) << 16 | (y & 0xffff);
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
        vga_point(x+160, y+120, 0);
      else
        vga_point(x+160, y+120, lp);
    }
  }
}

void clear() {
  int x,y;
  for (y=0; y < 240; y++)
    for (x=0; x < 320; x++)
      vga_point(x,y,0x00);
}

void main(void) {
  int x,y;
  x = 0;

  clear();
  for (x=0; x < 256; x++)
    vga_pallette(x, x);
  printf("starting mandelbrot\n");
  mandelbrot(0.36f,0.1f,0.0001f);
  printf("done\n");
  while (1);
}
