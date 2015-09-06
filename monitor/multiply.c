#include <stdio.h>

void main(void) {
  unsigned int a;
  unsigned int b;
  unsigned long c;

  for (a=1; a < 10; a++) {
    for (b=2000000000; b < 2000000010; b++) {
      iprintf("%u * %u = %u\n", a, b, a*b);
      iprintf("%u + %u = %u\n", a, b, a+b);
      c = a*b;
      iprintf("%u * %u = %lu\n", a,b, c);
    }
  }
  while (1);
}
