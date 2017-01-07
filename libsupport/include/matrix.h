#ifndef _MATRIX_H
#define _MATRIX_H

#include <machine.h>

extern volatile unsigned * const matrix;

extern void matrix_init(void);
extern void matrix_line(unsigned x0, unsigned y0, unsigned x1, unsigned y1, unsigned val);
extern void matrix_circle(unsigned x0, unsigned y0, unsigned r, unsigned val);

extern void matrix_put(unsigned x, unsigned y, unsigned val);
extern void matrix_bitprint(unsigned row, unsigned val);

#endif
