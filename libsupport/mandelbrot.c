#include "mandelbrot.h"

volatile float * const mand_x0 =  (float *)(MANDEL_BASE);
volatile float * const mand_y0 =  (float *)(MANDEL_BASE+0x4);
volatile unsigned int * const mand_x0i =  (unsigned int *)(MANDEL_BASE+0x8);
volatile unsigned int * const mand_y0i =  (unsigned int *)(MANDEL_BASE+0xc);
volatile unsigned int * const mand_loop =  (unsigned int *)(MANDEL_BASE+0x10);
volatile unsigned int * const mand_control = (unsigned int *)(MANDEL_BASE+0x1c);
