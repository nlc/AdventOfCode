#include <iostream>
#include <fstream>
#include <cstdio>
#include <cstring>

using namespace std;

#define GRID_SIZE 1000
//#define NUM_CLAIMS 1373

bool grid[GRID_SIZE][GRID_SIZE] = {{0}};

typedef bool (*switchAction)(const bool);

bool toggle(const bool b) {
  return !b;
}
bool turn_on(const bool b) {
  return true;
}
bool turn_off(const bool b) {
  return false;
}

class Rectangle {
public:
  int x1, y1, x2, y2;
  switchAction t;

  void init(char *raw) {
    // turn on 489,959 through 759,964
    char *word;
    word = strtok(raw, " ");
    if(strcmp(word, "turn") == 0) {
      word = strtok(NULL, " ");
      if(strcmp(word, "on") == 0) {
        t = &turn_on;
      } else {
        t = &turn_off;
      }
    } else {
      t = &toggle;
    }
    word = strtok(NULL, " ");
    sscanf(word, "%d,%d", &x1, &y1);

    word = strtok(NULL, " "); // Ignore "through"

    word = strtok(NULL, " ");
    sscanf(word, "%d,%d", &x2, &y2);
  }

  // Transform the grid array
  void execute() {
    for(int x = x1; x <= x2; x++) {
      for(int y = y1; y <= y2; y++) {
        grid[x][y] = t(grid[x][y]);
      }
    }
  }
};

void writePBM(char *fname) {
  ofstream ofs(fname, ios_base::trunc);
  ofs << "P1" << endl;
  ofs << GRID_SIZE << " " << GRID_SIZE << endl;
  for(int x = 0; x < GRID_SIZE; x++) {
    for(int y = 0; y < GRID_SIZE; y++) {
      ofs << (grid[x][y] ? '1' : '0');
    }
    ofs << endl;
  }
  ofs.close();
}

int main() {
  ifstream input("./input2015day6.txt");
  Rectangle rectangle;

  int frame = 0;
  char fname[128];

  sprintf(fname, "frame_%03d.pbm", frame++);
  writePBM(fname);

  char line[256];
  for(int i = 0; input.getline(line, 256); i++) {
    rectangle.init(line);
    rectangle.execute();
    sprintf(fname, "frame_%03d.pbm", frame++);
    writePBM(fname);
    printf("%d\n", frame);
  }

  int numLit = 0;
  for(int i = 0; i < GRID_SIZE; i++) {
    for(int j = 0; j < GRID_SIZE; j++) {
      if(grid[i][j]) {
        numLit++;
      }
    }
  }

  printf("Found %d lit.\n", numLit);
}
