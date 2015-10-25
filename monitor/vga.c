#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <math.h>
#include "matrix.h"
#include "misc.h"
#include "serial.h"

unsigned int *vga = (unsigned *)0xb0000000;
unsigned int *sw = (unsigned *)0x00800810;

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
        vga[640*(y+240)+x+320] = 0;
      else
        vga[640*(y+240)+x+320] = lp;
    }
  }
}

void clear() {
  int x,y;
  for (y=0; y < 480; y++)
    for (x=0; x < 640; x++)
      vga[y*640+x] = 0;
}

void pattern() {
  int x,y;
  for (y=0; y < 480; y++)
    for (x=0; x < 640; x++)
      vga[y*640+x] = (((x>>2)+1) % 8) | ((((y>>2)+1) % 8) << 6);
}

void main(void) {
  int x,y;
  x = 0;

  while (1) {
    iprintf("Select test with switches and press a key\n");
    serial_getchar(0);
    switch (sw[0]) {
    case 0:
      pattern();
      break;
    case 1:
      mandelbrot(0.36f, 0.1f, 0.0001f);
      break;
    case 2:
      mandelbrot(0.36f, 0.1f, 0.00001f);
      break;
    case 3:
      clear();
      break;
    }
  }
}
