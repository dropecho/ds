package graph;

import massive.munit.Assert;
import dropecho.ds.*;
import dropecho.ds.graph.*;

class DijkstraTest {
	var graph:Graph<Int, Int>;

	@Before
	public function setup() {
		graph = new Graph<Int, Int>();
	}

	@Test
	public function run() {
		/*
		 *     1
		 *    / \
		 *   2   4
		 *  / \   \
		 * 3   5 - 6
		 */
		var node1 = new GraphNode(1);
		node1.id = '1';
		var node2 = new GraphNode(1);
		node2.id = '2';
		var node3 = new GraphNode(1);
		node3.id = '3';
		var node4 = new GraphNode(1);
		node4.id = '4';
		var node5 = new GraphNode(1);
		node5.id = '5';
		var node6 = new GraphNode(1);
		node6.id = '6';

		graph.addNode(node1);
		graph.addNode(node2);
		graph.addNode(node3);
		graph.addNode(node4);
		graph.addNode(node5);
		graph.addNode(node6);

		graph.addBiEdge(node1.id, node4.id);
		graph.addBiEdge(node1.id, node2.id);
		graph.addBiEdge(node2.id, node3.id);
		graph.addBiEdge(node2.id, node5.id);
		graph.addBiEdge(node4.id, node6.id);
		graph.addBiEdge(node6.id, node5.id);

		var results = Search.dijkstra(node1.graph, node1);
		var path = results.path;

		Assert.isTrue(null == path[node1]);
		Assert.areEqual(node1.id, path[node4]);
		Assert.areEqual(node1.id, path[node2]);
		Assert.areEqual(node4.id, path[node6]);
		Assert.areEqual(node2.id, path[node3]);
		Assert.areEqual(node2.id, path[node5]);
	}

	@Test
	function traversal() {
		/*
		 *	  1-2-3
		 *	  | | |
		 *	  4-5-6
		 *	  | | |
		 *	  7-8-9
		 */
		var node1 = graph.addNode(new GraphNode(1, "1"));
		var node2 = graph.addNode(new GraphNode(2, "2"));
		var node3 = graph.addNode(new GraphNode(3, "3"));
		var node4 = graph.addNode(new GraphNode(4, "4"));
		var node5 = graph.addNode(new GraphNode(5, "5"));
		var node6 = graph.addNode(new GraphNode(6, "6"));
		var node7 = graph.addNode(new GraphNode(7, "7"));
		var node8 = graph.addNode(new GraphNode(8, "8"));

		graph.addBiEdge(node1.id, node2.id);
		graph.addBiEdge(node1.id, node4.id);

		graph.addBiEdge(node2.id, node1.id);
		graph.addBiEdge(node2.id, node3.id);
		graph.addBiEdge(node2.id, node5.id);

		graph.addBiEdge(node3.id, node2.id);
		graph.addBiEdge(node3.id, node6.id);

		graph.addBiEdge(node4.id, node1.id);
		graph.addBiEdge(node4.id, node5.id);
		graph.addBiEdge(node4.id, node7.id);

		graph.addBiEdge(node5.id, node2.id);
		graph.addBiEdge(node5.id, node4.id);
		graph.addBiEdge(node5.id, node6.id);
		graph.addBiEdge(node5.id, node8.id);

		graph.addBiEdge(node6.id, node3.id);
		graph.addBiEdge(node6.id, node5.id);

		graph.addBiEdge(node7.id, node4.id);
		graph.addBiEdge(node7.id, node8.id);

		graph.addBiEdge(node8.id, node7.id);
		graph.addBiEdge(node8.id, node5.id);

		var results = Search.dijkstra(node1.graph, node1);
		var dist = results.distances;

		Assert.areEqual(0, dist[node1]);
		Assert.areEqual(1, dist[node2]);
		Assert.areEqual(2, dist[node3]);
		Assert.areEqual(1, dist[node4]);
		Assert.areEqual(2, dist[node5]);
		Assert.areEqual(3, dist[node6]);
		Assert.areEqual(2, dist[node7]);
	}
}
