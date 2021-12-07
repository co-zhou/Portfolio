# Starter code 

def run_train_test(training_input, testing_input):
    """
    Implement the training and testing procedure here. You are permitted
    to use additional functions but DO NOT change this function definition.
    You are permitted to use the numpy library but you must write
    your own code for the linear classifier.

    Inputs:
        training_input: list form of the training file
            e.g. [[3, 5, 5, 5],[.3, .1, .4],[.3, .2, .1]...]
        testing_input: list form of the testing file

    Output:
        Dictionary of result values

        IMPORTANT: YOU MUST USE THE SAME DICTIONARY KEYS SPECIFIED

        Example:
            return {
                "tpr": #your_true_positive_rate,
                "fpr": #your_false_positive_rate,
                "error_rate": #your_error_rate,
                "accuracy": #your_accuracy,
                "precision": #your_precision
            }
    """

    import numpy as np

    trainA = training_input[1:training_input[0][1]+1]
    trainB = training_input[training_input[0][1]+1:training_input[0][1]+training_input[0][2]+1]
    trainC = training_input[training_input[0][1]+training_input[0][2]+1:]

    centroidA = np.sum(trainA, axis = 0)/len(trainA)
    centroidB = np.sum(trainB, axis = 0)/len(trainB)
    centroidC = np.sum(trainC, axis = 0)/len(trainC)

    t_AB = 0.5*(np.dot((centroidA+centroidB).T, (centroidA-centroidB)))
    w_AB = centroidA-centroidB
    t_AC = 0.5*(np.dot((centroidA+centroidC).T, (centroidA-centroidC)))
    w_AC = centroidA-centroidC
    t_BC = 0.5*(np.dot((centroidB+centroidC).T, (centroidB-centroidC)))
    w_BC = centroidB-centroidC

    confusionMatrix = np.zeros((3,3))

    for i in range(1, len(testing_input)):
        actual = 2
        if i < testing_input[0][1]+1:
            actual = 0
        elif i < testing_input[0][1]+testing_input[0][2]+1:
            actual = 1
        
        predicted = 2
        if np.dot(np.array(testing_input[i]).T, w_AB) >= t_AB:
            if np.dot(np.array(testing_input[i]).T, w_AC) >= t_AC:
                predicted = 0
        else:
            if np.dot(np.array(testing_input[i]).T, w_BC) >= t_BC:
                predicted = 1

        confusionMatrix[predicted][actual] += 1

    dictionary = { "tpr": 0,
                   "fpr": 0,
                   "error_rate": 0,
                   "accuracy": 0,
                   "precision": 0 }

    dictionary["tpr"] = sum([confusionMatrix[i][i]/np.sum(confusionMatrix, axis = 0)[i] for i in range(3)])/3
    dictionary["fpr"] = sum([(sum(confusionMatrix[i])-confusionMatrix[i][i])/(np.sum(confusionMatrix)-np.sum(confusionMatrix, axis = 0)[i]) for i in range(3)])/3
    dictionary["error_rate"] = sum([(sum(confusionMatrix[i])+np.sum(confusionMatrix, axis = 0)[i]-2*confusionMatrix[i][i])/np.sum(confusionMatrix) for i in range(3)])/3
    dictionary["accuracy"] = sum([(np.sum(confusionMatrix)-sum(confusionMatrix[i])-np.sum(confusionMatrix, axis = 0)[i]+2*confusionMatrix[i][i])/np.sum(confusionMatrix) for i in range(3)])/3
    dictionary["precision"] = sum([confusionMatrix[i][i]/sum(confusionMatrix[i]) for i in range(3)])/3

    return dictionary
