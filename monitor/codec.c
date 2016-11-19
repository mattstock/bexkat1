#include <stdio.h>
#include <i2c.h>
#include <matrix.h>

void main() {
  i2c_addr(0b11011);
  printf("result = %02x\n", i2c_writeread(0));
}
