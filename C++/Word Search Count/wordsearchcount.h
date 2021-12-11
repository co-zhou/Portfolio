// Corey Zhou
// Project 2

#ifndef WORDSEARCHCOUNT_H
#define WORDSEARCHCOUNT_H

#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include "word.h"

using namespace std;

int getdir (string dir, vector<string> &files);

int main(int argc, char* argv[]);

#endif



