package dropecho.ds;

@:nativeGen
@:expose("BSPNode")
class BSPNode extends GraphNode<Dynamic, Dynamic> {
	public var parent:BSPNode;
	public var left:BSPNode;
	public var right:BSPNode;

	public function new(?value:Dynamic) {
		super(value);
	}

  /**
   * Create a left child node with the given value.
   *
   * @param {Dynamic} value - The value to assign to the node.
   * @return {BSPNode} The created node.
   */
	public function createLeft(?value:Dynamic):BSPNode {
		return this.setLeft(new BSPNode(value));
	}

  /**
   * Create a right child node with the given value.
   *
   * @param {Dynamic} value - The value to assign to the created node.
   * @return {BSPNode} The created node.
   */
	public function createRight(?value:Dynamic):BSPNode {
		return this.setRight(new BSPNode(value));
	}

  /**
   * Sets the left child of this node.
   *
   * @param {BSPNode} node - The node to set as left child.
   * @return {BSPNode} this node.
   */
	public function setLeft(node:BSPNode):BSPNode {
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
   * @param {BSPNode} node - The node to set as the right child.
   * @return {BSPNode} This node.
   */
	public function setRight(node:BSPNode):BSPNode {
		this.right = node;
		node.parent = this;
		graph.addNode(node);
		graph.addUniEdge(this.id, node.id, "right");
		graph.addUniEdge(node.id, this.id, "parent");

		return node;
	}

  /**
   * Returns true if this node has no children.
   * @return {Bool} 
   */
  public function isLeaf():Bool {
		return this.right == null && this.left == null;
	}

  /**
   * Returns true if this node has no parent. 
   * @return {Bool}
   */
	public function isRoot():Bool {
		return this.parent == null;
	}

  /**
   * Returns true if this node has a left child.
   * @return {Bool} 
   */
	public function hasLeft():Bool {
		return this.left != null;
	}

  /**
   * Returns true if this node has a right child.
   * @return {Bool} 
   */
	public function hasRight():Bool {
		return this.right != null;
	}
}
