#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include "matrix.h"
#include "serial.h"

extern char *__heap_ptr;

int main() {
  char *foo;

  matrix_init();
  matrix_put(0,0, 0xffff);
  iprintf("foo %d, %08x\n", 2034, &foo);
  matrix_put(0,1, 0xff00ff);
  while (1);
}

