#include <stdarg.h>
#include "misc.h"
#include "matrix.h"
#include "serial.h"
#include <stdio.h>
#include <stdlib.h>
#include "vectors.h"

void foo(unsigned x) {
  serial_printhex(0, x);
  serial_putchar(0, '\n');
}

void main(void) {
  unsigned val;

  val = 0;
  while (1) {
    foo(val);
    val++;
    serial_getchar(0);
  }
}
