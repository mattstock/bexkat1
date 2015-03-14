#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

// LED matrix stuff
void matrix_put(unsigned, unsigned, unsigned);

void main(void);

// for now, the first function in the object is the one that gets run
// we mark the entry point in the object code, but we need a program loader
// to use it
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  main();
}

void matrix_put(unsigned x, unsigned y, unsigned val) {
  if (y > 15 || x > 31)
    return;
  matrix[y*32+x] = val;
}

void main() {
  unsigned char x;
  int c;
  int i;
  while (1) {
    serial0[
    for (c=0; c < 12; c++) {
      matrix_put(19,c,0xff00);
      x = serial0[c];
      serial0[c] = '0' + c;
      for (i=0; i < 8; i++) {
        matrix_put(i,c, (x & 0x80 ? 0xff : 0x0));
        x = x << 1;
      }
    }
  } 
}
