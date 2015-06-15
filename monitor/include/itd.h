#ifndef _ITD_H
#define _ITD_H

extern volatile unsigned int *spi;

extern void itd_backlight(int s);
extern char spi_xfer(unsigned char dev, char tx);

#endif
