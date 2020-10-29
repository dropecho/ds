import massive.munit.TestSuite;

import bsp.BSPNodeTest;
import bsp.BSPTreeTest;
import heap.HeapTest;
import algos.PostOrderTraversalTest;
import algos.InOrderTraversalTest;
import algos.PreOrderTraversalTest;
import graph.BFSTest;
import graph.GraphTest;
import graph.DFSTest;
import graph.GraphNodeTest;
import graph.DijkstraTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(bsp.BSPNodeTest);
		add(bsp.BSPTreeTest);
		add(heap.HeapTest);
		add(algos.PostOrderTraversalTest);
		add(algos.InOrderTraversalTest);
		add(algos.PreOrderTraversalTest);
		add(graph.BFSTest);
		add(graph.GraphTest);
		add(graph.DFSTest);
		add(graph.GraphNodeTest);
		add(graph.DijkstraTest);
	}
}
