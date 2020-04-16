package algos;

import massive.munit.Assert;
import vantreeseba.gameds.*;
import vantreeseba.gameds.algos.*;

class DijkstraTest {
	var graph:Graph<Int, Int>;
	var dijkstra:Dijkstra<Int, Int>;

	@Before
	public function setup() {
		graph = new Graph<Int, Int>();
		dijkstra = new Dijkstra();
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(dijkstra);
	}

	@Test
	public function run() {
		/* 
						GRAPH

          1
         / \
        2   4
			 / \   \
			3   5 - 6

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
		dijkstra.run(node1.graph, node1);
		var prev = dijkstra.prev;

		Assert.isNotNull(dijkstra);

		Assert.isTrue(null == prev[node1]);
		Assert.areEqual(node1.id, prev[node4]);
		Assert.areEqual(node1.id, prev[node2]);
		Assert.areEqual(node4.id, prev[node6]);
		Assert.areEqual(node2.id, prev[node3]);
		Assert.areEqual(node2.id, prev[node5]);
	}

	@Test function traversal() {
		/* GRAPH 
			1-2-3
			| | |
			4-5-6
			| | |
			7-8-9
		 */
		var node1 = graph.addNode(new GraphNode(1, "1"));
		var node2 = graph.addNode(new GraphNode(2, "2"));
		var node3 = graph.addNode(new GraphNode(3, "3"));
		var node4 = graph.addNode(new GraphNode(4, "4"));
		var node5 = graph.addNode(new GraphNode(5, "5"));
		var node6 = graph.addNode(new GraphNode(6, "6"));
		var node7 = graph.addNode(new GraphNode(7, "7"));
		var node8 = graph.addNode(new GraphNode(8, "8"));
		// var node9 = graph.addNode(new GraphNode(9, "9"));

		// TODO: Map map to graph / vice versa.

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
		// graph.addBiEdge(node6.id, node9.id);

		graph.addBiEdge(node7.id, node4.id);
		graph.addBiEdge(node7.id, node8.id);

		graph.addBiEdge(node8.id, node7.id);
		graph.addBiEdge(node8.id, node5.id);
		// graph.addBiEdge(node8.id, node9.id);

		// graph.addBiEdge(node9.id, node8.id);
		// graph.addBiEdge(node9.id, node6.id);

		dijkstra.run(node1.graph, node1);
		var prev = dijkstra.prev;
		var dist = dijkstra.dist;

		Assert.isNotNull(dijkstra);

		Assert.areEqual(0, dist[node1]);
		Assert.areEqual(1, dist[node2]);
		Assert.areEqual(2, dist[node3]);
		Assert.areEqual(1, dist[node4]);
		Assert.areEqual(2, dist[node5]);
		Assert.areEqual(3, dist[node6]);
		Assert.areEqual(2, dist[node7]);
		// Assert.areEqual(3, dist[node8]);
		// Assert.areEqual(4, dist[node9]);

		// Assert.isTrue(prev[node9] == '6' || prev[node9] == '8');
	}
}
