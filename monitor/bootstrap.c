#include "misc.h"
#include "matrix.h"
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
#include <sys/time.h>
#include <time.h>
#include <stdarg.h>
#include <vga.h>
#include <console.h>
#include <malloc.h>

void rts_set();

unsigned char katherine[] = { 194, 132, 190, 148, 129, 141, 0 }; 
unsigned char rebecca[] = { 148, 131, 172, 131, 196, 131, 0 };

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
    console_printf(CONSOLE_WHITE, "header index %d\n", hidx);
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
    console_printf(CONSOLE_WHITE, "filesize = %d, base address = %08x\n",
		   segidx, memidx);
    while (segidx > 1024) {
      foo = f_read(&fp, &buffer, 1024, &count);
      if (foo != FR_OK) {
	console_printf(CONSOLE_RED, "read error\n");
      }
      if (count != 1024) {
	console_printf(CONSOLE_RED, "partial read of 1k block?!\n");
      }
      console_printf(CONSOLE_WHITE, "copy block to %08x\n", memidx);
      memcpy((unsigned int *)memidx, &buffer , 1024);
      segidx -= 1024;
      memidx += 1024;
    }
    foo = f_read(&fp, &buffer, segidx, &count);
    if (foo != FR_OK) {
      console_printf(CONSOLE_RED, "read error\n");
    }
    memcpy((unsigned int *)memidx, &buffer , segidx);
  }
  // Cleanly unmount sdcard
  f_close(&fp);
  f_mount((void *)0, "", 0);
  // Shut off interrupts
  cli();
  console_printf(CONSOLE_WHITE, "Jumping to %08x\n", header.e_entry);
  execptr = (void *)header.e_entry;
  if (!super) {
    asm("ldiu %1, 0\n");
    asm("movsr %1\n");
    asm("ldi %sp, 0x08000000\n");
  }
  (*execptr)();
}

void sdcard_ls() {
  FATFS f;
  FRESULT foo;
  FILINFO fno;
  DIR dp;
  char *fn;

  console_printf(CONSOLE_WHITE, "\n");
  foo = f_mount(&f, "", 1);
  if (foo != FR_OK) {
    console_printf(CONSOLE_RED, "mount failed %d\n", foo);
    return;
  }
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
  timers[7] += 100000; // reset timer3 interval
}

void utf8(uint32_t cp, char *val) {
  if (cp < 0x80) {
    val[1] = '\0';
    val[0] = cp & 0x7f;
    return;
  }
  if (cp < 0x800) {
    val[2] = '\0';
    val[1] = (cp & 0x3f) | 0x80;
    cp >>= 6;
    val[0] = (cp & 0x1f) | 0xc0;
    return;
  }
  if (cp < 0x10000) {
    val[3] = '\0';
    val[2] = (cp & 0x3f) | 0x80;
    cp >>= 6;
    val[1] = (cp & 0x3f) | 0x80;
    cp >>= 6;
    val[0] = (cp & 0x0f) | 0xe0;
    return;
  }
  val[4] = '\0';
  val[3] = (cp & 0x3f) | 0x80;
  cp >>= 6;
  val[2] = (cp & 0x3f) | 0x80;
  cp >>= 6;
  val[1] = (cp & 0x3f) | 0x80;
  cp >>= 6;
  val[0] = (cp & 0x7) | 0xf0;
}

void idx2pos(int idx) {
  int col = (idx % 8);
  int row = (idx / 8);

  int posx = 19 + (col * 10);
  int posy = 4 + row;
  
  serial_printf(0, "\x1b[%d;%dH", posy, posx);
}

void dumpmem(uint32_t addr, uint32_t *values) {
  uint32_t *pos = (uint32_t *)addr;
  
  serial_printf(0, "\x1b[1;33;44m+");
  for (int i=0; i < 14; i++)
    serial_putchar(0, '-');
  serial_putchar(0, '+');
  for (int i=0; i < 82; i++)
    serial_putchar(0, '-');
  serial_printf(0, "+\n|   ADDRESS    |");
  for (int i=0; i < 8; i++)
    serial_printf(0, "  %02x      ", i*4);
  serial_printf(0, "  |\n+");
  for (int i=0; i < 14; i++)
    serial_putchar(0, '-');
  serial_putchar(0, '+');
  for (int i=0; i < 82; i++)
    serial_putchar(0, '-');
  serial_printf(0, "+\n");

  // dump the memory to screen
  for (int i=0; i < 128; i += 8) {
    serial_printf(0, "\x1b[1;33;44m|");
    serial_printf(0, "\x1b[1;37m   %08x   ", addr+4*i);
    serial_printf(0, "\x1b[1;33m|");
    for (int j=0; j < 8; j++)
      if (values[i+j] == pos[i+j]) {
	serial_printf(0,"\x1b[1;37m  %08x", values[i+j]);
      } else {
	values[i+j] = pos[i+j];
	serial_printf(0,"\x1b[1;31m  %08x\x1b[1;37m", values[i+j]);
      }
    serial_printf(0, "\x1b[1;33m  |\n");
  }

  serial_putchar(0, '+');
  for (int i=0; i < 14; i++)
    serial_putchar(0, '-');
  serial_putchar(0, '+');
  for (int i=0; i < 82; i++)
    serial_putchar(0, '-');
  serial_printf(0, "+\n");
}

uint32_t edit(uint32_t val, int idx) {
  int n = 0;
  char x, y;
  uint32_t newval = val;
  
  // set an editing cursor
  
  while (1) {
    x = serial_getchar(0);
    if (x == '\x1b') { // escape code functions
      if (serial_getchar(0) == '[') {
	switch (serial_getchar(0)) {
	case 'C':
	  if (n < 7) {
	    serial_printf(0, "\x1b[1C");
	    n++;
	  }
	  break;
	case 'D':
	  if (n > 0) {
	    serial_printf(0, "\x1b[1D");
	    n--;
	  }
	  break;
	}
      }
    }
    if (x >= '0' && x <= '9') {
      serial_printf(0, "\x1b[1;41;33m%c", x);
      newval = (newval & ~(0xf << (7-n)*4)) | ((x-'0') << (7-n)*4);
      if (n < 7)
	n++;
      else
	serial_printf(0, "\x1b[1D");
    }
    if (x >= 'a' && x <= 'f') {
      serial_printf(0, "\x1b[1;41;33m%c", x);
      newval = (newval & ~(0xf << (7-n)*4)) | ((x-'a'+10) << (7-n)*4);
      if (n < 7)
	n++;
      else
	serial_printf(0, "\x1b[1D");
    }
    if (x == '\x0d')
      return newval;
  }
}

void hex_editor(uint32_t addr) {
  uint32_t *values;
  uint32_t *pos = (uint32_t *)addr;
  uint16_t s, s2;
  char msg[20];
  int idx = 0;
  char special[6];
  char x;
  
  values = malloc(sizeof(uint32_t)*128);
  for (int i=0; i < 128; i++)
    values[i] = pos[i];

  serial_printf(0, "\x1b[2J");
  dumpmem(addr, values);

  while (1) {
    idx2pos(idx);
    x = serial_getchar(0);
    switch (x) {
    case '0':
      addr = 0;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '2':
      addr = 0xc0000000;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '3':
      addr = 0x30000000;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '4':
      addr = 0x40000000;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '5':
      addr = 0x50000000;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '7':
      addr = 0x70000000;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '8':
      addr = 0x80000000;
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case '\x1b': // escape code functions
      special[0] = serial_getchar(0);
      special[1] = serial_getchar(0);
      if (special[0] != '[') {
	break;
      }
      switch (special[1]) {
      case 'A':
	if (idx/8 > 0)
	  idx -= 8;
	break;
      case 'B':
	if (idx/8 < 15)
	  idx += 8;
	break;
      case 'C':
	if (idx < 127)
	  idx++;
	break;
      case 'D':
	if (idx > 0)
	  idx--;
	break;
      case 'U':
	if (addr < 128*4)
	  break;
	addr -= 128*4;
	pos = (uint32_t *)addr;
	for (int i=0; i < 128; i++)
	  values[i] = pos[i];
	serial_printf(0, "\x1b[2J");
	dumpmem(addr, values);
	break;
      case 'V':
	if (addr > 0xfffff10f)
	  break;
	addr += 128*4;
	pos = (uint32_t *)addr;
	for (int i=0; i < 128; i++)
	  values[i] = pos[i];
	serial_printf(0, "\x1b[2J");
	dumpmem(addr, values);
	break;
      }
      break;
    case 'q':
      serial_printf(0, "\x1b[1;1H\x1b[2J\x1b[0m");
      free(values);
      return;
    case 'e':
      pos[idx] = values[idx] = edit(values[idx], idx);
      break;
    case 'a':
      serial_printf(0, "\x1b[0m\x1b[23;2H\x1b[KNew address: ");
      s = 20;
      console_getline(CONSOLE_WHITE, msg, &s);
      addr = 0;
      for (int i=0; msg[i] != '\0'; i++) {
	addr = (addr << 4) + hextoi(msg[i]);
      }
      pos = (uint32_t *)addr;
      for (int i=0; i < 128; i++)
	values[i] = pos[i];
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    case 'r':
      serial_printf(0, "\x1b[2J");
      dumpmem(addr, values);
      break;
    default:
      serial_printf(0, "\x1b[25;2H\x1b[KUnknown character: %02x", x);
      delay(2000000);
      break;
    }
  }
}

void main(void) {
  unsigned int foo;
  uint32_t addr;
  unsigned short size=20;
  char buf[20];
  char *msg;
  int val;
  int *ref;
  unsigned int sp;

  matrix_init();
  spi_fast();
  addr = 0xc0000000;
  vga_text_clear();
  vga_set_mode(VGA_MODE_BLINK|VGA_MODE_TEXT);

  // for filesystem code
  // For 10MHz clock, we get to 100Hz we divide by 100000
  timers[7] = timers[12] + 100000; // 100Hz
  set_interrupt_handler(intr_timer3, timer3);
  timers[0] |= 0x88; // enable timer and interrupt
  sti();

  console_printf(CONSOLE_WHITE, "\n");
  console_printf(CONSOLE_WHITE, "BexOS v0.6\nCopyright 2019 Matt Stock\n");
  rts_set();

  while (1) {
    serial_printf(0, "\x1b[0m");
    console_printf(CONSOLE_WHITE, "\nBexkat1 [%08x] > ", addr);
    msg = buf;
    console_getline(CONSOLE_WHITE, msg, &size);
    
    switch (msg[0]) {
    case 'a': // change working address
      msg++;
      addr = 0;
      while (*msg != '\0') {
	if (*msg != ' ') 
	  addr = (addr << 4) + hextoi(*msg);
	msg++;
      }
      break;
    case 'h': // hex editor
      hex_editor(addr);
      break;
    case 'e': // exec file
      console_printf(CONSOLE_WHITE, "\n attempt to exec file....\n");
      msg += 2;
      sdcard_exec(0, msg);
      break;
    case 'l': // display files from SD
      sdcard_ls();
      break;
    case 'm': // clear led matrix
      matrix_init();
      break;
    case 'x':
      serial_printf(0, "\nANSI test\n");
      serial_printf(0, "\x1b[0mReset\n");
      for (int i=1; i < 8; i++)
	serial_printf(0, "\x1b[0;%dmReset, code %d\n", i, i);
      for (int i=30; i < 38; i++)
	serial_printf(0, "\x1b[0;%dmReset, code %d\n", i, i);
      for (int i=40; i < 48; i++)
	serial_printf(0, "\x1b[0;%dmReset, code %d\n", i, i);
      serial_printf(0, "\x1b[0mReset\n");
      serial_printf(0, "Input test, hit q to quit\n");
      while (1) {
	msg[1] = serial_getchar(0);
	if (msg[1] == 'q')
	  break;
	serial_printf(0, "got %02x\n", msg[1]);
      }
      break;
    case 'w':
      msg++;
      val = 0;
      while (*msg != '\0') {
	if (*msg != ' ') 
	  val = (val << 4) + hextoi(*msg);
	msg++;
      }
      ref = (int *)addr;
      *ref = val;
      console_printf(CONSOLE_WHITE, "\n");
      break;
    case '.':
      addr += 4;
      break;
    case ',':
      addr -= 4;
      break;
    default:
      console_printf(CONSOLE_WHITE, "\nunknown commmand: %s\n", msg);
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
