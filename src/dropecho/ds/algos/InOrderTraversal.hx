package dropecho.ds.algos;

@:nativeGen
@:expose("algos.InOrderTraversal")
class InOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run(node:BSPNode, ?visitor:BSPNode->Bool) {
		if (node.left != null) {
			run(node.left);
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

		if (node.right != null) {
			run(node.right);
		}

		return visited;
	}

	// Algorithm Inorder(tree)
	// 1. Traverse the left subtree, i.e., call Inorder(left-subtree)
	// 2. Visit the root.
	// 3. Traverse the right subtree, i.e., call Inorder(right-subtree)
}
