#include <stdio.h>
#include "spi.h"

void main(void) {
  unsigned char mdata, ldata;
  unsigned int ux, uy, i;
  int x,y;
  

  while (1) {
    while (SPI_CTL & 0x8);
    CLEAR_BIT(SPI_CTL, TOUCH_SEL);
    ux = uy = 0;
    for (i=0; i < 10; i++) {
      spi_xfer(0x90);
      mdata = spi_xfer(0x00);
      ldata = spi_xfer(0x00);
      uy += (ldata >> 3)|(mdata << 5);
      spi_xfer(0xd0);
      mdata = spi_xfer(0x00);
      ldata = spi_xfer(0x00);
      ux += (ldata >> 3)|(mdata << 5);
    }
    SET_BIT(SPI_CTL, TOUCH_SEL);
    ux /= 10;
    uy /= 10;

    iprintf("pos = (%u, %u)\n", ux, uy);
    delay(5000);
  }
}
