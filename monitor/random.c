#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

void matrix_fade(void);
void matrix_put(unsigned, unsigned, unsigned);

void delay(unsigned int limit);
void main(void);
unsigned char random(unsigned int);

// for now, the first function in the object is the one that gets run
// we mark the entry point in the object code, but we need a program loader
// to use it
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  // zero the bss
  main();
}

unsigned char random(unsigned int r_base) {
  static unsigned int y;
  static unsigned int r;

  if (r == 0 || r == 1 || r == -1)
    r = r_base;
  r = (9973 * ~r) + (y % 701);
  y = (r >> 24) % 9;
  return y;
}

void delay(unsigned int limit) {
  unsigned i;
  for (i=0; i < limit; i++);
}

void matrix_put(unsigned x, unsigned y, unsigned val) {
  if (y > 15 || x > 31)
    return;
  matrix[y*32+x] = val;
}

void matrix_clear() {
  int i;
  for (i=0; i < 32*16; i++)
    matrix[i] = 0x00;
}

void main(void) {
  unsigned char c;

  matrix_clear();
  while (1) {
    c = random(sw[0]);
    leds[0] = c;
    matrix_put(c%32, 0, 0x00ff00ff);
    delay(0x300000);
  }
}
