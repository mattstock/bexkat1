#include "matrix.h"

unsigned *matrix = (unsigned *)0x20000000;

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

void matrix_bitprint(unsigned row, unsigned val) {
  unsigned int i=0;

  while (i < 32) {
    matrix[row*32+i] = 0x00000000;
    i++;
  }
  i = 31;
  while (val) {
    if (val & 0x1)
      matrix[row*32+i] = 0x00ff0000;
    val = val >> 1;
    i--;
  }
}
