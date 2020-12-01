#include <iostream>
#include <fstream>
#include <cstdio>
#include <cstring>

using namespace std;

#define GRID_SIZE 1000
//#define NUM_CLAIMS 1373

int grid[GRID_SIZE][GRID_SIZE] = {{0}};

typedef int (*switchAction)(const int);

int toggle(const int b) {
  return b + 2;
}
int turn_on(const int b) {
  return b + 1;
}
int turn_off(const int b) {
  int res = b - 1;
  return (res < 0 ? 0 : res);
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
  ofs << "P2" << endl;
  ofs << GRID_SIZE << " " << GRID_SIZE << endl;
  ofs << "255" << endl;
  for(int x = 0; x < GRID_SIZE; x++) {
    for(int y = 0; y < GRID_SIZE; y++) {
      ofs << grid[x][y] << " ";
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

  printf("%d\n", frame);
  sprintf(fname, "frame_%03d.pgm", frame++);
  writePBM(fname);

  char line[256];
  for(int i = 0; input.getline(line, 256); i++) {
    rectangle.init(line);
    rectangle.execute();

    printf("%d\n", frame);
    sprintf(fname, "frame_%03d.pgm", frame++);
    writePBM(fname);
  }

  int maxBrightness = 0;
  int brightness = 0;
  for(int i = 0; i < GRID_SIZE; i++) {
    for(int j = 0; j < GRID_SIZE; j++) {
      brightness += grid[i][j];
      if(grid[i][j] > maxBrightness) {
        maxBrightness = grid[i][j];
      }
    }
  }

  printf("Total brightness %d\n", brightness);
  printf("Max brightness %d\n", maxBrightness);
}
