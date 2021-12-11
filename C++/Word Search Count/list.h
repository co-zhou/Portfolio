// Corey Zhou
// Project 2

#ifndef LIST_H
#define LIST_H
#include <cassert>
#include <cstdlib>
#include <iostream>
using namespace std;

template <class Item>
class list {
public:
    list(list<Item>* l=NULL, list<Item>* p=NULL)
    {
        link_field = l;
        prev_field = p;
        empty = true;
    }
    
    void set_data(const Item& d) {
      data_field = d;
      empty = false;
    }
    void set_link(list<Item>* l) {link_field = l;}
    void set_prev(list<Item>* p) {prev_field = p;}

    Item data() const {return data_field;}
    bool isEmpty() const {return empty;}
    list<Item>* link() {return link_field;}
    const list<Item>* link() const {return link_field;}
    list<Item>* prev() {return prev_field;}
    const list<Item>* prev() const {return prev_field;}
    
private:
    Item data_field;
    bool empty;
    list<Item>* link_field;
    list<Item>* prev_field;
};

template <class Item>
void insert(list<Item>* head, list<Item>* prevPtr, const Item* itemName){
	if(head->isEmpty()){
		head->set_data(*itemName);
    return;
  }

  list<Item>* temp = new list<Item>();
  temp->set_data(*itemName);

  temp->set_prev(prevPtr);
  if(prevPtr == NULL){
    temp->set_link(head);
    head = temp;
  } else {
    temp->set_link(prevPtr->link());
    prevPtr->set_link(temp);
  }
  if(temp->link()!=NULL){
    (temp->link())->set_prev(temp);
  }
}

template <class Item>
void deletePtr(list<Item>* head, list<Item>* ptr){
  if(ptr == head){
    head = ptr->link();
		ptr->prev() = NULL;
    delete ptr;
  } else {
    ptr->prev()->set_link(ptr->link());
    ptr->link()->set_prev(ptr->prev());
    delete ptr;
  }
}

#endif
