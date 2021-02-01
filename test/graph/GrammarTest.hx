package graph;

import dropecho.ds.graph.Grammar;
import dropecho.ds.Graph;
import dropecho.ds.GraphNode;
import massive.munit.Assert;

class GrammarTest {
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
	public function replace() {
		var node = graph.addNode(new GraphNode(4, "node"));
		var node2 = graph.addNode(new GraphNode(4, "node2"));
		var node3 = graph.addNode(new GraphNode(3, "node3"));

		graph.addBiEdge(node.id, node2.id);
		graph.addBiEdge(node3.id, node2.id);
		graph.addUniEdge(node3.id, node.id);

		// Grammar.replace(node, new GraphNode());

		trace(graph);

		// Assert.areEqual(4, node.value);
		// Assert.isTrue(graph.nodes.exists(node.id));
	} 
}
