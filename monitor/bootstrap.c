#include "misc.h"
#include "matrix.h"
#include "serial.h"
#include "spi.h"
#include "ff.h"
#include "lcd.h"
#include "rtc.h"
#include "elf32.h"
#include <string.h>

unsigned int addr;
unsigned short data;

unsigned char katherine[] = { 194, 132, 190, 148, 129, 141, 0 }; 
unsigned char rebecca[] = { 148, 131, 172, 131, 196, 131, 0 };

unsigned char *vid = (unsigned char *)0xc0000000;

char helpmsg[] = "\n? = help\na aaaaaaaa = set address\nr = read page of mem and display\nw dddddddd = write word current address\nc = SDcard test\nm = led matrix init\nl = lcd test\nb filename = boot file\n\n";

void vidtest(void) {
  int x;
  for (x=0; x < 640*480; x++)
    vid[x] = 0x00;
  for (x=0; x < 640; x++)
    vid[x] = 0xff;
  for (x=0; x < 640; x++)
    vid[239*640+x] = 0xff;
  for (x=0; x < 640; x++)
    vid[478*640+x] = 0xff;
}

void memtest(void) {
  unsigned int *ref = (unsigned int *)0x00004000;
  int val, i;

  ref[0x80001] = 0;
  for (i=0; i < 0x100000-0x1000; i++)
    ref[i] = 0;
  for (i=0; i < 0x100000-0x1000; i++) {
    if (ref[i] != 0) {
      serial_print(0, "\nclear failure at ");
      serial_printhex(0, i);
      return;
    }
    ref[i] = i;
  }
  for (i=0; i < 0x100000-0x1000; i++) {
    if (ref[i] != i) {
      serial_print(0, "\nassign failure at ");
      serial_printhex(0, i*4+0x00004000);
      return;
    }
  }
  serial_print(0, "\ntest successful\n");
}

void flash_erase(void) {
  unsigned short *fm, *fm2;

  fm = (unsigned short *)0x08000aaa; // 555 * 2
  fm2 = (unsigned short *)0x08000554; // 2aa * 2
  *fm = (short)0x00aa;
  *fm2 = (short)0x0055;
  *fm = (short)0x0080;
  *fm = (short)0x00aa;
  *fm2 = (short)0x0055;
  *fm = (short)0x0010;
}

void flash_write(unsigned int addr, unsigned short val) {
  unsigned short *fm, *fm2;

  fm = (unsigned short *)0x08000aaa; // 555 * 2
  fm2 = (unsigned short *)0x08000554; // 2aa * 2
  *fm = (short)0x00aa;
  *fm2 = (short)0x0055;
  *fm = (short)0x00a0;
  fm = (unsigned short *)addr;
  *fm = val;
}

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

void set_rtc() {
  
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
  serial_print(1, rebecca);
  spi_fast();
  addr = 0xc0000000;
  lcd_init();
  lcd_print("Bexkat 1000");
  lcd_pos(0,1);
  lcd_print("v4.0");
  if ((sysio[0] & 0x1) == 0x1) {
    sdcard_exec("/kernel");
    serial_print(0, "\nautoboot failed\n");
  }
  
  while (1) {
    serial_print(0, "\nBexkat1 [");
    serial_printhex(0, addr);
    serial_print(0, "] > ");
    sysctrl[0] = addr;
    msg = buf;
    serial_getline(0, msg, &size);
    
    switch (msg[0]) {
    case '?':
      serial_print(0, helpmsg);
      break;
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
    case 'e':
      serial_print(0, "\nerasing flash...\n");
      flash_erase();
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
    case 'v':
      vidtest();
      break;
    case 'w':
      msg++;
      while (*msg != '\0') {
	val = (val << 4) + hextoi(*msg);
	msg++;
      }
      if (addr >= 0xe0000000 && addr < 0xf0000000) {
        serial_print(0, "\nflash write");
        flash_write(addr, val);
      } else {
        ref = (int *)addr;
        *ref = val;
      }
      serial_print(0, "\n");
      break;
    default:
      serial_print(0, "\nunknown commmand: ");
      serial_print(0, msg);
      serial_print(0, "\n");
    }
  }
}
