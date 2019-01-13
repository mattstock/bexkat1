#ifndef VGA_H
#define VGA_H

#include <stdarg.h>
#include <machine.h>
#include <console.h>

#define VGA_P0_BASE  (VGA_CF_BASE)
#define VGA_P1_BASE  (VGA_CF_BASE+0x400)
#define VGA_F0_BASE  (VGA_CF_BASE+0x800)
#define VGA_CTL_BASE (VGA_CF_BASE+0xc00)

#define VGA_TEXT_FONT_X 8
#define VGA_TEXT_FONT_Y 8
#define VGA_MAX_X 640
#define VGA_MAX_Y 480

#define VGA_TEXT_MAX_Y VGA_MAX_Y/VGA_TEXT_FONT_Y
#define VGA_TEXT_MAX_X VGA_MAX_X/VGA_TEXT_FONT_X

#define VGA_MODE_NORMAL 0x00
#define VGA_MODE_DOUBLE 0x01
#define VGA_MODE_TEXT 0x02
#define VGA_MODE_BLINK 0x03
#define VGA_MODE_SOLID 0x04

#define VGA_TEXT_RED1 (0x400000)
#define VGA_TEXT_RED2 (0x800000)
#define VGA_TEXT_RED (0xc00000)
#define VGA_TEXT_WHITE (0xc0e0e0)
#define VGA_TEXT_BLUE1 (0x20)
#define VGA_TEXT_BLUE2 (0x40)
#define VGA_TEXT_BLUE3 (0x60)
#define VGA_TEXT_BLUE4 (0x80)
#define VGA_TEXT_BLUE5 (0xa0)
#define VGA_TEXT_BLUE6 (0xc0)
#define VGA_TEXT_BLUE (0xe0)
#define VGA_TEXT_GREEN1 (0x2000)
#define VGA_TEXT_GREEN2 (0x4000)
#define VGA_TEXT_GREEN3 (0x6000)
#define VGA_TEXT_GREEN4 (0x8000)
#define VGA_TEXT_GREEN5 (0xa000)
#define VGA_TEXT_GREEN6 (0xc000)
#define VGA_TEXT_GREEN (0xe000)

extern volatile unsigned char * const vga_fb;

extern void vga_palette(int pnum, unsigned char idx, unsigned int color);
extern void vga_point(int x, int y, unsigned char val);
extern unsigned int vga_mode(void);
extern void vga_set_mode(unsigned int m);
extern unsigned char vga_color233(unsigned int color);
extern void vga_text_clear();
extern void vga_putchar(unsigned short color233, unsigned char c);
extern void vga_print(unsigned int color, unsigned char *s);
extern void vga_set_cursor(unsigned short x, unsigned short y);
extern void vga_printf(unsigned int color, const char *fmt, ...);
extern void vga_vprintf(unsigned int color, const char *fmt, va_list argp);
extern void vga_scroll(int offset);
extern void vga_printhex(unsigned int color, unsigned int val);

#endif
