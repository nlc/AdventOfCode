#include <stdio.h>

int main() {
  int first_num, second_num, total = 0;
  char ch;
  char string[128];
  char *fname = "input.txt";
  FILE *file = fopen(fname, "r");

  if(!file) {
    fprintf(stderr, "No such file: %s\n", fname);
    return 1;
  }

  while(fscanf(file, "%d-%d %c: %s", &first_num, &second_num, &ch, string) != EOF) {
    total += (string[first_num - 1] == ch ^ string[second_num - 1] == ch);
  }

  printf("%d\n", total);

  fclose(file);

  return 0;
}
