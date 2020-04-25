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

	@Test
	public function neighborIds() {
		var graph = new Graph<Int, Int>();
		var node = graph.createNode(3);
		var node2 = graph.createNode(3);

		graph.addBiEdge(node.id, node2.id);

		var neighborIds = node.neighborIds();

		Assert.areEqual(node2.id, neighborIds[0]);
	}

	@Test
	public function neighbors() {
		var graph = new Graph<Int, Int>();
		var node = graph.createNode(3);
		var node2 = graph.createNode(3);

		graph.addBiEdge(node.id, node2.id);

		var neighbors = node.neighbors();

		Assert.areEqual(node2, neighbors[0]);
	}

	@Test
	public function edgeData() {
		var graph = new Graph<Int, Dynamic>();
		var node = graph.createNode(3);
		var node2 = graph.createNode(3);

		var data = {x: 35, w: 5};
		graph.addBiEdge(node.id, node2.id, data);

		var edgeData = node.edgeData(node2.id);

		Assert.areEqual(data, edgeData);
	}
}
