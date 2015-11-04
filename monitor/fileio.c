#include "misc.h"
#include "matrix.h"
#include "serial.h"
#include "ff.h"
#include "lcd.h"
#include "itd.h"
#include "elf32.h"
#include <string.h>

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
  // Bootstrap kernel
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
  FATFS f;
  matrix[0] = 0xff;
  if (f_mount(&f, "", 1) != FR_OK) {
    matrix[1] = 0xff0000;
  } else {
    matrix[1] = 0xff00;
  }
  while (1);
}
