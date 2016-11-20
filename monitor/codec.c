#include <stdio.h>
#include <unistd.h>
#include <i2c.h>
#include <matrix.h>
#include <serial.h>

void main() {
  i2c_addr(0b11011);
  for (int i=0; i < 0x0a; i++) 
    printf("reg %d: %02x\n", i, i2c_regread(i<<1));
}
