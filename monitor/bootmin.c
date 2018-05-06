#include "misc.h"
#include "serial.h"
#include "spi.h"
#include "lcd.h"
#include "kernel/include/vectors.h"
#include "kernel/include/ff.h"
#include "rtc.h"
#include "timers.h"
#include "elf32.h"
#include <string.h>
#include <sys/types.h>
#include <stdarg.h>
#include <console.h>

void rts_set();

extern void disk_timerproc (void);

void sdcard_exec(int super, char *name) {
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
    console_printf(CONSOLE_RED, "file error\n");
    return;
  }

  foo = f_read(&fp, &header, sizeof(elf32_hdr), &count);
  if (foo != FR_OK) {
    console_printf(CONSOLE_RED, "read error\n");
  }
  if (count != sizeof(elf32_hdr)) {
    console_printf(CONSOLE_RED, "partial read of header!\n");
  }
  // iterate over program headers and do copies
  for (hidx=0; hidx < header.e_phnum; hidx++) {
    foo = f_lseek(&fp, header.e_phoff+hidx*header.e_phentsize);
    if (foo != FR_OK) {
      console_printf(CONSOLE_RED, "seek error\n");
    }
    foo = f_read(&fp, &prog_header, sizeof(elf32_phdr), &count);
    if (foo != FR_OK) {
      console_printf(CONSOLE_RED, "read error\n");
    }
    if (count != sizeof(elf32_phdr)) {
      console_printf(CONSOLE_RED, "partial read of program header!\n");
    }
    foo = f_lseek(&fp, prog_header.p_offset);
    if (foo != FR_OK) {
      console_printf(CONSOLE_RED, "seek error\n");
    }

    segidx = prog_header.p_filesz;
    memidx = prog_header.p_paddr;
    while (segidx > 1024) {
      foo = f_read(&fp, &buffer, 1024, &count);
      if (foo != FR_OK) {
	console_printf(CONSOLE_RED, "read error\n");
      }
      if (count != 1024) {
	console_printf(CONSOLE_RED, "partial read of 1k block?!\n");
      }
      memcpy((unsigned int *)memidx, &buffer , 1024);
      segidx -= 1024;
      memidx += 1024;
    }
    foo = f_read(&fp, &buffer, segidx, &count);
    if (foo != FR_OK) {
      console_printf(CONSOLE_RED, "read error\n");
    }
    if (count != segidx) {
      console_printf(CONSOLE_RED, "partial read of segidx block?!\n");
    }
    memcpy((unsigned int *)memidx, &buffer , segidx);
  }
  // Cleanly unmount sdcard
  f_close(&fp);
  f_mount((void *)0, "", 0);
  // Shut off interrupts
  cli();
  execptr = (void *)header.e_entry;
  (*execptr)();
}

void sdcard_ls() {
  FATFS f;
  FRESULT foo;
  FILINFO fno;
  DIR dp;
  char *fn;

  console_printf(CONSOLE_WHITE, "\n");
  if (f_mount(&f, "", 1) != FR_OK) return;
  if (f_opendir(&dp, "/") != FR_OK) {
    console_printf(CONSOLE_RED, "opendir failed\n");
    return;
  }
  for (;;) {
    foo = f_readdir(&dp, &fno);
    if (foo != FR_OK || fno.fname[0] == 0) break;
    if (fno.fname[0] == '.') continue;
    fn = fno.fname;
    if (fno.fattrib & AM_DIR) {
      console_printf(CONSOLE_BLUE, "%s\n", fn);
    } else {
      console_printf(CONSOLE_WHITE, "%s\n", fn);
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

  console_printf(CONSOLE_WHITE, "BexOS v0.5\nCopyright 2018 Matt Stock\n");

  while (1) {
    console_printf(CONSOLE_WHITE, "\nBexkat1 > ");
    msg = buf;
    console_getline(CONSOLE_WHITE, msg, &size);
    
    switch (msg[0]) {
    case 'b':
      console_printf(CONSOLE_WHITE, "\n attempt to exec file....\n");
      msg += 2;
      sdcard_exec(0, msg);
      break;
    case 'l':
      sdcard_ls();
      break;
    default:
      console_printf(CONSOLE_WHITE, "\nunknown commmand: %s\n", msg);
    }
  }
}
