#include "matrix.h"
#include "misc.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define BLUE 0xff0000
#define GREEN 0xff00
#define RED 0xff
#define BLACK 0x00

#define ROCKS 7

unsigned ship[15] = { BLACK, BLACK, BLUE, BLACK, BLACK,
		      BLACK, BLUE, BLUE, BLUE, BLACK,
		      BLUE, BLUE, BLUE, BLUE, BLUE };
  
unsigned rocka[15] = { BLACK, BLACK, RED, BLACK, BLACK,
		       BLACK, RED, GREEN, RED, BLACK,
		       BLACK, BLACK, RED, BLACK, BLACK };

unsigned rockb[15] = { BLACK, RED, BLACK, RED, BLACK,
		       BLACK, BLACK, GREEN, BLACK, BLACK,
		       BLACK, RED, BLACK, RED, BLACK };

struct coord {
  unsigned speed; // how many loop iterations between each row move
  unsigned tick; // countdown to next move
  int x;
  int y;
};

// draw the ship along the bottom row at the x position listed
void draw_ship(unsigned p) {
  // the ship is 5 wide, and so we add an extra band of black on each side
  // to clear any old state
  unsigned i = 0;
  
  for (unsigned y=13; y < 16; y++) {
    for (unsigned x=0; x < 7; x++) {
      if (x==0 || x==6) {
	matrix_put(p+x-3,y,BLACK);
	continue;
      }
      matrix_put(p+x-3,y,ship[i]);
      i++;
    }
  }
}

// this does three things.  it needs to clear the position above.
// if the new position is below the screen, we clear the whole thing,
// otherwise we draw the rock
void draw_rock(unsigned a, unsigned b) {
  unsigned i=0;
  
  for (unsigned y=0; y < 3; y++)
    for (unsigned x=0; x < 5; x++)
      matrix_put(x+a-3, y+b-2, BLACK);
  if (b==16)
    return;
  for (unsigned y=0; y < 3; y++)
    for (unsigned x=0; x < 5; x++) {
      if (b%2 == 0)
	matrix_put(x+a-3, y+b-1, rocka[i]);
      else 
	matrix_put(x+a-3, y+b-1, rockb[i]);
      i++;
    }
}

void main(void) {
  unsigned pos;
  unsigned score;
  struct coord rock[ROCKS];
  char c;

  srandom(time(0));
  
  for (int i=0; i < ROCKS; i++) {
    rock[i].speed = 0;
    rock[i].tick = 0;
    rock[i].x = 0;
    rock[i].y = 0;
  }

  score = 0;
  pos = 15;
  matrix_init();

  draw_ship(pos);
  while (1) {

    // ship movement
#if 0
    if (read(0, &c, 1) > 0) {
      if (c == 'a' && pos > 2) {
	pos--;
	draw_ship(pos);
      }
      if (c == 'd' && pos < 29) {
	pos ++;
	draw_ship(pos);
      }
    }
#endif
    
    // create a rock 10% of the time
    if ((random()%100) < 30) {
      for (int i=0; i < ROCKS; i++) {
	if (rock[i].speed == 0) {
	  iprintf("spawning rock %d\n", i);
	  rock[i].speed = 50 + random()%100;
	  rock[i].tick = rock[i].speed;
	  rock[i].x = random()%32;
	  rock[i].y = -1;
	  break;
	}
      }
    }

    // move the rocks 
    for (int i=0; i < ROCKS; i++) {
      if (rock[i].speed != 0) {
	rock[i].tick--;
	if (rock[i].tick == 0) {
	  rock[i].y++;
	  rock[i].tick = rock[i].speed;
	  draw_rock(rock[i].x,rock[i].y);
	  if (rock[i].y==16) {
	    rock[i].speed = 0;
	    score++;
	  }
	}
      }
    }
    
    // check for collision
    
    delay(500);
    
  }
}
