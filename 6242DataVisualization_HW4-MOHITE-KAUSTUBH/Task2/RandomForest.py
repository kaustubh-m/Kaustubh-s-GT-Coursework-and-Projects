import csv
import numpy as np  # http://www.numpy.org
import ast 
from numpy import random
import math
import pdb
from random import randrange
from random import seed

np.random.seed(1)
seed(1)


"""
Here, X is assumed to be a matrix with n rows and d columns
where n is the number of total records
and d is the number of features of each record
Also, y is assumed to be a vector of d labels

XX is similar to X, except that XX also contains the data label for
each record.
"""

"""
This skeleton is provided to help you implement the assignment. It requires
implementing more that just the empty methods listed below. 

So, feel free to add functionalities when needed, but you must keep
the skeleton as it is.
"""

###############################################################
#
#References:
#http://machinelearningmastery.com/implement-random-forest-scratch-python/
#https://www.analyticsvidhya.com/blog/2016/04/complete-tutorial-tree-based-modeling-scratch-in-python/
#
###############################################################

class RandomForest(object):
    class __DecisionTree(object):
        def __init__(self): self.tree = {} # this line changed

        # Given a dataset, an attribute number, and a threshold, perform a two-way split: XX1 = left, XX2 = right
        def twoWaySplit(self, XX, attrNo, threshold):
            XX1, XX2 = list(), list()
            
            for row in XX:

                if row[attrNo] < threshold:
                    XX1.append(row)
                else:
                    XX2.append(row)
                
            
            return XX1, XX2
            
        
        # Given a dataset, unique values of the output classification, find Gini Index of the System  
        def gini(self, unqOPClass, dataSeg):
            
            gIndex = 0.0
            
            for q in unqOPClass:
                for ds in dataSeg:
                    nRow = len(ds)
                    if(nRow == 0):
                        continue
                    countRatio = [row[-1] for row in ds].count(q) / float(nRow)
                    gIndex += (countRatio * (1.0 - countRatio))
            
            return gIndex
                
            
        
        # Given a dataset and the number of attributes contained, find the feature to split the dataset on using Gini index
        def selectSplit(self, X, y, nAttr):
            
            XX = X            
            if (len(X[0]) < 12):
                [XX[i].append(y[i]) for i in range(len(XX))]
                
                        
                
            unqOPClass = list(set(row[-1] for row in XX))
            selAttr, selThresh, selGScore, selDataSeg = 999, 999, 999, None
            attr = list()
            while len(attr) < nAttr:
                tempAttr = randrange(len(XX[0])-1)
                #int(np.random.randint(0,len(XX[0])-1, 1))
                if tempAttr not in attr:
                    attr.append(tempAttr)

            for tempAttr in attr:
                for row in XX:
                    
                    dataSeg = self.twoWaySplit(XX, tempAttr, row[tempAttr])
                    
                    gIndex = self.gini(unqOPClass, dataSeg)
                    if gIndex < selGScore:
                        selAttr, selThresh, selGScore, selDataSeg = tempAttr, row[tempAttr], gIndex, dataSeg
            
            return {'attrNo':selAttr, 'threshold':selThresh, 'dataSeg': selDataSeg}
            
        
        # Given a data segment, return the terminal node
        def to_terminal(self, dataSeg):
            
            OPClass = [row[-1] for row in dataSeg]
            return max(set(OPClass), key = OPClass.count)
            
        
        # Recursively split on a node, or terminate
        def recSplit(self, node, max_depth, min_size, nAttr, depth):
            XX1, XX2 = node['dataSeg']
            del (node['dataSeg'])
            
            # Return if there is an empty split
            if not XX1 or not XX2:
                node['XX1'] = node['XX2'] = self.to_terminal(XX1 + XX2)
                
                return
                
            # Return if max_depth has been reached
            if depth >= max_depth:
                node['XX1'], node['XX2'] = self.to_terminal(XX1), self.to_terminal(XX2)
                return
                
            # Split or terminate: 'left' segment
            if len(XX1) <= min_size:
                node['XX1'] = self.to_terminal(XX1)
            else:
                node['XX1'] = self.selectSplit(XX1, [0]*len(XX1), nAttr)
                self.recSplit(node['XX1'], max_depth, min_size, nAttr, depth+1)
                
            # Split or terminate: 'right' segment
            if len(XX2) <= min_size:
                node['XX2'] = self.to_terminal(XX2)
            else:
                node['XX2'] = self.selectSplit(XX2, [0]*len(XX2), nAttr)
                self.recSplit(node['XX2'], max_depth, min_size, nAttr, depth+1)
                
            
            
                
        def learn(self, X, y):
        
            np.random.seed(1)
                
            nAttr = int(math.sqrt(len(X[0])))
            root = self.selectSplit(X, y, nAttr)
            
            self.recSplit(root, 10, 1, nAttr, 1) 
            
            
            
            self.tree = root
            
           

        def classify(self, record):
            # TODO: return predicted label for a single record using self.tree
            return self._classify(self.tree, record)
            
        def _classify(self, tree, record):
            if record[tree['attrNo']] < tree['threshold']:
                if isinstance(tree['XX1'], dict):
                    return self._classify(tree['XX1'], record)
                else:
                    return tree['XX1']
            else:
                if isinstance(tree['XX2'], dict):
                    return self._classify(tree['XX2'], record)
                else:
                    return tree['XX2']
            
            
            
            
            
            

    num_trees = 0
    decision_trees = []
    bootstraps_datasets = [] # the bootstrapping dataset for trees
    bootstraps_labels = []   # the true class labels,
                             # corresponding to records in the bootstrapping dataset 

    def __init__(self, num_trees):
        # TODO: do initialization here.
        self.num_trees = num_trees
        self.decision_trees = [self.__DecisionTree() for i in range(num_trees)]
    
    def _bootstrapping(self, XX, n):
        # TODO: create a sample dataset with replacement of size n
        #
        # Note that you will also need to record the corresponding
        #           class labels for the sampled records for training purpose.
        #
        # Reference: https://en.wikipedia.org/wiki/Bootstrapping_(statistics)
        
        
        
        
        sampX, sampy = list(), list()
        
        while len(sampX) < n:
            vSampIndex = randrange(len(XX))
            sampX.append(XX[vSampIndex][:11])
            sampy.append(XX[vSampIndex][11])
		
        return sampX, sampy
		
		
		
        

    def bootstrapping(self, XX):
        # TODO: initialize the bootstrap datasets for each tree.
        for i in range(self.num_trees):
            data_sample, data_label = self._bootstrapping(XX, len(XX))
            self.bootstraps_datasets.append(data_sample)
            self.bootstraps_labels.append(data_label)

    def fitting(self):
        # TODO: train `num_trees` decision trees using the bootstraps datasets and labels
        
        for i in range(self.num_trees):
            self.decision_trees[i].learn(self.bootstraps_datasets[i], self.bootstraps_labels[i])
            
        pass

    def voting(self, X):
        y = np.array([], dtype = int)

        for record in X:
            # TODO: find the sets of proper trees that consider the record
            #       as an out-of-bag sample, and predict the label(class) for the record. 
            #       The majority vote serves as the final label for this record.
            votes = []
            for i in range(len(self.bootstraps_datasets)):
                dataset = self.bootstraps_datasets[i]
                if record.tolist() not in dataset:
                    OOB_tree = self.decision_trees[i] 
                    effective_vote = OOB_tree.classify(record)
                    votes.append(effective_vote)

            counts = np.bincount(votes)
            if len(counts) == 0:
                # TODO: special handling may be needed.
                
                pass
            else:
                y = np.append(y, np.argmax(counts))

        return y

def main():
    X = list()
    y = list()
    XX = list() # Contains data features and data labels 

    # Note: you must NOT change the general steps taken in this main() function.

    # Load data set
    with open("hw4-data.csv") as f:
        next(f, None)

        for line in csv.reader(f, delimiter = ","):
            X.append(line[:-1])
            y.append(line[-1])
            xline = [ast.literal_eval(i) for i in line]
            XX.append(xline[:])
    
    
    
    # Initialize according to your implementation
    forest_size = 10 

    # Initialize a random forest
    randomForest = RandomForest(forest_size)

    # Create the bootstrapping datasets
    randomForest.bootstrapping(XX)

    # Build trees in the forest
    randomForest.fitting()
    
    #pdb.set_trace()
    
    #pp randomForest.decision_trees[0].tree

    # Provide an unbiased error estimation of the random forest 
    # based on out-of-bag (OOB) error estimate.
    # Note that you may need to handle the special case in
    #       which every single record in X has used for training by some 
    #       of the trees in the forest.
    y_truth = np.array(y, dtype = int)
    X = np.array(X, dtype = float)
    y_predicted = randomForest.voting(X)

    #results = [prediction == truth for prediction, truth in zip(y_predicted, y_test)]
    results = [prediction == truth for prediction, truth in zip(y_predicted, y_truth)]

    # Accuracy
    accuracy = float(results.count(True)) / float(len(results))
    print "accuracy: %.4f" % accuracy
    
    # OOB estimate
    print "OOB estimate: %.4f" % (1 - accuracy)

main()
