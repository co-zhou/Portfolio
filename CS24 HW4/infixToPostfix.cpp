#include "arrayStack.h"
#include <cstring>
#include <iostream>

using namespace std;

int main(){
  char[100] infix;
  string postfix;
  arrayStack<char> opStack;

  for(int i=0; i<strlen(infix); i++){
    char next = infix[i];
    if(strcmp(&next, "*")==0 || strcmp(&next, "/")==0 || strcmp(&next, "+")==0 || strcmp(&next, "-")==0){
      opStack.push(next);
    } else if(strcmp(&next, ")")==0){
      postfix += opStack.top();
      opStack.pop();
    } else {
      postfix += next;
    }
    postfix += " ";
  }
  return 0;
}
