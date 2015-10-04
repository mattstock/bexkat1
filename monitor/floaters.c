#include <stdio.h>
#include "misc.h"

void main(void) {
  double a = 10.0;
  double b = 1.000000001;
  float c = 1.0f;
  float d = 0.00001f;
  while (1) {
    delay(5000);
    printf("%f + %f = %f, %f + %f = %f\n", a, b, a+b, c, d, c+d);
    b = a+b;
    c = c+d;
  }
}
