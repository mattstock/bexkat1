#include "matrix.h"
#include "serial.h"

void main() {
  char c;
  int i;
  while (1) {
    matrix_put(3,1,0xff);
    serial_print(0, "hello\n");
    matrix_put(2,1,0xff00);
    serial_putchar(0, '>');
    matrix_put(1,1,0xff0000);
    matrix_put(0,1,0xff000000);
    matrix_put(15,1,0xff);
    matrix_put(31,1,0xff00);
    matrix_put(31,15,0xff0000);
    c = serial_getchar(0);
    serial_putchar(0, c);
  }
}
