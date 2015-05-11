#include "matrix.h"

void main() {
  matrix_put(0,0,0xff0000);
  matrix_put(1,1,0xff00);
  matrix_put(2,2,0xff);
  matrix_put(16,8,0xff0000);
  matrix_put(17,9,0xff00);
  matrix_put(18,10,0xff);
  while (1);
}
