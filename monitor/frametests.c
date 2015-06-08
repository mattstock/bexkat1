#include "matrix.h"
#include "misc.h"

int a(int x);
int b(int x, int y, int z);
void bitprint(unsigned row, unsigned val);

void bitprint(unsigned row, unsigned val) {
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

int a(int x) {
  unsigned int h = 32;
  return 32 + x;
}

int b(int x, int y, int z) {
  return a(x) + y + z;
}

void main(void) {
  unsigned x;
  unsigned char c;

  matrix[0] = 0;
  matrix[1] = 0;
  matrix[2] = 0;
  matrix[0] = 0x00ff0000;
  c = random(2000);
  matrix[0] = 0x0000ff00;
  bitprint(3, c);
  matrix[0] = 0x000000ff;
  bitprint(4, 10);
  matrix[1] = 0x000000ff;
  matrix[2] = 0x00ff0000;
  delay(10000);
  matrix[2] = 0x000000ff;
  while (1);
}
