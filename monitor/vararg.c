#include "stdarg.h"
#include "serial.h"

void testing(int a, char *b, ...);

void main(void) {
  testing(0, "abcdef", 0x1234, 0x5678, "hello");
}  

void testing(int a, char *b, ...) {
  va_list foo;
  int i;
  char *s;

  va_start(foo, b);

  serial_print(0, "\nlastarg ref: ");
  serial_printhex(0, (unsigned int)&b);
  serial_print(0, "\nfoo: ");
  serial_printhex(0, (unsigned int)foo);
  serial_print(0, "\nint1 vararg value (should be 0x1234): ");
  _asm("halt\n");
  i = va_arg(foo, int);
  serial_printhex(0, i);
  serial_print(0, "\nint1 foo: ");
  serial_printhex(0, (unsigned int)foo);
  serial_print(0, "\nint2 vararg value (should be 0x5678): ");
  i = va_arg(foo, int);
  serial_printhex(0, i);
  serial_print(0, "\nint2 foo: ");
  serial_printhex(0, (unsigned int)foo);
  serial_print(0, "\nstring vararg:");
  s = va_arg(foo, char *);
  serial_print(0, s);
  serial_print(0, "\nstring foo: ");
  serial_printhex(0, (unsigned int)foo);
  while (1);
}
