// Corey Zhou
// Project 2

#ifndef WORD_H
#define WORD_H
#include "itemtype.h"
#include "list.h"

class word{
 public:
  word(string name = "");
  string wordname() const;
  void addFile(string fileName);
  void printFiles();
  void printFilesThreshold(int threshold);

 private:
  string word_name;
  list<itemtype>* filesListHead;
};
#endif
