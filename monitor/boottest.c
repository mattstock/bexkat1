#include "misc.h"
#include "serial.h"
#include "timers.h"
#include "elf32.h"
#include <string.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdarg.h>

volatile uint32_t * const seg = (uint32_t *)0x30000000;

char buffer[200];
void bar(unsigned port, const char *fmt, ...) {
  va_list argp;

  seg[3] = 1;
  va_start(argp, fmt);
  seg[3] = 2;
  vsnprintf(buffer, 200, fmt, argp);
  seg[3] = 3;
  serial_print(port, buffer);
  seg[3] = 4;
}

void foo(void) {
  seg[1] = 1;
  serial_print(0, "foo() printing\n");
  seg[1] = 2;
}

void main(void) {
  seg[0] = 1;
  bar(0,"hello\n");
  seg[0] = 2;
  while (1);
}
