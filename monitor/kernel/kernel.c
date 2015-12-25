#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include "itd.h"
#include "matrix.h"
#include "misc.h"

extern unsigned font88[];

// x,y defines the upper left corner for now
void drawchar(int x, int y, char c) {
  // need 2 unsigned for the 8x8 char
  int a, b, v, w, on;
  unsigned bitmap;

  bitmap = font88[2*c];
  for (int b=0; b < 32; b++) {
      v = x+(b%8);
      w = y+(b/8);
      on = (bitmap & (1 << (31-b)) ? 0xff : 0x00);
      matrix_put(v,w,on);
      itd_rect(v,w,v+1,w+1,color565(on,0,0));
  }
  bitmap = font88[2*c+1];
  for (int b=0; b < 32; b++) {
      v = x+(b%8);
      w = y+4+(b/8);
      on = (bitmap & (1 << (31-b)) ? 0xff : 0x00);
      matrix_put(v,w,on);
      itd_rect(v,w,v+1,w+1,color565(on,0,0));
  }
}

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
  int i;
  char buf[10];
  int x,y;
  unsigned int b;

  x = 75497472;
  y = -239075328;
  printf("%d -> %d, %d -> %d\n", x, x>>16, y, y>>16);
  b = x;
  printf("%d -> %d\n", b, b>>16);
  b = y;
  printf("%d -> %d\n", b, b>>16);
  x = 0;
  y = 0;
  itd_init();
  itd_backlight(1);
  mandelbrot(0.36f,0.1f,0.0001f);
  while (1) {
    read(0, buf, 1);
    printf("%c\n", buf[0]);
    drawchar(x,y,buf[0]);
    x += 8;
    if (x == 32) {
      y += 8;  x=0;
    }
    if (y == 16) {
      y = 0;
    }
  }
  for (i=0; i < 128; i++) {
    printf("%x\n", i);
    drawchar(0,0, (char)i);
    delay(0x10000);
  }
  while (1);
}
