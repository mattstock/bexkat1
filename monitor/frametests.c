#include "matrix.h"
#include "misc.h"

int a(int x);
int b(int x, int y, int z);

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
  matrix_bitprint(3, c);
  matrix[0] = 0x000000ff;
  matrix_bitprint(4, 10);
  matrix[1] = 0x000000ff;
  matrix[2] = 0x00ff0000;
  delay(10000);
  matrix[2] = 0x000000ff;
  while (1);
}
