package graph;

import utest.Assert;
import utest.Test;
import dropecho.ds.Graph;
import dropecho.ds.graph.Search;

typedef Pos = {x:Float, y:Float};

function euclidean(a:dropecho.ds.IGraphNode<Pos, Float>, b:dropecho.ds.IGraphNode<Pos, Float>):Float {
	var dx = b.value.x - a.value.x;
	var dy = b.value.y - a.value.y;
	return Math.sqrt(dx * dx + dy * dy);
}

class AStarTests extends Test {
	var graph:Graph<Pos, Float>;

	public function setup() {
		graph = new Graph<Pos, Float>();
	}

	public function test_finds_direct_path() {
		var a = graph.createNode({x: 0.0, y: 0.0}, "A");
		var b = graph.createNode({x: 1.0, y: 0.0}, "B");
		var c = graph.createNode({x: 2.0, y: 0.0}, "C");

		graph.addBiEdge(a.label, b.label, 1.0);
		graph.addBiEdge(b.label, c.label, 1.0);

		var result = Search.astar(a, c, euclidean);
		Assert.isTrue(result.found);
		Assert.equals(3, result.path.length);
		Assert.equals(a, result.path[0]);
		Assert.equals(b, result.path[1]);
		Assert.equals(c, result.path[2]);
	}

	public function test_returns_not_found_for_disconnected_graph() {
		var a = graph.createNode({x: 0.0, y: 0.0}, "A");
		var b = graph.createNode({x: 1.0, y: 0.0}, "B");

		var result = Search.astar(a, b, euclidean);
		Assert.isFalse(result.found);
		Assert.isNull(result.path);
	}

	public function test_start_equals_end_returns_single_node_path() {
		var a = graph.createNode({x: 0.0, y: 0.0}, "A");
		graph.createNode({x: 1.0, y: 0.0}, "B");

		var result = Search.astar(a, a, euclidean);
		Assert.isTrue(result.found);
		Assert.equals(1, result.path.length);
		Assert.equals(a, result.path[0]);
	}

	public function test_chooses_shorter_path_over_longer() {
		/*
		 * A --10-- B
		 * |        |
		 * 1        1
		 * |        |
		 * C --1--- D
		 *
		 * A->B directly costs 10; A->C->D->B costs 3.
		 */
		var a = graph.createNode({x: 0.0, y: 0.0}, "A");
		var b = graph.createNode({x: 1.0, y: 0.0}, "B");
		var c = graph.createNode({x: 0.0, y: 1.0}, "C");
		var d = graph.createNode({x: 1.0, y: 1.0}, "D");

		graph.addBiEdge(a.label, b.label, 10.0);
		graph.addBiEdge(a.label, c.label, 1.0);
		graph.addBiEdge(c.label, d.label, 1.0);
		graph.addBiEdge(d.label, b.label, 1.0);

		var result = Search.astar(a, b, euclidean, (n1, n2) -> {
			var data = n1.graph.edgeData(n1.label, n2.label);
			data != null ? (data : Float) : 1.0;
		});

		Assert.isTrue(result.found);
		Assert.equals(4, result.path.length);
		Assert.equals(a, result.path[0]);
		Assert.equals(c, result.path[1]);
		Assert.equals(d, result.path[2]);
		Assert.equals(b, result.path[3]);
	}

	public function test_unweighted_path_length() {
		var nodes = [for (i in 0...5) graph.createNode({x: (i : Float), y: 0.0})];
		for (i in 0...4) graph.addBiEdge(nodes[i].label, nodes[i + 1].label, 1.0);

		var result = Search.astar(nodes[0], nodes[4], euclidean);
		Assert.isTrue(result.found);
		Assert.equals(5, result.path.length);
	}
}
