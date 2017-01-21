#include <stdarg.h>
#include "console.h"
#include "serial.h"
#include "vga.h"
#include "misc.h"

const unsigned int console_colormap[16] =
  { 0,
    VGA_TEXT_RED2,
    VGA_TEXT_GREEN4,
    VGA_TEXT_GREEN2|VGA_TEXT_RED1,
    VGA_TEXT_BLUE4,
    VGA_TEXT_RED1|VGA_TEXT_BLUE2,
    VGA_TEXT_BLUE2|VGA_TEXT_GREEN2,
    VGA_TEXT_RED1|VGA_TEXT_BLUE2|VGA_TEXT_GREEN2,
    VGA_TEXT_RED2|VGA_TEXT_BLUE4|VGA_TEXT_GREEN4,
    VGA_TEXT_RED,
    VGA_TEXT_GREEN,
    VGA_TEXT_RED|VGA_TEXT_GREEN6,
    VGA_TEXT_BLUE,
    VGA_TEXT_RED|VGA_TEXT_BLUE6,
    VGA_TEXT_GREEN6|VGA_TEXT_BLUE6,
    VGA_TEXT_RED|VGA_TEXT_BLUE6|VGA_TEXT_GREEN6
  };

// I/O helpers to allow for toggle of serial or vga console
void console_printf(console_color_t color, char *fmt, ...) {
  va_list argp;

  va_start(argp, fmt);
  if ((sysio[0] & 0x2) == 0x2)
    vga_vprintf(vga_console_color(color), fmt, argp);
  else
    serial_vprintf(0, fmt, argp);
  va_end(argp);
}

short console_getline(console_color_t color, char *str, unsigned short *len) {
  unsigned short i=0;
  char c;
  unsigned char c233 = vga_color233(vga_console_color(color));

  while (i < *len-1) {
    c = serial_getchar(0);
    if (c >= ' ' && c <= '~') {
      if ((sysio[0] & 0x2) == 0x2)
	vga_putchar(c233,c);
      else
	serial_putchar(0, c);
      str[i++] = c;
    }
    if (c == '\r' || c == '\n') {
      str[i] = '\0';
      return i;
    }
    if (c == 0x03) {
      str[0] = '\0';
      return -1;
    }
    if ((c == 0x7f || c == 0x08) && i > 0) {
      if ((sysio[0] & 0x2) == 0x2)
	vga_putchar(c233, c);
      else
	serial_putchar(0, c);
      i--;
    }
  }
  str[i+1] = '\0';
  return i;
}
