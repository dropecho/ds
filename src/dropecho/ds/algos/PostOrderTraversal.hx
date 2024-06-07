package dropecho.ds.algos;

@:nativeGen
@:expose("algos.PostOrderTraversal")
class PostOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run<T>(node:BSPNode<T>, ?visitor:BSPNode<T>->Bool) {
		if (node.left != null) {
			run(node.left, visitor);
		}
		if (node.right != null) {
			run(node.right, visitor);
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

		return visited;
	}

	// Algorithm Postorder(tree)
	// 1. Traverse the left subtree, i.e., call Postorder(left-subtree)
	// 2. Traverse the right subtree, i.e., call Postorder(right-subtree)
	// 3. Visit the root.
}
