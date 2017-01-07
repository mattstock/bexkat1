#include <stdarg.h>
#include <stdio.h>
#include "serial.h"
#include "misc.h"

volatile unsigned int * const serial0 = (unsigned int *)UART0_BASE;
volatile unsigned int * const serial1 = (unsigned int *)UART1_BASE;

void serial_dumpmem(unsigned port,
		    unsigned addr, 
		    unsigned short len) {
  unsigned int i,j;
  unsigned *pos = (unsigned *)addr;
  
  serial_print(port, "\n");
  for (i=0; i < len; i += 8) {
    serial_printhex(port, addr+4*i);
    serial_print(port, ": ");
    for (j=0; j < 8; j++) {
      serial_printhex(port, pos[i+j]);
      serial_print(port, " ");
    }
    serial_print(port, "\n");
  }
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
