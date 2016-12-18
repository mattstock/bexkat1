#include "misc.h"
#include "matrix.h"
#include "serial.h"
#include "spi.h"
#include "ff.h"
#include "lcd.h"
#include "rtc.h"
#include "timers.h"
#include "vectors.h"
#include "elf32.h"
#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>

unsigned int addr;
unsigned short data;

void rts_set();

unsigned char katherine[] = { 194, 132, 190, 148, 129, 141, 0 }; 
unsigned char rebecca[] = { 148, 131, 172, 131, 196, 131, 0 };

void serial_dumpmem(unsigned port,
		    unsigned addr, 
		    unsigned short len) {
  unsigned int i,j;
  unsigned *pos = (unsigned *)addr;
  
  serial_print(port, "\n");
  for (i=0; i < len; i += 8) {
    serial_printhex(port, addr+4*i);
    serial_print(port, ": ");
    for (j=0; j < 8; j++) {
      serial_printhex(port, pos[i+j]);
      serial_print(port, " ");
    }
    serial_print(port, "\n");
  }
}

void sdcard_exec(char *name) {
  FATFS f;
  FRESULT foo;
  FIL fp;
  elf32_hdr header;
  elf32_phdr prog_header;
  int count, hidx, segidx;
  unsigned int memidx;
  unsigned int buffer[1024];
  void (*execptr)(void);

  if (f_mount(&f, "", 1) != FR_OK) return;
  foo = f_open(&fp, name, FA_READ);
  if (foo != FR_OK) {
    serial_print(0, "file error\n");
    return;
  }

  foo = f_read(&fp, &header, sizeof(elf32_hdr), &count);
  if (foo != FR_OK) {
    serial_print(0, "read error\n");
  }
  if (count != sizeof(elf32_hdr)) {
    serial_print(0, "partial read of header!\n");
  }
  // iterate over program headers and do copies
  for (hidx=0; hidx < header.e_phnum; hidx++) {
    foo = f_lseek(&fp, header.e_phoff+hidx*header.e_phentsize);
    if (foo != FR_OK) {
      serial_print(0, "seek error\n");
    }
    foo = f_read(&fp, &prog_header, sizeof(elf32_phdr), &count);
    if (foo != FR_OK) {
      serial_print(0, "read error\n");
    }
    if (count != sizeof(elf32_phdr)) {
      serial_print(0, "partial read of program header!\n");
    }
    foo = f_lseek(&fp, prog_header.p_offset);
    if (foo != FR_OK) {
      serial_print(0, "seek error\n");
    }

    segidx = prog_header.p_filesz;
    memidx = prog_header.p_paddr;
    while (segidx > 1024) {
      foo = f_read(&fp, &buffer, 1024, &count);
      if (foo != FR_OK) {
	serial_print(0, "read error\n");
      }
      if (count != 1024) {
      serial_print(0, "partial read of 1k block?!\n");
      }
      memcpy((unsigned int *)memidx, &buffer , 1024);
      segidx -= 1024;
      memidx += 1024;
    }
    foo = f_read(&fp, &buffer, segidx, &count);
    if (foo != FR_OK) {
      serial_print(0, "read error\n");
    }
    if (count != segidx) {
      serial_print(0, "partial read of segidx block?!\n");
    }
    memcpy((unsigned int *)memidx, &buffer , segidx);
  }
  // Cleanly unmount sdcard
  f_close(&fp);
  f_mount((void *)0, "", 0);
  // Shut off interrupts
  asm("cli");
  execptr = (void *)header.e_entry;
  (*execptr)();
}

void sdcard_ls() {
  FATFS f;
  FRESULT foo;
  FILINFO fno;
  DIR dp;
  char *fn;
  if (f_mount(&f, "", 1) != FR_OK) return;
  if (f_opendir(&dp, "/") != FR_OK) {
    serial_print(0, "opendir failed\n");
    return;
  }
  for (;;) {
    foo = f_readdir(&dp, &fno);
    if (foo != FR_OK || fno.fname[0] == 0) break;
    if (fno.fname[0] == '.') continue;
    fn = fno.fname;
    if (fno.fattrib & AM_DIR) {
      serial_print(0, "directory found: ");
      serial_print(0, fn);
      serial_print(0, "\n");
    } else {
      serial_print(0, "file found: ");
      serial_print(0, "/");
      serial_print(0, fn);
      serial_print(0, "\n");
    }
  }
  f_closedir(&dp);
  f_mount((void *)0, "", 0);
}

void main(void) {
  unsigned int foo;
  unsigned short size=20;
  char buf[20];
  char *msg;
  int val;
  int *ref;
  unsigned int sp;

  matrix_init();
  serial_print(1, katherine);
  spi_fast();
  addr = 0xc0000000;
  lcd_init();
  lcd_print("Bexkat 1000");
  lcd_pos(0,1);
  lcd_print("v2.5");
  serial_print(1, rebecca);
  if ((sysio[0] & 0x1) == 0x1) {
    sdcard_exec("/kernel");
    serial_print(0, "\nautoboot failed\n");
  }

  rts_set();

  while (1) {
    serial_print(0, "\nBexkat1 [");
    serial_printhex(0, addr);
    serial_print(0, "] > ");
    sysctrl[0] = addr;
    msg = buf;
    serial_getline(0, msg, &size);
    
    switch (msg[0]) {
    case 'a':
      msg++;
      while (*msg != '\0') {
	addr = (addr << 4) + hextoi(*msg);
	msg++;
      }
      break;
    case 'b':
      serial_print(0, "\n attempt to exec file....\n");
      msg += 2;
      sdcard_exec(msg);
      break;
    case 'c':
      serial_print(0, "\nSDCard test...\n");
      sdcard_ls();
      break;
    case 'm':
      matrix_init();
      break;
    case 'r':
      serial_dumpmem(0, addr, 128);
      break;
    case '.':
      addr += 4;
      break;
    case ',':
      addr -= 4;
      break;
    case 'w':
      msg++;
      while (*msg != '\0') {
	val = (val << 4) + hextoi(*msg);
	msg++;
      }
      ref = (int *)addr;
      *ref = val;
      serial_print(0, "\n");
      break;
    default:
      serial_print(0, "\nunknown commmand: ");
      serial_print(0, msg);
      serial_print(0, "\n");
    }
  }
}

unsigned int atoi(char *s) {
  unsigned int x = 0;

  if (*s >= '0' && *s <= '9') {
    x += *s - '0';
    s++;
  }
  while (*s >= '0' && *s <= '9') {
    x = 10*x;
    x += *s - '0';
    s++;
  }
  return x;
}

unsigned char dec2bcd(unsigned char dec) {
  unsigned char tens, ones;

  ones = tens = 0;
  for (int i=0; i < 8; i++) {
    if (ones >= 5)
      ones += 3;
    if (tens >= 5)
      tens += 3;
    tens  = (tens << 1) & 0xf;
    if (ones & 0x8)
      tens++;
    ones  = (ones << 1) & 0xf;
    if (dec & 0x80)
      ones++;
    dec <<= 1;
  }
  ones = (ones & 0xf) | ((tens & 0xf) << 4);

  return (ones & 0xff);
}

void rts_set() {
  unsigned short size=20;
  char buf[20];
  unsigned char result;
  char *msg;

  unsigned int year, month, day;
  unsigned int hour, min, sec, dow;

  // date
  result = rtc_cmd(0x06, 0xff);
  year = 1900 + (rtc_cmd(0x05, 0xff) & 0x80 ? 100 : 0) + 10*(result >> 4) + (result & 0xf);
  result = rtc_cmd(0x05, 0xff) & 0x1f;
  month = 10*(result >> 4) + (result & 0xf);
  result = rtc_cmd(0x04, 0xff) & 0x3f;
  day = 10*(result >> 4) + (result & 0xf);
  serial_print(0, "\nDate [");
  msg = itos(year, buf);
  *msg = '\0';
  serial_print(0, buf);
  serial_print(0, "-");
  msg = itos(month, buf);
  *msg = '\0';
  serial_print(0, buf);
  serial_print(0, "-");
  msg = itos(day, buf);
  *msg = '\0';
  serial_print(0, buf);
  serial_print(0, "]: ");

  msg = buf;
  if (serial_getline(0, msg, &size) > 0) { 
    year = atoi(msg);
    while (*msg != '-' && *msg != '\0') msg++;
    msg++;
    month = atoi(msg);
    while (*msg != '-' && *msg != '\0') msg++;
    msg++;
    day = atoi(msg);

    if (year >= 2000 && month < 13 && day < 32) { 
      rtc_cmd(0x86, dec2bcd(year-2000));
      rtc_cmd(0x85, 0x80 | dec2bcd(month));
      rtc_cmd(0x84, dec2bcd(day));
    }
  }

  // time
  result = rtc_cmd(0x02, 0xff);
  hour = (result & 0xf) + 10*((result >> 4) & 0x1);
  if (result & 0x20)
    hour += (result & 0x40 ? 12 : 20);
  result = rtc_cmd(0x01, 0xff);
  min = 10*(result >> 4) + (result & 0xf);
  result = rtc_cmd(0x00, 0xff);
  sec = 10*(result >> 4) + (result & 0xf);
  serial_print(0, "\nTime [");
  msg = itos(hour, buf);
  *msg = '\0';
  serial_print(0, buf);
  serial_print(0, ":");
  msg = itos(min, buf);
  *msg = '\0';
  serial_print(0, buf);
  serial_print(0, ":");
  msg = itos(sec, buf);
  *msg = '\0';
  serial_print(0, buf);
  serial_print(0, "]: ");

  msg = buf;
  if (serial_getline(0, msg, &size) > 0) { 
    hour = atoi(msg);
    while (*msg != ':' && *msg != '\0') msg++;
    msg++;
    min = atoi(msg);
    while (*msg != ':' && *msg != '\0') msg++;
    msg++;
    sec = atoi(msg);

    if (hour < 24 && min < 60 && sec < 60) { 
      rtc_cmd(0x80, dec2bcd(sec));
      rtc_cmd(0x81, dec2bcd(min));
      rtc_cmd(0x82, dec2bcd(hour));
    }
  }
}
