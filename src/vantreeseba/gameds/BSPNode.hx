package vantreeseba.gameds;

@:nativeGen
class BSPNode extends GraphNode<Dynamic, Dynamic> {
	public var parent:BSPNode;
	public var left:BSPNode;
	public var right:BSPNode;

	public function new(?value:Dynamic) {
		super(value);
	}

	public function createLeft(?value:Dynamic):BSPNode {
		return this.setLeft(new BSPNode(value));
	}

	public function createRight(?value:Dynamic):BSPNode {
		return this.setRight(new BSPNode(value));
	}

	public function setLeft(node:BSPNode):BSPNode {
		this.left = node;
		node.parent = this;
    graph.addNode(node);
		graph.addUniEdge(this.id, node.id, "left");
		graph.addUniEdge(node.id, this.id, "parent");

		return node;
	}

	public function setRight(node:BSPNode):BSPNode {
		this.right = node;
		node.parent = this;
    graph.addNode(node);
		graph.addUniEdge(this.id, node.id, "right");
		graph.addUniEdge(node.id, this.id, "parent");

		return node;
	}

	public function isLeaf() {
		return this.right == null && this.left == null;
	}

	public function isRoot() {
		return this.parent == null;
	}
}
