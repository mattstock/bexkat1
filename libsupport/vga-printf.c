#include <stdio.h>
#include <stdarg.h>
#include "vga.h"

void vga_printf(unsigned int color, const char *fmt, ...) {
  va_list argp;
  char buf[200];
  
  va_start(argp, fmt);
  vsnprintf(buf, 200, fmt, argp);
  vga_print(color, buf);
}

