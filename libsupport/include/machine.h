#ifndef MACHINE_H
#define MACHINE_H

// Define the memory map so that if we want to make changes we can make
// them in one place.  Note that changing this would also require changes
// in the FPGA logic.

#define RAM_BASE    (0x00000000)
#define IO_BASE     (0x30000000)
#define SEGSW_BASE  (IO_BASE)
#define UART0_BASE  (IO_BASE+0x2000)
#define PS2_BASE    (IO_BASE+0x4000)
#define SPI_BASE    (IO_BASE+0x7000)
#define TIMER_BASE  (IO_BASE+0x8000)
#define MATRIX_BASE (IO_BASE+0xc000)

#define ROM_BASE    (0x70000000)
#define VECTOR_BASE (0xf0000000)

// None of these are functional right now.
// Saved so that we can build the support library.
//#define SWLED_BASE  (IO_BASE+0x1000)
#define UART1_BASE  (IO_BASE+0x3000)
#define CODEC_BASE  (IO_BASE+0x5000)
#define LCD_BASE    (IO_BASE+0x6000)
#define I2C0_BASE   (IO_BASE+0x9000)
#define I2C1_BASE   (IO_BASE+0xa000)
#define I2C2_BASE   (IO_BASE+0xb000)
#define IRDA_BASE   (IO_BASE+0xd000)
#define UART2_BASE  (IO_BASE+0xe000)

#define CACHE_BASE  (0x40000000)
#define VGA_CF_BASE (0x80000000)
#define VGA_FB_BASE (0xc0000000)
#define MANDEL_BASE (0xd0000000)

#endif
