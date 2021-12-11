Run the program using ./wordsearchcount input

This program first stores how many times each word appears in each text document. 
Then you can input any word and the program will either print out every file with its word count or will say the word was not found. 
The "input" command line argument can be any directory that contains only text files.
The dictionary of words is an array of word objects, each containing the word name and a pointer to a linked list object.
The data this list stores is a file (itemtype) object that contains a file name and the count of the specific word in that file.
