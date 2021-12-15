#ifndef FEATURE_H
#define FEATURE_H


#include <string>
#include <vector>
#include <map>
#include "GraphHelper.h"


using namespace std;



class FeatureGraph {

public:
    // Constructor
    // N: The number of nodes
    // nodeIds: the ids of nodes as integers
    // d: the size of the skill vectors of all nodes
    // nodeIDtoSkillsMap: a map form the nodeID to their skiils vector
    FeatureGraph(int N, int d, vector<Node> nodes, vector<Edge> edges);


    //Insert node with given ID and feature vectors
    void insert(Node node);

    // insert given edge
    // May assume nodes in edge are already present
    void insert(Edge edge);

	int numNodes;
	int skillLength;
	vector<Node> nodes;
	vector<Edge> edges;
	map<int,vector<pair<int,int>>> adjacencyList;
};  

#endif
