#include "matrix.h"
#include "misc.h"

void main() {
  int i,x,y;
  while (1) {
      for (x=0; x < 32; x++)
        for (y=0; y < 16; y++)
          matrix_put(x,y,(y << 19)+x);
      delay(0x10000);
  }
}