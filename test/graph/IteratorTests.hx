package graph;

import dropecho.ds.graph.DFIterator;
import utest.Assert;
import utest.Test;
import dropecho.ds.*;
import dropecho.ds.graph.BFIterator;

class IteratorTests extends Test {
	var graph:Graph<Int, Int>;

	public function setup() {
		graph = new Graph();
		/*******************
			GRAPH

					1
				 / \
				2   4
			 / \   \
			3   5 - 6

		*******************/

		var node1 = new GraphNode(1);

		node1.label = '1';
		var node2 = new GraphNode(1);
		node2.label = '2';
		var node3 = new GraphNode(1);
		node3.label = '3';
		var node4 = new GraphNode(1);
		node4.label = '4';
		var node5 = new GraphNode(1);
		node5.label = '5';
		var node6 = new GraphNode(1);
		node6.label = '6';

		graph.addNode(node1);
		graph.addNode(node2);
		graph.addNode(node3);
		graph.addNode(node4);
		graph.addNode(node5);
		graph.addNode(node6);

		graph.addBiEdge(node1.label, node4.label);
		graph.addBiEdge(node1.label, node2.label);

		graph.addBiEdge(node2.label, node3.label);
		graph.addBiEdge(node2.label, node5.label);

		graph.addBiEdge(node4.label, node6.label);
		graph.addBiEdge(node6.label, node5.label);
	}

	public function test_bf_iterator() {
		var iterator = new BFIterator(graph.nodes.get('1'));
		var nodes = [1, 2, 4, 3, 5, 6];
		var i = 0;

		for (node in iterator) {
			Assert.equals(node.label, Std.string(nodes[i]));
			i++;
		}
	}

	public function test_df_iterator() {
		var iterator = new DFIterator(graph.nodes.get('1'));

		// Start at one, and go df on "last" in.
		var nodes = [1, 4, 6, 5, 2, 3];
		var i = 0;

		for (node in iterator) {
			Assert.equals(node.label, Std.string(nodes[i]));
			i++;
		}
	}
}
