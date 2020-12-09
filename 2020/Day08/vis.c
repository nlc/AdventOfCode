#include "./Machine.c"

int main(int argc, char **argv) {
  Machine machine;
  MachineDisplay display;
  int found = 0;
  int width = 90, height = 70;

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

  MachineDisplay_draw(&display);

  return 0;
}
