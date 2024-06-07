package dropecho.ds.algos;

@:nativeGen
@:expose("algos.InOrderTraversal")
class InOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run<T>(node:BSPNode<T>, ?visitor:BSPNode<T>->Bool) {
		if (node.left != null) {
			run(node.left, visitor);
		}

		if (visitor != null) {
			if (visitor(node)) {
				visited.push(node.label);
			} else {
				return visited;
			}
		} else {
			visited.push(node.label);
		}

		if (node.right != null) {
			run(node.right, visitor);
		}

		return visited;
	}

	// Algorithm Inorder(tree)
	// 1. Traverse the left subtree, i.e., call Inorder(left-subtree)
	// 2. Visit the root.
	// 3. Traverse the right subtree, i.e., call Inorder(right-subtree)
}
