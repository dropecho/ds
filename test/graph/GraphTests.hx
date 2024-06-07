package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.Graph;
import dropecho.ds.GraphNode;

class GraphTests extends Test {
	var graph:Graph<Int, Int>;

	public function setup() {
		graph = new Graph();
	}

	public function test_canInstantiate() {
		Assert.notNull(graph);
	}

	public function test_createNode() {
		var node = graph.createNode(4);

		Assert.equals(4, node.value);
		Assert.isTrue(graph.nodes.exists(node.label));
	}

	public function test_addNode() {
		var node = new GraphNode(4);
		var inslabele = graph.addNode(node);

		Assert.equals(node, inslabele);
		Assert.isTrue(graph.nodes.exists(node.label));
	}

	public function test_addUniEdge() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);

		graph.addUniEdge(node1.label, node2.label, 12);

		Assert.isTrue(graph.edges.exists(node1.label));
		Assert.equals(node2, graph.outNeighbors(node1)[0]);
		Assert.isFalse(graph.edges.exists(node2.label));
		Assert.equals(12, graph.edges.get(node1.label).get(node2.label));
	}

	public function test_addBiEdge() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);

		graph.addBiEdge(node1.label, node2.label, 12);

		Assert.isTrue(graph.edges.exists(node1.label));
		Assert.equals(node2, graph.outNeighbors(node1)[0]);
		Assert.equals(12, graph.edges.get(node1.label).get(node2.label));

		Assert.isTrue(graph.edges.exists(node2.label));
		Assert.equals(node1, graph.outNeighbors(node2)[0]);
		Assert.equals(12, graph.edges.get(node2.label).get(node1.label));
	}

	public function test_remove() {
		var node1 = graph.createNode(0);
		var node2 = graph.createNode(0);
		var node3 = graph.createNode(0);
		var node4 = graph.createNode(0);

		graph.addUniEdge(node1.label, node2.label);
		graph.addUniEdge(node3.label, node1.label);
		graph.addBiEdge(node4.label, node1.label);

		graph.remove(node1.label);

		Assert.isFalse(graph.nodes.exists(node1.label));
		Assert.isFalse(graph.edges.exists(node1.label));
		Assert.isFalse(graph.neighbors(node2).contains(node1));
		Assert.isFalse(graph.neighbors(node3).contains(node1));
		Assert.isFalse(graph.neighbors(node4).contains(node1));
	}

	public function test_outNeighbors() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);
		var node3 = graph.createNode(5);

		graph.addUniEdge(node1.label, node2.label, 12);
		graph.addUniEdge(node1.label, node3.label, 14);

		var outNeighbors = graph.outNeighbors(node1);

		Assert.notEquals(-1, outNeighbors.indexOf(node2));
		Assert.notEquals(-1, outNeighbors.indexOf(node3));
	}

	public function test_outNeighborLabels() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);
		var node3 = graph.createNode(6);

		graph.addUniEdge(node1.label, node2.label, 12);
		graph.addUniEdge(node1.label, node3.label, 14);

		var outNeighborLabels = graph.outNeighborLabels(node1);

		Assert.notEquals(-1, outNeighborLabels.indexOf(node2.label));
		Assert.notEquals(-1, outNeighborLabels.indexOf(node3.label));
	}

	public function test_outNeighborLabels_when_empty() {
		var node1 = graph.createNode(4);

		var outNeighborLabels = graph.outNeighborLabels(node1);

		Assert.equals(0, outNeighborLabels.length);
	}

	public function test_edgeData() {
		var node1 = graph.createNode(4, "edge_data_test_node_1");
		var node2 = graph.createNode(5, "edge_data_test_node_2");
		var node3 = graph.createNode(6, "edge_data_test_node_3");

		graph.addUniEdge(node1.label, node2.label, 12);
		graph.addUniEdge(node1.label, node3.label, 14);

		var node1_to_node2_data = graph.edgeData(node1.label, node2.label);
		var node1_to_node3_data = graph.edgeData(node1.label, node3.label);

		Assert.equals(12, node1_to_node2_data);
		Assert.equals(14, node1_to_node3_data);
	}

	public function test_edgeData_when_empty() {
		var node1 = graph.createNode(4);
		var node2 = graph.createNode(5);

		var node1_to_node2_data = graph.edgeData(node1.label, node2.label);
		var nul:Null<Int> = null;

		Assert.equals(nul, node1_to_node2_data);
	}

	public function test_dotOutput() {
		var expected = "digraph {\n\ta\n\tb\n\ta -> b\n}";

		var node1 = graph.createNode(4, "a");
		var node2 = graph.createNode(5, "b");

		graph.addUniEdge(node1.label, node2.label);

		Assert.equals(expected, graph.toDot());
	}
}
