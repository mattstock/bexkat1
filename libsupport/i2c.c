#include "i2c.h"

volatile unsigned int * const i2c = (unsigned int *)0x30009000;

void i2c_init(unsigned int speed) {
  unsigned int scale = 50000/(5*speed) - 1;
  i2c[I2C_PRERL] = scale & 0xff;
  i2c[I2C_PRERH] = (scale >> 8) & 0xff;
  i2c[I2C_CTR] = 0x80; // enable
}

unsigned char i2c_regread(unsigned char addr, unsigned char reg) {
  i2c[I2C_TXR] = addr << 1;
  i2c[I2C_CR] = 0b10010000; // START & address
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  i2c[I2C_TXR] = reg << 1;
  i2c[I2C_CR] = 0b00010000; // write reg addr
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  i2c[I2C_TXR] = (addr << 1) | 0x1;
  i2c[I2C_CR] = 0b10010000; // reSTART & address
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  i2c[I2C_CR] = 0b00100000; // read
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  return i2c[I2C_RXR] & 0xff;
}

unsigned char i2c_regwrite(unsigned char addr, unsigned char reg, unsigned char val) {
  i2c[I2C_TXR] = addr << 1;
  i2c[I2C_CR] = 0b10010000; // START & address
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  i2c[I2C_TXR] = reg << 1;
  i2c[I2C_CR] = 0b00010000; // write reg addr
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  i2c[I2C_TXR] = val;
  i2c[I2C_CR] = 0b00010000; // write reg addr
  while (i2c[I2C_SR] & 0x2); // poll
  if (i2c[I2C_SR] & 0x80) //NAK from slave
    return 0;
  return 1;
}
