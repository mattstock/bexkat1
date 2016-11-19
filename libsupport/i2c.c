#include "i2c.h"

volatile unsigned int * const i2c = (unsigned int *)0x30009000;


void i2c_addr(char addr) {
  I2C_DATA = addr << 9;
}

char i2c_writeread(char data) {
  I2C_DATA &= 0x0000fe00;;
  I2C_DATA |= data;
  I2C_CTL = 0; // start
  I2C_CTL = 3; // write
  I2C_DATA &= 0x0000fe00;;
  I2C_DATA |= 0x00000100;
  I2C_CTL = 0; // start
  I2C_CTL = 2; // read
  I2C_CTL = 1; // stop
  return (I2C_DATA & 0xff);
}

void i2c_write(char data) {
  I2C_DATA &= 0x0000fe00;;
  I2C_DATA |= data;
  I2C_CTL = 0; // start
  I2C_CTL = 3; // write
  I2C_CTL = 1; // stop
}

char i2c_read() {
  I2C_DATA &= 0x0000fe00;
  I2C_DATA |= 0x00000100;
  I2C_CTL = 0; // start
  I2C_CTL = 2; // read
  I2C_CTL = 1; // stop
  return (I2C_DATA & 0xff);
}
