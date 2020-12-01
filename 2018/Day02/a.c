/* Perfect.
   Error-less.
   Warning-less.
   ANSI C.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_LABELS 250
#define LABEL_LENGTH 26

/* Function prototypes */
int indexOf(char c);
char valueOf(int n);
int evaluate(char *label);
void populateLabels(char *fname);

/*char *has2[NUM_LABELS];*/ /* crude but oh well. Actually, not necessary*/
/*char *has3[NUM_LABELS];*/
int has2count = 0;
int has3count = 0;

/* Let's make this interesting. Our alphabet is known, so try doing it
   without hash tables or anything fancy like that */
#define ALPHA_LEN 26
int indexOf(char c) { /* char to alphabet index (i. e. b->1) */
  /* assume all lowercase */
  int index = c - 'a';
  if(index < 0 || index >= ALPHA_LEN) {
    return -1;
  }
  return index;
}
char valueOf(int n) { /* index to char (i. e. 3->d) */
  if(n < 0 || n >= ALPHA_LEN) {
    return 0;
  }
  return n + 'a';
}
#define HAS_TWO 1
#define HAS_THREE 2
int evaluate(char *label) {
  int result = 0;
  int counter[ALPHA_LEN] = {0};
  char ch;
  int index;
  int i;
  for(i = 0; i < 2048 && (ch = label[i]); i++) {
    if((index = indexOf(ch)) != -1) {
      counter[index]++;
    }
  }
  for(i = 0; i < ALPHA_LEN; i++) {
    if(counter[i] == 2) {
      result |= HAS_TWO;
    }
    if(counter[i] == 3) {
      result |= HAS_THREE;
    }
  }

  return result;
}

char labels[NUM_LABELS][LABEL_LENGTH + 1];
void populateLabels(char *fname) {
  FILE *fptr = fopen(fname, "r");
  int i;

  if(!fptr) {
    printf("File %s not found!\n", fname);
    exit(1);
  }

  for(i = 0; i < NUM_LABELS; i++) {
    fgets(labels[i], LABEL_LENGTH + 2, fptr);
    labels[i][strcspn(labels[i], "\r\n")] = 0;
  }
}

int main(void) {
  int i;
  int checksum;

  populateLabels("input.txt");

  for(i = 0; i < NUM_LABELS; i++) {
    int evaluation = evaluate(labels[i]);

    if(evaluation & HAS_TWO) {
      has2count++;
    }
    if(evaluation & HAS_THREE) {
      has3count++;
    }
  }

  checksum = has2count * has3count;

  printf("Found %d with two and %d with three\n", has2count, has3count);
  printf("Checksum is %d\n", checksum);

  return 0;
}
