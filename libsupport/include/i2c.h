#ifndef _I2C_H
#define _I2C_H

#include "misc.h"

#define I2C_CTL (i2c[1])
#define I2C_DATA (i2c[0])

extern volatile unsigned int * const i2c;

extern void i2c_addr(unsigned char addr);
extern void i2c_write(unsigned char data);
extern unsigned char i2c_regread(unsigned char data);
extern void i2c_regwrite(unsigned char data, unsigned char data2);
extern unsigned char i2c_read();

#endif
