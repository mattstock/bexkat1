#ifndef _I2C_H
#define _I2C_H

#include "misc.h"

#define I2C_CTL (i2c[1])
#define I2C_DATA (i2c[0])

extern volatile unsigned int * const i2c;

extern void i2c_addr(char addr);
extern void i2c_write(char data);
extern char i2c_writeread(char data);
extern char i2c_read();

#endif
