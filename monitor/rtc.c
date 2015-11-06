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
  unsigned char r;
  unsigned int mo, d, dow, y, s,m,h;
  struct tm ts;
  time_t now;

/*  iprintf("hour [0-23]: ");
  scanf("%d", &h);
  rtc_cmd(0x82, dec2bcd(h&0x3f));
  iprintf("minute [0-59]: ");
  scanf("%d", &m);
  rtc_cmd(0x81, dec2bcd(m&0x7f));
  iprintf("seconds [0-59]: ");
  scanf("%d", &s);
  rtc_cmd(0x80, dec2bcd(s&0x7f));
  rtc_cmd(0x84, 0x05); */
  rtc_cmd(0x83, 0x04);
  while (1) {
    now = time(0);
    iprintf("now = %d\n", now);
    ts = *localtime(&now);
    strftime(buf, sizeof(buf), "%a %m-%d-%Y %H:%M:%S %Z", &ts);
    iprintf("%s\n", buf);
    delay(1000000);
  }
}
