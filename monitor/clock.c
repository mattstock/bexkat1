#include "rtc.h"
#include "matrix.h"
#include "serial.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>
#include <math.h>

unsigned sarc[16];
unsigned marc[16];
unsigned harc[3];

void calc_arc(unsigned r) {
  int x;

  for (x=0; x < 16; x++) {
    sarc[x] = (unsigned) (r * cosf(x*0.1047f));
    marc[x] = (unsigned) ((2.0f/3.0f) * r * cosf(x*0.1047f));
  }
  for (x=0; x < 3; x++)
    harc[x] = (unsigned) ((1.0f/3.0f) * r * cosf(x*0.5233f));

}

void main() {
//  char buf[80];
//  struct tm ts;
//  time_t now;
  unsigned i;
  unsigned s,m,h;

  // fix a bug in initialization during define?
  s = 0;
  m = 0;
  h = 0;
  calc_arc(6);

  while (1) {
    matrix_init();
    matrix_circle(16,7,7,0xff00ff);
//    now = time(0);
//    ts = *localtime(&now);
//    strftime(buf, sizeof(buf), "%a %H:%M:%S %Z", &ts);
//    iprintf("%s\n", buf);
//    int s = ts.tm_sec;
    i = s;
    if (i <= 15) 
      matrix_line(16,7,16+sarc[15-i],7-sarc[i],0xff);
    if (i > 15 && i <= 30) {
      i -= 15;
      matrix_line(16,7,16+sarc[i],7+sarc[15-i],0xff);
    }
    if (i > 30 && i <= 45) {
      i -= 30;
      matrix_line(16,7,16-sarc[15-i],7+sarc[i],0xff);
    }
    if (i >= 45) {
      i -= 45;
      matrix_line(16,7,16-sarc[i],7-sarc[15-i],0xff);
    }

    i = m;
    if (i <= 15) 
      matrix_line(16,7,16+marc[15-i],7-marc[i],0xff00);
    if (i > 15 && i <= 30) {
      i -= 15;
      matrix_line(16,7,16+marc[i],7+marc[15-i],0xff00);
    }
    if (i > 30 && i <= 45) {
      i -= 30;
      matrix_line(16,7,16-marc[15-i],7+marc[i],0xff00);
    }
    if (i >= 45) {
      i -= 45;
      matrix_line(16,7,16-marc[i],7-marc[15-i],0xff00);
    }

    i = h;
    if (i <= 3) 
      matrix_line(16,7,16+harc[3-i],7-harc[i],0xff0000);
    if (i > 3 && i <= 6) {
      i -= 3;
      matrix_line(16,7,16+harc[i],7+harc[3-i],0xff0000);
    }
    if (i > 6 && i <= 9) {
      i -= 6;
      matrix_line(16,7,16-harc[3-i],7+harc[i],0xff0000);
    }
    if (i >= 9) {
      i -= 9;
      matrix_line(16,7,16-harc[i],7-harc[3-i],0xff0000);
    }


    s++;
    if (s == 60) {
      s = 0;
      m++;
      if (m == 60) {
        m = 0;
        h++;
        if (h == 12) {
          h = 0;
        }
      }
    }

    delay(50000);
  }
}
