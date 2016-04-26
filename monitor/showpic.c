#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <unistd.h>
#include <errno.h>
#include <vga.h>
#include <matrix.h>
#include <serial.h>

uint16_t swap_uint16(uint16_t val) {
  return (val << 8) | (val >> 8);
}

uint32_t swap_uint32(uint32_t val) {
  val = ((val << 8) & 0xff00ff00) | ((val >> 8) & 0xff00ff);
  return (val << 16) | (val >> 16);
}

uint16_t read_uint16(int fd) {
  uint16_t x;
  read(fd, &x, 2);
  return swap_uint16(x);
}

uint32_t read_uint32(int fd) {
  uint32_t x;
  read(fd, &x, 4);
  return swap_uint32(x);
}

struct colormap {
  uint32_t color;
  uint32_t count;
  struct colormap *prev;
  struct colormap *next;
};

uint8_t *buffer;

struct colormap *make_histogram(uint32_t width, uint32_t height) {
  struct colormap *top, *node;
  int x, y;

  top = NULL;
  // build a sorted histogram
  for (y=0; y < height; y++) {
    iprintf("histogram %u\n", y);
    for (x=0; x < width; x++) {
      int subpixel = y*(width << 2) + (x << 2);
      uint32_t color = (buffer[subpixel+2] << 16) |
	(buffer[subpixel+1] << 8) | buffer[subpixel];
      if (top == NULL) {
	top =
	  (struct colormap *)malloc(sizeof(struct colormap));
	top->color = color;
	top->count = 1;
	top->prev = NULL;
	top->next = NULL;
      } else {
	node = top;
	while (node != NULL) {
	  if (node->color == color) {
	    node->count++;
	    struct colormap *parent = node->prev;
	    while (parent != NULL && parent->count < node->count) {
	      parent->next = node->next;
	      node->prev = parent->prev;
	      parent->prev = node;
	      node->next = parent;
	      if (node->prev != NULL)
		node->prev->next = node;
	      if (parent->next != NULL)
		parent->next->prev = parent;
	      if (parent == top)
		top = node;
	      // Now, keep sorting if we need to
	      parent = node->prev;
	    } 
	    break;
	  }
	  if (node->next == NULL) {
	    struct colormap *n =
	      (struct colormap *)malloc(sizeof(struct colormap));
	    n->color = color;
	    n->count = 1;
	    n->prev = node;
	    n->next = NULL;
	    node->next = n;
	    break;
	  }
	  node = node->next;
	}
      }
      // a verification step.
#if 0
      node = top;
      while (node != NULL && node->next != NULL) {
	if (node->count < node->next->count) {
	  iprintf("sort fail, dumping:\n");
	  while (top != NULL) {
	    iprintf("%04x: %u\n", top->color, top->count);
	    top = top->next;
	  }
	  while (1);
	}
	node = node->next;
      }
#endif
    }
  }
  return top;
}

void main(void) {
  int x,y,idx;
  unsigned zx = 50;
  unsigned zy = 460;
    
  struct colormap *l, *cm;
  struct h {
    uint32_t size;
    uint32_t offset;
  } header;
  struct bch {
    uint32_t size;
    uint32_t width;
    uint32_t height;
    uint16_t planes;
    uint16_t bpp;
    uint32_t compress;
    uint32_t image_size;
    uint32_t colors;
  } bmpcore;
  int fh;
  uint8_t buf[14];
  
  // load image
  fh = open("/foo.bmp", O_RDONLY);
  if (fh != -1) {
    read_uint16(fh);
    header.size = read_uint32(fh);
    read_uint32(fh);
    header.offset = read_uint32(fh);
    iprintf("pixel offset = %4x\n", header.offset);
    bmpcore.size = read_uint32(fh);
    iprintf("DIB size = %u\n", bmpcore.size);
    bmpcore.width = read_uint32(fh);
    bmpcore.height = read_uint32(fh);
    iprintf("(%u, %u)\n", bmpcore.width, bmpcore.height);
    bmpcore.planes = read_uint16(fh);
    bmpcore.bpp = read_uint16(fh);
    bmpcore.compress = read_uint32(fh);
    bmpcore.image_size = read_uint32(fh);
    read_uint32(fh);
    read_uint32(fh);
    bmpcore.colors = read_uint32(fh);
    iprintf("colors = %u\n", bmpcore.colors);

    vga_set_mode(0);

    // load the full image into a buffer initially to build the histogram
    // and colormap.
    buffer = (uint8_t *)malloc(4*bmpcore.width*bmpcore.height);

    // load the image
    lseek(fh, header.offset, SEEK_SET);
    uint8_t *sl = buffer;
    for (y=0; y < bmpcore.height; y++) {
      read(fh, sl, bmpcore.width*4);
      sl += bmpcore.width*4;
    }
    close(fh);

    // check for histogram file
    fh = open("/foo.hst", O_RDONLY);
    if (fh != -1) {
      iprintf("loading histogram\n");
      cm = NULL;
      struct colormap *parent = NULL;
      while (1) {
	l = (struct colormap *)malloc(sizeof(struct colormap));
	if (read(fh, &(l->color), 4) == 0)
	  break;
	read(fh, &(l->count), 4);
	l->prev = parent;
	l->next = NULL;
	if (parent == NULL)
	  cm = l;
	else
	  parent->next = l;
	parent = l;
      }
      close(fh);
    } else {
      iprintf("building histogram\n");
      cm = make_histogram(bmpcore.width, bmpcore.height);
      iprintf("histogram complete, writing to disk\n");
      fh = open("/foo.hst", O_CREAT|O_WRONLY);
      l = cm;
      while (l != NULL) {
	write(fh, &(l->color), 4);
	write(fh, &(l->count), 4);
	l = l->next;
      }
      close(fh);
    }

    // Load palette based on order of histogram
    idx = 0;
    l = cm;
    iprintf("loading palette\n");
    while (l != NULL) {
      vga_palette(0, idx++, l->color);
      l = l->next;
    }

    iprintf("displaying image\n");
    for (y=0; y < bmpcore.height; y++)
      for (x=0; x < bmpcore.width; x++) {
	int subpixel = y*(bmpcore.width << 2) + (x << 2);
	uint32_t color = (buffer[subpixel+2] << 16) |
	  (buffer[subpixel+1] << 8) | buffer[subpixel];
	matrix_put(x-zx,bmpcore.height-y-1-zy, color);
	idx = 0;
	l = cm;
	while (l != NULL) {
	  if (l->color == color)
	    break;
	  l = l->next;
	  idx++;
	}
	if ((x == zx && x == (zx+32) && y >= zy && y <= zy+16) ||
	    (y == zy && y == (zy+16) && x >= zx && x <= zx+32))
	  vga_point(x,bmpcore.height-y-1, 0);
	else
	  vga_point(x,bmpcore.height-y-1, idx);
      }
  }
  iprintf("done\n");
  
  while (1) {
    char a = serial_getchar(0);
    switch (a) {
    case 'a':
      zx--;
      break;
    case 'd':
      zx++;
      break;
    case 'w':
      zy--;
      break;
    case 's':
      zy++;
      break;
    }
    
    iprintf("(%u, %u)\n", zx, zy);
    for (x=0; x < 32; x++)
      for (y=0; y < 16; y++) {
	int subpixel = (bmpcore.height-1-(zy+y))*(bmpcore.width << 2) + ((zx+x) << 2);
	uint32_t color = (buffer[subpixel+2] << 16) |
	  (buffer[subpixel+1] << 8) | buffer[subpixel];
	matrix_put(x,y,color);
      }
  }
}
