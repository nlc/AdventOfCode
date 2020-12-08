#include "./Machine.c"

int main(int argc, char **argv) {
  Machine machine;

  if(argc < 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    return 1;
  }

  if(Machine_init(&machine, argv[1])) {
    fprintf(stderr, "Machine loaded!\n");
  } else {
    fprintf(stderr, "Machine failed to load.\n");
    return 1;
  }

  for(int i = 0; i < 1000000; ++i) {
    int old_iptr = machine.iptr;
    Machine_execute(&machine);
    /* printf("iptr = %d\n", machine.iptr); */
    if(machine.instructions[old_iptr].visited > 1) {
      printf("Repeated instruction found after %d iterations!\n", i);
      printf("Accumulator = %d\n", machine.accumulator);
      break;
    }
  }
}
