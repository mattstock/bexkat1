#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include "spi.h"
#include "codec.h"
#include "matrix.h"

#define SAMPLE_RATE 44100
#define SAMPLE_BITS 16
#define SAMPLE_CHAN 2

uint16_t swap_uint16(uint16_t val) {
  return (val << 8) | (val >> 8);
}

uint32_t swap_uint32(uint32_t val) {
  val = ((val << 8) & 0xff00ff00) | ((val >> 8) & 0xff00ff);
  return (val << 16) | (val >> 16);
}

struct wav_header {
  char chunkid[4];
  uint32_t chunksize;
  char format[4];
  char fmt_chunkid[4];
  uint32_t fmt_chunksize;
  uint16_t audioformat;
  uint16_t numchannels;
  uint32_t samplerate;
  uint32_t byterate;
  uint16_t blockalign;
  uint16_t bitspersample;
  char data_chunkid[4];
  uint32_t data_chunksize;
};
  

unsigned char *generate_wav(int *count, int sec) {
  unsigned char *b, *data;
  int idx;
  struct wav_header *wav;
  unsigned int data_size = sec*SAMPLE_RATE*SAMPLE_CHAN*SAMPLE_BITS/8;

  printf("data size = %d\n", data_size);
  b = malloc(data_size);
  if (b == NULL) {
    printf("malloc failure\n");
    *count = 0;
    return NULL;
  }
  wav = (struct wav_header *)b;
  data = b + sizeof(struct wav_header);
  strcpy(wav->chunkid, "RIFF");
  wav->chunksize = swap_uint32(32 + data_size);
  strcpy(wav->format, "WAVE");
  strcpy(wav->fmt_chunkid, "fmt ");
  wav->fmt_chunksize = swap_uint32(16);
  wav->audioformat = swap_uint16(1);
  wav->numchannels = swap_uint16(SAMPLE_CHAN);
  wav->samplerate = swap_uint32(SAMPLE_RATE);
  wav->byterate = swap_uint32(SAMPLE_RATE*SAMPLE_CHAN*SAMPLE_BITS/8);
  wav->blockalign = swap_uint16(SAMPLE_CHAN*SAMPLE_BITS/8);
  wav->bitspersample = swap_uint16(SAMPLE_BITS);
  strcpy(wav->data_chunkid, "data");
  wav->data_chunksize = swap_uint32(data_size);
  data = b + sizeof(struct wav_header);
  idx = 0;
  *count = 36 + data_size;

  int fd = open("/foo.wav", O_RDONLY);
  if (fd != 4) {
    printf("open failed %d\n", errno);
    while (1);
  }
  lseek(fd, 0xf6, SEEK_SET);
  while (idx < data_size) {
    int frag = (idx + (8*1024) < data_size ? (8*1024) : data_size - idx );
    read(fd, data, frag);
    data += frag;
    idx += frag;
  }
  close(fd);
  return b;
}

void main(void) {
  unsigned char *buffer;
  int pos = 0;
  int count, fd;
  
  spi_speed(SPI_SPEED0);
  spi_mode(SPI_MODE0);
  codec_reset();
  delay(100);
  iprintf("mode = %04x\n", codec_sci_read(CODEC_REG_MODE));
  iprintf("status = %04x\n", codec_sci_read(CODEC_REG_STATUS));

  codec_sci_write(CODEC_REG_VOL, 0x4040);
  iprintf("new volume = %04x\n", codec_sci_read(CODEC_REG_VOL));

  codec_sci_write(CODEC_REG_CLOCKF, 0x8800);
  delay(100000);
  iprintf("speed0 clockf = %04x\n", codec_sci_read(CODEC_REG_CLOCKF));
  
  while (!SPI_CODEC_READY);

  spi_speed(SPI_SPEED3);
  buffer = generate_wav(&count, 10);
  printf("count = %d\n", count);

  fd = open("/new.wav", O_CREAT|O_WRONLY);
  if (fd != 4) {
    printf("open failed %d\n", errno);
    while (1);
  }
  pos = 0;
  while (pos != count) {
    int frag = (pos + 1024 < count ? 1024 : count - pos);
    write(fd, &(buffer[pos]), frag);
    pos += frag;
  }
  close(fd);
    
  pos = 0;
  while (pos != count) {
    int frag = (pos + 32 < count ? pos + 32 : count);
    CLEAR_BIT(SPI_CTL, CODEC_DATA_SEL);
    while (pos < frag)
      spi_xfer(buffer[pos++]);
    SET_BIT(SPI_CTL, CODEC_DATA_SEL);
    while (!SPI_CODEC_READY);
  }
  printf("done\n");
}
