#include "lcd.h"
#include "misc.h"

unsigned int *lcd = (unsigned int *)0x20000c00;

void lcd_init(void) {
  lcd[32] = 0x1;
  lcd[33] = 0x30;
  delay(5000);
  lcd[33] = 0x30;
  delay(5000);
  lcd[33] = 0x30;
  delay(500);
  lcd[33] = 0x3f;
  delay(500);
  lcd[33] = 0x0c; // no cursor or blink
  delay(500);
  lcd_clear();
  lcd_home();
}

void lcd_clear() {
  lcd[33] = 0x01;
  delay(1000);
}

void lcd_home() {
  lcd[33] = 0x02;
  delay(2000);
}

void lcd_cursor(int on) {
  lcd[33] = (on ? 0x0e : 0x0c);
  delay(500);
}

void lcd_pos(int x, int y) {
  if (x < 0 || y < 0 || x >= 16 || y >= 2)
    return;
  lcd[33] = (y ? 0xc0 : 0x80) | (x & 0x0f);
  delay(500);
}
 
void lcd_print(char *str) {
  while (*str != '\0') {
    lcd[0] = *str;
    str++;
    delay(500);
  }
}
