#ifndef _MISC_H
#define _MISC_H

// misc functions
extern void delay(unsigned int limit);
extern unsigned char random(unsigned int);

// conversion stuff
extern char nibble2hex(char n);
extern char *byte2hex(char b);
extern char *short2hex(short s);
extern char *int2hex(int v);
extern int hextoi(char s);
extern char *itos(unsigned int val, char *s);

#endif
