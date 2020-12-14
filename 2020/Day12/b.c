#include <stdio.h>

typedef struct Instruction {
  char movement;
  int argument;
} Instruction;

typedef struct Mover {
  int x, y;
  int wx, wy;
} Mover;


int Mover_init(Mover *mover) {
  mover->x = 0;
  mover->y = 0;
  mover->wx = 10;
  mover->wy = 1;

  return 1;
}

int Mover_move(Mover *mover, Instruction *instruction) {
  int movement = instruction->movement;
  int argument = instruction->argument;

  int i, temp;

  switch(movement) {
    case 'N' :
      mover->wy += argument;
      break;
    case 'S' :
      mover->wy -= argument;
      break;
    case 'E' :
      mover->wx += argument;
      break;
    case 'W' :
      mover->wx -= argument;
      break;
    case 'L' :
    case 'R' :
      if((movement == 'L' && argument == 90) || (movement == 'R' && argument == 270)) {
        temp = mover->wx;
        mover->wx = -mover->wy; /* simple rotation matrix */
        mover->wy = temp;
      } else if((movement == 'L' && argument == 270) || (movement == 'R' && argument == 90)) {
        temp = mover->wx;
        mover->wx = mover->wy; /* simple rotation matrix */
        mover->wy = -temp;
      } else if(argument == 180) {
        mover->wx = -mover->wx;
        mover->wy = -mover->wy;
      } else {
        fprintf(stderr, "Bad turn command \"%c%d\"\n", movement, argument);
        return 0;
      }
      break;
    case 'F' :
      for(i = 0; i < argument; ++i) {
        mover->x += mover->wx;
        mover->y += mover->wy;
      }
      break;
    default :
      fprintf(stderr, "Bad movement \"%c\"\n", movement);
      return 0;
  }

  return 1;
}

int abs(const int x) {
  return (x < 0 ? -x : x);
}


int main(int argc, char **argv) {
  char *fname;
  FILE *file;
  char movement;
  int argument;
  int num_instructions = 0;
  int i;
  Instruction instructions[1024];
  Mover mover;

  if(argc < 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    return 1;
  }

  fname = argv[1];
  file = fopen(fname, "r");
  while(fscanf(file, "%c%d\n", &movement, &argument) != EOF) {
    instructions[num_instructions].movement = movement;
    instructions[num_instructions].argument = argument;

    ++num_instructions;
  }
  fclose(file);

  Mover_init(&mover);

  for(i = 0; i < num_instructions; ++i) {
    Mover_move(&mover, (instructions + i));
  }

  printf("<%d, %d> --> %d\n", mover.x, mover.y, abs(mover.x) + abs(mover.y));

  return 0;
}
