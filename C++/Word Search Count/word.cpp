// Corey Zhou

#include "word.h"

word::word(string name){
  word_name = name;
  filesListHead = new list<itemtype>();
}

string word::wordname() const{
  return word_name;
}

void word::addFile(string fileName){
  list<itemtype>* iterator = filesListHead;

	while(true){
		if(!iterator->isEmpty() && iterator->data().filename() == fileName){
			iterator->set_data(itemtype(fileName, iterator->data().count()+1));
			return;
		}
		if(iterator->link() == NULL) break;
		iterator = iterator->link();
	}
	
	itemtype* file = new itemtype(fileName, 1);
  insert(filesListHead, iterator, file);
  
}

void word::printFiles(){
  for(list<itemtype>* ptr = filesListHead; ptr != NULL; ptr = ptr->link()){
    cout << "File: " << ptr->data().filename() << endl;
  }
}

void word::printFilesThreshold(int threshold){
  bool found = false;
  for(list<itemtype>* ptr = filesListHead; ptr != NULL; ptr = ptr->link()){
		if(ptr->data().count() >= threshold){
      cout << "File: " << ptr->data().filename() << "; Count: " << ptr->data().count() << endl;
      found = true;
    }
  }
  if(!found) cout << "Files not found that meet the threshold" << endl;
}
