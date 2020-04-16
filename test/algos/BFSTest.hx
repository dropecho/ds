package algos;

import massive.munit.Assert;
import vantreeseba.gameds.*;
import vantreeseba.gameds.algos.*;

class BFSTest {
	var graph:Graph<Int, Int>;
	var bfs:BFS<Int, Int>;

	@Before
	public function setup() {
		graph = new Graph();
		bfs = new BFS();
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(bfs);
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

		bfs.run(node1);

		Assert.isNotNull(bfs);

		Assert.areEqual(node1.id, bfs.visited[0]);
		Assert.areEqual(node2.id, bfs.visited[1]);
		Assert.areEqual(node4.id, bfs.visited[2]);
		Assert.areEqual(node3.id, bfs.visited[3]);
		Assert.areEqual(node5.id, bfs.visited[4]);
		Assert.areEqual(node6.id, bfs.visited[5]);
	}

	@Test function traversal() {
/*
			GRAPH

				  1
			   / \
			  2   3
			 / \   \
			4   5   6
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

		graph.addBiEdge(node1.id, node3.id);
		graph.addBiEdge(node1.id, node2.id);
		graph.addBiEdge(node2.id, node5.id);
		graph.addBiEdge(node2.id, node4.id);
    graph.addBiEdge(node3.id, node6.id);

		bfs.run(node1);

		Assert.isNotNull(bfs);

		Assert.areEqual(node1.id, bfs.visited[0]);
		Assert.areEqual(node2.id, bfs.visited[1]);
		Assert.areEqual(node3.id, bfs.visited[2]);
		Assert.areEqual(node4.id, bfs.visited[3]);
		Assert.areEqual(node5.id, bfs.visited[4]);
		Assert.areEqual(node6.id, bfs.visited[5]);
	}
}
