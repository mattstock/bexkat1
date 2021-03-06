/*
 * some basic ITD functions
 *
 */
#include "misc.h"
#include "spi.h"
#include "itd.h"

// ITD commands
#define SLPOUT 0x11
#define GAMMASET 0x26
#define DISPON 0x29
#define CASET 0x2a
#define PASET 0x2b
#define RAMWR 0x2c
#define MADCTL 0x36
#define MADCTL_MY 0x80
#define MADCTL_MX 0x40
#define MADCTL_MV 0x20
#define MADCTL_BGR 0x08
#define PIXFMT 0x3a
#define FRMCTR1 0xb1
#define DFUNCTR 0xb6
#define PWCTR1 0xc0
#define PWCTR2 0xc1
#define VMCTR1 0xc5
#define VMCTR2 0xc7
#define GMCTRP1 0xe0
#define GMCTRN1 0xe1

// Bits of interest for the SPI control port
#define BACKLIGHT 9
#define DC 8


void itd_backlight(int s) {
  if (s)
    SET_BIT(SPI_CTL, BACKLIGHT);
  else
    CLEAR_BIT(SPI_CTL, BACKLIGHT);
}

void itd_command(unsigned char tx) {
  CLEAR_BIT(SPI_CTL, DC);
  CLEAR_BIT(SPI_CTL, LCD_SEL);
  spi_xfer(tx);
  SET_BIT(SPI_CTL, LCD_SEL);
}

void itd_data(unsigned char tx) {
  SET_BIT(SPI_CTL, DC);
  CLEAR_BIT(SPI_CTL, LCD_SEL);
  spi_xfer(tx);
  SET_BIT(SPI_CTL, LCD_SEL);
}

void itd_rotation(int r) {
  itd_command(MADCTL);
  switch (r % 4) {
    case 0:
      itd_data(MADCTL_MX|MADCTL_BGR);
      break;
    case 1:
      itd_data(MADCTL_MV|MADCTL_BGR);
      break;
    case 2:
      itd_data(MADCTL_MY|MADCTL_BGR);
      break;
    case 3:
      itd_data(MADCTL_MX|MADCTL_MY|MADCTL_MV|MADCTL_BGR);
      break;
  }
}

void itd_init() {
  itd_command(0xef);
  itd_data(0x03);
  itd_data(0x80);
  itd_data(0x02);

  itd_command(0xcf);
  itd_data(0x00);
  itd_data(0xc1);
  itd_data(0x30);

  itd_command(0xed);
  itd_data(0x64);
  itd_data(0x03);
  itd_data(0x12);
  itd_data(0x81);

  itd_command(0xe8);
  itd_data(0x85);
  itd_data(0x00);
  itd_data(0x78);

  itd_command(0xcb);
  itd_data(0x39);
  itd_data(0x2c);
  itd_data(0x00);
  itd_data(0x34);
  itd_data(0x02);

  itd_command(0xf7);
  itd_data(0x20);

  itd_command(0xea);
  itd_data(0x00);
  itd_data(0x00);
  
  itd_command(PWCTR1);
  itd_data(0x23);

  itd_command(PWCTR2);
  itd_data(0x10);

  itd_command(VMCTR1);
  itd_data(0x3e);
  itd_data(0x28);

  itd_command(VMCTR2);
  itd_data(0x86);

  itd_command(MADCTL);
  itd_data(MADCTL_MX | MADCTL_BGR);

  itd_command(PIXFMT);
  itd_data(0x55);

  itd_command(FRMCTR1);
  itd_data(0x00);
  itd_data(0x18);

  itd_command(DFUNCTR);
  itd_data(0x08);
  itd_data(0x82);
  itd_data(0x27);

  itd_command(0xf2);
  itd_data(0x00);

  itd_command(GAMMASET);
  itd_data(0x01);

  itd_command(GMCTRP1);
  itd_data(0x0f);
  itd_data(0x31);
  itd_data(0x2b);
  itd_data(0x0c);
  itd_data(0x0e);
  itd_data(0x08);
  itd_data(0x4e);
  itd_data(0xf1);
  itd_data(0x37);
  itd_data(0x07);
  itd_data(0x10);
  itd_data(0x03);
  itd_data(0x0e);
  itd_data(0x09);
  itd_data(0x00);

  itd_command(GMCTRN1);
  itd_data(0x00);
  itd_data(0x0e);
  itd_data(0x14);
  itd_data(0x03);
  itd_data(0x11);
  itd_data(0x07);
  itd_data(0x31);
  itd_data(0xc1);
  itd_data(0x48);
  itd_data(0x08);
  itd_data(0x0f);
  itd_data(0x0c);
  itd_data(0x31);
  itd_data(0x36);
  itd_data(0x0f);

  itd_command(SLPOUT);
  delay(1000);
  itd_command(DISPON);
}

void setwindow(unsigned short x0,
	       unsigned short y0, 
	       unsigned short x1,
	       unsigned short y1) {
  itd_command(CASET);
  itd_data(x0 >> 8);
  itd_data(x0 & 0xff);
  itd_data(x1 >> 8);
  itd_data(x1 & 0xff);

  itd_command(PASET);
  itd_data(y0 >> 8);
  itd_data(y0 & 0xff);
  itd_data(y1 >> 8);
  itd_data(y1 & 0xff);

  itd_command(RAMWR);
}

void itd_rect(unsigned short x0,
	      unsigned short y0,
	      unsigned short x1,
	      unsigned short y1,
	      unsigned short color) {
  setwindow(x0,y0,x1,y1);
  
  SET_BIT(SPI_CTL, DC);
  CLEAR_BIT(SPI_CTL, LCD_SEL);

  for (x0=0; x0 < x1; x0++)
    for (y0=0; y0 < y1; y0++) {
      spi_xfer(color >> 8);
      spi_xfer(color & 0xff);
    }
  SET_BIT(SPI_CTL, LCD_SEL);  
}

unsigned short color565(unsigned char r,
			unsigned char g,
			unsigned char b) {
  return ((r & 0xf8) << 8) | ((g & 0xfc) << 3) | (b >> 3);
}
