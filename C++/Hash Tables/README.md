Run the shorter test with ./dictionary_test and the longer test with ./dictionary_test_grading

This dictionary implementation uses a hash table with two levels. When the dictionary is first constructed using bulkInsert the function will generate a hash table with the
first layer having a size of the square root of the number of inserted elements rounded up. The first level will continuously generate a random matrix for the first hash function
until the sum of squares of the number of elements in each bucket is at most four times the total number of elements. Within each bucket, a second hash function is randomly 
generated until there are no collisions. The size of the second layer buckets is the square of the size of their corresponding first level buckets. Any collisions that occur after 
the initial bulkInsert is resolved with separate chaining.
