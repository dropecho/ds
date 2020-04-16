package vantreeseba.gameds.algos;

@:nativeGen
class PostOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run(node:BSPNode) {
		if (node.left != null) {
			run(node.left);
		}
		if (node.right != null) {
			run(node.right);
		}

		visited.push(node.id);
		return visited;
	}

	// Algorithm Postorder(tree)
	// 1. Traverse the left subtree, i.e., call Postorder(left-subtree)
	// 2. Traverse the right subtree, i.e., call Postorder(right-subtree)
	// 3. Visit the root.
}
