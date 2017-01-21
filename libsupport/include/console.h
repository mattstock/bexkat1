#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdarg.h>

typedef enum _color {
  CONSOLE_BLACK,
  CONSOLE_RED,
  CONSOLE_GREEN,
  CONSOLE_YELLOW,
  CONSOLE_BLUE,
  CONSOLE_MAGENTA,
  CONSOLE_CYAN,
  CONSOLE_L_GREY,
  CONSOLE_GREY,
  CONSOLE_B_RED,
  CONSOLE_B_GREEN,
  CONSOLE_B_YELLOW,
  CONSOLE_B_BLUE,
  CONSOLE_B_MAGENTA,
  CONSOLE_B_CYAN,
  CONSOLE_WHITE
} console_color_t;

extern const unsigned int console_colormap[];

#define vga_console_color(c) (console_colormap[c])

extern void console_printf(console_color_t color, char *fmt, ...);
extern short console_getline(console_color_t color, char *str, unsigned short *len);

#endif
