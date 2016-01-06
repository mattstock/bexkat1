#include "serial.h"
#include "misc.h"

volatile unsigned int *serial0 = (unsigned int *)0x30002000;
volatile unsigned int *serial1 = (unsigned int *)0x30003000;

void serial_printf(unsigned port, const char *format, ...) {
  serial_print(port, format);
  serial_print(port, "\n");
}


char serial_getchar(unsigned port) {
  unsigned result;
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

  result  = p[0];
  while ((result & 0x8000) == 0)
    result = p[0];
  return (char)(result & 0xff); 
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
  p[0] = (unsigned)c;
}

void serial_printhex(unsigned port, unsigned val) {
  char *x = int2hex(val);
  serial_print(port, x);
}

void serial_print(unsigned port, const char *str) {
  const char *c = str;

  while (*c != '\0') {
    serial_putchar(port, *c);
    c++;
  }
}

short serial_getline(unsigned port,
		     char *str, 
		     unsigned short *len) {
  unsigned short i=0;
  char c;

  while (1) {
    c = serial_getchar(port);
    if (c >= ' ' && c <= '~') {
      serial_putchar(port, c);
      str[i++] = c;
    }
    if (c == '\r' || c == '\n') {
      str[i] = '\0';
      return i;
    }
    if (c == 0x03) {
      str[0] = '\0';
      return -1;
    }
    if ((c == 0x7f || c == 0x08) && i > 0) {
      serial_putchar(port, c);
      i--;
    }
  }
  return 0;
}	
