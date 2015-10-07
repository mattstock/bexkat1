#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include "itd.h"
#include "matrix.h"
#include "misc.h"

void mandelbrot(float cx, float cy, float scale) {
  float limit = 4.0f;
  int x,y,lp;
  float ax,ay;
  float a1,b1,a2,b2;
  float res,asq,bsq;

  for (x=-120; x < 120; x++) {
    ax = cx+x*scale;
    for (y=-160; y < 160; y++) {
      printf("(%d,%d): ", x+120, y+160);
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
      } while ((lp <= 255) && (res <= limit));
      printf("lp = %d, res = %f ab = (%f,%f)\n", lp, res, a1, b1);
      if (lp > 255)
        itd_rect(x+120,y+160,x+120,y+160,color565(0,0,0));
      else
        itd_rect(x+120,y+160,x+120,y+160,color565(0,0,lp));
    }
  }
}

void main(void) {
  itd_init();
  itd_backlight(1);
  mandelbrot(0.36f,0.1f,0.0001f);
  while (1);
}
