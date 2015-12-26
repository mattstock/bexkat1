#include <stdio.h>
#include <math.h>
#include "matrix.h"

void main(void) {
  int i;
  float f;

  while (1) {
    iprintf("Pick a float: ");
    scanf("%f", &f);
    printf("%f * %f = %f\n", f, f, f*f);
    printf("%f / 3.0 = %f\n", f, f/3.0f);
    printf("%f / 1.5 = %f\n", f, f/1.5f);
  }
}
 
