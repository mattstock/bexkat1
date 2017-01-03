#include <stdarg.h>
#include <stdio.h>
#include "serial.h"

void serial_printf(unsigned port, const char *format, ...) {
  va_list argp;
  char buf[200];
  
  va_start(argp, format);
  vsnprintf(buf, 200, format, argp);
  serial_print(port, buf);
}
