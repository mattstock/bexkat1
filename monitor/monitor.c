#include "misc.h"
#include "matrix.h"
#include "serial.h"
#include "ff.h"
#include "lcd.h"
#include "itd.h"

unsigned int addr;
unsigned short data;

volatile unsigned int *vga = (unsigned int *)0x00c00000;

void serial_srec(unsigned port);
void vga_test();

char helpmsg[] = "\n? = help\na aaaaaaaa = set address\nr = read page of mem and display\nw dddddddd = write word current address\nv = vga test\nc = SDcard test\nm = led matrix init\ns = s-record upload\n\n";

void vga_test() {
  unsigned x,y;

  for (x=0; x < 640; x++) {
    for (y=0; y < 480; y++) {
      vga[(y*640)+x] = 0x800000 + x;
    }
  }
}

void serial_srec(unsigned port) {
  unsigned short done = 0;
  char c;
  unsigned char len;
  char type;
  unsigned char sum;
  unsigned short pos;
  char *s;

  while (!done && (serial_getchar(port) == 'S')) {
    type = serial_getchar(port);
    switch (type) {
    case '0':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = len;
      while (len != 0) {
	c = hextoi(serial_getchar(port));
	c = (c << 4) + hextoi(serial_getchar(port));
	sum += c;
	serial_printhex(port, sum);
	serial_putchar(port, '\n');
	len--;
      }
      if (sum != 0xff) {
	done = 1;
	serial_print(0, "checksum fail!?\n");
        matrix[pos++] = 0xff0000;
      } else {
  	matrix[pos++] = 0xff00;
      }
    break;
    case '1':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = 0;
      break;
    case '2':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = 0;
      break;
    case '3':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = 0;
      break;
    case '9':
      done = 1;
      break;
    case '8':
      done = 1;
      break;
    case '7':
      done = 1;
      break;
    }
  }
}

void serial_dumpmem(unsigned port,
		    unsigned addr, 
		    unsigned short len) {
  unsigned int i;
  unsigned *pos = (unsigned *)addr;
  
  serial_print(port, "\n");
  for (i=0; i < len; i += 4) {
    serial_printhex(port, addr+4*i);
    serial_print(port, ": ");
    serial_printhex(port, pos[i]);
    serial_print(port, " ");
    serial_printhex(port, pos[i+1]);
    serial_print(port, " ");
    serial_printhex(port, pos[i+2]);
    serial_print(port, " ");
    serial_printhex(port, pos[i+3]);
    serial_print(port, "\n");
  }
}

void sdcard_init() {
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
}

void main(void) {
  unsigned short size=20;
  char buf[20];
  char *msg;
  int val;
  int *ref;

  addr = 0x00800004;
  lcd_init();
  lcd_print("Bexkat 1000");
  lcd_pos(0,1);
  lcd_print("Monitor Mode");
  while (1) {
    serial_print(0, "\nBexkat1 [");
    serial_printhex(0, addr);
    serial_print(0, "] > ");
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
      serial_print(0, "\nturning on backlight...\n");
      itd_backlight(1);
      break;
    case 'c':
      serial_print(0, "\nSDCard test...\n");
      sdcard_init();
      break;
    case 'm':
      matrix_init();
      break;
    case 'r':
      serial_dumpmem(0, addr, 32);
      break;
    case 's':
      serial_print(0, "\nstart srec upload...\n");
      serial_srec(0);
      break;
    case 'v':
      serial_print(0, "\nVGA test starting...\n");
      vga_test();
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
