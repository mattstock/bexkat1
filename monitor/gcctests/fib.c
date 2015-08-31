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
  char a[1024];
  a[x % 1024] = 'a';
  if (x == 0)
    return 0;
  if (x == 1)
    return 1;
  return fib(x-1) + fib(x-2) + a[(x+3)%1024];
}

void main(void) {
  unsigned v;

  matrix[0] = 0x00ff0000;
  matrix[1] = 0x00000000;
  matrix[2] = 0x00000000;
  matrix[0] = 0x0000ff00;
  bitprint(1, 0xffffffff); 
  bitprint(2, 0xa0244fd1); 
  bitprint(3, 0xaaaa5555); 
  matrix[1] = 0x00ff0000;
  v = fib(30);
  matrix[1] = 0x0000ff00;
  bitprint(4, v);
  matrix[2] = 0x0000ff00;
  while (1);
}
