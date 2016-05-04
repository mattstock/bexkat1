#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <math.h>
#include "matrix.h"
#include "misc.h"
#include "vga.h"
#include "keyboard.h"
#include <math.h>

volatile float * const mand =  (float *)0xd0000000;
volatile unsigned int * const mand_control = (unsigned int *)0xd0000020;

#define MAND_X0   0
#define MAND_Y0   1
#define MAND_XN   2
#define MAND_YN   3
#define MAND_RES  4
#define MAND_PUSH 0
#define MAND_POP  1

typedef union {
  float f;
  unsigned int i;
} mixel;

void mandelbrot_double(double cx, double cy, double scale) {
  double limit = 4.0;
  int x,y,lp;
  double ax,ay;
  double a1,b1,a2,b2;
  double res,asq,bsq;

  for (x=-120; x < 120; x++) {
    ax = cx+x*scale;
    for (y=-160; y < 160; y++) {
      ay = cy+y*scale;
      a1 = ax;
      b1 = ay;
      lp = 0; 
      sysctrl[0] = ((x & 0xffff)) << 16 | (y & 0xffff);
      do {
	if (keyboard_count() != 0) // abort on keypress
	  return;
        lp++;
        asq = a1*a1;
        bsq = b1*b1;
        a2 = asq - bsq + ax;
        b2 = 2.0*a1*b1+ay;
        a1 = a2;
        b1 = b2;
        res = a1*a1 + b1*b1;
      } while ((lp <= 255) && (res <= limit));
      if (lp > 255)
        vga_point(x+320, y+240, 0);
      else
        vga_point(x+320, y+240, lp);
    }
  }
}

void mandelbrot_float(float cx, float cy, float scale) {
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
	if (keyboard_count() != 0) // abort on keypress
	  return;
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

void circle(int a, int b, int size) {
  int d = 1 - size;
  int x = size;
  int y = 0;

  while (y <= x) {
    vga_point(x+a,y+b, 0xff);
    vga_point(y+a,x+b, 0xff);
    vga_point(a-x,y+b, 0xff);
    vga_point(a-y,x+b, 0xff);
    vga_point(a-x,b-y, 0xff);
    vga_point(a-y,b-x, 0xff);
    vga_point(x+a,b-y, 0xff);
    vga_point(y+a,b-x, 0xff);
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
  double a = 0.1;
  double b = 0.0;
  double c = 0.008;
  int x = 0;

  printf("Clearing screen\n");
  clear();
  printf("Defining palette 0\n");
  for (x=0; x < 256; x++)
    vga_palette(0, x, x | (x << 8));
  
  vga_set_mode(VGA_MODE_NORMAL);
  
  while (1) {
    x = 1;
    if (x) {
      printf("starting (%f, %f, %f)\n", a, b, c);
      mandelbrot_float(a,b,c);
      /*      printf("now doubles\n");
	      mandelbrot_double(a,b,c); */
      printf("done\n");
    }
    while (keyboard_count() == 0);
    switch (keyboard_getevent()) { 
    case 0x1c: // a
      a -= 0.1f;
      break;
    case 0x23: // d
      a += 0.1f;
      break;
    case 0x1b: // s
      b -= 0.1f;
      break;
    case 0x1d: // w
      b += 0.1f;
      break;
    case 0x2d: // r
      c += 0.001f;
      break;
    case 0x2b: // f
      c -= 0.001f;
      break;
    default:
      x = 0;
    }
    
    // eat key release
    do {
      while (keyboard_count() == 0);
    } while (keyboard_getevent() < 256);
  }
}
