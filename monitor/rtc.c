#include "rtc.h"
#include "serial.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>

unsigned char dec2bcd(unsigned char dec) {
  unsigned char tens, ones;

  ones = tens = 0;
  for (int i=0; i < 8; i++) {
    if (ones >= 5)
      ones += 3;
    if (tens >= 5)
      tens += 3;
    tens  = (tens << 1) & 0xf;
    if (ones & 0x8)
      tens++;
    ones  = (ones << 1) & 0xf;
    if (dec & 0x80)
      ones++;
    dec <<= 1;
  }
  ones = (ones & 0xf) | ((tens & 0xf) << 4);

  return (ones & 0xff);
}

extern time_t _time(time_t *t);

void main() {
  char buf[80];
  unsigned char r = 0;
  unsigned int mo, d, dow, y, s,m,h;
  struct tm ts;
  time_t now;

  s = rtc_cmd(0x00, 0xff);
  m = rtc_cmd(0x01, 0xff);
  h = rtc_cmd(0x02, 0xff);
  dow = rtc_cmd(0x03, 0xff);
  d = rtc_cmd(0x04, 0xff);
  mo = rtc_cmd(0x05, 0xff);
  y = rtc_cmd(0x06, 0xff);

  iprintf("%02x / %02x / %02x  %02x  %02x:%02x:%02x\n",
	  mo,d,y,dow,h,m,s);
  while (1) {
    now = time(0);
    iprintf("now = %d\n", now);
    ts = *localtime(&now);
    strftime(buf, sizeof(buf), "%a %m-%d-%Y %H:%M:%S %Z", &ts);
    iprintf("%s\n", buf);
    delay(1000000);
  }
}
