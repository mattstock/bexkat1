#ifndef _MATRIX_H
#define _MATRIX_H

extern unsigned *matrix;

extern void matrix_init(void);
extern void matrix_put(unsigned x, unsigned y, unsigned val);
extern void matrix_bitprint(unsigned row, unsigned val);

#endif
