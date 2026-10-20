#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#define BASE_CAP 2 << 12
#define MAX_CAP 2 << 25

/* assume num has at most 2 digits */
uint8_t digits(uint8_t dgs[2], uint8_t num) {
  if(num < 10) {
    dgs[0] = num;
    return 1;
  } else {
    dgs[0] = 1;
    dgs[1] = num - 10;
    return 2;
  }
}

int main(void) {
  int capacity = BASE_CAP;
  uint8_t *board = malloc(capacity * sizeof(uint8_t));
  int board_size = 2;

  int i1 = 0, i2 = 1;
  uint8_t e1, e2;
  uint8_t dholder[2];

  board[i1] = 3;
  board[i2] = 7;

  uint8_t ansbuf[6] = {8, 6, 4, 8, 0, 1};
  int anslen = 6;
  int ansidx = 0;

  while(1) {
    e1 = board[i1];
    e2 = board[i2];

    uint8_t sum = e1 + e2;

    uint8_t ndgs = digits((board + board_size), sum);
    board_size += (int)ndgs;

    i1 = (i1 + e1 + 1) % board_size;
    i2 = (i2 + e2 + 1) % board_size;


    if(board_size > capacity - 3) {
      if(capacity >= MAX_CAP) {
        printf("Hit max capacity at %d\n", MAX_CAP);
        break;
      }

      for(int i = (capacity == BASE_CAP ? 0 : board_size / 2); i < board_size; ++i) { /* bad, redoes work */
        if(board[i] == ansbuf[ansidx]) {
          if(ansidx == anslen - 1) {
            printf("%d\n", i - anslen + 1);
            return 0;
          }
          ++ansidx;
        } else {
          ansidx = 0;
        }
      }

      board = realloc(board, capacity *= 2);
    }
  }

  printf("Not found\n");

  free(board);

  return 0;
}
