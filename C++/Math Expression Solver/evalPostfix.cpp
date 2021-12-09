// Corey Zhou

#include "arrayStack.h"
#include "infixToPostfix.h"
#include <iostream>

int main(){
  string infix;
	string postfix;
  bool correct = true;
  arrayStack<int> numStack; 

	while(true){
		cout<<"Enter an infix expression or \"exit\": "<<endl;
		cin>>infix;
		if(infix == "exit") break;
		postfix = infixToPostfix(infix);
		cout<<"Postfix: "<<postfix<<endl;

		if(postfix != ""){
			for(int i=0; i<postfix.length(); i++){
				char token = postfix[i];
				switch(token){
					int left;
					int right;

					case '+':
						right = numStack.top();
						numStack.pop();
						left = numStack.top();
						numStack.pop();
						numStack.push(left+right);
						break;
					case '-':			
						right = numStack.top();
						numStack.pop();
						left = numStack.top();
						numStack.pop();
						numStack.push(left-right);
						break;
					case '*':
						right = numStack.top();
						numStack.pop();
						left = numStack.top();
						numStack.pop();
						numStack.push(left*right);
						break;
					case '/':
						right = numStack.top();
						numStack.pop();
						left = numStack.top();
						numStack.pop();
						numStack.push(left/right);
						break;
					default:
						numStack.push(atoi(&token));
				}
			}
	   
			int answer = numStack.top();
			numStack.pop();
			if(numStack.empty()) cout<<"Answer: "<<answer<<endl;
			else cout<<"Incorrect format"<<endl;
		}
	}
  return 0;
}
