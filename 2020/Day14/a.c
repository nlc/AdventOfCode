#include <stdio.h>

#define MEM_SIZE 65536
#define BUF_SIZE 64

unsigned long apply_mask(unsigned long value,
                         unsigned long setbits,
                         unsigned long bitvals) {
  int freebits = ~setbits;
  return (value & freebits) | (bitvals & setbits);
}

int main(int argc, char **argv) {
  char *fname;
  FILE *file;
  char buf[BUF_SIZE];
  int i;
  unsigned long mem[MEM_SIZE] = { 0 };
  char ch;
  unsigned long mask_setbits, mask_bitvals;
  int override_bit;
  int address;
  unsigned long input_value;
  unsigned long sum;

  if(argc < 2) {
    fprintf(stderr, "Usage: %s <input file name>\n", argv[0]);
    return 1;
  }

  fname = argv[1];
  file = fopen(fname, "r");
  while(fgets(buf, BUF_SIZE, file)) {
    if(buf[1] == 'a') {
      /* Set mask */
      /* Two-part mask:
       * mask_setbits marks all the locations where the mask overrides
       * the incoming value, mask_bitvals holds the corresponding
       * overriding bit values
       */
      mask_setbits = mask_bitvals = 0;
      for(i = 0; i < BUF_SIZE && (ch = buf[i + 7]) >= 0x20; ++i) {
        mask_setbits <<= 1;
        mask_bitvals <<= 1;
        override_bit = (ch < '2') & 1;
        if(override_bit) {
          mask_setbits |= 1;
          mask_bitvals |= (ch - '0') & 1;
        }
      }
    } else if(buf[1] == 'e') {
      sscanf(buf, "mem[%d] = %lu", &address, &input_value);
      mem[address] = apply_mask(input_value, mask_setbits, mask_bitvals);
    }

  }
  fclose(file);

  sum = 0;
  for(i = 0; i < MEM_SIZE; ++i) {
    sum += mem[i];
  }

  printf("%lu\n", sum);

  return 0;
}
