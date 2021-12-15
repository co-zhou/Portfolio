#include "GraphHelper.h"
#include "FeatureGraph.h"
#include "GraphAnalyzer.h"

using namespace std;

void GraphAnalyzer::insert(Node n) {
    G.insert(n);
};

void GraphAnalyzer::insert(Edge e) {
        for(vector<pair<int,int>>::iterator i = G.adjacencyList[e.IdA].begin(); i < G.adjacencyList[e.IdA].end(); i++){
                bool found = false;
                for(vector<pair<int,int>>::iterator j = G.adjacencyList[i->first].begin(); j < G.adjacencyList[i->first].end(); j++){
                        if(e.IdB == j->first) found = true;
                }
                // Check if open triangle turned into closed triangle else new open triangle
                if(found){
                        for(vector<Triangle*>::iterator j = triangleVector.begin(); j < triangleVector.end(); j++){
                                if(((*j)->nodeA == e.IdA && (*j)->nodeB == e.IdB) || ((*j)->nodeA == e.IdB && (*j)->nodeB == e.IdA)) {
                                        (*j)->flag = 0;
                                }
                        }
                } else {
                        Triangle* t = new Triangle(e.IdA, i->first, e.IdB, 1, i->second + e.weight);
                        triangleVector.push_back(t);
                        triangleHeap.push(t);
                }
        }

        for(vector<pair<int,int>>::iterator i = G.adjacencyList[e.IdB].begin(); i < G.adjacencyList[e.IdB].end(); i++){
                bool found = false;
                for(vector<pair<int,int>>::iterator j = G.adjacencyList[i->first].begin(); j < G.adjacencyList[i->first].end(); j++){
                        if(e.IdA == j->first) found = true;
                }
                // Check if open triangle turned into closed triangle else new open triangle
                if(found){
                        for(vector<Triangle*>::iterator j = triangleVector.begin(); j < triangleVector.end(); j++){
                                if(((*j)->nodeA == e.IdA && (*j)->nodeB == e.IdB) || ((*j)->nodeA == e.IdB && (*j)->nodeB == e.IdA)) {
                                        (*j)->flag = 0;
                                }
                        }
                } else {
                        Triangle* t = new Triangle(e.IdB, i->first, e.IdA, 1, i->second + e.weight);
                        triangleVector.push_back(t);
                        triangleHeap.push(t);
                }
        }
	G.insert(e);
};

int GraphAnalyzer::diameter() {
    	//For each node
	int diameter = 0;
    	for(int a = 0; a < G.numNodes; a++){
		int sourceNode = G.nodes[a].id;
		//initialize map of pairs of node ids and distance with distance = infinity except the node itself
	    	map<int,int> distances;
		//initialize minheap with node ids compared by distance
		//extra elements are inserted, takes element only if it is not explored
		priority_queue<pair<int,int>, vector<pair<int,int>>, CompareDistance> minheap;
                for(int i = 0; i < G.numNodes; i++){
                        pair<int,int> p(G.nodes[i].id,INT_MAX);
                        if(G.nodes[i].id == sourceNode) p.second = 0;
			distances.insert(p);
			minheap.push(p);
               	}

		//initialize explored set as vector of node ids
		vector<int> explored;
		//while number of nodes in explored set is less than number of nodes in graph
		while(explored.size() < G.numNodes){
			//move shortest distance to explored set
			int p;
			bool found;
			do{
				found = false;
				p = minheap.top().first;
				minheap.pop();
				for(vector<int>::iterator j = explored.begin(); j < explored.end(); j++){
					if(*j == p) found = true;
				}
			} while (found);
			explored.push_back(p);
			//update diameter if distances[p] is larger
			if(distances[p] > diameter) diameter = distances[p];
			//for each neighbor of new element
			for(vector<pair<int,int>>::iterator j = G.adjacencyList[p].begin(); j < G.adjacencyList[p].end(); j++){
				//update shortest distance if distance from source to new element to neighbor
				//is less than from source to neighbor
				if(distances[j->first] > distances[p] + j->second){
					distances[j->first] = distances[p] + j->second;
					minheap.push(pair<int,int>(j->first,distances[j->first]));
				}
			}
		}
    	}
    	return diameter;
};


float GraphAnalyzer::openClosedTriangleRatio() {
    	int numOpen = 0;
	int numClosed = 0;
    	for(vector<Triangle*>::iterator i = triangleVector.begin(); i < triangleVector.end(); i++){
    		if((*i)->flag == 1) numOpen++;
		else if((*i)->flag == 0) numClosed++;
    	}
   	if(numClosed > 0) return (numOpen * 1.0)/numClosed;
	return -1;
};

string GraphAnalyzer::topKOpenTriangles(int k) {
	int i = 0;
	string str;
	priority_queue<Triangle*, vector<Triangle*>, CompareTriangle> heap = triangleHeap;
    	while(i < k && !heap.empty()){
		Triangle* t = heap.top();
		if(t->flag == 1){
			int a = t->vertex;
			int b = t->nodeA;
			int c = t->nodeB;
			if(a > b) {
				int temp = a;
				a = b;
				b = temp;
			}
			if(b > c) {
				int temp = b;
				b = c;
				c = temp;
			}
			if(a > b) {
                                int temp = a;
                                a = b;
                                b = temp;
                        }
			str += to_string(a) + "," + to_string(b) + "," + to_string(c) + ";";
			i++;
		}
		else if (t->flag == -1) delete t;
		heap.pop();
	}
    	return str.substr(0,str.length()-1);
};


vector<int> GraphAnalyzer::topKNeighbors(int nodeID, int k, vector<float> w) {
    // Does not use adjacencyList

	vector<int> list;
	priority_queue<pair<int,float>,vector<pair<int,float>>, CompareNeighbor> maxheap;

	for(vector<Edge>::iterator i = G.edges.begin(); i < G.edges.end(); i++){
    		int ID = -1;
    		if(i->IdA == nodeID){
			ID = i->IdB;
    		} else if(i->IdB == nodeID){
			ID = i->IdA;
		}
    		if(ID != -1) {
			float score = 0;
    			bool found = false;
    			vector<Node>::iterator i = G.nodes.begin();
       	 		while(!found && i < G.nodes.end()){
	    			if(i->id == ID){
					for(int j = 0; j < G.skillLength; j++){
						score += i->features[j]*w[j];
					}
					found = true;
	    			}
				i++;
        		}
			maxheap.push(pair<int,float>(ID,score));
    		}
	}

	for(int i = 0; i < k; i++){
   		list.push_back(maxheap.top().first);
   		maxheap.pop();
	}	
	return list;
};


int GraphAnalyzer::topNonNeighbor(int nodeID, vector<float> w) {
    //vector<int> of all other nodes
    //for(nodeID in adjacencyList[nodeID]) if one id is nodeID, delete other id from vector
    //for(node in vector) {
    //	calculate score
    //	if(score > maxscore)
    //	    id = node.id
    //	    maxscore = score
    //}
    //return id;
    
	vector<Node> n;
	for(int i = 0; i < G.numNodes; i++){
		if(G.nodes[i].id != nodeID) n.push_back(G.nodes[i]);
	}

	int ID = -1;
        int maxScore = -1;

	vector<pair<int,int>>::iterator i = G.adjacencyList[nodeID].begin();
	while(i < G.adjacencyList[nodeID].end()){
		vector<Node>::iterator j = n.begin();
		bool found = false;
		while(!found && j < n.end()){
			if(j->id == i->first){
				n.erase(j);
				found = true;
			}
			j++;
		}
		if(!found) i++;
	}

	for(vector<Node>::iterator j = n.begin(); j < n.end(); j++){
		int score = 0;
                for(int k = 0; k < G.skillLength; k++) score += j->features[k] * w[k];
	        if(score > maxScore){
                        ID = j->id;
                        maxScore = score;
		}
	}

    	return ID;
};


float GraphAnalyzer::jacardIndexOfTopKNeighborhoods(int nodeA, int nodeB, int k, vector<float> w) {
	vector<int> vectorA = topKNeighbors(nodeA, k, w);
	vector<int> vectorB = topKNeighbors(nodeB, k, w);

	int numUnion = k;
	int numIntersection = 0;

	for(int i = 0; i < k; i++){
		bool found = false;
		int j = 0;
		while(j < k && !found){
			if(vectorB[i] == vectorA[j]){
				numIntersection++;
				found = true;
			}
			j++;
		}
		if(!found) numUnion++;
	}
	return (numIntersection*1.0)/numUnion;
};
