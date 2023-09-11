package dropecho.ds;

@:nativeGen
@:expose("BSPNode")
class BSPNode<TNodeData> extends GraphNode<TNodeData, String> {
	public var parent:BSPNode<TNodeData>;
	public var left:BSPNode<TNodeData>;
	public var right:BSPNode<TNodeData>;

	public function new(?value:TNodeData) {
		super(value);
	}

	/**
	 * Create a left child node with the given value.
	 *
	 * @param value - The value to assign to the created node.
	 * @return The created node.
	 */
	inline public function createLeft(?value:TNodeData):BSPNode<TNodeData> {
		return this.setLeft(new BSPNode(value));
	}

	/**
	 * Create a right child node with the given value.
	 *
	 * @param value - The value to assign to the created node.
	 * @return The created node.
	 */
	inline public function createRight(?value:TNodeData):BSPNode<TNodeData> {
		return this.setRight(new BSPNode(value));
	}

	/**
	 * Sets the left child of this node.
	 *
	 * @param node - The node to set as left child.
	 * @return this node.
	 */
	public function setLeft(node:BSPNode<TNodeData>):BSPNode<TNodeData> {
		this.left = node;
		node.parent = this;
		graph.addNode(node);
		graph.addUniEdge(this.id, node.id, "left");
		graph.addUniEdge(node.id, this.id, "parent");

		return node;
	}

	/**
	 * Sets the right child of this node.
	 *
	 * @param node - The node to set as the right child.
	 * @return This node.
	 */
	public function setRight(node:BSPNode<TNodeData>):BSPNode<TNodeData> {
		this.right = node;
		node.parent = this;
		graph.addNode(node);
		graph.addUniEdge(this.id, node.id, "right");
		graph.addUniEdge(node.id, this.id, "parent");

		return node;
	}

	/**
	 * @return true if this node has no children.
	 */
	inline public function isLeaf():Bool {
		return this.right == null && this.left == null;
	}

	/**
	 * @return true if this node has no parent.
	 */
	inline public function isRoot():Bool {
		return this.parent == null;
	}

	/**
	 * @return true if this node has a left child.
	 */
	inline public function hasLeft():Bool {
		return this.left != null;
	}

	/**
	 * @return true if this node has a right child.
	 */
	inline public function hasRight():Bool {
		return this.right != null;
	}
}
