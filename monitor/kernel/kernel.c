#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <vga.h>
#include <vectors.h>
#include <misc.h>
#include <matrix.h>
#include <serial.h>
#include <timers.h>
#include <elf32.h>
#include <ff.h>

extern void disk_timerproc (void);
extern void init_vectors();

#define PROC_EMPTY 0
#define PROC_RUNNING 1
#define PROC_DEAD 2

struct proc {
  unsigned short parent;
  unsigned char state;
  void *base;
};

#define MAX_PROC 10
struct proc proctable[MAX_PROC];
unsigned int proc_running;

unsigned int do_fork() {
  int newp = 0;
  for (int i=1; i < MAX_PROC; i++)
    if (proctable[i].state == 0) {
      newp = i;
      break;
    }
  if (newp == 0)
    return 0;
  proctable[newp].parent = proc_running;
  proctable[newp].base = NULL;
  proctable[newp].state = PROC_RUNNING;
  return newp;
}

void do_exec(int pid, char *name) {
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
    serial_print(0, "file error\n");
    return;
  }

  foo = f_read(&fp, &header, sizeof(elf32_hdr), &count);
  if (foo != FR_OK) {
    serial_print(0, "read error\n");
  }
  if (count != sizeof(elf32_hdr)) {
    serial_print(0, "partial read of header!\n");
  }
  // iterate over program headers and do copies
  for (hidx=0; hidx < header.e_phnum; hidx++) {
    foo = f_lseek(&fp, header.e_phoff+hidx*header.e_phentsize);
    if (foo != FR_OK) {
      serial_print(0, "seek error\n");
    }
    foo = f_read(&fp, &prog_header, sizeof(elf32_phdr), &count);
    if (foo != FR_OK) {
      serial_print(0, "read error\n");
    }
    if (count != sizeof(elf32_phdr)) {
      serial_print(0, "partial read of program header!\n");
    }
    foo = f_lseek(&fp, prog_header.p_offset);
    if (foo != FR_OK) {
      serial_print(0, "seek error\n");
    }

    segidx = prog_header.p_filesz;
    memidx = prog_header.p_paddr;
    serial_printf(0, "segment address %08x : size %d\n", segidx, memidx);
    memidx += 0x02000000;
    
    while (segidx > 1024) {
      foo = f_read(&fp, &buffer, 1024, &count);
      if (foo != FR_OK) {
	serial_print(0, "read error\n");
      }
      if (count != 1024)
	serial_print(0, "partial read of 1k block?!\n");
      memcpy((unsigned int *)memidx, &buffer , 1024);
      segidx -= 1024;
      memidx += 1024;
    }
    foo = f_read(&fp, &buffer, segidx, &count);
    if (foo != FR_OK) {
      serial_print(0, "read error\n");
    }
    if (count != segidx) {
      serial_print(0, "partial read of segidx block?!\n");
    }
    memcpy((unsigned int *)memidx, &buffer , segidx);
  }
  // Cleanly unmount sdcard
  f_close(&fp);
  f_mount((void *)0, "", 0);
  /*
  execptr = (void *)(header.e_entry+0x02000000);
  asm("ldiu %1, 0\n");
  asm("movsr %1\n");
  asm("ldi %sp, 0x07000000\n");
  (*execptr)(); */
}

void sdcard_ls() {
  FATFS f;
  FRESULT foo;
  FILINFO fno;
  DIR dp;
  char *fn;
  if (f_mount(&f, "", 1) != FR_OK) return;
  if (f_opendir(&dp, "/") != FR_OK) {
    vga_printf(VGA_TEXT_RED, "opendir failed\n");
    return;
  }
  for (;;) {
    foo = f_readdir(&dp, &fno);
    if (foo != FR_OK || fno.fname[0] == 0) break;
    if (fno.fname[0] == '.') continue;
    fn = fno.fname;
    if (fno.fattrib & AM_DIR)
      vga_printf(VGA_TEXT_BLUE, "  /%s\n", fn);
    else
      vga_printf(VGA_TEXT_BLUE, "  %s\n", fn);
  }
  f_closedir(&dp);
  f_mount((void *)0, "", 0);
}

INTERRUPT_HANDLER(illegal_opcode)
static void illegal_opcode(void) {
  vga_print(VGA_TEXT_RED, "ILLEGAL OPCODE!\n");
  asm("halt");
}

INTERRUPT_HANDLER(timer3)
static void timer3(void) {
  disk_timerproc();
  timers[1] = 0x8; // clear the interrupt
  timers[7] += 1000000; // reset timer3 interval
}

INTERRUPT_HANDLER(page_fault)
static void page_fault(void) {
  vga_print(VGA_TEXT_RED2, "PAGE FAULT!\n");
  asm("halt");
}

EXCEPTION_HANDLER(trap0)
static int trap0(void) {
  unsigned int callnum;
  void *args;

  // this is very fragile - changes to the stack in syscall()
  // will change the offsets here - a better way?
  asm ("ld.l %%0, (%%fp)\n"
    "ld.l %0, 12(%%0)\n"
    : "=r" (callnum)
    :
    : "%0");
  asm ("ld.l %0, 16(%%0)\n"
    : "=r" (args));

  switch (callnum) {
  case 1:
    return do_fork();
    break;
  case 2:
    do_exec(do_fork(), (char *)args);
    return -1;
    break;
  default:
    serial_printf(0, "invalid syscall %d\n", callnum);
    return -1;
  }
}

int syscall(int cid, void *message) {
  register int ret asm("%12");
  asm("trap 0\n");
  return ret;
}

void main(void) {
  int i, ret;
  unsigned short size = 40;
  unsigned char buf[40];

  for (i=1; i < MAX_PROC; i++)
    proctable[i].state = PROC_EMPTY;
  proc_running = 0;
  proctable[0].parent = 0;
  proctable[0].state = PROC_RUNNING;
  proctable[0].base = 0;
  
  init_vectors();
  cli();
  set_interrupt_handler(intr_illop, illegal_opcode);
  set_interrupt_handler(intr_mmu, page_fault);
  set_exception_handler(intr_trap0, trap0);
  // for filesystem code
  timers[7] = timers[12] + 1000000; // 100Hz
  set_interrupt_handler(intr_timer3, timer3);
  timers[0] |= 0x88; // enable timer and interrupt
  sti();
  vga_text_clear();
  vga_set_mode(VGA_MODE_BLINK);
  vga_print(VGA_TEXT_RED2, "BexOS v0.2\nCopyright 2016 Matt Stock\n");
  while (1) {
    vga_print(VGA_TEXT_WHITE, "> ");
    i = vga_getline(VGA_TEXT_RED1|VGA_TEXT_GREEN4, buf, &size);
    vga_print(VGA_TEXT_WHITE, "\n");
    if (buf[0] == 'i') {
      asm("reset");
    }
    if (buf[0] == 'f') {
      //      ret = syscall(1, ""); // we'll call this fork()
      //      if (ret == 0) { // child
      //	serial_printf(0, "child here, going to try exec()\n");
      syscall(2, "/pretty");
      //  } else { // parent
      //	vga_printf(VGA_TEXT_GREEN, "fork() returned %d\n", ret);
      // }
    }
    if (buf[0] == 'l') {
      sdcard_ls();
    }
  }

  while (1);
}
