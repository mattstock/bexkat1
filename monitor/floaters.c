#include <stdio.h>
#include <math.h>
#include "misc.h"

double foo() {
  return 120.0;
}

void main(void) {
  float a = 1.0f;
  float b = 120.0f;
  int c = -1;
  
  printf("%f * %f = %f\n", a,b,a*b);
  printf("sqrtf(%f) = %f\n", b, sqrtf(b));
  a = 100.0f; b = 50.0f;
  printf("%f + %f = %f\n", a,b,a+b);
  printf("%f/%f = %f\n", a,b, a/b);
  while (1);
}
