#ifndef RTC_H
#define RTC_H

#include "spi.h"

#define BCD2DEC(x) ((((x) >> 4)&0xf)*10 + ((x)&0xf))

#define RTC_SECONDS       0x00
#define RTC_MINUTES       0x01
#define RTC_HOURS         0x02
#define RTC_DAY_OF_WEEK   0x03
#define RTC_DATE_OF_MONTH 0x04
#define RTC_MONTH         0x05
#define RTC_YEAR          0x06

extern unsigned char rtc_cmd(unsigned char cmd, unsigned char data);

#endif

