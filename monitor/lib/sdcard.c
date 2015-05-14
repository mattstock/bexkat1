#include "sdcard.h"
#include "matrix.h"
#include "serial.h"

volatile unsigned int *sdcard = (unsigned int *)0x00800820;

unsigned const char SD_CMD0 = 0x00;
unsigned const char SD_CMD8 = 0x08;
unsigned const char SD_CMD9 = 0x09;
unsigned const char SD_CMD55 = 0x37;
unsigned const char SD_CMD58 = 0x3a;
unsigned const char SD_ACMD41 = 0x29;
unsigned const char SD_R1_READY_STATE = 0x00;
unsigned const char SD_R1_IDLE_STATE = 0x01;
unsigned const char SD_R1_ILLEGAL_COMMAND = 0x04;

static char type = 0;
static char sdhc = 0;

static void spi_send(unsigned char b) {
  unsigned int res;
  res = b;
  sdcard[0] = res;
  res = sdcard[0];
  while ((res & 0x0000c000) != 0x0000c000) {
    res = sdcard[0];
  }
}

static unsigned char spi_rec() {
  unsigned int res;

  sdcard[0] = 0xff;
  res = sdcard[0];
  while ((res & 0x0000c000) != 0x0000c000) {
    res = sdcard[0];
  }
  return (res & 0xff);
}


int sdcard_cmd(unsigned char cmd, unsigned int arg) {
  int i;
  unsigned char crc = 0xff;
  unsigned char status;

  spi_send(cmd | 0x40);
  for (i=24; i >= 0; i -= 8) {
    spi_send(arg >> i);
  }

  if (cmd == SD_CMD0) 
    crc = 0x95;
  if (cmd == SD_CMD8)
    crc = 0x87;
  spi_send(crc);
  matrix_put(0,0,0x000000ff);

  status = spi_rec();
  i=0;
  while ((i < 256) && (status & 0x80)) {
    status = spi_rec();
    i++;
  }
  if (i == 256)
    matrix_put(1,0,0x00ff0000);
  else
    matrix_put(1,0,0x000000ff);
  return status;
}

int sdcard_acmd(unsigned char cmd, unsigned int arg) {
  sdcard_cmd(SD_CMD55, 0);
  return sdcard_cmd(cmd, arg);
}

int sdcard_init() {
  int i;
  char status;
  unsigned int arg;

  for (i=0; i < 10; i++)
    spi_send(0xff);

  sdcard[1] = 0x00000000;
  status = sdcard_cmd(SD_CMD0, 0);
  if (status != SD_R1_IDLE_STATE) {
    serial_print(0, "sdcard unable to go into idle state\n");
    sdcard[1] = 0x01000000;
    return -1;
  }

  if (sdcard_cmd(SD_CMD8, 0x1AA) & SD_R1_ILLEGAL_COMMAND) {
    type = 1;
    serial_print(0, "sdcard is type 1\n");
  } else {
    for (i=0; i < 4; i++)
      status = spi_rec();
    if (status != 0xaa) {
      sdcard[1] = 0x01000000;
      serial_print(0, "sdcard failed cmd8\n");
      return -1;
    } else {
      type = 2;
      serial_print(0, "sdcard is type 2\n");
    }
  }
  if (type == 2)
    arg = 0x40000000;
  else
    arg = 0; 
  while ((status = sdcard_acmd(SD_ACMD41, arg)) != SD_R1_READY_STATE)
    matrix_put(0,5,0x00ff0000);
  matrix_put(0,5,0x000000ff);
  serial_print(0,"sdcard ready state\n");

  if (type == 2) {
    if (sdcard_cmd(SD_CMD58, 0)) {
      serial_print(0, "sdcard CMD58 failed\n");
      sdcard[1] = 0x01000000;
      return -1;
    }
    if ((spi_rec() & 0xc0) == 0xc0) {
      sdhc = 1;
      serial_print(0, "card is sdhc\n");
    }
    for (i=0; i < 3; i++)
      status = spi_rec();
  }
  sdcard[1] = 0x01000000;
  return 0;
}

