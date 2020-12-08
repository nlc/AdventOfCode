#include "./Machine.c"

int detect_loop(Machine *machine, int max_iterations) {
  int i;
  int found = 0;

  for(i = 0; i < max_iterations && (machine->iptr >= 0 && machine->iptr < machine->num_instructions); ++i) {
    int old_iptr = machine->iptr;
    Instruction_print(machine->instructions + machine->iptr);
    printf("\n");
    Machine_execute(machine);
    if(machine->instructions[old_iptr].visited > 1) {
      return 1;
    }
  }

  if(i >= max_iterations) {
    printf("Reached max_iterations!\n");
  } else if(machine->iptr <= 0) {
    printf("iptr < 0!\n");
  } else {
    printf("Halted!\n");
  }

  return 0;
}

int part_a(Machine *machine) {
  int max_iterations = 1e6;
  int found = detect_loop(machine, max_iterations);

  if(found) {
    printf("Repeated instruction found!\n");
    printf("Accumulator = %d\n", machine->accumulator);
  } else {
    printf("Failed to find repeated instruction after %d iterations.\n", max_iterations);
    return 1;
  }

  return !!found;
}

int part_b(Machine *machine) {
  int max_iterations = 1e6;
  int flip_index = 0; /* jmp <-> nop */
  int seeking;
  int loop;
  int num_tries = 0;

  while(num_tries < machine->num_instructions) {
    ++num_tries;
    Machine_reset(machine);
    seeking = 1;

    /* Seek flip index forward until jmp or nop */
    /* flip one to the other */
    while(seeking && flip_index < machine->num_instructions) {
      if(machine->instructions[flip_index].opcode_index == 1) { /* jmp */
        seeking = 0;
        machine->instructions[flip_index].opcode_index = 2;
      } else if(machine->instructions[flip_index].opcode_index == 2) { /* nop */
        seeking = 0;
        machine->instructions[flip_index].opcode_index = 1;
      }
      ++flip_index;
    }

    if(flip_index >= machine->num_instructions) {
      printf("Seeking reached end of instructions!\n");
      return 0;
    }

    loop = detect_loop(machine, max_iterations);
    if(!loop) {
      printf("Halting condition found after %d attempts!\n", num_tries);
      printf("Accumulator = %d\n", machine->accumulator);
      return 1;
    }

    /* unflip */
    flip_index -= 1;
    if(machine->instructions[flip_index].opcode_index == 1) { /* jmp */
      machine->instructions[flip_index].opcode_index = 2;
    } else if(machine->instructions[flip_index].opcode_index == 2) { /* nop */
      machine->instructions[flip_index].opcode_index = 1;
    }
    flip_index += 1;
  }

  return 0;
}

int main(int argc, char **argv) {
  Machine machine;
  int found = 0;

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

  printf("\033[1mPART A:\033[0m\n");
  part_a(&machine);
  printf("\033[1mPART B:\033[0m\n");
  part_b(&machine);

  return !found;
}
