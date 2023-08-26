package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.Graph;
import dropecho.ds.GraphNode;

class GrammarTests extends Test {
	var graph:Graph<Int, Int>;

	public function setup() {
		graph = new Graph();
	}

	public function test_createNode() {
		var node = graph.createNode(4);

		Assert.equals(4, node.value);
		Assert.isTrue(graph.nodes.exists(node.id));
	}

	public function replace() {
		var node = graph.addNode(new GraphNode(4, "node"));
		var node2 = graph.addNode(new GraphNode(4, "node2"));
		var node3 = graph.addNode(new GraphNode(3, "node3"));

		graph.addBiEdge(node.id, node2.id);
		graph.addBiEdge(node3.id, node2.id);
		graph.addUniEdge(node3.id, node.id);

		// Grammar.replace(node, new GraphNode());

		// Assert.equals(4, node.value);
		// Assert.isTrue(graph.nodes.exists(node.id));
	}
}
