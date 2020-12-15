/* hijacked the old logic so that it just spits out a bunch of assign commands
 * for a more modern language to handle.
 * 36 bits of "memory" was not something I wanted to try to deal with in C,
 * not without associative arrays.
 */

#include <stdio.h>

#define MEM_SIZE 65536
#define BUF_SIZE 64

int get_x_locations(int x_locations[64], const char *line) {
  int i;
  int num_xs = 0;

  /* mask = 000000000000000000000000000000X1001X */
  for(i = 43; i >= 7; --i) {
    if(line[i] == 'X') {
      x_locations[num_xs++] = 43 - i - 1;
    }
  }

  return num_xs;
}

unsigned long apply_odometer(unsigned long value,
                             int reading,
                             int num_xs,
                             int x_locations[64]) {
  int i;
  unsigned long temp_mask;

  for(i = 0; i < num_xs; ++i) {
    temp_mask = 1 << x_locations[i];

    value = (value & ~temp_mask) | (((reading >> i) & 1) << x_locations[i]);
  }

  return value;
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
  int num_xs;
  int x_locations[64];
  unsigned long new_address;

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
      num_xs = get_x_locations(x_locations, buf);
    } else if(buf[1] == 'e') {
      sscanf(buf, "mem[%d] = %lu", &address, &input_value);

      address |= mask_bitvals;

      for(i = 0; i < (1 << num_xs); ++i) {
        new_address = apply_odometer(address, i, num_xs, x_locations);
        printf("mem[%lu] = %lu\n", new_address, input_value);
        /* mem[new_address] = input_value; */
      }
    }

  }
  fclose(file);

  /*
  * sum = 0;
  * for(i = 0; i < MEM_SIZE; ++i) {
  *   sum += mem[i];
  * }
  */

  /* printf("%lu\n", sum); */

  return 0;
}
