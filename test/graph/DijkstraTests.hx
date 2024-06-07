package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.Graph;
import dropecho.ds.graph.*;

class DijkstraTests extends Test {
	var graph:Graph<Int, Int>;

	public function setup() {
		graph = new Graph<Int, Int>();
	}

	public function test_run() {
		/******************
				GRAPH

				  1
				 / \
				2   4
			 / \   \
			3   5 - 6

		******************/

		var node1 = graph.createNode(1);

		var node2 = graph.createNode(1);
		var node3 = graph.createNode(1);
		var node4 = graph.createNode(1);
		var node5 = graph.createNode(1);
		var node6 = graph.createNode(1);

		graph.addBiEdge(node1.label, node4.label);
		graph.addBiEdge(node1.label, node2.label);
		graph.addBiEdge(node2.label, node3.label);
		graph.addBiEdge(node2.label, node5.label);
		graph.addBiEdge(node4.label, node6.label);
		graph.addBiEdge(node6.label, node5.label);

		var results = Search.dijkstra(node1);
		var path = results.path;

		Assert.isFalse(path.exists(node1));
		Assert.equals(node1.label, path[node4]);
		Assert.equals(node1.label, path[node2]);
		Assert.equals(node4.label, path[node6]);
		Assert.equals(node2.label, path[node3]);
		Assert.equals(node2.label, path[node5]);
	}

	function test_traversal() {
		/*
		 *	  1-2-3
		 *	  | | |
		 *	  4-5-6
		 *	  | | |
		 *	  7-8-9
		 */
		var node1 = graph.createNode(1);
		var node2 = graph.createNode(1);
		var node3 = graph.createNode(1);
		var node4 = graph.createNode(1);
		var node5 = graph.createNode(1);
		var node6 = graph.createNode(1);
		var node7 = graph.createNode(1);
		var node8 = graph.createNode(1);

		graph.addBiEdge(node1.label, node2.label);
		graph.addBiEdge(node1.label, node4.label);

		graph.addBiEdge(node2.label, node1.label);
		graph.addBiEdge(node2.label, node3.label);
		graph.addBiEdge(node2.label, node5.label);

		graph.addBiEdge(node3.label, node2.label);
		graph.addBiEdge(node3.label, node6.label);

		graph.addBiEdge(node4.label, node1.label);
		graph.addBiEdge(node4.label, node5.label);
		graph.addBiEdge(node4.label, node7.label);

		graph.addBiEdge(node5.label, node2.label);
		graph.addBiEdge(node5.label, node4.label);
		graph.addBiEdge(node5.label, node6.label);
		graph.addBiEdge(node5.label, node8.label);

		graph.addBiEdge(node6.label, node3.label);
		graph.addBiEdge(node6.label, node5.label);

		graph.addBiEdge(node7.label, node4.label);
		graph.addBiEdge(node7.label, node8.label);

		graph.addBiEdge(node8.label, node7.label);
		graph.addBiEdge(node8.label, node5.label);

		var results = Search.dijkstra(node1);
		var dist = results.distances;

		Assert.equals(0, dist[node1]);
		Assert.equals(1, dist[node2]);
		Assert.equals(2, dist[node3]);
		Assert.equals(1, dist[node4]);
		Assert.equals(2, dist[node5]);
		Assert.equals(3, dist[node6]);
		Assert.equals(2, dist[node7]);
	}
}
