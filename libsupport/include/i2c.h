#ifndef _I2C_H
#define _I2C_H

#include "misc.h"

#define I2C_PRERL 0
#define I2C_PRERH 1
#define I2C_CTR 2
#define I2C_TXR 3
#define I2C_RXR 3
#define I2C_CR 4
#define I2C_SR 4

extern volatile unsigned int * const i2c;

extern void i2c_init(unsigned int speed);
extern unsigned char i2c_regread(unsigned char addr, unsigned char data);
extern unsigned char i2c_regwrite(unsigned char addr, unsigned char reg, unsigned char data);

#endif
