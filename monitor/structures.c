#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

void serial_putchar(unsigned short, char);
char serial_getchar(unsigned short);
void serial_print(unsigned short, char *);
void matrix_init(void);
void matrix_put(unsigned, unsigned, unsigned);

struct foo {
  char x;
  int a;
  int b;
  short c;
};

void test_struct(struct foo *x);
void delay(unsigned int limit);
void main(void);
char *itos(unsigned int val, char *s);

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

void delay(unsigned int limit) {
  unsigned i;
  for (i=0; i < limit; i++);
}

void test_struct(struct foo *x) {
  serial_putchar(0, x->x);
}

char serial_getchar(unsigned short port) {
  unsigned short result;
  volatile unsigned int *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
    break;
  default:
    p = serial0;
  }

  result  = p[0];
  while ((result & 0x8000) == 0)
    result = p[0];
  return (char)(result & 0xff); 
}

char *itos(unsigned int val, char *s) {
  unsigned int c;

  c = val % 10;
  val /= 10;
  if (val)
    s = itos(val, s);
  *s++ = (c+'0');
  return s;
}
  
void serial_putchar(unsigned short port, char c) {
  volatile unsigned int *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
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

void matrix_put(unsigned x, unsigned y, unsigned val) {
  if (y > 15 || x > 31)
    return;
  matrix[y*32+x] = val;
}

void matrix_init(void) {
  unsigned short i;
  for (i=0; i < 16*32; i++) {
    if (i < 32 || i >= 15*32)
      matrix[i] = 0xff000000;
    else
      matrix[i] = 0x00000000;
  }
}

void main(void) {
  struct foo bar;

  bar.x = 'a';
  bar.a = 34;
  serial_putchar(0,bar.x);
  test_struct(&bar);
}
