#include <stdio.h>

void main(void) {
  float a = 10.0;
  float b = 3.7;
  int count = 0;
  
  while (count < 100) {
    printf("%.5f * %.5f = %.5f\n", a, b, a*b);
    printf("%.5f + %.5f = %.5f\n", a, b, a+b);
    a = a*b;
    b = a+b;
    count++;
  }
  while (1);
}
