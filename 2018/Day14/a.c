#include <stdio.h>
#include <stdint.h>

#define INPUT 864801
#define MAX_CAP INPUT + 10

/* assume num has at most 2 digits */
uint8_t digits(uint8_t dgs[2], uint8_t num) {
  if(num < 10) {
    dgs[0] = num;
    return 1;
  } else {
    dgs[0] = num / 10;
    dgs[1] = num % 10;
    return 2;
  } /* note: if this isn't performant enough, try using the fact that it's actually <19 */
}

int main(void) {
  uint8_t board[MAX_CAP];
  int cap = 2;

  int i1 = 0, i2 = 1;
  uint8_t e1, e2;
  uint8_t dholder[2];

  board[i1] = 3;
  board[i2] = 7;

  while(cap <= MAX_CAP) {
    e1 = board[i1];
    e2 = board[i2];

    uint8_t sum = e1 + e2;

    uint8_t ndgs = digits((board + cap), sum);
    cap += (int)ndgs;

    i1 = (i1 + e1 + 1) % cap;
    i2 = (i2 + e2 + 1) % cap;
  }

  /* for(int i = 0; i < MAX_CAP; ++i) {
    printf("b[%d] = %u\n", i, board[i]);
  }*/

  for(int i = 0; i < 10; ++i) {
    printf("%u", board[INPUT + i]);
  }
  printf("\n");

  return 0;
}
