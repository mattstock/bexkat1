#ifndef _SPI_H
#define _SPI_H

#include "misc.h"

#define JOY_SEL 29
#define RTC_SEL 28
#define SD2_SEL 27
#define TOUCH_SEL 26
#define LCD_SEL 25
#define SD_SEL 24
#define SPI_SPEED 18
#define SPI_CPOL 17
#define SPI_CPHA 16

#define TX_READY 1
#define RX_READY 0

#define SPI_MODE0 0
#define SPI_MODE1 1
#define SPI_MODE2 2
#define SPI_MODE3 3

#define SPI_CTL (spi[1])
#define SPI_DATA (spi[0])
#define SPI_TX_READY (SPI_CTL & (1 << TX_READY))
#define SPI_RX_READY (SPI_CTL & (1 << RX_READY))

extern volatile unsigned int *spi;

extern char spi_xfer(char tx);
extern void spi_fast(void);
extern void spi_slow(void);
extern void spi_mode(int mode);

#endif
