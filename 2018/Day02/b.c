/* Perfect.
   Error-less.
   Warning-less.
   ANSI C.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uthash.h"

#define NUM_LABELS 250
#define LABEL_LENGTH 26

/* Function prototypes */
int indexOf(char c);
char valueOf(int n);
int evaluate(char *label);
void populateLabels(char *fname);

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

/* Key is a valid label with one letter removed (replaced by ' ', say) */
struct allButOne {
  char key[LABEL_LENGTH + 1];
  char match[LABEL_LENGTH + 1];
  int id;
  UT_hash_handle hh;
};

/* Again, let's make it interesting. I KNOW there's a way to do this in sub-
   quadratic time (maybe even linear???) AND not use a pre-written hash library.
   Okay fuck the part about not using a hash library.
*/
int main(void) {
  struct allButOne *s, *tmp, *labelsHash = NULL;
  int i;

  populateLabels("input.txt");
  for(i = 0; i < NUM_LABELS; i++) {
    int j;
    char *label = labels[i]; /* This is dicey, check here if it explodes */
    /* Declare and initialize key */
    char tempKey[LABEL_LENGTH + 1];
    strcpy(tempKey, label);
    /* Iterate through letters of label and replace one by one */
    for(j = 0; j < LABEL_LENGTH; j++) {
      tempKey[j] = ' '; /* destroy the information at that index */
      HASH_FIND_STR(labelsHash, tempKey, s);
      if(s) {
        printf("MATCH FOUND: %s and %s", label, s->match);
        exit(0);
      } else {
        s = (struct allButOne *)malloc(sizeof *s);
        strcpy(s->match, label);
        HASH_ADD_STR(labelsHash, key, s);
      }
      tempKey[j] = label[j]; /* restore original value */
    }
  }

  /* free the hash table contents */
  HASH_ITER(hh, labelsHash, s, tmp) {
    HASH_DEL(labelsHash, s);
    free(s);
  }

  return 0;
}

/* lufjygedpvfbhft xiwnaorzmq */
