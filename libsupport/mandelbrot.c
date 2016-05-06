#include "mandelbrot.h"

volatile float * const mand_x0 =  (float *)0xd0000000;
volatile float * const mand_y0 =  (float *)0xd0000004;
volatile unsigned int * const mand_x0i =  (unsigned int *)0xd0000008;
volatile unsigned int * const mand_y0i =  (unsigned int *)0xd000000c;
volatile unsigned int * const mand_loop =  (unsigned int *)0xd0000010;
volatile unsigned int * const mand_control = (unsigned int *)0xd000001c;
