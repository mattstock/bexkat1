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
  unsigned int x;
  int c;
  int i;
  while (1) {
    matrix_put(3,1,0xff);
    matrix_put(2,1,0xff00);
    matrix_put(1,1,0xff0000);
    matrix_put(0,1,0xff000000);
    x = serial0[0];
    for (i=0; i < 32; i++) {
      matrix_put(i,0, (x & 0x80000000 ? 0xff : 0x0));
      x = x << 1;
    }
    serial0[0] = 'a';
  } 
}
