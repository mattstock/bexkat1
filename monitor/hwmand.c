#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vga.h>
#include <keyboard.h>

volatile float * const xpos =  (float *)0xd0000000;
volatile float * const ypos =  (float *)0xd0001000;
volatile float * const xout =  (float *)0xd0002000;
volatile float * const yout =  (float *)0xd0003000;
volatile float * const x1out = (float *)0xd0004000;
volatile float * const y1out = (float *)0xd0005000;
volatile unsigned int * const mandreg = (unsigned int *)0xd0007000;

typedef union {
  float f;
  unsigned int i;
} mixel;

void main(void) {
  int x,y,lp, found;
  float ax, ay;
  float res;
  int *val = (int *)malloc(2000*sizeof(int));

  printf("starting\n");
  for (x=0; x < 256; x++)
    vga_palette(0, x, x | (x<<8));

  vga_set_mode(VGA_MODE_NORMAL);
  
  for (y=0; y < 480; y++) {
    ay = (y-240)*0.008f;
    printf("row %d\n", y);
    for (x=0; x < 640; x++) {
      ax = 0.1f + (x-320)*0.008f;
      val[x] = 0;
      ypos[x] = ay;
      yout[x] = ay;
      xpos[x] = ax;
      xout[x] = ax;
      x1out[x] = 0.0f;
      y1out[x] = 0.0f;
      vga_point(x, y, 0);
    }

    lp = 0;
    found = 0;
    do {
      lp++;
      mandreg[0] = 1;
      while (mandreg[0] < 0x400);
      for (x=0; x < 640; x++) {
	yout[x] = y1out[x];
	xout[x] = x1out[x];
	if (val[x] == 0) {
	  res = yout[x]*yout[x] + xout[x]*xout[x];
	  if (res > 4.0f || fpclassify(res) == FP_INFINITE) {
	    val[x] = lp;
	    vga_point(x, y, lp);
	    found++;
	  }
	}
      }
    } while (lp < 256 && found < 640);
    printf("found = %d\n", found);
  }
}
