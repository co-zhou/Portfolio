Run the program using ./GraphTester or recompile with the Makefile

This program implements a weighted, undirected graph. In GraphHelper.h, each node contains a nodeId(int) and a vector of features(int). Each edge
contains the ids of the two nodes the edge is connected to and the weight(int) of the edge. A triangle class is also implemented
which contains the ids of the three nodes, a flag telling whether it is open, closed, or invalid, and a sum of the edge weights if
the triangle is closed. These triangles are stored in a max heap for faster calculations.

FeatureGraph.h stores the number of nodes, length of node skill vectors, vectors of nodes and edges, and an adjacency list that maps
each node to a vector of its neighbors and corresponding edge distances.

GraphAnalyzer.cpp implements the following functions:

insert(): inserts a node or and edge into the feature graph
  
diameter(): returns the diameter of the graph
  
openClosedTriangleRatio(): returns the ratio of open to closed triangles
  
topKOpenTriangles(int k): returns a string listing the top K open triangles
  
topKNeighbor(int nodeID, int k, vector<float> w): returns top k neighbors with the highest vector product of vector w and neighbor's skill vector
  
topNonNeighbor(int nodeID, vector<float> w): returns top non neighbor with the highest vector product of vector w and neighbor's skill vector
  
jacardIndexOfTopKNeighborhoods(int nodeA, int nodeB, int k, vector<float> w): returns similarity between two nodes' top k neighborhoods with the highest vector product of vector w and neighbor's skill vector
