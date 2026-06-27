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

	function test_weighted_edges() {
		/*
		 * Graph with weights:
		 *
		 *   A --10-- B
		 *   |        |
		 *   2        2
		 *   |        |
		 *   C --2--- D
		 *
		 * Shortest path A->B should be A->C->D->B (cost 6), not the direct A->B (cost 10).
		 */
		var nodeA = graph.createNode(1);
		var nodeB = graph.createNode(1);
		var nodeC = graph.createNode(1);
		var nodeD = graph.createNode(1);

		graph.addBiEdge(nodeA.label, nodeB.label, 10);
		graph.addBiEdge(nodeA.label, nodeC.label, 2);
		graph.addBiEdge(nodeC.label, nodeD.label, 2);
		graph.addBiEdge(nodeD.label, nodeB.label, 2);

		var results = Search.dijkstra(nodeA, (a, b) -> {
			var data = a.graph.edgeData(a.label, b.label);
			data != null ? (data : Float) : 1.0;
		});
		var dist = results.distances;
		var path = results.path;

		Assert.equals(0.0, dist[nodeA]);
		Assert.equals(2.0, dist[nodeC]);
		Assert.equals(4.0, dist[nodeD]);
		// B is cheaper via C->D->B (cost 6) than directly (cost 10).
		Assert.equals(6.0, dist[nodeB]);

		// Verify the actual path taken to B goes through D, not directly from A.
		Assert.equals(nodeD.label, path[nodeB]);
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
