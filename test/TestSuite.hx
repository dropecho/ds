import massive.munit.TestSuite;

import bsp.BSPNodeTest;
import bsp.BSPTreeTest;
import algos.BFSTest;
import algos.PostOrderTraversalTest;
import algos.DFSTest;
import algos.InOrderTraversalTest;
import algos.PreOrderTraversalTest;
import graph.GraphTest;
import graph.GraphNodeTest;

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
		add(algos.BFSTest);
		add(algos.PostOrderTraversalTest);
		add(algos.DFSTest);
		add(algos.InOrderTraversalTest);
		add(algos.PreOrderTraversalTest);
		add(graph.GraphTest);
		add(graph.GraphNodeTest);
	}
}
