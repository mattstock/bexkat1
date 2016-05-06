#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <math.h>
#include <matrix.h>
#include <misc.h>
#include <vga.h>

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
  float ax,ay, xy, xmidsub, xy2, xn1, yn1;
  float xn,yn, rx, ry;
  float res,xsq,ysq;
  
  for (x=0; x < 640; x++) {
    ax = cx+(x-320)*scale;
    for (y=0; y < 480; y++) {
      ay = cy+(y-240)*scale;
      xn = ax;
      yn = ay;
      lp = 0; 
      do {
        lp++;
        xsq = xn*xn;
        ysq = yn*yn;
	xy = xn * yn;
	xmidsub = xsq - ysq;
	xy2 = 2.0f*xy;
	xn1 = xmidsub + ax;
        yn1 = xy2+ay;
        xn = xn1;
        yn = yn1;
	rx = xn*xn;
	ry = yn*yn;
        res = rx + ry;
      } while ((lp <= 255) && (res <= limit) &&
	       (fpclassify(res) != FP_INFINITE));
      if (lp > 255)
        vga_point(x, y, 0);
      else
        vga_point(x, y, lp);
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
  double a = -0.9; //= 0.1;
  double b = -0.2; //= 0.0;
  double c = 0.001; //= 0.008;
  int x = 0;

  printf("Defining palette 0\n");
  for (x=0; x < 256; x++)
    vga_palette(0, x, x | (x << 8));

  vga_set_mode(VGA_MODE_NORMAL);

  printf("starting (%f, %f, %f)\n", a, b, c);
  clear();
  mandelbrot_float(a,b,c);
}
