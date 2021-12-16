#include <cassert>
#include <iostream>

template <class Item>
void arrayStack<Item>::push(const Item& entry)
{
    // check if you can add
    assert(used < 30);
    // add node to the top of the stack
    data[used++]=entry;
}

template <class Item>
void arrayStack<Item>::pop()
{
    // check if stack is empty
    assert(used > 0);
    // remove node from the top of the stack
    used = used-1;
}

template <class Item>
Item arrayStack<Item>::top()
{
	// check stack not empty
	assert(used > 0);
	// return the top element
    return data[used-1];
}


