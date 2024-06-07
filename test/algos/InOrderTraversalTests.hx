package algos;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;
import dropecho.ds.algos.*;

class InOrderTraversalTests extends Test {
	var tree:BSPTree<Int>;
	var iot:InOrderTraversal;

	public function setup() {
		tree = new BSPTree<Int>();
		iot = new InOrderTraversal();
	}

	public function test_canInstantiate() {
		Assert.notNull(tree);
		Assert.notNull(iot);
	}

	public function test_run() {
		/*****
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

		var visited = iot.run(node1);

		Assert.equals(node4.label, visited[0]);
		Assert.equals(node2.label, visited[1]);
		Assert.equals(node5.label, visited[2]);
		Assert.equals(node1.label, visited[3]);
		Assert.equals(node3.label, visited[4]);
	}
}
