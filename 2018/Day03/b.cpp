// This is going to be shitty

#include <iostream>
#include <fstream>
#include <cstdio>
#include <cstdint>

using namespace std;

#define FABRIC_SIZE 2000
#define NUM_CLAIMS 1373

uint16_t fabric[FABRIC_SIZE][FABRIC_SIZE] = {{0}};
int maxX = 0, maxY = 0; // Keep track of maximum reach of x and y

class Claim {
public:
  int n, x, y, w, h;

  void init(const char *raw) {
    sscanf(raw, "#%d @ %d,%d: %dx%d", &n, &x, &y, &w, &h);
  }

  void print() {
    printf("#%d @ %d,%d: %dx%d\n", n, x, y, w, h);
  }

  // Stake a claim on the fabric array
  void stake() {
    for(int i = 0; i < w; i++) {
      for(int j = 0; j < h; j++) {
        fabric[x + i][y + j]++;
      }
    }
    if(x + w > maxX) {
      maxX = x + w;
    }
    if(y + h > maxY) {
      maxY = y + h;
    }
  }
};

Claim claims[NUM_CLAIMS];

int main() {
  ifstream input("./input.txt");

  char line[256];
  for(int i = 0; input.getline(line, 256); i++) {
    claims[i].init(line);
    claims[i].stake();
  }

  for(int c = 0; c < NUM_CLAIMS; c++) {
    Claim claim = claims[c];
    bool valid = true;
    for(int i = 0; i < claim.w && valid; i++) {
      for(int j = 0; j < claim.h && valid; j++) {
        if(fabric[claim.x + i][claim.y + j] > 1) {
          valid = false;
        }
      }
    }
    if(valid) {
      printf("Non-overlapping claim: #%d\n", claim.n);
      break;
    }
  }
}
