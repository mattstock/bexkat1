#include "serial.h"
#include "misc.h"
#include "matrix.h"

unsigned fib(unsigned short x);
void bitprint(short row, unsigned val);

void bitprint(short row, unsigned val) {
  unsigned short i=0;

  while (i < 32) {
    matrix[row*32+i] = 0x00000000;
    i++;
  }
  i = 31;
  while (val) {
    if (val & 0x1)
      matrix[row*32+i] = 0x00ff0000;
    val = val >> 1;
    i--;
  }
}

unsigned fib(unsigned short x) {
  if (x == 0)
    return 0;
  if (x == 1)
    return 1;
  return fib(x-1) + fib(x-2);
}

void main(void) {
  unsigned v;

  matrix[0] = 0x00ff0000;
  matrix[2] = 0x00000000;
  while (1) {
    bitprint(1, 0xffffffff); 
    bitprint(3, 0xaaaa5555); 
    matrix[1] = 0xff000000;
    v = fib(250);
    matrix[1] = 0x00ff0000;
    bitprint(2, v);
    matrix[2] = 0x00ff0000;
  }
}
