#include <string>
#include <vector>
#include "FeatureGraph.h"
#include "GraphHelper.h"


using namespace std;


FeatureGraph::FeatureGraph(int N, int d, vector<Node> nodes, vector<Edge> edges) {
    //int numNodes;
	numNodes = N;
    //vector<Node> nodes;
    	this->nodes = nodes;
    //vector<Edge> edges;
	this->edges = edges;
    //int skillLength;
	skillLength = d;
    //map<int,vector<pair<int,int>>> adjacencyList;
    	for(int i = 0; i < N; i++){
		pair<int,vector<pair<int,int>>> p;
		p.first = nodes[i].id;
		for(vector<Edge>::iterator j = edges.begin(); j < edges.end(); j++){
			int ID = -1;
			if(j->IdA == nodes[i].id) ID = j->IdB;
			if(j->IdB == nodes[i].id) ID = j->IdA;
			if(ID > -1) p.second.push_back(pair<int,int>(ID,j->weight));
		}
		adjacencyList.insert(p);
	}

};

void FeatureGraph::insert(Node node){
    //TODO
    nodes.push_back(node);
    pair<int,vector<pair<int,int>>> p;
    p.first = node.id;
    adjacencyList.insert(p);
    numNodes++;
};
    
void FeatureGraph::insert(Edge edge){
    //TODO
    edges.push_back(edge);
    adjacencyList[edge.IdA].push_back(pair<int,int>(edge.IdB,edge.weight));
    adjacencyList[edge.IdB].push_back(pair<int,int>(edge.IdA,edge.weight));
};
