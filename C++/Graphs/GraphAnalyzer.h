#ifndef ANALYZER_H
#define ANALYZER_H

#include "FeatureGraph.h"
#include <queue>
#include <iostream>
#include <climits>

using namespace std;



class GraphAnalyzer {


public:	
	struct CompareNeighbor{
		bool operator()(pair<int,float> const& p1, pair<int,float> const& p2){
			return p1.second < p2.second;
		}
	};

	struct CompareDistance{
		bool operator()(pair<int,int> const& p1, pair<int,int> const& p2){
			return p1.second > p2.second;
		}
	};

        struct CompareTriangle{
                bool operator()(Triangle* const p1, Triangle* const p2){
                        return p1->weight < p2->weight;
                }
        };

	FeatureGraph G;
        //TODO: Store a heap of triangeles using cpp priority_queue
        priority_queue<Triangle*, vector<Triangle*>, CompareTriangle> triangleHeap;
        vector<Triangle*> triangleVector;

    //constructor
	// 
	// G: FeatureGraph to build on
    GraphAnalyzer(FeatureGraph& G):G(G){
        this->G = G;
        //for each node
        for(int a = 0; a < G.numNodes; a++){
                //for each distinct pair of neighbors
                for(vector<pair<int,int>>::iterator i = G.adjacencyList[G.nodes[a].id].begin(); i < G.adjacencyList[G.nodes[a].id].end()-1; i++){
                        for(vector<pair<int,int>>::iterator j = i+1; j < G.adjacencyList[G.nodes[a].id].end(); j++){
                                //if there is no edge between them, add open triangle
				bool found = false;
                                for(vector<pair<int,int>>::iterator k = G.adjacencyList[i->first].begin(); k < G.adjacencyList[i->first].end(); k++){
                                        if(k->first == j->first) found = true; 
                                }
				int flag;
				int weight;
				if(!found){
					flag = 1;
					weight = i->second + j->second;
				}
				else if (G.nodes[a].id < i->first && G.nodes[a].id < j->first){
					flag = 0;
					weight = INT_MAX;
				}
				else flag = -1;
				if(flag > -1){
      	                        	Triangle* t = new Triangle(G.nodes[a].id, i->first, j->first, flag, weight);
            	                	triangleVector.push_back(t);
                    	        	if(flag == 1) triangleHeap.push(t);
				}
                        }
                }
        }
};

    // Insert given node and corresponding features into graph
    // You may assume the number of features is the same as all other nodes in the graph
    void insert(Node n);


    //Insert given edge into graph
    // You may assume that the edge contains nodes already inserted into the graph
    void insert(Edge e);

    // Return the diameter of the network.
    int diameter();

    // Return the ratio of open triangles to closed triangles.
    float openClosedTriangleRatio();   

    // Return the top k open triangles ranked by the total weight on their edges.
    // 
    // K: number of triangles to return
    string topKOpenTriangles(int k);

    // Return the top k skilled individuals around a given node based on a given weighting
    //
    // nodeID: Id of seed node
    // k: number of nodes to return
    // w: weight vector
    vector<int> topKNeighbors(int nodeID, int k,  vector<float> w);

    // Return the most skilled individual that does not share an edge with the seed node
    // nodeId: Id of seed node
    // w: weight vector
    int topNonNeighbor(int nodeID, vector<float> w);
    
    // Return the Jacard Index of the top-k neighbors of two seed nodes
    //
    // nodeA: id of first node
    // nodeB id of second node
    // k: number of neighbors to evaluate for each node
    // w: weight vector
    float jacardIndexOfTopKNeighborhoods(int nodeA, int nodeB, int k, vector<float> w);

    void printTriangleVector(){
	for(vector<Triangle*>::iterator i = triangleVector.begin(); i < triangleVector.end(); i++){
            if ((*i)->flag == 1) cout << "Open(" << (*i)->vertex << ", " << (*i)->nodeA << ", " << (*i)->nodeB << "): Weight = " << (*i)->weight << endl;
            else if ((*i)->flag == 0) cout << "Closed(" << (*i)->vertex << ", " << (*i)->nodeA << ", " << (*i)->nodeB << "): Weight = " << (*i)->weight << endl;
	}
    }
    
    void printTriangleHeap(){
   	priority_queue<Triangle*, vector<Triangle*>, CompareTriangle> test = triangleHeap;
	while(!test.empty()){
	    Triangle* t = test.top();
	    if (t->flag == 1) cout << "Open(" << t->vertex << ", " << t->nodeA << ", " << t->nodeB << "): Weight = " << t->weight << endl;
            else if (t->flag == 0) cout << "Closed(" << t->vertex << ", " << t->nodeA << ", " << t->nodeB << "): Weight = " << t->weight << endl;
	    test.pop();
	}	
    } 
};


#endif
