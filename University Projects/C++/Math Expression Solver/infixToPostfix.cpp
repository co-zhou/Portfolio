#include "arrayStack.h"
#include <iostream>

using namespace std;

string infixToPostfix(string infix){
  string postfix;
  arrayStack<char> opStack;
	int numParen = 0;

  for(int i=0; i<infix.length(); i++){
    char next = infix[i];

    if(next == '*' || next == '/'|| next == '+'|| next == '-'){
			opStack.push(next);
    } else if (next == '('){
			numParen++;
		} else if(next == ')'){
      postfix += opStack.top();
      opStack.pop();
			numParen--;
    } else if (isdigit(next)){
      postfix += next;
    } else {
			cout<<"Incorrect Format"<<endl;
			return "";
		}
  }
	
	if(numParen !=0){
		cout<<"Incorrect Format"<<endl;
		return "";
	}

	return postfix;
}
