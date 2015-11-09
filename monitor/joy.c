#include <stdio.h>
#include "spi.h"

void main(void) {
  unsigned char a0,a1;
  unsigned short ch0, ch1;

  spi_slow();
  while (1) {
    CLEAR_BIT(SPI_CTL, JOY_SEL);
    a0 = spi_xfer(0x78);
    a1 = spi_xfer(0x00);
    SET_BIT(SPI_CTL, JOY_SEL);
    ch1 = ((a0 << 8) | a1) & 0x3ff;
    CLEAR_BIT(SPI_CTL, JOY_SEL);
    a0 = spi_xfer(0x68);
    a1 = spi_xfer(0x00);
    SET_BIT(SPI_CTL, JOY_SEL);
    ch0 = ((a0 << 8) | a1) & 0x3ff;
    iprintf("ch0 = %u, ch1 = %u\n", ch0, ch1);
    delay(50000);
  }
}
