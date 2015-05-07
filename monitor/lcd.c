#include "lcd.h"
#include "misc.h"
#include "matrix.h"
#include "serial.h"

void main(void) {
  char a;

  lcd_init();
  while (1) {
    matrix_put(0,0,0xff);
    a = serial_getchar(0);
    serial_putchar(0,a);
    lcd_cursor(1);
    lcd_pos(4,1);
    lcd_print("testing");
  }
}
