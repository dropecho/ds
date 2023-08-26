package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

class GraphNodeTests extends Test {
	public function testExample() {
		var node = new GraphNode();
		Assert.notNull(node);
	}

	public function test_value() {
		var value = 3;
		var node = new GraphNode<Float, Float>(value);
		Assert.equals(value, node.value);
	}

	public function test_id_is_unique() {
		var nodes = [for (_ in 0...10) new GraphNode(3)];

		for (node in nodes) {
			for (other in nodes) {
				if (node != other) {
					Assert.notEquals(node.id, other.id);
				}
			}
		}
	}
}
