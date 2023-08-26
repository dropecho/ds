package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;
import dropecho.ds.algos.*;
import dropecho.ds.graph.Traversal;

class DFSTests extends Test {
	var graph:Graph<Int, Int>;

	public function setup() {
		graph = new Graph();
	}

	//   public function test_run() {
	/******************
			GRAPH

				1
			 / \
			2   4
		 / \   \
		3   5 - 6

	*****************/
	//     var node1 = new GraphNode(1);
	//
	//     node1.id = '1';
	//     var node2 = new GraphNode(1);
	//     node2.id = '2';
	//     var node3 = new GraphNode(1);
	//     node3.id = '3';
	//     var node4 = new GraphNode(1);
	//     node4.id = '4';
	//     var node5 = new GraphNode(1);
	//     node5.id = '5';
	//     var node6 = new GraphNode(1);
	//     node6.id = '6';
	//
	//     graph.addNode(node1);
	//     graph.addNode(node2);
	//     graph.addNode(node3);
	//     graph.addNode(node4);
	//     graph.addNode(node5);
	//     graph.addNode(node6);
	//
	//     graph.addBiEdge(node1.id, node4.id);
	//     graph.addBiEdge(node1.id, node2.id);
	//     graph.addBiEdge(node2.id, node3.id);
	//     graph.addBiEdge(node2.id, node5.id);
	//     graph.addBiEdge(node4.id, node6.id);
	//     graph.addBiEdge(node6.id, node5.id);
	//
	//     var visited = Traversal.depthFirst(node1);
	//
	//     Assert.equals(node1.id, visited[0]);
	//     Assert.equals(node2.id, visited[1]);
	//     Assert.equals(node3.id, visited[2]);
	//     Assert.equals(node5.id, visited[3]);
	//     Assert.equals(node6.id, visited[4]);
	//     Assert.equals(node4.id, visited[5]);
	//   }
	//   function test_traversal() {
	/******************
		  GRAPH

				1
			 / \
			2   3
		 / \   \
		4   5   6

	 */
	// var node1 = new GraphNode(1);
	//
	// node1.id = '1';
	// var node2 = new GraphNode(1);
	// node2.id = '2';
	// var node3 = new GraphNode(1);
	// node3.id = '3';
	// var node4 = new GraphNode(1);
	// node4.id = '4';
	// var node5 = new GraphNode(1);
	// node5.id = '5';
	// var node6 = new GraphNode(1);
	// node6.id = '6';
	//
	// graph.addNode(node1);
	// graph.addNode(node2);
	// graph.addNode(node3);
	// graph.addNode(node4);
	// graph.addNode(node5);
	// graph.addNode(node6);
	//
	// graph.addBiEdge(node1.id, node3.id);
	// graph.addBiEdge(node1.id, node2.id);
	// graph.addBiEdge(node2.id, node5.id);
	// graph.addBiEdge(node2.id, node4.id);
	// graph.addBiEdge(node3.id, node6.id);
	//
	// var visited = Traversal.depthFirst(node1);
	//
	// Assert.equals(node1.id, visited[0]);
	// Assert.equals(node2.id, visited[1]);
	// Assert.equals(node4.id, visited[2]);
	// Assert.equals(node5.id, visited[3]);
	// Assert.equals(node3.id, visited[4]);
	// Assert.equals(node6.id, visited[5]);
	//   }
}
