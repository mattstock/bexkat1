#include "matrix.h"

int main(void) {
  matrix[0] = 0xff; // b
  matrix[1] = 0xffff; // cyan
  matrix[3] = 0xffffff; // white
  matrix[32] = 0xff00; // g
  
  matrix[64+2] = 0xff0000; // r
  while (1);
}
