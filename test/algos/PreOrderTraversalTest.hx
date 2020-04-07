package algos;

import massive.munit.Assert;
import vantreeseba.gameds.*;
import vantreeseba.gameds.algos.*;

class PreOrderTraversalTest {
	var tree:BSPTree;
	var trav:PreOrderTraversal;

	@Before
	public function setup() {
		tree = new BSPTree();
		trav = new PreOrderTraversal();
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(trav);
	}

	@Test
	public function run() {
		/*
			GRAPH

				  1
			   / \
			  2   3
			 / \
			4   5
		 */

		var node1 = tree.getRoot();
    var node2 = node1.createLeft(2);
    var node3 = node1.createRight(3);
    var node4 = node2.createLeft(4);
    var node5 = node2.createRight(5);

		var visited = trav.run(node1);

		Assert.areEqual(node1.id, visited[0]);
		Assert.areEqual(node2.id, visited[1]);
		Assert.areEqual(node4.id, visited[2]);
		Assert.areEqual(node5.id, visited[3]);
		Assert.areEqual(node3.id, visited[4]);
	}
}
