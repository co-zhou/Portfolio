// Corey Zhou, 11/25/2018

#include "arrayStack.h"
#include <iostream>
#include <cstring>

int main(){
  char expression[100];
  bool correct = true;
  arrayStack<int> numStack;

  
  cout<<"Enter a postfix expression or \"exit\": "<<endl;
  cin>>expression;
  while(strcmp(expression,"exit") !=0){
    for(int i=0; i<strlen(expression); i++){
      char* token = &expression[i];
      if(strcmp(token, "*") == 0){
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int right = numStack.top();
	numStack.pop();
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int left = numStack.top();
	numStack.pop();
	numStack.push(left*right);
      } else if(strcmp(token, "+") == 0){
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int right = numStack.top();
	numStack.pop();
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int left = numStack.top();
	numStack.pop();
	numStack.push(left+right);
      } else if(strcmp(token, "-") == 0){
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int right = numStack.top();
	numStack.pop();
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int left = numStack.top();
	numStack.pop();
	numStack.push(left-right);
      } else if(strcmp(token, "/") == 0){
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int right = numStack.top();
	numStack.pop();
	if(numStack.empty()){
	  correct = false;
	  break;
	}
	int left = numStack.top();
	numStack.pop();
	numStack.push(left/right);
      } else {
	numStack.push(atoi(token));
      } 
    }

    int answer = numStack.top();
    numStack.pop();
    if(numStack.empty() && correct) cout<<"Answer: "<<answer<<endl;
    else cout<<"Incorrect format"<<endl;

    for(int x = strlen(expression); x>0; x--) expression[x] = '\0';
    cout<<"Enter a postfix expression or \"exit\": "<<endl;
    cin>>expression;  
  }
  return 0;
}
