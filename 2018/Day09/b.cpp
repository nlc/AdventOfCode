#include <iostream>
#include <iomanip>
#include <fstream>

using namespace std;

class Marble {
private:
  unsigned long long number;
  Marble *prev, *next;

public:
  Marble(int numberIn) : number(numberIn) {
    prev = next = NULL;
  }

  ~Marble() {
    prev = next = NULL;
  }

  Marble *link(Marble *prevIn, Marble *nextIn) {
    prev = prevIn;
    next = nextIn;

    prev->next = this;
    next->prev = this;

    return this;
  }

  Marble *unlink() {
    counterclockwise()->next = next;
    clockwise()->prev = prev;

    prev = next = NULL;

    return this;
  }

  Marble *clockwise(int steps = 1) {
    if(steps == 0) {
      return this;
    } else {
      return next->clockwise(steps - 1);
    }
  }
  Marble *counterclockwise(int steps = 1) {
    if(steps == 0) {
      return this;
    } else {
      return prev->counterclockwise(steps - 1);
    }
  }

  unsigned long long getNumber() {
    return number;
  }
};

class Circle {
private:
  int count;
  Marble *origin, *current;

public:
  Circle() {
    count = 0;
    origin = new Marble(count);
    origin->link(origin, origin);
    current = origin;
    count++;
  }

  ~Circle() {
    Marble *destroyer = origin;
    Marble *temp;
    do {
      temp = destroyer->clockwise();
      delete destroyer;
      destroyer = temp;
    } while(destroyer != origin);

    origin = current = NULL;
  }

  int add() {
    int result = 0;
    if(count % 23) {
      Marble *toAdd = new Marble(count);

      Marble *marbleA = current->clockwise();
      Marble *marbleB = marbleA->clockwise();

      current = toAdd->link(marbleA, marbleB);
    } else {
      current = current->counterclockwise(6);
      Marble *freed = current->counterclockwise(1)->unlink();
      result = count + freed->getNumber();
      delete freed;
    }

    count++;

    return result;
  }

  int size() {
    return count;
  }

  void print() {
    Marble *temp = origin;
    cout << "<-";
    do {
      cout << (temp == current ? "(" : " ") << setw(2) << temp->getNumber() << (temp == current ? ")" : " ") << "-";
      temp = temp->clockwise();
    } while(temp != origin);
    cout << ">" << endl;
  }
};

int main() {
  int lastMarbleScore;
  int numScores;
  unsigned long long *scores;

  int player = 0;
  int leader = 0;

  ifstream is("input.txt");
  string temp;
  int index = 0;
  while(is >> temp) {
    if(index == 0) {
      numScores = stoi(temp, NULL, 10);
    }
    if(index == 6) {
      lastMarbleScore = stoi(temp, NULL, 10);
    }
    index++;
  }

  // For part B
  lastMarbleScore *= 100;

  scores = new unsigned long long[numScores];
  for(int i = 0; i < numScores; i++) {
    scores[i] = 0;
  }

  Circle circle;

  // 447 players; last marble is worth 71510 points
  unsigned long long latestScore = 0;
  unsigned long long iterations = 0;
  bool cutoff = false;
  while(latestScore != lastMarbleScore && iterations++ <= lastMarbleScore && !cutoff) {
    latestScore = circle.add();

    scores[player] += latestScore;
    if(scores[player] > scores[leader]) {
      leader = player;
    }

    player = (player + 1) % numScores;
  }

  cout << scores[leader] << endl;

  if(scores) {
    delete [] scores;
  }
}
