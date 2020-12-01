#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NCHILDRENBASE 4
#define NCHILDRENFACTOR 2

struct Node {
  char name[4];
  int childrencap, childrenlen;
  struct Node **children;
};

/* aw shit */
/* i played myself */
int allnodeslen = 0;
struct Node *allnodes[2048];
struct Node *nodebyname(const char *name) {
  int i;
  for(i = 0; i < allnodeslen; ++i) {
    if(strcmp((const char *)allnodes[i]->name, name) == 0) {
      return allnodes[i];
    }
  }
  return NULL;
}

struct Node *makenode(const char *name) {
  struct Node *node = (struct Node *)malloc(sizeof(struct Node));
  strncpy((char *)(node->name), name, 3);
  node->childrencap = node->childrenlen = 0;
  node->children = NULL;

  /* sorry */
  allnodes[allnodeslen++] = node;

  return node;
}

void printnode(struct Node *node) {
  int i;
  printf("%s\n", node->name);
  for(i = 0; i < node->childrencap; ++i) {
    if(i < node->childrenlen) {
      printf("  [ %s ]\n", node->children[i]->name);
    } else {
      printf("  [ ]\n");
    }
  }
}

void addchild(struct Node *parent, struct Node *child) {
  if(!parent || !child) {
    return;
  }

  if(!parent->children) {
    parent->children = (struct Node **)malloc(sizeof(struct Node *) * NCHILDRENBASE);
    parent->childrencap = NCHILDRENBASE;
    parent->childrenlen = 0;
  }

  if(parent->childrencap <= parent->childrenlen) {
    struct Node **newchildren = (struct Node **)malloc(sizeof(struct Node *) * parent->childrencap * NCHILDRENFACTOR);
    memcpy(newchildren, parent->children, parent->childrencap + 1);
    free(parent->children);
    parent->children = newchildren;
  }

  parent->children[parent->childrenlen++] = child;
}

int readtree(const char *fname) {
  int numnodes = 0;
  char parentname[4], childname[4];
  FILE *input = fopen(fname, "r");

  while(fscanf(input, "%3s)%3s", parentname, childname) != EOF) {
    struct Node *parent = nodebyname(parentname);
    struct Node *child = nodebyname(childname);

    if(!parent) {
      parent = makenode(parentname);
      numnodes++;
    }
    if(!child) {
      child = makenode(childname);
      numnodes++;
    }

    addchild(parent, child);
  }
  return numnodes;
}

unsigned int sumdepth(struct Node *root, unsigned int depth) {
  int i;
  unsigned int sum = depth;

  for(i = 0; i < root->childrenlen; ++i) {
    sum += sumdepth(root->children[i], depth + 1);
  }

  return sum;
}

int destroytree(struct Node *root) {
  int i;
  int numdestroyed = 0;

  for(i = 0; i < root->childrenlen; ++i) {
    numdestroyed += destroytree(root->children[i]);
  }

  free(root->children);
  root->childrencap = 0;
  root->childrenlen = 0;
  numdestroyed++;

  return numdestroyed;
}

int main() {
  int numnodes = readtree("input.txt");
  printf("created %d nodes\n", numnodes);
  struct Node *com = nodebyname("COM");

  unsigned int sum = sumdepth(com, 0);

  printf("sum of node depths: %u\n", sum);

  int numdestroyed = destroytree(com);

  printf("destroyed %d nodes\n", numnodes);
  if(numnodes == numdestroyed) {
    printf("all nodes successfully freed\n");
  } else {
    printf("possible memory leak\n");
  }

  return 0;
}
