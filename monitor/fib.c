#include <stdio.h>
#include "misc.h"
#include "matrix.h"
#include "vectors.h"

unsigned int *timers = (unsigned int *)0x30008000;

unsigned fib(unsigned short x);

unsigned fib(unsigned short x) {
  if (x == 0)
    return 0;
  if (x == 1)
    return 1;
  return fib(x-1) + fib(x-2);
}

void timer0(void) {
  matrix_put(0,0,0xff);
  timers[1] &= 0xfffffffe; // clear the fire
  timers[4] += 500000; // reset timer0 interval
}

void timer1(void) {
  matrix_put(0,1,0xff00);
  timers[1] &= 0xfffffffd; // clear the fire
  timers[5] += 50000000; // reset timer1 interval
}

void timer0() __attribute__ ((exception_handler));
void timer1() __attribute__ ((exception_handler));
  
void main(void) {
  unsigned v;
  unsigned int count = 50000000; // 1Hz

  timers[4] = timers[12] + 500000; // 100Hz
  timers[5] = timers[12] + 50000000; // 1Hz
  _vectors_start[2] = &timer0;
  _vectors_start[3] = &timer1;
  timers[0] |= 0x33; // enable timer and timer interrupt
  asm("sti");
  while (1) {
    matrix_put(0,3, 0xff00);
  };
  
  matrix_bitprint(1, 0xffffffff); 
  matrix_bitprint(2, 0xa0244fd1); 
  matrix_bitprint(3, 0xaaaa5555); 
  matrix_put(0,0,0xff0000);
  v = fib(30);
  matrix_put(1,0,0xff00);
  matrix_bitprint(4, v); 
  while (1);
}
