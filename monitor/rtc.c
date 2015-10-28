#include "spi.h"
#include "serial.h"
#include <stdio.h>

unsigned int *sw = (unsigned *)0x00800810;

unsigned char rtc_read(unsigned char cmd) {
  unsigned char bcd;

  CLEAR_BIT(SPI_CTL, RTC_SEL);
  spi_xfer(0x00); // read seconds
  bcd = spi_xfer(cmd); // data
  SET_BIT(SPI_CTL, RTC_SEL);
  return bcd;
}

void main() {
  unsigned char res, step;
  spi_slow();
  
  step = 0;
  while (1) {
    spi_mode(sw[0]);
    iprintf("mode = %d, step = %d\n", sw[0], step);
    res = rtc_read(step);
    iprintf("%02x\n", res);
    step++;
    delay(1000000);
  }
  spi_fast();
  spi_mode(SPI_MODE0);
}
