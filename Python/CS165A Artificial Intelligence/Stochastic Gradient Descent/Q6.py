import numpy
from scipy.sparse import csr_matrix
from math import log
import matplotlib.pyplot as plt

fullErr = []
stochasticErr = []
lamdaErr = []

def inference(theta, x):
    y = numpy.exp(csr_matrix(theta.T).dot(x).toarray())
    expSum = y.sum()
    return numpy.log(y/expSum).flatten()

def gradient(theta, x, y):
    expVector = numpy.exp(csr_matrix(theta.T).dot(x).toarray())
    expSum = expVector.sum()
    yHat = (expVector/expSum).T[0]
    yHat[y-1] -= 1
    yHat = csr_matrix(yHat)
    
    return yHat.multiply(x).toarray()

def full_gradient(theta, x, y, lamda):
    grad = numpy.zeros(theta.shape)
    
    for i in range(len(y)):
        grad += gradient(theta, x[i], y[i])
        
    return (grad / len(y)) + (2 * lamda * theta)

def stochastic_gradient(theta, x, y, lamda):
    i = numpy.random.randint(len(y))
        
    return gradient(theta, x[i], y[i]) + (2 * lamda * theta)

def error(theta, x, y):
    err = 0
    for i in range(len(y)):
        err -= inference(theta, x[i])[y[i]-1]

    return err

def train(theta, learningRate, n, function, x, y, lamda):
    new = theta
    for i in range(n):
        if function == full_gradient:
            new = new - (learningRate/(i+1)) * function(theta, x, y, lamda)
            fullErr.append(error(new, x, y))      
        else:
            for j in range(len(y)):
                new = new - (learningRate/(3000*i+j+1)) * function(theta, x, y, lamda)
            stochasticErr.append(error(new, x, y))
    return new

def generate_word_collection(file_name):
    f = open(file_name, encoding='ISO-8859-1')
    word_collection = []
    for line in f:
        for word in line.split()[:-1]:
            if word not in word_collection:
                word_collection.append(word)
    
    return sorted(word_collection)

if __name__ == '__main__':
    numpy.random.seed(93106)
    
##    file = "testing.txt"
##    f = open(file, encoding='ISO-8859-1')
##    word_collection = generate_word_collection("training.txt")
##
##    numpy.save("word_collection.npy", word_collection)
##    print("Generated Word Collection")  
##
##    x = []
##    y = []
##    listCount = []
##    wordCount = []
##    numDocWithTerm = {}
##    numDoc = 0
##    
##    for document in f:
##        lst = {}
##        count = 0
##        for word in document.split()[:-1]:
##            if word not in lst:
##                lst.update({word: 1})
##                if word not in numDocWithTerm:
##                    numDocWithTerm.update({word: 1})
##                else:
##                    numDocWithTerm[word] += 1
##            else:
##                lst[word] += 1
##            count += 1
##        listCount.append(lst)
##        wordCount.append(count)
##        numDoc += 1
##        y.append(int(document.rsplit(' ', 1)[1][1:]))
##
##    print("Finished First Loop")
##    
##    for i in range(numDoc):
##        row = []
##        col = []
##        data = []
##        for word in listCount[i]:
##            num = (listCount[i][word]/wordCount[i]) * log(numDoc/numDocWithTerm[word])
##            col.append(0)
##            row.append(word_collection.index(word))
##            data.append(num)
##        x.append(csr_matrix((data, (row, col)), shape=(len(word_collection), 1)))
##
##    numpy.save("testX.npy", x)
##    numpy.save("testY.npy", y)
    
##    word_collection = numpy.load("word_collection.npy")
##    x = numpy.load("trainX.npy", allow_pickle=True)
##    y = numpy.load("trainY.npy", allow_pickle=True)
##
##    learningRate = 44000
##    theta = numpy.zeros((len(word_collection), 15))
##    
##    fullErr.append(error(theta, x,y))
##    thetaF = train(theta, learningRate, 10, full_gradient, x, y, 1)
##    print(fullErr)
##    numpy.save("fullTrainErr.npy", fullErr)
    
##    stochasticErr.append(error(theta, x, y))
##    thetaS = train(numpy.zeros((len(word_collection), 15)), 0.1, 10, stochastic_gradient, x, y, 1)
##    print(stochasticErr)
##    numpy.save("stochasticTestErr.npy", stochasticErr)

##    for i in range(-5, 4, 1):
##        print(i)
##        thetaS = train(numpy.zeros((len(word_collection), 15)), 0.1, 10, stochastic_gradient, x, y, 10**i)
##        lamdaErr.append(error(thetaS, x, y))
##        numpy.save("lamdaErr.npy", lamdaErr)

    y = numpy.load("lamdaErr.npy")
    x = numpy.geomspace(0.00001, 1000, 9)
    plt.plot(x, y)
    plt.title("Q6f")
    plt.xscale("log")
    plt.yscale("log")
    plt.show()
