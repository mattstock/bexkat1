#include "serial.h"
#include "matrix.h"

struct foo {
  char x;
  int a;
  int b;
  short c;
};

void test_struct(struct foo *x) {
  serial_putchar(0, x->x);
}

void main(void) {
  struct foo bar;

  bar.x = 'a';
  bar.a = 34;
  serial_putchar(0,bar.x);
  test_struct(&bar);
}
