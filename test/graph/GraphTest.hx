package graph;

import vantreeseba.gameds.Graph;
import vantreeseba.gameds.GraphNode;
import massive.munit.Assert;

class GraphTest {
	var graph:Graph<Int, Int>;

	@Before
	public function setup() {
		graph = new Graph();
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(graph);
	}

	@Test
	public function createNode() {
		var node = graph.createNode(4);

		Assert.areEqual(4, node.value);
		Assert.isTrue(graph.nodes.exists(node.id));
	}

	@Test
	public function addNode() {
		var node = new GraphNode(4);
		var inside = graph.addNode(node);

		Assert.areEqual(node, inside);
		Assert.isTrue(graph.nodes.exists(node.id));
	}

	@Test
	public function addUniEdge() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);

		graph.addUniEdge(node1.id, node2.id, 12);

		Assert.isTrue(graph.edges.exists(node1.id));
		Assert.areEqual(node2, graph.neighbors(node1)[0]);
		Assert.isFalse(graph.edges.exists(node2.id));
		Assert.areEqual(12, graph.edges.get(node1.id).get(node2.id));
	}

	@Test
	public function addBiEdge() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);

		graph.addBiEdge(node1.id, node2.id, 12);

		Assert.isTrue(graph.edges.exists(node1.id));
		Assert.areEqual(node2, graph.neighbors(node1)[0]);
		Assert.areEqual(12, graph.edges.get(node1.id).get(node2.id));

		Assert.isTrue(graph.edges.exists(node2.id));
		Assert.areEqual(node1, graph.neighbors(node2)[0]);
		Assert.areEqual(12, graph.edges.get(node2.id).get(node1.id));
	}

	@Test
	public function remove() {
		var node1 = graph.createNode(4);
		graph.remove(node1.id);

		Assert.isFalse(graph.nodes.exists(node1.id));
	}

	@Test
	public function neighbors() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);
		var node3 = graph.createNode(5);

		graph.addUniEdge(node1.id, node2.id, 12);
		graph.addUniEdge(node1.id, node3.id, 14);

		var neighbors = graph.neighbors(node1);

		Assert.areNotEqual(-1, neighbors.indexOf(node2));
		Assert.areNotEqual(-1, neighbors.indexOf(node3));
	}

	@Test
	public function neighborIds() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);
		var node3 = graph.createNode(6);

		graph.addUniEdge(node1.id, node2.id, 12);
		graph.addUniEdge(node1.id, node3.id, 14);

		var neighborIds = graph.neighborIds(node1);

		Assert.areNotEqual(-1, neighborIds.indexOf(node2.id));
		Assert.areNotEqual(-1, neighborIds.indexOf(node3.id));
	}

	@Test
	public function neighborIds_when_empty() {
		var node1 = graph.createNode(4);

		var neighborIds = graph.neighborIds(node1);

		Assert.areEqual(0, neighborIds.length);
	}

	@Test
	public function edgeData() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);
		var node3 = graph.createNode(6);

		graph.addUniEdge(node1.id, node2.id, 12);
		graph.addUniEdge(node1.id, node3.id, 14);

		var node1_to_node2_data = graph.edgeData(node1.id, node2.id);
		var node1_to_node3_data = graph.edgeData(node1.id, node3.id);

		Assert.areEqual(12, node1_to_node2_data);
		Assert.areEqual(14, node1_to_node3_data);
	}

	@Test
	public function edgeData_when_empty() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);

		var node1_to_node2_data = graph.edgeData(node1.id, node2.id);
		var nul:Null<Int> = null;

		Assert.areEqual(nul, node1_to_node2_data);
	}
}
