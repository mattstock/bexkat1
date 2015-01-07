#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

void serial_putchar(unsigned short, char);
char serial_getchar(unsigned short);
void serial_print(unsigned short, char *);
void matrix_init(void);
void matrix_put(unsigned, unsigned, unsigned);

void delay(void);
void main(void);

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

char serial_getchar(unsigned short port) {
  unsigned short result;
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

  result  = p[0];
  while ((result & 0x8000) == 0) {
    matrix[64] = 0xff000000;
    result = p[0];
  }
  matrix[65] = 0x00ff0000;
  return (char)(result & 0xff); 
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
  unsigned i;
  char c;
  unsigned short x, y;

  serial_print(0, "\r\nbexkat> ");
  matrix_init();
  x = 16;
  y = 8;

  while (1) {
    matrix_put(x,y, 0x0000ff00);
    c = serial_getchar(0);
    serial_putchar(0,c);
    matrix_put(x,y, 0x00ff0000);
    if (c == 'a')
      x--;
    if (c == 'w')
      y--;
    if (c == 'd')
      x++;
    if (c == 's')
      y++;
  }
}
