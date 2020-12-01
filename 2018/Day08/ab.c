/* Schema:
   A node consists of:
     header: quantity of children, quantity of metatada
     zero or more child nodes
     one or more metadata entries
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

typedef struct node node;
struct node {
  uint8_t num_children, num_metadata;
  char pad[6];

  node **children;
  uint8_t *metadata;
};

void print_node(node *current_node) {
  printf("NODE @ %p\n", current_node);
  printf("  %d children:\n", current_node->num_children);
  for(int i = 0; i < current_node->num_children; i++) {
    printf("    NODE @ %p\n", current_node->children[i]);
  }
  printf("  %d metadata:\n", current_node->num_metadata);
  for(int i = 0; i < current_node->num_metadata; i++) {
    printf("    %d\n", current_node->metadata[i]);
  }
}

node *init_node(FILE *file) {
  node *new_node = (node*)malloc(sizeof(node));

  fscanf(file, "%" SCNu8 "%" SCNu8 "", &(new_node->num_children), &(new_node->num_metadata));
  new_node->children = (node **)malloc(new_node->num_children * sizeof(node *));
  new_node->metadata = (uint8_t *)malloc(new_node->num_metadata * sizeof(uint8_t));

  for(int i = 0; i < new_node->num_children; i++) {
    new_node->children[i] = init_node(file);
  }
  for(int i = 0; i < new_node->num_metadata; i++) {
    fscanf(file, "%" SCNu8 "", &(new_node->metadata[i]));
  }

  return new_node;
}

uint32_t free_node(node *current_node) {
  uint32_t num_freed = 1;
  for(int i = 0; i < current_node->num_children; i++) {
    num_freed += free_node(current_node->children[i]);
    current_node->children[i] = NULL;
  }
  free(current_node->children);
  current_node->children = NULL;
  current_node->num_children = 0;
  free(current_node->metadata);
  current_node->metadata = NULL;
  current_node->num_metadata = 0;

  return num_freed;
}

uint32_t sum_metadata(node *current_node) {
  uint32_t sum = 0;

  for(int i = 0; i < current_node->num_metadata; i++) {
    sum += current_node->metadata[i];
  }

  for(int i = 0; i < current_node->num_children; i++) {
    sum += sum_metadata(current_node->children[i]);
  }

  return sum;
}

uint32_t get_value(node *current_node) {
  uint32_t value = 0;
  if(current_node->num_children == 0) {
    for(int i = 0; i < current_node->num_metadata; i++) {
      value += current_node->metadata[i];
    }
  } else {
    for(int i = 0; i < current_node->num_metadata; i++) {
      int index = current_node->metadata[i] - 1;
      if(index >= 0 && index < current_node->num_children) {
        value += get_value(current_node->children[index]);
      }
    }
  }

  return value;
}

int main(void) {
  FILE *file = fopen("input.txt", "r");
  node *root = init_node(file);
  fclose(file);

  printf("Checksum 1 = %d\n", sum_metadata(root));
  printf("Checksum 2 = %d\n", get_value(root));

  free_node(root);
}
