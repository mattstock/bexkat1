#include "monitor.h"

void serial_putbin(unsigned port, char *list, unsigned short len);
void serial_putchar(unsigned port, char c);
char serial_getchar(unsigned port);
void serial_print(unsigned port, char *str);
void vga_fade(void);
void vga_put(unsigned, unsigned, unsigned);

void delay(unsigned int limit);
void main(void);
char *itos(unsigned int val, char *s);
unsigned char random(unsigned int);

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

char serial_getchar(unsigned port) {
  unsigned result;
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
  return (char)(p[0] & 0xff); 
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
  
void serial_putchar(unsigned port, char c) {
  volatile unsigned *p;

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

  while (!(p[0] & 0x2000));
  p[0] = (unsigned short)c;
}

void serial_putbin(unsigned port, char *list, unsigned short len) {
  unsigned short i;

  for (i=0; i < len; i++)
    serial_putchar(port, list[i]);
}

void serial_print(unsigned port, char *str) {
  char *c = str;

  while (*c != '\0') {
    serial_putchar(port, *c);
    c++;
  }
}

void vga_put(unsigned x, unsigned y, unsigned val) {
  if (y > 480 || x > 640)
    return;
  vga[y*640+x] = val;
}

void vga_fade(void) {
  unsigned short i;
  unsigned a,b;
  unsigned subber;
  for (i=0; i < 16*32; i++) {
    subber=0;
    a = vga[i];
    b = a & 0xff0000;
    if (b >= 0x70000)
      subber += 0x70000;
    else
      subber += b;
    b = a & 0xff00;
    if (b >= 0x700)
      subber += 0x700;
    else
      subber += b;
    b = a & 0xff;
    if (b >= 0x7)
      subber += 0x7;
    else
      subber += b;
    vga[i] -= subber; 
  }
}

char katherine[] = { 194, 132, 190, 148, 129, 141 }; 
char rebecca[] = { 148, 131, 172, 131, 196, 131 };

void main(void) {
  char c;
  unsigned val;
  unsigned short x, y;

  x = 320;
  y = 240;
  val = 0x00808080;
  serial_putbin(1, katherine, 6);
  delay(0x15000);
  serial_putbin(1, rebecca, 6);
  for (val=0; val < 640*480; val++)
    vga[val] = 0;
  for (val=0; val < 640; val++)
    vga[640*100+val] = 0x00ffffff;
  while (1);
}
