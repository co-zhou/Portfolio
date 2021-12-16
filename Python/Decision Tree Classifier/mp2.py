import numpy
from copy import deepcopy
from math import log

def impurity(labels):
    p = labels.count(1)/len(labels)
    result = 0
    if (p > 0) and (p < 1):
        result = -p*log(p, 2)-(1-p)*log(1-p, 2)
    return result

def bestSplit(node):
    imp = impurity(node[3])
    featureNumber = None
    barrier = 0
    children = []
    zipped = zip(node[2], node[3])
    
    for featureNum in range(len(node[2][0])):
        if featureNum not in node[0]:
            zipped = sorted(list(zipped), key = lambda x: x[0][featureNum])
            features, labels = map(list, zip(*zipped))
            for i in range(len(labels)-1):
                if features[i][featureNum] < features[i+1][featureNum]:
                    temp = ((i+1)/len(node[3]))*impurity(labels[:i+1]) + ((len(node[3])-i-1)/len(node[3]))*impurity(labels[i+1:])
                    if imp > temp:
                        imp = temp
                        featureNumber = featureNum
                        barrier = (features[i][featureNum] + features[i+1][featureNum])/2
                        children = [[features[:i+1], labels[:i+1]], [features[i+1:], labels[i+1:]]]
    return featureNumber, barrier, children

def growTree(root, threshold, depth):
    if (impurity(root[3]) > threshold) and (len(root[0]) < depth):
        temp1 = bestSplit(root)
        root[0].append(temp1[0])
        if temp1[0] is None:
            if root[3].count(1)/len(root[3]) > 0.5:
                root[5] = 1
        else:
            root[1] = temp1[1]
            child0 = [deepcopy(root[0]), 0, temp1[2][0][0], temp1[2][0][1], [], 0, 2*root[6]]
            child1 = [deepcopy(root[0]), 0, temp1[2][1][0], temp1[2][1][1], [], 0, 2*root[6]+1]
            root[4] = [child0, child1]
            growTree(child0, threshold, depth)
            growTree(child1, threshold, depth)

    elif root[3].count(1)/len(root[3]) > 0.5:
        root[5] = 1

def run_train_test(training_data, training_labels, testing_data):
    """
    Implement the training and testing procedure here. You are permitted
    to use additional functions but DO NOT change this function definition.

    Inputs:
        training_data: List[List[float]]
        training_label: List[int]
        testing_data: List[List[float]]

    Output:
        testing_prediction: List[int]
    Example:
    return [1]*len(testing_data)
    """

    # Node = [[features used], threshold using the last feature, [features],
    #         [labels], [children], output label, node number]
    top = [[], 0, training_data, training_labels, [], 0, 1]
    threshold = 0.2
    depth = 3

    growTree(top, threshold, depth)
    testingLabels = []
    for sample in testing_data:
        it = top
        while len(it[4]) > 0:
            if sample[it[0][-1]] <= it[1]:
                it = it[4][0]
            else:
                it = it[4][1]
        testingLabels.append(it[5])
    return testingLabels
