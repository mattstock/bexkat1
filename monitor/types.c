#include "serial.h"
#include "misc.h"

void main(void) {
  int i1;
  short s1;
  unsigned short us1;
  char c1;
  unsigned char uc1;

  s1 = -1;
  c1 = 0xff;
  uc1 = 0xff;
  us1 = 0xff;
  us1 = c1;
  s1 = uc1;
  serial_printhex(0, us1);
  serial_print(0, "\n");
  serial_printhex(0, s1);
  serial_print(0, "\n");
  s1 = c1;
  serial_printhex(0, s1);
  serial_print(0, "\n");
}
