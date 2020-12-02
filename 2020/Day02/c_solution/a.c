#include <stdio.h>

int strcount(const char* str, char ch) {
  int i = 0, count = 0;
  char currch;

  while((currch = str[i++]) != 0) {
    count += currch == ch;
  }

  return count;
}

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
    int count = strcount(string, ch);
    total += (count >= first_num && count <= second_num);
  }

  printf("%d\n", total);

  fclose(file);

  return 0;
}
