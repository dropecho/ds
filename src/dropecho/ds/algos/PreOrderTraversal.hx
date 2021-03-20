package dropecho.ds.algos;

@:nativeGen
@:expose("algos.PreOrderTraversal")
class PreOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run<T>(node:BSPNode<T>, ?visitor:BSPNode<T>->Bool) {
		if (visitor != null) {
			if (visitor(node)) {
				visited.push(node.id);
			} else {
				return visited;
			}
		} else {
			visited.push(node.id);
		}

		if (node.left != null) {
			run(node.left, visitor);
		}
		if (node.right != null) {
			run(node.right, visitor);
		}
		return visited;
	}

	// Algorithm Preorder(tree)
	// 1. Visit the root.
	// 2. Traverse the left subtree, i.e., call Preorder(left-subtree)
	// 3. Traverse the right subtree, i.e., call Preorder(right-subtree)
}
