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


int Machine_init(Machine *machine, const char *fname) {
  FILE *file;
  char buf[16];
  int arg;
  int errors = 0;

  machine->num_instructions = 0;
  machine->iptr = 0;
  machine->accumulator = 0;

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
