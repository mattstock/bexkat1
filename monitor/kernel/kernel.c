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

  itd_init();
  itd_backlight(1);
  bitmap = font88[2*c];
  for (int b=0; b < 32; b++) {
      v = x+(b%8);
      w = y+(b/8);
      on = (bitmap & (1 << (31-b)) ? 0xff : 0x00);
      matrix_put(v,w,on);
      itd_rect(v,w,v,w,color565(on,0,0));
  }
  bitmap = font88[2*c+1];
  for (int b=0; b < 32; b++) {
      v = x+(b%8);
      w = y+4+(b/8);
      on = (bitmap & (1 << (31-b)) ? 0xff : 0x00);
      matrix_put(v,w,on);
      itd_rect(v,w,v,w,color565(on,0,0));
  }
}

void main(void) {
  int i;
  char buf[10];
  int x,y;

  x = 0;
  y = 0;
  while (1) {
    read(0, buf, 1);
    iprintf("%c\n", buf[0]);
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
    iprintf("%x\n", i);
    drawchar(0,0, (char)i);
    delay(0x10000);
  }
  while (1);
}
