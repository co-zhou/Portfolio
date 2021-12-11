// Corey Zhou
// Project 1

#include "wordsearchcount.h"

int getdir (string dir, vector<string> &files)
{
  DIR *dp;
  struct dirent *dirp;
  if((dp  = opendir(dir.c_str())) == NULL) {
    cout << "Error(" << errno << ") opening " << dir << endl;
    return errno;
  }

  while ((dirp = readdir(dp)) != NULL) {
    files.push_back(string(dirp->d_name));
  }
  closedir(dp);
  return 0;
}

int main(int argc, char* argv[])
{
  string dir;
  vector<string> files = vector<string>();

  if (argc < 2){
  	cout << "No Directory specified; Exiting ..." << endl;
    return(-1);
  }
  dir = string(argv[1]);
  if (getdir(dir,files)!=0){
    cout << "Error opening " << dir << "; Exiting ..." << endl;
    return(-2);
  }
  
  string slash("/");
  word listOfWords[200000];
  int size = 0;
  for (unsigned int i = 0; i < files.size(); i++) {
    if(files[i][0]=='.') continue; //skip hidden files
    ifstream fin((string(argv[1])+slash+files[i]).c_str()); //open using absolute path
    // ...read the file...
    string word1;
    while(true){
      fin>>word1;
      if(fin.eof()) {
				cout << "EOF " << files[i] << endl;
				break;
      } else {
				//cout<<files[i]<<"::"<<word1<<endl;
				// Now the string "word" holds the keyword, and the string "files[i]" holds the document name.
				// Use these two strings to search/insert in your array/list of words.
				int j = 0;
				while(true){
	  			if(j == size || listOfWords[j].wordname() == word1){
	    			if(j == size) {
	      			listOfWords[j] = word(word1);
	      			size++;
	    			}
	    			listOfWords[j].addFile(files[i]);
	    			break;
	  			}
	  			j++;
				}
      }
    }
    fin.close();
  }
  
  cout << "\nThis is the next part of the program " << endl;
  string input;
  while(true){
    cout << "Enter word or \"exit\": ";
    cin >> input;
    if(input == "exit") break;
    int i = 0;
    while(i<size){
      if(input == listOfWords[i].wordname()){
				listOfWords[i].printFilesThreshold(1);
				break;
      }
      i++;
    }    
    if(i == size) cout << "Word not found" << endl << endl;
  }
  return 0;
}
