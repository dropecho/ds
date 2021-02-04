package dropecho.ds;

@:nativeGen
@:expose("BSPTree")
class BSPTree extends Graph<Dynamic, Dynamic> {
	public var root:BSPNode;

	/**
	 * @param rootValue - The value to create the root node with. 
	 */
	public function new(?rootValue:Dynamic) {
		super();
		root = new BSPNode();
		root.value = rootValue;
		this.addNode(root);
	}

	public function getParent(node):BSPNode {
		return cast(outNeighbors(node, (id, data) -> data == "parent")[0]);
	}

	/**
	 * Get the direct children of a given node.
	 * @param node - The node to get the children of.
	 */
	public function getChildren(node:BSPNode):Array<BSPNode> {
		return cast(outNeighbors(node, (id, data) -> data == "left" || data == "right"));
	}

	/**
	 * Get the root node of the bsp tree.
	 * The root node is the "parent" most node of the tree, and has no parent itself.
	 */
	public function getRoot() {
		return root;
	}

	/**
	 * Get the leaf nodes of the bsp tree.
	 * Leaf nodes are the "child most" nodes, that have no children themselves.
	 */
	public function getLeafs() {
		return [
			for (node in nodes) {
				getChildren(cast node).length == 0 ? node : continue;
			}
		];
	}
}
