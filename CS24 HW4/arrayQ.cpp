#include <cassert>

template <class Item>
void arrayQ<Item>::enq(const Item& entry)
{
    // check if you can add
    assert(size < 30);
    // add element to the rear of the Queue
    data[rear] = entry;
    rear = (rear + 1) % 30; // BAD CODE by DA
    
    size++;
}

template <class Item>
void arrayQ<Item>::deq()
{
    // check if stack is empty
    assert(size > 0);
    // remove element from the front of the Queue
    front = (front + 1) % 30; 
    size--;
}

template <class Item>
Item arrayQ<Item>::qfront()
{
    // check stack not empty
    assert(size > 0);
    // return the front element
    return data[front];
}


