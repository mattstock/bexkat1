#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <vga.h>
#include <misc.h>
#include <matrix.h>

short vga_getline(unsigned int color, char *str, unsigned short *len) {
  unsigned short i=0;
  unsigned char c;
  unsigned char buf[1];
  unsigned char c233 = vga_color233(color);

  while (i < *len-1) {
    read(0, buf, 1);
    c = buf[0];
    if (c >= ' ' && c <= '~') {
      vga_putchar(c233,c);
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
      vga_putchar(c233,c);
      i--;
    }
  }
  str[i+1] = '\0';
  return i;
}       

void main(void) {
  int i;
  unsigned short size = 11;
  unsigned char buf[11];

  vga_text_clear();
  vga_set_mode(VGA_MODE_BLINK);
  vga_print(VGA_TEXT_RED2, "BexOS v0.1\nCopyright 2016 Matt Stock\n");
  while (1) {
    vga_print(VGA_TEXT_WHITE, "> ");
    i = vga_getline(VGA_TEXT_RED1|VGA_TEXT_GREEN4, buf, &size);
    vga_print(VGA_TEXT_RED2, "\ngot: ");
    vga_print(VGA_TEXT_RED2, buf);
    vga_print(VGA_TEXT_WHITE, "\n");
  }

  while (1);
}
