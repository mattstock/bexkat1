#include "misc.h"
#include "serial.h"
#include "timers.h"
#include "elf32.h"
#include <string.h>
#include <sys/types.h>
#include <stdarg.h>

volatile uint32_t * const seg = (uint32_t *)0x30000000;

void foo(void) {
  seg[2] = 3;
}

void main(void) {
  seg[0] = 1;
  seg[1] = 2;
  foo();
  seg[3] = 4;
  serial_putchar(0, 'x');
  seg[4] = 5;
  while (1);
}
