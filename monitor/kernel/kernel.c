#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "serial.h"

int x;

int ordering(int a, int b, int c, int d, int e, int f, int g) {
  int m, n, o, p;

  m = 1;
  n = 2;
  o = 3;
  p = 4;
  a = 100;
  b = 200;
  c = 300;
  d = 400;
  e = 500;
  f = 600;
  g = 700;
  return a;
}

int test(const char *s, ...) {
  const char *p;
  va_list argp;

  va_start(argp, s);
  x = va_arg(argp, int);
  
  va_end(argp);
  return x;
}

void main(void) {
  ordering(10,20,30,40,50,60,70);
  serial_printhex(0, test("bar", 1023));
  while (1);
}
