package algos;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;
import dropecho.ds.algos.*;

class PreOrderTraversalTests extends Test {
	var tree:BSPTree<Int>;
	var trav:PreOrderTraversal;

	public function setup() {
		tree = new BSPTree<Int>();
		trav = new PreOrderTraversal();
	}

	public function test_canInstantiate() {
		Assert.notNull(trav);
	}

	public function test_run() {
		/************************
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

		Assert.equals(node1.id, visited[0]);
		Assert.equals(node2.id, visited[1]);
		Assert.equals(node4.id, visited[2]);
		Assert.equals(node5.id, visited[3]);
		Assert.equals(node3.id, visited[4]);
	}
}
