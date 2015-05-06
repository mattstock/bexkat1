#include "matrix.h"
#include "misc.h"

void main(void) {
  unsigned char c;

  matrix_init();
  while (1) {
    c = random(1034);
    matrix_put(c%32, 0, 0x00ff00ff);
    delay(0x300000);
  }
}
