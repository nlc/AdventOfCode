#include <stdio.h>

typedef struct Instruction {
  char movement;
  int argument;
} Instruction;

typedef struct Mover {
  int x, y;
  int heading;
} Mover;


int Mover_init(Mover *mover) {
  mover->x = 0;
  mover->y = 0;
  mover->heading = 90;

  return 1;
}

int Mover_move(Mover *mover, Instruction *instruction) {
  int movement = instruction->movement;
  int argument = instruction->argument;

  switch(movement) {
    case 'N' :
      mover->y += argument;
      break;
    case 'S' :
      mover->y -= argument;
      break;
    case 'E' :
      mover->x += argument;
      break;
    case 'W' :
      mover->x -= argument;
      break;
    case 'L' :
      mover->heading = (mover->heading + 360 - argument) % 360;
      break;
    case 'R' :
      mover->heading = (mover->heading + argument) % 360;
      break;
    case 'F' :
      switch(mover->heading) {
        case 0 :
          mover->y += argument;
          break;
        case 90 :
          mover->x += argument;
          break;
        case 180 :
          mover->y -= argument;
          break;
        case 270 :
          mover->x -= argument;
          break;
        default :
          fprintf(stderr, "Bad heading \"%d\"\n", mover->heading);
          return 0;
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
