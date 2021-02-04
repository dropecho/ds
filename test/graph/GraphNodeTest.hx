package graph;

import massive.munit.Assert;
import dropecho.ds.*;

class GraphNodeTest {
	@Test
	public function testExample() {
		var node = new GraphNode();
		Assert.isNotNull(node);
	}

	@Test
	public function value() {
		var value = 3;
		var node = new GraphNode<Float, Float>(value);
		Assert.areEqual(value, node.value);
	}

	@Test
	public function id_is_unique() {
		var nodes = [for (_ in 0...50) new GraphNode(3)];

		for (node in nodes) {
			for (other in nodes) {
				if (node != other) {
					Assert.areNotEqual(node.id, other.id);
				}
			}
		}
	}
}
