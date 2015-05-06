#include "matrix.h"

unsigned *matrix = (unsigned *)0x00800000;

void matrix_put(unsigned x, unsigned y, unsigned val) {
  if (y > 15 || x > 31)
    return;
  matrix[y*32+x] = val;
}

void matrix_init() {
  unsigned short i;

  for (i=0; i < 16*32; i++)
    matrix[i] = 0;
}
