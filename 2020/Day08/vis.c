#include <unistd.h>

#include "./Machine.c"

int main(int argc, char **argv) {
  Machine machine;
  MachineDisplay display;
  int found = 0;
  int width = 130, height = 27;
  int i = 0;

  if(argc < 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    return 1;
  }

  if(Machine_init(&machine, argv[1])) {
    printf("Machine loaded!\n");
  } else {
    printf("Machine failed to load.\n");
    return 1;
  }

  MachineDisplay_init(&display, &machine, width, height);

  for(i = 0; machine.iptr < 504; i++) {
    MachineDisplay_draw(&display);
    Machine_execute(&machine);
    fflush(stdout);
    usleep(100000);
  }

  printf("\n");

  return 0;
}
