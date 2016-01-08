#include "spi.h"

volatile unsigned int *spi = (unsigned int *)0x30007000;

void spi_fast() {
  spi_speed(SPI_SPEED3);
}

void spi_slow() {
  spi_speed(SPI_SPEED0);
}

void spi_speed(unsigned int speed) {
  if (speed > 3)
    return;
  speed <<= 18;
  SPI_CTL = SPI_CTL & (~SPI_SPEED) | speed;
}

void spi_mode(unsigned int mode) {
  if (mode > 3)
    return;
  mode <<= 16;
  SPI_CTL = SPI_CTL & (~SPI_MODE) | mode;
}

char spi_xfer(char tx) {
  char val;

  SPI_DATA = tx;
  while (!SPI_RX_READY);
  val = SPI_DATA;
  return val;
}
