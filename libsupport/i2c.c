#include "i2c.h"

volatile unsigned int * const i2c = (unsigned int *)0x30009000;

void i2c_addr(unsigned char addr) {
  I2C_DATA = addr << 9;
}

unsigned char i2c_regread(unsigned char data) {
  int count = 10;

  while (count) {
    I2C_DATA = (I2C_DATA & 0xfe00) | data;
    I2C_CTL = 0; // start
    if ((I2C_CTL & 0x1) == 0) {
      I2C_CTL = 3; // write
      if ((I2C_CTL & 0x1) == 0) {
        I2C_DATA = (I2C_DATA & 0xfe00) | 0x100;
        I2C_CTL = 0; // start
        if ((I2C_CTL & 0x1) == 0) {
          I2C_CTL = 2; // read
          if ((I2C_CTL & 0x1) == 0) {
            I2C_CTL = 1; // stop
            return (I2C_DATA & 0xff);
          }
        }
      }
    }
    count--;
  }
  return 0x00;
}

void i2c_regwrite(unsigned char data, unsigned char data2) {
  int count = 10;

  while (count) {
    I2C_DATA = (I2C_DATA & 0xfe00) | data;
    I2C_CTL = 0; // start
    if ((I2C_CTL & 0x1) == 0) {
      I2C_CTL = 3; // write
      if ((I2C_CTL & 0x1) == 0) {
        I2C_DATA = (I2C_DATA & 0xfe00) | data2;
        I2C_CTL = 3; // write
        if ((I2C_CTL & 0x1) == 0) {
          I2C_CTL = 1; // stop
          return;
        }
      }
    }
    count--;
  }
  return;
}

void i2c_write(unsigned char data) {
  I2C_DATA = (I2C_DATA & 0xfe00) | data;
  I2C_CTL = 0; // start
  I2C_CTL = 3; // write
  I2C_CTL = 1; // stop
}

unsigned char i2c_read() {
  I2C_DATA = (I2C_DATA & 0xfe00) | 0x100;
  I2C_CTL = 0; // start
  I2C_CTL = 2; // read
  I2C_CTL = 1; // stop
  return (I2C_DATA & 0xff);
}
