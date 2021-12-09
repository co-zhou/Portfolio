Run the program using evalPostFix

This program is a simple calculator that solves the mathematical expression in infix format. It only supports the basic mathematical operators ("+", "-", "\*", "/")
and single digit integers (0-9). The program will not follow standard order of operations, but will follow parentheses.
Every operator needs to have parentheses around it for the program to work. Ex: ((4*(3+2))-(8/4)) = 18

The program stores the operators in a stack to convert the string from infix to postfix notation, then it stores the integers in another stack to solve the postfix expression.
