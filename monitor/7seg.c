#include <stdio.h>
#include "spi.h"
#include "serial.h"

void main(void) {
  serial_print(2, "Done!\n");
  spi_slow();
  CLEAR_BIT(SPI_CTL, LED_SEL);
  spi_xfer(0x01); // write
  spi_xfer(0x00); // first pos
  spi_xfer(0xff); // turn it all on
  spi_xfer(0xff); // turn it all on
  spi_xfer(0x01); // write
  spi_xfer(0x08); // 9 pos
  spi_xfer(0xcc); //
  spi_xfer(0xff); // turn it all on
  SET_BIT(SPI_CTL, LED_SEL);
  while (1);
}
