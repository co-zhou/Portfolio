import numpy
import random
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import SVC
from sklearn.neural_network import MLPClassifier
from sklearn import preprocessing

labels = {
    "Pikachu": 0,
    "Bulbasaur": 1,
    "Squirtle": 2,
    "Charmander": 3,
    "Gastly": 4,
    "Jigglypuff": 5,
    "Pidgey": 6,
    "Sudowoodo": 7
}

inv_labels = {v: k for k, v in labels.items()}

def processFeatures(x):
    genders = {
        'F': 0,
        'M': 1
    }

    arr = []
    
    for a in x:
        t = list(a)
        t[-1] = genders[t[-1]]
        arr.append(t)
    return preprocessing.normalize(arr, axis = 0)

def processLabels(y):
    arr = [None] * len(y)
    
    for i in range(len(y)):
        arr[i] = labels[y[i]]

    return arr

def confusion(f, x, y):
    confusion = numpy.zeros((8,8))
    
    predictY = f.predict(x)
    for a in range(len(y)):
        confusion[predictY[a]][y[a]] +=1
        
    return confusion

def predictTest(f):
    testX = processFeatures(numpy.load("pokemon_test_x.npy"))
    return f.predict(testX)      

def K_Nearest_Neighbors(trainX, trainY, validationX, validationY):
    f = KNeighborsClassifier(n_neighbors = 19, weights = 'distance')
    f.fit(trainX,trainY)
    print(f.score(validationX, validationY))
    
    return confusion(f, validationX, validationY)

def Linear_Discriminant_Analysis(trainX, trainY, validationX, validationY):
    f = LinearDiscriminantAnalysis(solver='eigen', shrinkage='auto')
    f.fit(trainX,trainY)
    print(f.score(validationX, validationY))

    numpy.save("Classification_Results.npy", predictTest(f))
    return confusion(f, validationX, validationY)

def Naive_Bayes(trainX, trainY, validationX, validationY):
    f = GaussianNB(var_smoothing=(10**-3))
    f.fit(trainX,trainY)
    print(f.score(validationX, validationY))

    return confusion(f, validationX, validationY)

def Decision_Tree(trainX, trainY, validationX, validationY):
    f = DecisionTreeClassifier(criterion='entropy')
    f.fit(trainX,trainY)
    print(f.score(validationX, validationY))

    return confusion(f, validationX, validationY)
    
def SVM(trainX, trainY, validationX, validationY):
    f = SVC(gamma='scale')
    f.fit(trainX,trainY)
    print(f.score(validationX, validationY))

    return confusion(f, validationX, validationY)

def Neural_Network(trainX, trainY, validationX, validationY):
    f = MLPClassifier(solver='adam', learning_rate='adaptive',
                      learning_rate_init=.01, max_iter=1000)
    f.fit(trainX,trainY)
    print(f.score(validationX, validationY))

    return confusion(f, validationX, validationY)

if __name__== "__main__":
    X = processFeatures(numpy.load('pokemon_train_x.npy'))
    y = processLabels(numpy.load('pokemon_train_y.npy'))

    z = list(zip(X,y))
    random.shuffle(z)
    X, y = zip(*z)

    print(X)

    percentTraining = 0.8
    trainX = X[:int(percentTraining*len(X))]
    trainY = y[:int(percentTraining*len(y))]
    validationX = X[int((1 - percentTraining)*len(X)):]
    validationY = y[int((1 - percentTraining)*len(y)):]

##    numpy.save("Neighbors_Confusion.npy", K_Nearest_Neighbors(trainX, trainY, validationX, validationY))
##    numpy.save("LDA_Confusion.npy", Linear_Discriminant_Analysis(trainX, trainY, validationX, validationY))
##    numpy.save("Bayes_Confusion.npy", Naive_Bayes(trainX, trainY, validationX, validationY))
##    numpy.save("Tree_Confusion.npy", Decision_Tree(trainX, trainY, validationX, validationY))
##    numpy.save("SVM_Confusion.npy", SVM(trainX, trainY, validationX, validationY))
##    numpy.save("MLP_Confusion.npy", Neural_Network(trainX, trainY, validationX, validationY))
