package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.Graph;
import dropecho.ds.graph.Traversal;

class TraversalTests extends Test {
	var graph:Graph<Int, Int>;

	public function setup() {
		graph = new Graph<Int, Int>();
	}

	public function test_topological_sort_on_dag() {
		// A -> B -> C, A -> C
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");

		graph.addUniEdge(a.label, b.label);
		graph.addUniEdge(b.label, c.label);
		graph.addUniEdge(a.label, c.label);

		var sorted = Traversal.topologicalSort(graph);
		Assert.notNull(sorted);
		Assert.equals(3, sorted.length);
		// A must come before B and C; B must come before C
		var ai = sorted.indexOf(a);
		var bi = sorted.indexOf(b);
		var ci = sorted.indexOf(c);
		Assert.isTrue(ai < bi);
		Assert.isTrue(ai < ci);
		Assert.isTrue(bi < ci);
	}

	public function test_topological_sort_returns_all_nodes() {
		var nodes = [for (i in 0...4) graph.createNode(i)];
		graph.addUniEdge(nodes[0].label, nodes[1].label);
		graph.addUniEdge(nodes[1].label, nodes[2].label);
		graph.addUniEdge(nodes[2].label, nodes[3].label);

		var sorted = Traversal.topologicalSort(graph);
		Assert.notNull(sorted);
		Assert.equals(4, sorted.length);
	}

	public function test_topological_sort_returns_null_on_cycle() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");

		graph.addUniEdge(a.label, b.label);
		graph.addUniEdge(b.label, c.label);
		graph.addUniEdge(c.label, a.label); // cycle

		Assert.isNull(Traversal.topologicalSort(graph));
	}

	public function test_topological_sort_single_node() {
		var a = graph.createNode(1, "A");
		var sorted = Traversal.topologicalSort(graph);
		Assert.notNull(sorted);
		Assert.equals(1, sorted.length);
		Assert.equals(a, sorted[0]);
	}

	public function test_hasCycle_false_on_dag() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		graph.addUniEdge(a.label, b.label);
		Assert.isFalse(Traversal.hasCycle(graph));
	}

	public function test_hasCycle_true_on_cyclic_graph() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		graph.addUniEdge(a.label, b.label);
		graph.addUniEdge(b.label, a.label);
		Assert.isTrue(Traversal.hasCycle(graph));
	}

	public function test_hasCycle_false_on_single_node() {
		graph.createNode(1, "A");
		Assert.isFalse(Traversal.hasCycle(graph));
	}

	public function test_connected_components_single_component() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		graph.addBiEdge(a.label, b.label);
		graph.addBiEdge(b.label, c.label);

		var comps = Traversal.connectedComponents(graph);
		Assert.equals(1, comps.length);
		Assert.equals(3, comps[0].length);
	}

	public function test_connected_components_two_components() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		var d = graph.createNode(4, "D");
		graph.addBiEdge(a.label, b.label);
		graph.addBiEdge(c.label, d.label);

		var comps = Traversal.connectedComponents(graph);
		Assert.equals(2, comps.length);
		var sizes = comps.map(c -> c.length);
		sizes.sort(Reflect.compare);
		Assert.equals(2, sizes[0]);
		Assert.equals(2, sizes[1]);
	}

	public function test_connected_components_isolated_nodes() {
		graph.createNode(1, "A");
		graph.createNode(2, "B");
		graph.createNode(3, "C");

		var comps = Traversal.connectedComponents(graph);
		Assert.equals(3, comps.length);
	}

	public function test_scc_dag_each_node_is_own_scc() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		graph.addUniEdge(a.label, b.label);
		graph.addUniEdge(b.label, c.label);

		var sccs = Traversal.stronglyConnectedComponents(graph);
		Assert.equals(3, sccs.length);
		for (scc in sccs) Assert.equals(1, scc.length);
	}

	public function test_scc_cycle_forms_one_scc() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		graph.addUniEdge(a.label, b.label);
		graph.addUniEdge(b.label, c.label);
		graph.addUniEdge(c.label, a.label);

		var sccs = Traversal.stronglyConnectedComponents(graph);
		Assert.equals(1, sccs.length);
		Assert.equals(3, sccs[0].length);
	}

	public function test_scc_mixed_graph() {
		/*
		 * A -> B <-> C -> D
		 * B,C form one SCC; A and D are their own.
		 */
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		var d = graph.createNode(4, "D");
		graph.addUniEdge(a.label, b.label);
		graph.addUniEdge(b.label, c.label);
		graph.addUniEdge(c.label, b.label);
		graph.addUniEdge(c.label, d.label);

		var sccs = Traversal.stronglyConnectedComponents(graph);
		Assert.equals(3, sccs.length);

		// Find the multi-node SCC
		var multiScc = sccs.filter(s -> s.length > 1);
		Assert.equals(1, multiScc.length);
		Assert.equals(2, multiScc[0].length);

		var multiLabels = multiScc[0].map(n -> n.label);
		Assert.isTrue(multiLabels.indexOf(b.label) != -1);
		Assert.isTrue(multiLabels.indexOf(c.label) != -1);
	}
}
