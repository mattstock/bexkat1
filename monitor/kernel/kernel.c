#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <vga.h>
#include <vectors.h>
#include <misc.h>
#include <matrix.h>
#include <timers.h>

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
      vga_putchar(vga_color233(VGA_TEXT_WHITE),c);
      i--;
    }
  }
  str[i+1] = '\0';
  return i;
}

INTERRUPT_HANDLER(illegal_opcode)
static void illegal_opcode(void) {
  vga_print(VGA_TEXT_RED2, "ILLEGAL OPCODE!\n");
  asm("halt");
}

INTERRUPT_HANDLER(page_fault)
static void page_fault(void) {
  vga_print(VGA_TEXT_RED2, "PAGE FAULT!\n");
  asm("halt");
}

void main(void) {
  int i;
  unsigned short size = 40;
  unsigned char buf[40];

  cli();
  timers[1] = 0x00; // clear any outstanding timer interrupt
  timers[0] = 0x00; // disable timers and interrupt
  set_interrupt_handler(intr_illop, illegal_opcode);
  set_interrupt_handler(intr_mmu, page_fault);
  sti();
  vga_text_clear();
  vga_set_mode(VGA_MODE_BLINK);
  vga_print(VGA_TEXT_RED2, "BexOS v0.1\nCopyright 2016 Matt Stock\n");
  while (1) {
    vga_print(VGA_TEXT_WHITE, "> ");
    i = vga_getline(VGA_TEXT_RED1|VGA_TEXT_GREEN4, buf, &size);
    vga_print(VGA_TEXT_RED2, "\ngot: ");
    vga_print(VGA_TEXT_GREEN6, buf);
    vga_print(VGA_TEXT_WHITE, "\n");
    if (buf[0] == 'u') {
      asm("push %0\n");
      asm("push %1\n");
      asm("mov.l %0, %sp\n"); // this isn't normal, but we need to map SSP -> SP
      asm("ldiu %1, 0\n");
      asm("movsr %1\n");
      asm("mov.l %sp, %0\n");
      asm("pop %1\n");
      asm("pop %0\n");
    }
    if (buf[0] == 'i') {
      asm("reset");
    }
  }

  while (1);
}
