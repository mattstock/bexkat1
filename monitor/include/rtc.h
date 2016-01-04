#ifndef RTC_H
#define RTC_H

#include "spi.h"

#define BCD2INT(x) ((((x) >> 4)&0xf)*10 + ((x)&0xf))

extern unsigned char rtc_cmd(unsigned char cmd, unsigned char data);

#endif

