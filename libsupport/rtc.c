#include "rtc.h"

unsigned char rtc_cmd(unsigned char cmd, unsigned char data) {
  unsigned char val;
  spi_slow();
  spi_mode(SPI_MODE1);
  CLEAR_BIT(SPI_CTL, RTC_SEL);
  spi_xfer(cmd);
  val = spi_xfer(data);
  SET_BIT(SPI_CTL, RTC_SEL);
  spi_mode(SPI_MODE0);
  spi_fast(); 
  return val;
}
