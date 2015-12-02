#include <stdio.h>
#include <math.h>
#include "matrix.h"

void main(void) {
  int i;

  for (i = 0 ; i < 100; i++) 
    printf("i = %i (%08x)\n", i, i);
  while (1);
}
 
