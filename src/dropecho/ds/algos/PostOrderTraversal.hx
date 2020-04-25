package dropecho.ds.algos;

@:nativeGen
@:expose("algos.PostOrderTraversal")
class PostOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run(node:BSPNode, ?visitor:BSPNode->Bool) {
		if (node.left != null) {
			run(node.left);
		}
		if (node.right != null) {
			run(node.right);
		}

		if (visitor != null) {
			if (visitor(node)) {
				visited.push(node.id);
			} else {
				return visited;
			}
		} else {
			visited.push(node.id);
		}

		return visited;
	}

	// Algorithm Postorder(tree)
	// 1. Traverse the left subtree, i.e., call Postorder(left-subtree)
	// 2. Traverse the right subtree, i.e., call Postorder(right-subtree)
	// 3. Visit the root.
}
