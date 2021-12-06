#include "arrayStack.h"
#include "arrayQ.h"

using namespace std;

int main(){
  arrayQ<int> queue;
  int k;
  arrayStack<int> stack;

  assert(k<=queue.size());
  for(int i=0; i<k; i++){
    stack.push(queue.front());
    queue.deq();
  }

  for(int i=0; i<stack.size(); i++){
    queue.enq(stack.top());
    stack.pop();
  }

  for(int i=0; i<queue.size()-k; i++){
    int x = queue.front();
    queue.deq();
    queue.enq(x);
  }
}
