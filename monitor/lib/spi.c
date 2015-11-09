#include "spi.h"

volatile unsigned int *spi = (unsigned int *)0x20000820;

void spi_fast() {
  SET_BIT(SPI_CTL, SPI_SPEED);
}

void spi_slow() {
  CLEAR_BIT(SPI_CTL, SPI_SPEED);
}

void spi_mode(int mode) {
  switch (mode) {
    case SPI_MODE0:
      CLEAR_BIT(SPI_CTL, SPI_CPOL);
      CLEAR_BIT(SPI_CTL, SPI_CPHA);
      break;
    case SPI_MODE1:
      CLEAR_BIT(SPI_CTL, SPI_CPOL);
      SET_BIT(SPI_CTL, SPI_CPHA);
      break;
    case SPI_MODE2:
      SET_BIT(SPI_CTL, SPI_CPOL);
      CLEAR_BIT(SPI_CTL, SPI_CPHA);
      break;
    case SPI_MODE3:
      SET_BIT(SPI_CTL, SPI_CPOL);
      SET_BIT(SPI_CTL, SPI_CPHA);
      break;
  }
}

char spi_xfer(char tx) {
  char val;

  SPI_DATA = tx;
  while (!SPI_RX_READY);
  val = SPI_DATA;
  return val;
}
