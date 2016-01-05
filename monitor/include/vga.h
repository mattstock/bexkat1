#ifndef VGA_H
#define VGA_H

typedef enum {
  VGA_MODE_NORMAL = 0,
  VGA_MODE_DOUBLE,
  VGA_MODE_TEXT
} vga_mode_t;

extern volatile unsigned char *vga_fb;

extern void vga_palette(int pnum, unsigned char idx, unsigned int color);
extern void vga_point(int x, int y, unsigned char val);
extern vga_mode_t vga_mode(void);
extern void vga_set_mode(vga_mode_t m);


#endif
