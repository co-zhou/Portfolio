// Corey Zhou 12/6/2018
// Project 2

#include <iostream>
#include <string>
#include "itemtype.h"
using namespace std;

itemtype::itemtype(string fname, const int& num) {
    file_name=fname; file_count=num;    
}

void itemtype::set_filename(string fname){
    file_name=fname;    
}

void itemtype::set_count(const int& num) {
    file_count=num;   
}

string itemtype::filename() const {
    return file_name;    
}

int itemtype::count() const {
    return file_count;
}
