#include <stdio.h>
#include <unistd.h>
#include <matrix.h>
#include <serial.h>
#include <i2c.h>

void main() {
  i2c_init(0,100);
  for (int i=0; i < 10; i++)
    printf("reg %d: %02x\n", i, i2c_regread(0,0b0011011, i));
}
