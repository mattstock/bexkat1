#include "keyboard.h"

volatile unsigned int * const keyboard = (unsigned int *)PS2_BASE;

// ps2 scan codes to ASCII.  Since the elements I want aren't
// contiguous, this list is bigger than it needs to be, but I'm aiming for
// simplicity.
static const unsigned char remap[] =
  { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x60, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 'q' , '1' , 0x00,
    0x00, 0x00, 'z' , 's' , 'a' , 'd' , '2' , 0x00,
    0x00, 'c' , 'x' , 'd' , 'e' , '4' , '3' , 0x00,
    0x00, ' ' , 'v' , 'f' , 't' , 'r' , '5' , 0x00,
    0x00, 'n' , 'b' , 'h' , 'g' , 'y' , '6' , 0x00,
    0x00, 0x00, 'm' , 'j' , 'u' , '7' , '8' , 0x00,
    0x00, 0x00, 'k' , 'i' , 'o' , '0' , '9' , 0x00,
    0x00, 0x00, 0x00, 'l' , 0x00, 'p' , '-' , 0x00 };

static const unsigned char numcap[] = ")!@#$%^&*(";

unsigned int keyboard_count(void) {
  return keyboard[KEYBOARD_SIZE];
}

unsigned int keyboard_getevent(void) {
  return keyboard[KEYBOARD_VALUE];
}

// blocks waiting for a single character.  We need to ignore key release
// and any characters that are invalid ASCII, as well as map the
// scan codes to ASCII to return.  The tricky stuff is the modal states,
// like control and shift.  For that we need to track and preserve those
// values and translate the result.
unsigned char keyboard_getchar(void) {
  static unsigned char state = 0;
  unsigned int val;
  unsigned char result;
  
  while (1) {
    while (keyboard_count() == 0); // block for key
    val = keyboard_getevent();
    if ((0x200 & val) == 0x200) { // a release, see if we care
      switch (val) {
      case 0x212: // shift bit 1
	state &= 0b11111110;
	break;
      case 0x214: // ctrl bit 2
	state &= 0b11111101;
	break;
      case 0x211: // alt bit 3
	state &= 0b11111011;
      }
    } else { // press of some kind
      switch (val) {
      case 0x12: // shift
	state |= 0b1;
	break;
      case 0x14: // ctrl
	state |= 0b10;
	break;
      case 0x11: // alt
	state |= 0b100;
	break;
      case 0x58: // caps lock toggles
	if (state & 0x1)
	  state &= 0b11111110;
	else
	  state |= 0b1;
	break;
      case 0x5a: // enter
	return '\n';
      case 0x66: // bs
	return 0x08;
      case 0x171: // del
	return 0x7f;
      }
      // figure out what we can output
      
      if (val < 80 && val != 0) {
	result = remap[val];
	if (result != 0) {
	  if (state & 0x1) { // need to shift stuff
	    if (result >= '0' && result <= '9')
	      return numcap[result-'0'];
	    return result-'a'+'A';
	  }
	  return result;
	}
      }
    }
  }
  return 0;
}
