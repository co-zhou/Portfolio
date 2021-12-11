// Corey Zhou
// Project 2

#ifndef ITEMTYPE_H
#define ITEMTYPE_H
#include <cstdlib>
#include <string>
using namespace std;

class itemtype{
 public:
  itemtype(string fname = "",const int& num = 0);
  void set_filename(string fname);
  void set_count(const int& num);
  string filename() const;
  int count() const;
  
 private:
  string file_name;
  int file_count;
};
#endif
