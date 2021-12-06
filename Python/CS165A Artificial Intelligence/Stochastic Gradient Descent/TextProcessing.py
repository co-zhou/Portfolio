import numpy
from scipy.sparse import csr_matrix
from sklearn.linear_model import LogisticRegression
from math import log

def generate_word_collection(file_name):
    f = open(file_name, encoding='ISO-8859-1')
    word_collection = []
    for line in f:
        for word in line.split(' ')[:-1]:
            if word not in word_collection:
                word_collection.append(word)
    
    return sorted(word_collection)

def bag_of_word_encoding(sentence, word_collection):
    row = []
    col = []
    count = []
    for word in sentence.split():
        colNum = word_collection.index(word)
        if colNum not in col:
            row.append(0)
            col.append(colNum)
            count.append(float(sentence.split().count(word)))
    return csr_matrix((count, (row, col)), shape=(1, len(word_collection)))

def N_Gram(sentence, N):
    n_gram_list = []
    for i in range(len(sentence.split())-N+1):
        n_gram_list.append(" ".join(sentence.split()[i:i+N]).strip())

    return n_gram_list

def get_TF(term, document):
    return document.split().count(term)/len(document.split())

def get_IDF(term, file_name):
    f = open(file_name, encoding='ISO-8859-1')
    totalDoc = 0
    numInDoc = 0
    for line in f:
        if term in line.split():
            numInDoc += 1
        totalDoc += 1
    return log(totalDoc/numInDoc)

def get_TF_IDF(term, document, filename):
    return get_TF(term, document) * get_IDF(term, filename)

def TF_IDF_encoding(word_collection, filename, document):
    row = []
    col = []
    data = []
    for word in document.split():
        colNum = word_collection.index(word)
        if colNum not in col:
            num = get_TF_IDF(word, document, filename)
            row.append(0)
            col.append(word_collection.index(word))
            data.append(num)

    return csr_matrix((data, (row, col)), shape=(1, len(word_collection)))

if __name__ == "__main__":
    sentence = "wish for solitude he was twenty years of age "
    word_collection = generate_word_collection("training.txt")
    print(bag_of_word_encoding(sentence, word_collection))
    print(N_Gram(sentence, 3))
    print(TF_IDF_encoding(word_collection, "training.txt", sentence)) 
