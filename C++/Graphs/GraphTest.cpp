#include "GraphHelper.h"
#include "FeatureGraph.h"
#include "GraphAnalyzer.h"
#include <map>
#include <iostream>
using namespace std;

int main() {

    vector<Node> nodes  {
       Node(1, vector<float> { 5, 10}),
       Node(2, vector<float> { 10, 20}),
       Node(3, vector<float> { 20, 30}),
       Node(4, vector<float> { 30, 40}) };
    
    vector<Edge> edges {Edge(1,2, 10), Edge(2, 3, 9), Edge(3, 4, 1), Edge(1, 3, 5), Edge(2, 4, 8)};
    int d = 2;

    FeatureGraph graph = FeatureGraph(4, d, nodes, edges);
    GraphAnalyzer analyzer = GraphAnalyzer(graph);

    for(vector<Node>::iterator i = analyzer.G.nodes.begin(); i < analyzer.G.nodes.end(); i++){
	cout << "Node(" << i->id << ",{";
	for(vector<float>::iterator j = i->features.begin(); j < i->features.end(); j++){
	    cout << *j << ", ";
	}
	cout << "})" << endl;
    }

    cout << endl;

    for(vector<Edge>::iterator i = analyzer.G.edges.begin(); i < analyzer.G.edges.end(); i++){
        cout << "Edge(" << i->IdA << ", " << i->IdB << ", " << i->weight << ")" << endl;
    }

    cout << endl;

    cout << "adjacencyList:" << endl;
    for(vector<Node>::iterator i = analyzer.G.nodes.begin(); i < analyzer.G.nodes.end(); i++){
    	cout << "Node " << i->id << ": ";
	for(vector<pair<int,int>>::iterator j = analyzer.G.adjacencyList[i->id].begin(); j < analyzer.G.adjacencyList[i->id].end(); j++){
	    cout << "(" << j->first << ", " << j->second << "), ";
	}
	cout << endl;
    }

    cout << endl;

    cout << "numNodes: " <<  analyzer.G.numNodes << "\n" << endl;

    cout << "skillLength: " << analyzer.G.skillLength << "\n" << endl;

    cout << "diameter(): " << analyzer.diameter() << "\n" << endl;

    cout << "Triangle Vector: " << endl;
    analyzer.printTriangleVector();
    cout << endl;

    cout << "Triangle Heap: " << endl;
    analyzer.printTriangleHeap();
    cout << endl;

    cout << "openClosedTriangleRatio(): " << analyzer.openClosedTriangleRatio() << "\n" << endl;

    cout << "topKOpenTriangles(2): " << analyzer.topKOpenTriangles(2) << "\n" << endl;

    vector<float> weights{20.5, .5};
    vector<int> neighbors = analyzer.topKNeighbors(2, 2, weights);

    cout << "topKNeighbors(2, 2, {20.5, .5}): ";
    for(auto i = neighbors.begin(); i != neighbors.end(); ++i)
        cout << *i << ",";
    cout << "\n" << endl;
			
    cout << "topNonNeighbor(2,{20.5,.5}): "  << analyzer.topNonNeighbor(2, weights) << "\n" << endl;

    analyzer.insert(Node(5, vector<float>{3,5}));
    analyzer.insert(Edge(4, 5, 32));
    
    for(vector<Node>::iterator i = analyzer.G.nodes.begin(); i < analyzer.G.nodes.end(); i++){
        cout << "Node(" << i->id << ",{";
        for(vector<float>::iterator j = i->features.begin(); j < i->features.end(); j++){
            cout << *j << ", ";
        }
        cout << "})" << endl;
    }

    cout << endl;

    for(vector<Edge>::iterator i = analyzer.G.edges.begin(); i < analyzer.G.edges.end(); i++){
        cout << "Edge(" << i->IdA << ", " << i->IdB << ", " << i->weight << ")" << endl;
    }

    cout << endl;

    cout << "adjacencyList:" << endl;
    for(vector<Node>::iterator i = analyzer.G.nodes.begin(); i < analyzer.G.nodes.end(); i++){
        cout << "Node " << i->id << ": ";
        for(vector<pair<int,int>>::iterator j = analyzer.G.adjacencyList[i->id].begin(); j < analyzer.G.adjacencyList[i->id].end(); j++){
            cout << "(" << j->first << ", " << j->second << "), ";
        }
        cout << endl;
    }

    cout << endl;

    cout << "numNodes: " <<  analyzer.G.numNodes << "\n" << endl;

    cout << "skillLength: " << analyzer.G.skillLength << "\n" << endl;

    cout << "Triangle Vector: " << endl;
    analyzer.printTriangleVector();
    cout << endl;

    cout << "Triangle Heap: " << endl;
    analyzer.printTriangleHeap();
    cout << endl;

    cout << "openClosedTriangleRatio(): " << analyzer.openClosedTriangleRatio() << "\n" << endl;

    cout << "topKOpenTriangles(2): " << analyzer.topKOpenTriangles(2) << "\n" << endl;

    weights = {.5, 1.5};
    neighbors = analyzer.topKNeighbors(4, 2, weights);
    
    cout << "topKNeighbors(4, 2, {.5, 1.5}) after insert: ";
    for(auto i = neighbors.begin(); i != neighbors.end(); ++i)
        cout << *i << ",";
    cout << "\n" << endl;

    cout << "topNonNeighbor(5,{.5,1.5}): "  << analyzer.topNonNeighbor(5, weights) << "\n" << endl;

    cout << "jacardIndexOfTopKNeighborhoods(): "  << analyzer.jacardIndexOfTopKNeighborhoods(1, 2, 2, weights) << "\n" << endl;
    return 0;
}
