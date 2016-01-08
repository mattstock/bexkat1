#include "codec.h"
#include "spi.h"

void codec_sci_write(uint8_t addr, uint16_t value) {
  while (!SPI_CODEC_READY); // should add a timeout
  CLEAR_BIT(SPI_CTL, CODEC_COMMAND_SEL);
  spi_xfer(CODEC_SCI_WRITE);
  spi_xfer(addr);
  spi_xfer(value >> 8);
  spi_xfer(value & 0xff);
  SET_BIT(SPI_CTL, CODEC_COMMAND_SEL);
}

uint16_t codec_sci_read(uint8_t addr) {
  uint16_t value = 0;
  
  while (!SPI_CODEC_READY); // should add a timeout
  CLEAR_BIT(SPI_CTL, CODEC_COMMAND_SEL);
  spi_xfer(CODEC_SCI_READ);
  spi_xfer(addr);
  value = spi_xfer(0xff);
  value <<= 8;
  value |= spi_xfer(0xff);
  SET_BIT(SPI_CTL, CODEC_COMMAND_SEL);

  return value;
}

void codec_reset(void) {
  codec_sci_write(CODEC_REG_MODE, CODEC_SM_LINE1 | CODEC_SM_SDINEW);
  codec_sci_write(CODEC_REG_WRAMADDR, 0x1e29);
  codec_sci_write(CODEC_REG_WRAM, 0x0000);

  codec_sci_write(CODEC_REG_DECODE_TIME, 0x0000);
  codec_sci_write(CODEC_REG_DECODE_TIME, 0x0000);
}

