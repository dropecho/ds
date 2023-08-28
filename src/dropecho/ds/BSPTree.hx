package dropecho.ds;

@:nativeGen
@:expose("BSPTree")
class BSPTree<T> extends Graph<T, String> {
	public var root:BSPNode<T>;

	/**
	 * @param rootValue - The value to create the root node with. 
	 */
	public function new(?rootValue:T) {
		super();
		root = new BSPNode(rootValue);
		this.addNode(root);
	}

	inline public function getParent(node):BSPNode<T> {
		return node.parent;
	}

	/**
	 * Get the direct children of a given node.
	 * @param node - The node to get the children of.
	 */
	inline public function getChildren(node:BSPNode<T>):Array<BSPNode<T>> {
		var children = [];
		if (node.hasLeft()) {
			children.push(node.left);
		}
		if (node.hasRight()) {
			children.push(node.right);
		}
		return children;
	}

	/**
	 * Get the root node of the bsp tree.
	 * The root node is the "parent" most node of the tree, and has no parent itself.
	 */
	inline public function getRoot() {
		return root;
	}

	/**
	 * Get the leaf nodes of the bsp tree.
	 * Leaf nodes are the "child most" nodes, that have no children themselves.
	 */
	public function getLeafs() {
		return [
			for (node in nodes) {
				(cast(node)).isLeaf() ? node : continue;
			}
		];
	}
}
