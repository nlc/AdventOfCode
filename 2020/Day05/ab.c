#include <stdio.h>
#include <stdlib.h>

#define BUFLEN 16
#define ARRLEN 1024

typedef struct Seat {
  int row;
  int column;
  int seatID;
  int data;
} Seat;

void Seat_init(Seat *seat, const char *init_string) {
  int i;
  seat->row = seat->column = seat->seatID = seat->data = 0;
  for(i = 0; i < 7; i++) {
    seat->row |= (init_string[i] == 'B') << (6 - i);
    seat->data |= (init_string[i] == 'B') << (6 - i);
  }
  for(i = 0; i < 3; i++) {
    seat->column |= (init_string[i + 7] == 'R') << (2 - i);
    seat->data |= (init_string[i + 7] == 'R') << (9 - i);
  }
  /* multiply the row by 8, then add the column */
  seat->seatID = (seat->row << 3) + seat->column;
}

void Seat_print(Seat *seat) {
  printf("%d\nID    % 4d\nROW   % 4d\nCOLUMN% 4d\n",
         seat->data,
         seat->seatID,
         seat->row,
         seat->column);
}

int Seat_ordering(const void *ptr_a, const void *ptr_b) {
  Seat *seat_a = (Seat *)ptr_a;
  Seat *seat_b = (Seat *)ptr_b;

  return seat_a->data - seat_b->data;
}

Seat Seat_from_row_column(int row, int col) {
  Seat seat;
  seat.row = row;
  seat.column = col;
  seat.seatID = (seat.row << 3) + seat.column;

  return seat;
}

void sort_seats(Seat *seats, int num_seats) {
  qsort((void *)seats, num_seats, sizeof(Seat), Seat_ordering);
}


int main(int argc, char **argv) {
  char buf[BUFLEN];
  Seat seats[ARRLEN];
  int num_seats = 0;
  int i;

  if(argc < 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    return 1;
  }

  char *fname = argv[1];

  FILE *file = fopen(fname, "r");

  int max_id = 0;
  printf("\033[2J");
  while(fgets(buf, BUFLEN, file)) {
    Seat_init(seats + num_seats, buf);
    if(seats[num_seats].seatID > max_id) {
      max_id = seats[num_seats].seatID;
    }

    printf("\033[%d;%dH@", seats[num_seats].column + 1, seats[num_seats].row + 1 + 12);

    num_seats++;
  }

  sort_seats(seats, num_seats);

  Seat missing;
  for(i = 0; i < num_seats; i++) {
    if((i > 1 && seats[i].data - seats[i - 1].data > 1) && (seats[i].column == seats[i - 1].column)) {
      missing = Seat_from_row_column(seats[i].row - 1, seats[i].column);
    }
  }

  printf("\033[%d;%dH\033[31;5m*\033[0m", missing.column + 1, missing.row + 1 + 12);
  printf("\033[0;0H");

  printf("\nMax. ID = %d\n", max_id);
  printf("\nMissing seat:\n");
  Seat_print(&missing);
  printf("\n");

  return 0;
}
