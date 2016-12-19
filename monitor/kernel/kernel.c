#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <vga.h>
#include <misc.h>
#include <matrix.h>

extern unsigned font88[];

// x,y defines the upper left corner for now
void drawchar(int x, int y, char c) {
  // need 2 unsigned for the 8x8 char
  int a, b, v, w, on;
  unsigned int bitmap;

  bitmap = font88[2*c];
  for (int b=0; b < 32; b++) {
      v = x+(b%8);
      w = y+(b/8);
      on = (bitmap & (1 << (31-b)) ? 0xff : 0x00);
      matrix_put(v,w, on);
      vga_point(v,w, on);
  }
  bitmap = font88[2*c+1];
  for (int b=0; b < 32; b++) {
      v = x+(b%8);
      w = y+4+(b/8);
      on = (bitmap & (1 << (31-b)) ? 0xff : 0x00);
      matrix_put(v,w, on);
      vga_point(v,w, on);
  }
}

void main(void) {
  int i;
  char buf[10];
  int x,y;
  unsigned int b;

  vga_set_mode(0);
  vga_palette(0, 255, 0x0000ff00);

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
