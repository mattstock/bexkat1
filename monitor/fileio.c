#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "spi.h"
#include "codec.h"
#include "matrix.h"
#include "vectors.h"
#include "timers.h"

INTERRUPT_HANDLER(timer2)
static void timer2(void) {
  matrix_put(0,0, 0x00);
  timers[1] = 0x4;
  timers[6] += 50000;
}

INTERRUPT_HANDLER(timer1)
static void timer1(void) {
  matrix_put(0,0, 0xff);
  timers[1] = 0x2;
  timers[5] += 165000;
}

INTERRUPT_HANDLER(timer0)
static void timer0(void) {
  matrix[1]++;
  timers[1] = 0x1;
  timers[5] += 10000000;
}

char *buffer;

void main(void) {
  int fd, count, transfer;

  timers[6] = timers[12] + 50000; // 1kHz
  set_interrupt_handler(intr_timer2, timer2);
  timers[5] = timers[12] + 165000; // 303Hz
  set_interrupt_handler(intr_timer1, timer1);
  timers[4] = timers[12] + 10000000; // 5Hz
  set_interrupt_handler(intr_timer0, timer0);
  timers[0] |= 0x77; // enable timer{3,2,1} and interrupts
  sti();

  fd = open("/foo.wav", O_RDONLY);
  if (fd != 4)
    iprintf("I got %d as a file descriptor and errno is %d\n", fd, errno);

  spi_speed(SPI_SPEED0);
  spi_mode(SPI_MODE0);

  codec_reset();
  delay(100);

  iprintf("mode = %04x\n", codec_sci_read(CODEC_REG_MODE));
  iprintf("status = %04x\n", codec_sci_read(CODEC_REG_STATUS));
  iprintf("clockf = %04x\n", codec_sci_read(CODEC_REG_CLOCKF)); 
  iprintf("volume = %04x\n", codec_sci_read(CODEC_REG_VOL));
  iprintf("hdat0 = %04x\n", codec_sci_read(CODEC_REG_HDAT0));
  iprintf("hdat1 = %04x\n", codec_sci_read(CODEC_REG_HDAT1));

  codec_sci_write(CODEC_REG_VOL, 0x4040);
  iprintf("new volume = %04x\n", codec_sci_read(CODEC_REG_VOL));

  codec_sci_write(CODEC_REG_CLOCKF, 0x8800);
  delay(100000);
  iprintf("speed0 clockf = %04x\n", codec_sci_read(CODEC_REG_CLOCKF));
  
  while (!SPI_CODEC_READY);

  spi_speed(SPI_SPEED3);
  buffer = malloc(2048);
  transfer = 0;
  while (1) {
    count = read(fd, buffer, 2048);
    if (count < 1)
      break;
    transfer += count;

    int pos = 0;
    while (pos != count) {
      int frag = (pos + 32 < count ? pos + 32 : count);
      CLEAR_BIT(SPI_CTL, CODEC_DATA_SEL);
      while (pos < frag)
	spi_xfer(buffer[pos++]);
      SET_BIT(SPI_CTL, CODEC_DATA_SEL);
      while (!SPI_CODEC_READY);
    }
    //    if ((transfer % 500*1024) == 0) 
    //iprintf("decode_time = %04x\n", sci_read(CODEC_REG_DECODE_TIME));
  }

  iprintf("done %d %d\n", count, transfer);
  close(fd);

  fd = open("/music2.mp3", O_RDONLY);
  if (fd != 4)
    iprintf("I got %d as a file descriptor and errno is %d\n", fd, errno);
  transfer = 0;
  while (1) {
    count = read(fd, buffer, 2048);
    if (count < 1)
      break;
    transfer += count;

    int pos = 0;
    while (pos != count) {
      int frag = (pos + 32 < count ? pos + 32 : count);
      CLEAR_BIT(SPI_CTL, CODEC_DATA_SEL);
      while (pos < frag)
	spi_xfer(buffer[pos++]);
      SET_BIT(SPI_CTL, CODEC_DATA_SEL);
      while (!SPI_CODEC_READY);
    }
    //    if ((transfer % 500*1024) == 0) 
    //iprintf("decode_time = %04x\n", sci_read(CODEC_REG_DECODE_TIME));
  }

  iprintf("done %d %d\n", count, transfer);
  
  while (1);

}
