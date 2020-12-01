#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NCHILDRENBASE 4
#define NCHILDRENFACTOR 2

struct Node {
  char name[4];
  int childrencap, childrenlen;
  struct Node **children;
  struct Node *parent;
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
  node->parent = NULL;

  /* sorry */
  allnodes[allnodeslen++] = node;

  return node;
}

void printnode(struct Node *node) {
  int i;
  if(node->parent) {
    printf("%s ( %s )\n", node->name, node->parent->name);
  } else {
    printf("%s ORPHAN\n", node->name);
  }
  for(i = 0; i < node->childrencap; ++i) {
    if(i < node->childrenlen) {
      printf("  [ %s ]\n", node->children[i]->name);
    } else {
      printf("  [ ]\n");
    }
  }
}

void printnodetree(struct Node *node, unsigned int depth) {
  int i;
  for(i = 0; i < depth; ++i) {
    printf(" ");
  }

  printf("%s\n", node->name);

  for(i = 0; i < node->childrenlen; ++i) {
    printnodetree(node->children[i], depth + 1);
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
  child->parent = parent;
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

char *backtrace(struct Node *node, int maxsteps) {
  int steps = 0;
  int tracecap = maxsteps;
  char *trace = (char *)malloc(sizeof(char) * 3 * tracecap + 1);
  trace[0] = 0;

  while(node && steps < maxsteps) {
    strcpy(trace + steps * 3, (const char *)node->name);
    node = node->parent;

    ++steps;
  }

  return trace;
}

char *lastcommon(const char *stra, const char *strb) {
  char *common = (char *)malloc(sizeof(char) * 4);

  int lena = strlen(stra);
  int lenb = strlen(strb);

  int ia = lena - 3;
  int ib = lenb - 3;

  int found = 0;
  while(ia >= 0 && ib >= 0 && !found) {
    if(strncmp(&stra[ia], &strb[ib], 3) != 0) {
      strncpy(common, (const char *)&stra[ia + 3], 3);
      found = 1;
    }
    ia -= 3;
    ib -= 3;
  }

  int lcadepth = (lena - ia) / 3 - 1;
  int adepth = lena / 3 - 1;
  int bdepth = lenb / 3 - 1;

  printf("lca depth = %d\n", lcadepth);
  printf("a depth   = %d\n", adepth);
  printf("b depth   = %d\n", bdepth);

  int dist = (adepth - lcadepth) + (bdepth - lcadepth) + 2;

  printf("distance  = %d\n", dist);
  return common;
}

int destroytree(struct Node *root) {
  int i;
  int numdestroyed = 0;

  for(i = 0; i < root->childrenlen; ++i) {
    numdestroyed += destroytree(root->children[i]);
  }

  free(root->children);
  root->children = NULL;
  root->childrencap = 0;
  root->childrenlen = 0;
  root->parent = NULL;
  free(root);

  numdestroyed++;

  return numdestroyed;
}

int main() {
  int numnodes = readtree("input.txt");
  printf("created %d nodes\n", numnodes);
  struct Node *com = nodebyname("COM");

  /* printnodetree(com, 0); */

  char *tracesan = backtrace(nodebyname("SAN"), 1000);
  char *traceyou = backtrace(nodebyname("YOU"), 1000);

  printf("%s\n", tracesan);
  printf("%s\n", traceyou);

  char *lc = lastcommon(tracesan, traceyou);
  printf("last common ancestor: %s\n", lc);

  free(tracesan);
  free(traceyou);
  free(lc);

  int numdestroyed = destroytree(com);

  printf("destroyed %d nodes\n", numnodes);
  if(numnodes == numdestroyed) {
    printf("all nodes successfully freed\n");
  } else {
    printf("possible memory leak\n");
  }

  return 0;
}
