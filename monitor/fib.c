#include <stdio.h>
#include "misc.h"
#include "matrix.h"
#include "vectors.h"

unsigned fib(unsigned short x);


unsigned fib(unsigned short x) {
  if (x == 0)
    return 0;
  if (x == 1)
    return 1;
  return fib(x-1) + fib(x-2);
}

void main(void) {
  unsigned v;

  matrix_bitprint(1, 0xffffffff); 
  matrix_bitprint(2, 0xa0244fd1); 
  matrix_bitprint(3, 0xaaaa5555); 
  matrix_put(0,0,0xff0000);
  v = fib(30);
  matrix_put(1,0,0xff00);
  matrix_bitprint(4, v); 
  while (1);
}
