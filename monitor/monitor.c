#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

void serial_putbin(unsigned short port, unsigned short *list, unsigned short len);
void serial_putchar(unsigned short, char);
char serial_getchar(unsigned short);
void serial_print(unsigned short, char *);
void matrix_init(void);
void matrix_put(unsigned, unsigned, unsigned);

void delay(unsigned int limit);
void main(void);
char *itos(unsigned int val, char *s);
unsigned char random(unsigned int);

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

unsigned char random(unsigned int r_base) {
  static unsigned char y;
  static unsigned int r;

  if (r == 0 || r == 1 || r == -1)
    r = r_base;
  r = (9973 * ~r) + (y % 701);
  y = (r >> 24);
  return y;
}

void delay(unsigned int limit) {
  unsigned i;
  for (i=0; i < limit; i++);
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

void serial_putbin(unsigned short port, unsigned short *list, unsigned short len) {
  unsigned short i;

  for (i=0; i < len; i++)
    serial_putchar(port, (char)list[i]);
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

unsigned short katherine[] = { 194, 132, 190, 148, 129, 141 }; 

void main(void) {
  char c;
  unsigned val;
  unsigned short x, y;

  x = 16;
  y = 8;
  val = 0x80808000;
  serial_putbin(1, katherine, 6);
  while (1) {
    c = random(2000);
    switch (c % 4) {
      case 0:
        if (x > 0)
          x--;
        break;
      case 1:
        if (x < 31)
          x++;
        break;
     case 2:
       if (y > 0)
         y--;
       break;
     case 3:
       if (y < 15)
         y++;
       break;
    }  
    c = random(2000);
    switch (c % 4) {
      case 0:
        val += 0x0f;
        break;
      case 1:
        val += 0xf00;
        break;
      case 2:
        val += 0xf0000;
        break;
      case 3:
        val += 0xf000000;
        break;
    }  
    matrix_put(x,y, val);
    delay(0x500);
  }
}
