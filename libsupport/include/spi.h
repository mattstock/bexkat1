#ifndef _SPI_H
#define _SPI_H

#include "misc.h"

#define CODEC_COMMAND_SEL 27
#define CODEC_DATA_SEL 26
#define RTC_SEL 25
#define SD_SEL 24
#define SPI_SPEED 0xc0000
#define SPI_MODE  0x30000

#define CODEC_READY 3
#define TX_READY 1
#define RX_READY 0

#define SPI_MODE0 0
#define SPI_MODE1 1
#define SPI_MODE2 2
#define SPI_MODE3 3

#define SPI_SPEED0 0
#define SPI_SPEED1 1
#define SPI_SPEED2 2
#define SPI_SPEED3 3

#define SPI_CTL (spi[1])
#define SPI_DATA (spi[0])
#define SPI_CODEC_READY (SPI_CTL & (1 << CODEC_READY))
#define SPI_TX_READY (SPI_CTL & (1 << TX_READY))
#define SPI_RX_READY (SPI_CTL & (1 << RX_READY))

extern volatile unsigned int * const spi;

extern char spi_xfer(char tx);
extern void spi_fast(void);
extern void spi_slow(void);
extern void spi_mode(unsigned int mode);
extern void spi_speed(unsigned int speed);

#endif
