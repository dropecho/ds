package dropecho.ds;

@:nativeGen
@:expose("BSPTree")
class BSPTree extends Graph<Dynamic, Dynamic> {
	public var root:BSPNode;

	public function new(?rootValue:Dynamic) {
		super();
		root = new BSPNode();
		root.value = rootValue;
		this.addNode(root);
	}

	public function getParent(node:BSPNode) {
		return outNeighbors(node, (id, data) -> data == "parent")[0];
	}

	public function getChildren(node:BSPNode) {
		return outNeighbors(node, (id, data) -> data == "left" || data == "right");
	}

	public function getRoot() {
		return root;
	}

	public function getLeafs() {
		return [
			for (node in nodes) {
				getChildren(cast node).length == 0 ? node : continue;
			}
		];
	}
}
