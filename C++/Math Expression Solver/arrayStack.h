#ifndef ARRAYSTACK_H
#define ARRAYSTACK_H
#include <cstdlib>

using namespace std;

template <class Item>
class arrayStack{
 public:
  // constructor
    arrayStack(){used =0;}
  // modifiers: add and deletes to a stack
    void push(const Item& entry);
    void pop();
  // observers: empty? and return top element
    bool empty(){return (used == 0);}
    Item top();
 private:
  // array declaration to store the elements of the stack
  Item data[30];
  // variable to indicate the top of the stack
        int used;
};
#include "arrayStack.cpp"  // <--- template class: THIS IS REQUIRED
#endif
 
