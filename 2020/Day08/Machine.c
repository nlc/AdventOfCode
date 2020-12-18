#include <stdio.h>
#include <string.h>

/* Inflexible but avoids potential nastiness */
#define MAX_INSTRUCTIONS 2048

#define NUM_OPCODES 3

typedef struct Instruction {
  int visited;
  int opcode_index;
  int argument;
} Instruction;

typedef struct Machine {
  Instruction instructions[MAX_INSTRUCTIONS];
  int num_instructions;
  int iptr;
  int accumulator;
} Machine;

typedef struct MachineDisplay {
  Machine *machine;
  int width, height;
  int cursor_x, cursor_y;
  int saved_x, saved_y;

  int cells_x;
} MachineDisplay;


/* Simple linear search should do it for now */
const char opcode_aliases[NUM_OPCODES][4] = {
  "acc",
  "jmp",
  "nop"
};

int opcode_function_acc(Machine *machine, Instruction *instruction) {
  machine->accumulator += instruction->argument;
  machine->iptr++;
  return 1;
}

int opcode_function_jmp(Machine *machine, Instruction *instruction) {
  machine->iptr += instruction->argument;
  return 1;
}

int opcode_function_nop(Machine *machine, Instruction *instruction) {
  machine->iptr++;
  return 1;
}

int (*opcode_functions[NUM_OPCODES])(Machine *machine, Instruction *instruction) = {
  opcode_function_acc,
  opcode_function_jmp,
  opcode_function_nop
};

int get_opcode_index(const char *opcode_alias) {
  int i;

  for(i = 0; i < NUM_OPCODES; ++i) {
    if(!strcmp(opcode_alias, opcode_aliases[i])) {
      return i;
    }
  }

  return -1;
}


int Instruction_init(Instruction *instruction, const char *opcode_alias, const int argument) {
  instruction->visited = 0;
  instruction->argument = argument;
  return (instruction->opcode_index = get_opcode_index(opcode_alias)) >= 0;
}

int Instruction_execute(Machine *machine, Instruction *instruction) {
  int status = (*opcode_functions[instruction->opcode_index])(machine, instruction);
  if(status) {
    instruction->visited++;
  }
  return status;
}

#define INSTRUCTION_PRINT_WIDTH 6
int Instruction_print(Instruction *instruction) {
  /* return printf("%s%+4d", opcode_aliases[instruction->opcode_index], instruction->argument); */
  int nchars = 0;

  if(instruction->opcode_index == 0) { /* acc, ++123, red */
    printf("\033[31m");
    char sign = (instruction->argument >= 0) ? '+' : '-';
    nchars = printf("%c%+-4d", sign, instruction->argument);
  } else if(instruction->opcode_index == 1) { /* jmp, ->19, green */
    printf("\033[32m");
    char *arrow = (instruction->argument < 0) ? "<-" : "->";
    nchars = printf("%s%-3d", arrow, instruction->argument < 0 ? -instruction->argument : instruction->argument);
  } else if(instruction->opcode_index == 2) { /* nop, ~*~, dim white */
    printf("\033[22;2m");
    nchars = printf(" ~*~ ");
  } else { /* illegal instruction, ??, inverse red */
    printf("\033[41m");
    nchars = printf("??   ");
  }
  printf("\033[0m");

  return nchars;
}


void Machine_reset(Machine *machine) {
  int i;

  machine->iptr = 0;
  machine->accumulator = 0;

  for(i = 0; i < machine->num_instructions; ++i) {
    machine->instructions[i].visited = 0;
  }
}

int Machine_init(Machine *machine, const char *fname) {
  FILE *file;
  char buf[16];
  int arg;
  int errors = 0;

  machine->iptr = 0;
  machine->accumulator = 0;

  machine->num_instructions = 0;

  file = fopen(fname, "r");
  if(!file) {
    fprintf(stderr, "No such file: %s\n", fname);
    return 0;
  }
  while(fscanf(file, "%s %d", buf, &arg) != EOF) {
    if(!Instruction_init(machine->instructions + machine->num_instructions, buf, arg)) {
      fprintf(stderr, "Bad instruction \"%s\" at SLOC #%d\n", buf, machine->num_instructions);
      ++errors;
    }

    machine->num_instructions++;
  }

  if(errors > 0) {
    fprintf(stderr, "%d errors during file load!\n", errors);
    return 0;
  }
  return 1;
}

int Machine_execute(Machine *machine) {
  return Instruction_execute(machine, machine->instructions + machine->iptr);
}


void MachineDisplay_init(MachineDisplay *display, Machine *machine, int width, int height) {
  display->machine = machine;
  display->width = width;
  display->height = height;

  display->cursor_x = display->cursor_y = 1;
  display->saved_x = display->saved_y = 1;

  display->cells_x = display->width / INSTRUCTION_PRINT_WIDTH;
}

void MachineDisplay_save(MachineDisplay *display) {
  display->saved_x = display->cursor_x;
  display->saved_y = display->cursor_y;
}

void MachineDisplay_goto(MachineDisplay *display, int x, int y) {
  display->cursor_x = x;
  display->cursor_y = y;

  printf("\033[%d;%dH", display->cursor_y, display->cursor_x);
}

void MachineDisplay_revisit(MachineDisplay *display) {
  int temp;

  MachineDisplay_goto(display, display->saved_x, display->saved_y);

  temp = display->saved_x;
  display->saved_x = display->saved_y;
  display->saved_y = temp;
}

void MachineDisplay_clear(MachineDisplay *display) {
  printf("\033[2J");

  /* TODO: Draw border */
}

void MachineDisplay_draw(MachineDisplay *display) {
  int i;
  int len;
  int x, y;

  int instr_width = 6;
  int cells_per_line = display->width / instr_width;

  MachineDisplay_clear(display);
  for(int i = 0; i < display->machine->num_instructions; ++i) {
  // for(int i = 0; i < 6000 && i < display->machine->num_instructions; ++i) {
    x = (i % cells_per_line) * instr_width + 1;
    y = i / cells_per_line + 1;
    if(i == display->machine->iptr) {
      MachineDisplay_save(display); /* Remember this location for later erasure */
      printf("\033[7m");
    }

    MachineDisplay_goto(display, x, y);
    len = Instruction_print(display->machine->instructions + i);
  }
}

// void MachineDisplay_redraw(MachineDisplay *display) {
//   MachineDisplay_revisit(display); /* return to highlighted iptr cell */
//   len = Instruction_print(display->machine->instructions + i);
//   x = (i % cells_per_line) * instr_width + 1;
//   y = i / cells_per_line + 1;
// }
