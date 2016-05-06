#ifndef MANDELBROT_H
#define MANDELBROT_H

extern volatile float * const mand_x0;
extern volatile float * const mand_y0;
extern volatile unsigned int * const mand_x0i;
extern volatile unsigned int * const mand_y0i;
extern volatile unsigned int * const mand_loop;
extern volatile unsigned int * const mand_control;

#define MAND_X0   (*mand_x0)
#define MAND_Y0   (*mand_y0)
#define MAND_X0I  (*mand_x0i)
#define MAND_Y0I  (*mand_y0i)
#define MAND_LOOP (*mand_loop)
#define MAND_CONTROL (*mand_control)

#define MAND_PUSH 1
#define MAND_POP  0

#endif
