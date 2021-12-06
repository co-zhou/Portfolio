#ifndef ARRAYQUEUE_H
#define ARRAYQUEUE_H
#include <cstdlib>

using namespace std;

template <class Item>
class arrayQ{
 public:
  // constructor
    arrayQ(){front=0; rear=0; size=0;}
  // modifiers: add and deletes to a stack
    void enq(const Item& entry);
    void deq();
  // observers: empty? and return top element
    bool empty(){return (size == 0);}
    Item qfront();
 private:
  // array declaration to store the elements of the stack
  Item data[30];
  // variable to indicate the top of the stack
  int front;
  int rear;
  int size;
};
#include "arrayQ.cpp"  // <--- template class: THIS IS REQUIREDp
#endif

