#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

void serial_putchar(unsigned short, char);
void serial_print(unsigned short, char *);
void delay(void);
void main(void);
unsigned fib(unsigned short x);
void bitprint(short row, unsigned val);

// for now, the first function in the object is the one that gets run
// we mark the entry point in the object code, but we need a program loader
// to use it
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  main();
}

void delay() {
  unsigned i;
  for (i=0; i < 0x10000; i++);
}

void serial_putchar(unsigned short port, char c) {
  volatile unsigned short *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
    break;
  case 2:
    p = serial2;
    break;
  default:
    p = serial0;
  }

  while (!(p[0] & 0x4000));
  p[0] = (unsigned short)c;
}

void serial_print(unsigned short port, char *str) {
  char *c = str;

  while (*c != '\0') {
    serial_putchar(port, *c);
    c++;
  }
}

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
    v = fib(sw[1]);
    matrix[1] = 0x00ff0000;
    bitprint(2, v);
    matrix[2] = 0x00ff0000;
  }
}
