#ifndef _LCD_H
#define _LCD_H

extern unsigned int *lcd;

extern void lcd_init(void);
extern void lcd_clear(void);
extern void lcd_home(void);
extern void lcd_cursor(int on);
extern void lcd_pos(int x, int y);
extern void lcd_print(char *str);

#endif
