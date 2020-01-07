#include <stdarg.h>
#include <stdio.h>
#include "serial.h"
#include "console.h"
#include "misc.h"

volatile unsigned int * const serial0 = (unsigned int *)UART0_BASE;
volatile unsigned int * const serial1 = (unsigned int *)UART1_BASE;
volatile unsigned int * const serial2 = (unsigned int *)UART2_BASE;

char serial_gc(unsigned port) {
  unsigned result;
  volatile unsigned *p;

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
  return (result & 0x8000 ? result & 0xff : -1);
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

void serial_ansi_sgr(unsigned port, console_color_t color) {
  uint8_t x;

  switch (color) {
  case CONSOLE_BLACK:
  case CONSOLE_RED:
  case CONSOLE_GREEN:
  case CONSOLE_YELLOW:
  case CONSOLE_BLUE:
  case CONSOLE_MAGENTA:
  case CONSOLE_CYAN:
    x = 30 + color;
    break;
  case CONSOLE_WHITE:
    x = 37;
    break;
  case CONSOLE_B_RED:
  case CONSOLE_B_GREEN:
  case CONSOLE_B_YELLOW:
  case CONSOLE_B_BLUE:
  case CONSOLE_B_MAGENTA:
  case CONSOLE_B_CYAN:
    x = 40 + color-8;
    break;
  }
  serial_putchar(port, 0x1b); // esc
  serial_printf(port, "[%um", x);
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
  case 2:
    p = serial2;
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

  while (i < *len-1) {
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
  str[i+1] = '\0';
  return i;
}	

// Defined in vga.c bus shared so we don't waste dead space
// or need to do dynamic allocation.  If I ever do multi-threading,
// I am seriously whacked.
extern char _bexkat_sprintfbuf[];

void serial_printf(unsigned port, const char *fmt, ...) {
  va_list argp;
  
  va_start(argp, fmt);
  vsnprintf(_bexkat_sprintfbuf, 200, fmt, argp);
  serial_print(port, _bexkat_sprintfbuf);
}

void serial_vprintf(unsigned port, const char *fmt, va_list argp) {
  vsnprintf(_bexkat_sprintfbuf, 200, fmt, argp);
  serial_print(port, _bexkat_sprintfbuf);
}
