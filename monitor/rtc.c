#include "rtc.h"
#include "serial.h"
#include <stdio.h>

void main() {
  unsigned char res;
  unsigned int s,m,r,h;
  
  while (1) {
    s = BCD2INT(rtc_cmd(0x00,0xff));
    m = BCD2INT(rtc_cmd(0x01,0xff));
    r = rtc_cmd(0x02,0xff);
    if (r & 0x40) {
      h = BCD2INT(r&0x1f);
      if (r & 0x20) {
        iprintf("%02d:%02d:%02d pm\n", h, m, s);
      } else {
        iprintf("%02d:%02d:%02d am\n", h, m, s);
      }
    } else {
      h = BCD2INT(r&0x0f);
      if (r & 0x10) {
        h += 10;
      }
      if (r & 0x20) {
        h += 20;
      }
      iprintf("%02d:%02d:%02d\n", h, m, s);
    }
    delay(1000000);
  }
}
