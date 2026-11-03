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

	public function test_label_is_unique() {
		var nodes = [for (_ in 0...10) new GraphNode(3)];

		for (node in nodes) {
			for (other in nodes) {
				if (node != other) {
					Assert.notEquals(node.label, other.label);
				}
			}
		}
	}

	public function test_toString_returns_label() {
		var node = new GraphNode<Int, Int>(3, "A");
		Assert.equals("A", node.toString());
		Assert.equals("A", Std.string(node));
	}

	public function test_toString_ignores_value_and_graph() {
		var graph = new Graph<Int, Int>();
		var a = graph.createNode(7, "A");
		var b = graph.createNode(7, "B");
		a.addBiEdge(b);

		Assert.equals("A", Std.string(a));
		Assert.equals("B", Std.string(b));
	}
}
