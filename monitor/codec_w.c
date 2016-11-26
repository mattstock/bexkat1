#include <stdio.h>
#include <unistd.h>
#include <matrix.h>
#include <serial.h>
#include <i2c.h>

void main() {
  i2c_init(100);
  for (int i=0; i < 10; i++)
    printf("reg %d: %02x\n", i, i2c_regread(0b0011011, i));
  i2c_regwrite(0b0011011, 0x9, 0x00);
  i2c_regwrite(0b0011011, 0x6, 0x22);
  i2c_regwrite(0b0011011, 0x0, 0x17);
  i2c_regwrite(0b0011011, 0x1, 0x17);
  i2c_regwrite(0b0011011, 0x4, 0x12);
  i2c_regwrite(0b0011011, 0x5, 0x00);
  i2c_regwrite(0b0011011, 0x7, 0x4b);
  i2c_regwrite(0b0011011, 0x8, 0x1c);
  usleep(30000);
  i2c_regwrite(0b0011011, 0x9, 0x01);
  i2c_regwrite(0b0011011, 0x6, 0x02);
  usleep(30000);
  for (int i=0; i < 10; i++)
    printf("reg %d: %02x\n", i, i2c_regread(0b0011011, i));
}
