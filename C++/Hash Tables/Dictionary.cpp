// Implement Dictionary methods.
#include "Dictionary.h"

void Dictionary::bulkInsert(int n, string *keys) {
	srand(time(0));
	int numRows = 1;
	if(n > 1) numRows = (int) ceil(log2(n));
	int numTrials = 0;
       	int sumSquares;
	int numInBucket[n];
	int bucketNum[n];

	size1 = n;
	do{
		sumSquares = 0;
		for(int i = 0; i < n; i++)
			numInBucket[i] = 0;
		if(hash1 != NULL) delete hash1;
		hash1 = getRandMatrix(numRows);
		for(int i = 0; i < n; i++){
			int hash = getHash(hash1, numRows, keys[i]) % n;
			bucketNum[i] = hash;
			numInBucket[hash]++;
		}
		for(int i = 0; i < n; i++)
			sumSquares += pow(numInBucket[i],2);
		numTrials++;
	} while (sumSquares >= 4 * n);
	cout << "hash1(x):" << endl;
	printMatrix(hash1, numRows);
	cout << "Number of trials for hash1(x) = " << numTrials << endl;
	cout << "Sum of Squares = " << sumSquares << endl;
	size2 = new int[n];
	hash2 = new int**[n];
	hashTable = new Node**[n];
	/*
	for(int i = 0; i < n; i++)
		cout << numInBucket[i] << " ";
	cout << endl;
        for(int i = 0; i < n; i++)
                cout << bucketNum[i] << " ";
	cout << endl;
	*/
	for(int i = 0; i < n; i++){
		hash2[i] = NULL;
		if(numInBucket[i] == 0){
			hashTable[i] = build2ndHash(0, NULL, i);
		} else {
			string keysInBucket[numInBucket[i]];
			int count = 0;
			for(int j = 0; j < n; j++){
				if(bucketNum[j] == i) keysInBucket[count++] = keys[j];
			}
			hashTable[i] = build2ndHash(numInBucket[i], keysInBucket, i);
		}
	}
	
}

void Dictionary::insert(string key) {
	int numRows = 1;
        if(size1 > 1) numRows = (int) ceil(log2(size1));
        int bucketNum1 = getHash(hash1, numRows, key) % size1;
	int bucketNum2 = 0;
	if(size2[bucketNum1] > 1){
        	numRows = (int) ceil(log2(size2[bucketNum1]));
        	bucketNum2 = getHash(hash2[bucketNum1], numRows, key) % size2[bucketNum1];
	}
        for(Node* n = hashTable[bucketNum1][bucketNum2]; n != NULL; n = n->next){
                if(key.compare(n->key) == 0){
                        cout << "\"" << key << "\" is already in bucket (" << bucketNum1 << "," << bucketNum2 << ")" << endl;
                        return;
                }
        }
        Node *n = new Node{key, hashTable[bucketNum1][bucketNum2]};
	if(hashTable[bucketNum1][bucketNum2] != NULL) cout << "Collision in bucket (" << bucketNum1 << "," << bucketNum2 << ")" << endl;
	hashTable[bucketNum1][bucketNum2] = n;
	cout << "\"" << key << "\" inserted in bucket (" << bucketNum1 << "," << bucketNum2 << ")" << endl;
}

void Dictionary::remove(string key) {
	int numRows = 1;
        if(size1 > 1) numRows = (int) ceil(log2(size1));
        int bucketNum1 = getHash(hash1, numRows, key) % size1;
        int bucketNum2 = 0;
        /*
        if(size2[bucketNum1] == 0) {
                cout << "\"" << key << "\" was not found: ";
                return false;
        }
        */
        numRows = 1;
        if(size2[bucketNum1] > 1) {
                numRows = (int) ceil(log2(size2[bucketNum1]));
                bucketNum2 = getHash(hash2[bucketNum1], numRows, key) % size2[bucketNum1];
        }
        /*
        if(size2[bucketNum1] > 1) numRows = (int) ceil(log2(size2[bucketNum1]));
        int bucketNum2 = getHash(hash2[bucketNum1], numRows, key) % size2[bucketNum1];
        */
        Node *prev = NULL;
	Node *cur = hashTable[bucketNum1][bucketNum2];
        while(cur != NULL){
                if(key.compare(cur->key) == 0){
			if(prev == NULL) hashTable[bucketNum1][bucketNum2] = cur->next;
			else prev->next = cur->next;
			delete cur;
                        cout << "\"" << key << "\" was removed from bucket (" << bucketNum1 << "," << bucketNum2 << ")" << endl;
                	return;
		}
		prev = cur;
		cur = cur->next;
        }
	cout << "\"" << key << "\" was not found and not removed" << endl;
}

bool Dictionary::find(string key) {
	int numRows = 1;
        if(size1 > 1) numRows = (int) ceil(log2(size1));
	int bucketNum1 = getHash(hash1, numRows, key) % size1;
	int bucketNum2 = 0;
	/*
	if(size2[bucketNum1] == 0) {
	        cout << "\"" << key << "\" was not found: ";
		return false;
	}
	*/
	numRows = 1;
        if(size2[bucketNum1] > 1) {
		numRows = (int) ceil(log2(size2[bucketNum1]));
        	bucketNum2 = getHash(hash2[bucketNum1], numRows, key) % size2[bucketNum1];
	}
	/*
        if(size2[bucketNum1] > 1) numRows = (int) ceil(log2(size2[bucketNum1]));
	int bucketNum2 = getHash(hash2[bucketNum1], numRows, key) % size2[bucketNum1];
	*/
	for(Node* n = hashTable[bucketNum1][bucketNum2]; n != NULL; n = n->next){
		if(key.compare(n->key) == 0){
			cout << "\"" << key << "\" was found in bucket (" << bucketNum1 << "," << bucketNum2 << "): ";
			return true;
		}
	}
	cout << "\"" << key << "\" was not found: ";
	return false;
}

int** Dictionary::getRandMatrix(int x) {
	// length of key is always 48 bits long
	int** matrix = new int*[x];
	for(int i = 0; i < x; i++){
		matrix[i] = new int[48];
	}

	for(int i = 0; i < x; i++){
		for(int j = 0; j < 48; j++){
			matrix[i][j] = rand() % 2;
		}
	}

	return matrix;
}

int Dictionary::getHash(int** matrix, int x, string key) {
	for(int i = key.length(); i < 8; i++)
		key.push_back(' ');
	string str = key.substr(key.length()-8,8);
	long long int asciiSum = 0;
	for(int i = 0; i < 8; i++)
		asciiSum += (static_cast<int>(str.at(i))) * pow(53,i);
	int keyVector[48];
	for(int i = 0; i < 48; i++){
		keyVector[47-i] = asciiSum % 2;
		asciiSum /= 2;
	}
	int hashVector[x] = {};
	for(int i = 0; i < x; i++){
		for(int j = 0; j < 48; j++){
			hashVector[i] += (matrix[i][j]*keyVector[j]);
		}
		hashVector[i] = hashVector[i] % 2;
	}
	int hash = 0;
	for(int i = 0; i < x; i++){
		hash += (hashVector[x-i-1]*pow(2,i));
	}
	return hash;
}

Dictionary::Node** Dictionary::build2ndHash(int n, string *keys, int bucketNum) {
	size2[bucketNum] = n*n;
	if(n == 0){
		Node** arr = new Node*[1];
		arr[0] = NULL;
		cout << "Bucket " << bucketNum << " is empty" << endl;
		return arr;
	}
	Node** arr = new Node*[n*n];
	bool collision;
	int count = 0;
	int numRows = 1;
	if(n > 1) numRows = (int) ceil(log2(n*n));
	do{
		count++;
		collision = false;
		for(int i = 0; i < n*n; i++)
			arr[i] = NULL;
		if(hash2[bucketNum] != NULL) delete hash2[bucketNum];
		hash2[bucketNum] = getRandMatrix(numRows);
		for(int i = 0; i < n; i++){
			int hash = getHash(hash2[bucketNum], numRows, keys[i]) % (n*n);
			if(arr[hash] != NULL){
				collision = true;
			} else {
				arr[hash] = new Node{keys[i],NULL};
			}
		}
	} while (collision);
	cout << "hash2_" << bucketNum << "(x):" << endl;
	printMatrix(hash2[bucketNum], numRows);
	cout << "Number of trials for second hash for bucket " << bucketNum << " = " << count << endl;
	cout << endl;
	return arr;
}

void Dictionary::printMatrix(int** matrix, int x){
        for(int i = 0; i < x; i++){
                for(int j = 0; j < 48; j++){
                        cout << matrix[i][j] << " ";
                }
                cout << endl;
        }
}

