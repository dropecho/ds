package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.Graph;
import dropecho.ds.graph.MST;

class MSTTests extends Test {
	var graph:Graph<Int, Null<Float>>;

	public function setup() {
		graph = new Graph<Int, Null<Float>>();
	}

	function edgeWeight(from:String, to:String, data:Null<Float>):Float {
		return data != null ? data : 1.0;
	}

	public function test_mst_has_n_minus_1_edges() {
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		var d = graph.createNode(4, "D");

		graph.addBiEdge(a.label, b.label, 1.0);
		graph.addBiEdge(b.label, c.label, 2.0);
		graph.addBiEdge(c.label, d.label, 3.0);
		graph.addBiEdge(a.label, d.label, 10.0);
		graph.addBiEdge(b.label, d.label, 5.0);

		var mst = MST.kruskal(graph, edgeWeight);
		Assert.equals(3, mst.length); // n-1 = 4-1 = 3
	}

	public function test_mst_selects_minimum_weight_edges() {
		/*
		 * Classic triangle: A-B=1, B-C=2, A-C=10.
		 * MST: A-B (1) + B-C (2) = total 3. The A-C edge (10) is excluded.
		 */
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");

		graph.addBiEdge(a.label, b.label, 1.0);
		graph.addBiEdge(b.label, c.label, 2.0);
		graph.addBiEdge(a.label, c.label, 10.0);

		var mst = MST.kruskal(graph, edgeWeight);
		Assert.equals(2, mst.length);

		var totalWeight = 0.0;
		for (e in mst) totalWeight += e.weight;
		Assert.equals(3.0, totalWeight);
	}

	public function test_mst_total_weight_is_minimum() {
		/*
		 * A --4-- B
		 * |       |
		 * 2       3
		 * |       |
		 * C --1-- D
		 * MST: C-D(1) + A-C(2) + D-B(3) = 6
		 */
		var a = graph.createNode(1, "A");
		var b = graph.createNode(2, "B");
		var c = graph.createNode(3, "C");
		var d = graph.createNode(4, "D");

		graph.addBiEdge(a.label, b.label, 4.0);
		graph.addBiEdge(a.label, c.label, 2.0);
		graph.addBiEdge(c.label, d.label, 1.0);
		graph.addBiEdge(d.label, b.label, 3.0);

		var mst = MST.kruskal(graph, edgeWeight);
		Assert.equals(3, mst.length);

		var totalWeight = 0.0;
		for (e in mst) totalWeight += e.weight;
		Assert.equals(6.0, totalWeight);
	}

	public function test_unweighted_graph_returns_n_minus_1_edges() {
		var g = new Graph<Int, Int>();
		var nodes = [for (i in 0...5) g.createNode(i)];
		for (i in 0...4) g.addBiEdge(nodes[i].label, nodes[i + 1].label);
		g.addBiEdge(nodes[0].label, nodes[4].label);
		g.addBiEdge(nodes[1].label, nodes[3].label);

		var mst = MST.kruskal(g);
		Assert.equals(4, mst.length);
	}
}
