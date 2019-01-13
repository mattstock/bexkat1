#include "misc.h"
#include "serial.h"
#include "kernel/include/vectors.h"
#include "kernel/include/ff.h"
#include "spi.h"
#include "rtc.h"
#include "timers.h"
#include "elf32.h"
#include <string.h>
#include <sys/types.h>
#include <stdarg.h>
#include <stdlib.h>
#include "vga.h"

void rts_set();

extern void disk_timerproc (void);

void (*execptr)(void);

void sdcard_exec(int super, char *name) {
  FATFS f;
  FRESULT foo;
  FIL fp;
  elf32_hdr header;
  elf32_phdr prog_header;
  int count, hidx, segidx;
  unsigned int memidx;
  unsigned int buffer[1024];

  if (f_mount(&f, "", 1) != FR_OK) return;
  foo = f_open(&fp, name, FA_READ);
  if (foo != FR_OK) {
    serial_printf(0, "file error\n");
    return;
  }

  foo = f_read(&fp, &header, sizeof(elf32_hdr), &count);
  if (foo != FR_OK) {
    serial_printf(0, "read error\n");
  }
  if (count != sizeof(elf32_hdr)) {
    serial_printf(0, "partial read of header!\n");
  }
  // iterate over program headers and do copies
  for (hidx=0; hidx < header.e_phnum; hidx++) {
    serial_printf(0, "seeking header %d\n", hidx);
    foo = f_lseek(&fp, header.e_phoff+hidx*header.e_phentsize);
    if (foo != FR_OK) {
      serial_printf(0, "seek error\n");
    }
    serial_printf(0, "reading header %d\n", hidx);
    foo = f_read(&fp, &prog_header, sizeof(elf32_phdr), &count);
    if (foo != FR_OK) {
      serial_printf(0, "read error\n");
    }
    if (count != sizeof(elf32_phdr)) {
      serial_printf(0, "partial read of program header!\n");
    }
    foo = f_lseek(&fp, prog_header.p_offset);
    if (foo != FR_OK) {
      serial_printf(0, "seek error\n");
    }

    serial_printf(0, "transferring segments\n");

    segidx = prog_header.p_filesz;
    memidx = prog_header.p_paddr;
    while (segidx > 1024) {
      foo = f_read(&fp, &buffer, 1024, &count);
      if (foo != FR_OK) {
	serial_printf(0, "read error\n");
      }
      if (count != 1024) {
	serial_printf(0, "partial read of 1k block?!\n");
      }
      serial_printf(0, "memcpy\n");
      memcpy((unsigned int *)memidx, &buffer , 1024);
      segidx -= 1024;
      memidx += 1024;
    }
    foo = f_read(&fp, &buffer, segidx, &count);
    if (foo != FR_OK) {
      serial_printf(0, "read error\n");
    }
    if (count != segidx) {
      serial_printf(0, "partial read of segidx block?!\n");
    }
    memcpy((unsigned int *)memidx, &buffer , segidx);
  }
  // Cleanly unmount sdcard
  serial_printf(0, "close and unmount\n");
  f_close(&fp);
  f_mount((void *)0, "", 0);
  execptr = (void *)header.e_entry;
  cli();
  (*execptr)();
}

void sdcard_ls() {
  FATFS f;
  FRESULT foo;
  FILINFO fno;
  DIR dp;
  char *fn;

  serial_printf(0, "\n");
  if (f_mount(&f, "", 1) != FR_OK) return;
  if (f_opendir(&dp, "/") != FR_OK) {
    serial_printf(0, "opendir failed\n");
    return;
  }
  for (;;) {
    foo = f_readdir(&dp, &fno);
    if (foo != FR_OK || fno.fname[0] == 0) break;
    if (fno.fname[0] == '.') continue;
    fn = fno.fname;
    if (fno.fattrib & AM_DIR) {
      serial_printf(0, "%s\n", fn);
    } else {
      serial_printf(0, "%s\n", fn);
    }
  }
  f_closedir(&dp);
  f_mount((void *)0, "", 0);
}

INTERRUPT_HANDLER(timer3)
static void timer3(void) {
  disk_timerproc();
  timers[1] = 0x8; // clear the interrupt
  timers[7] += 1000000; // reset timer3 interval
}

void main(void) {
  unsigned int foo;
  unsigned short size=20;
  char buf[20];
  char *msg;
  int val;
  int *ref;
  unsigned int sp;

  spi_fast();

  // for filesystem code
  timers[7] = timers[12] + 1000000; // 100Hz
  set_interrupt_handler(intr_timer3, timer3);
  timers[0] |= 0x88; // enable timer and interrupt
  sti();

  vga_set_mode(VGA_MODE_TEXT);
  vga_putchar(vga_color233(VGA_TEXT_RED), 'X');
  
  serial_printf(0, "BexOS v0.5\nCopyright 2018 Matt Stock\n");
  rts_set();
  
  while (1) {
    serial_printf(0, "\nBexkat1 > ");
    msg = buf;
    serial_getline(0, msg, &size);
    switch (msg[0]) {
    case 'b':
      serial_printf(0, "\n attempt to exec file....\n");
      msg += 2;
      sdcard_exec(0, msg);
      break;
    case 'l':
      sdcard_ls();
      break;
    default:
      console_printf(CONSOLE_RED, "\nunknown commmand: %s\n", msg);
    }
  }
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
  unsigned int hour, min, sec;

  // date
  result = rtc_cmd(0x06, 0xff);
  year = 1900 + (rtc_cmd(0x05, 0xff) & 0x80 ? 100 : 0) + 10*(result >> 4) + (result & 0xf);
  result = rtc_cmd(0x05, 0xff) & 0x1f;
  month = 10*(result >> 4) + (result & 0xf);
  result = rtc_cmd(0x04, 0xff) & 0x3f;
  day = 10*(result >> 4) + (result & 0xf);
  console_printf(CONSOLE_WHITE, "\nDate [%04u-%02u-%02u]: ", year, month, day);

  msg = buf;
  if (console_getline(CONSOLE_WHITE, msg, &size) > 0) { 
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
  console_printf(CONSOLE_WHITE, "\nTime [%02u:%02u:%02u]: ", hour, min, sec);

  msg = buf;
  if (console_getline(CONSOLE_WHITE, msg, &size) > 0) { 
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
