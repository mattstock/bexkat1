/*
 * some basic ITD functions
 *
 */
#include "misc.h"
#include "itd.h"

volatile unsigned int *spi = (unsigned int *)0x00800820;

// Bits of interest for the SPI control port
#define SD2_SEL 31
#define TOUCH_SEL 30
#define LCD_SEL 29
#define SD_SEL 28
#define BACKLIGHT 9
#define DC 8
#define TX_READY 1
#define RX_READY 0

#define SPI_CTL (spi[1])
#define SPI_DATA (spi[0])
#define SPI_TX_READY (SPI_CTL & (1 << TX_READY))
#define SPI_RX_READY (SPI_CTL & (1 << RX_READY))

void itd_backlight(int s) {
  if (s)
    SET_BIT(SPI_CTL, BACKLIGHT);
  else
    CLEAR_BIT(SPI_CTL, BACKLIGHT);
}

char spi_xfer(unsigned char dev, char tx) {
  char val;

  while (!SPI_TX_READY);
  CLEAR_BIT(SPI_CTL, SD_SEL + dev);
  SPI_DATA = tx;
  while (!SPI_RX_READY);
  val = SPI_DATA;
  SET_BIT(SPI_CTL, SD_SEL + dev);
  return val;
}

