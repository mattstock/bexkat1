#include "matrix.h"
#include "serial.h"

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
