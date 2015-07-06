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
  lcd_print("v1.0");
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
      serial_print(0, "\nstarting up lcd...\n");
      itd_init();
      serial_print(0, "making a red rect\n");
      itd_rect(10,10,20,20,color565(0xff,0,0));
      serial_print(0, "making a blue rect\n");
      itd_rect(100,130,110,150,color565(0,0,0xff));
      serial_print(0, "making a random rect\n");
      itd_rect(50,75,100,120,color565(0x10,0x10,0x30));
      serial_print(0, "turning on backlight...\n");
      itd_backlight(1);
      break;
    case 'c':
      serial_print(0, "\nSDCard test...\n");
      sdcard_init();
      break;
    case 'e':
      serial_print(0, "\nerasing flash...\n");
      flash_erase();
      break;
    case 'm':
      matrix_init();
      break;
    case 'r':
      serial_dumpmem(0, addr, 64);
      break;
    case 's':
      serial_print(0, "\nstart srec upload...\n");
      serial_srec(0);
      break;
    case 'v':
      serial_print(0, "\nVGA test starting...\n");
      vga_test();
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
      if (addr >= 0x08000000 && addr < 0x10000000) {
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
