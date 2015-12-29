#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <math.h>
#include "matrix.h"
#include "misc.h"
#include <math.h>

unsigned char *vga = (unsigned char *)0xc0000000;
unsigned int *vga_p = (unsigned int *)0x80000000;
unsigned int *kbd = (unsigned int *)0x30004000;


void vga_pallette(unsigned char idx, unsigned int color) {
  vga_p[idx] = color;
}

void vga_point(int x, int y, unsigned char val) {
  if (x < 0 || y < 0 || x > 639 || y > 479)
    return;
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

void circle(int size) {
  int d = 1 - size;
  int x = size;
  int y = 0;

  while (y <= x) {
    vga_point(x+320,y+240, 0xff);
    vga_point(y+320,x+240, 0xff);
    vga_point(320-x,y+240, 0xff);
    vga_point(320-y,x+240, 0xff);
    vga_point(320-x,240-y, 0xff);
    vga_point(320-y,240-x, 0xff);
    vga_point(x+320,240-y, 0xff);
    vga_point(y+320,240-x, 0xff);
    y++;
    if (d <= 0) {
      d += 2*y+1;
    } else {
      x--;
      d += 2 * (y - x) + 1;
    } 
  }
}

void main(void) {
  float a = 0.1f;
  float b = 0.0f;
  float c = 0.008f;
  int x = 0;

  printf("Clearing screen\n");
  clear();
  printf("Defining palette 0\n");
  for (x=0; x < 256; x++)
    vga_pallette(x, x << 16);
  circle(20);
  while (1) {
    while (kbd[1] == 0);
    switch (kbd[0]) { 
      case 0x1c: 
        a -= 0.1f;
        break;
      case 0x23: 
        a += 0.1f;
        break;
      case 0x1b: 
        b -= 0.1f;
        break;
      case 0x1d: 
        b += 0.1f;
        break;
      case 0x2d:
        c += 0.1f;
        break;
      case 0x2b:
        c -= 0.1f;
        break;
    }
     
    printf("starting (%f, %f, %f)\n", a, b, c);

    mandelbrot(a,b,c);
    printf("done\n");
  }
}
