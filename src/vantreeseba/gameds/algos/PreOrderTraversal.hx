package vantreeseba.gameds.algos;

class PreOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run(node:BSPNode) {
		visited.push(node.id);

		if (node.left != null) {
			run(node.left);
		}
		if (node.right != null) {
			run(node.right);
		}

		return visited;
	}

	// Algorithm Preorder(tree)
	// 1. Visit the root.
	// 2. Traverse the left subtree, i.e., call Preorder(left-subtree)
	// 3. Traverse the right subtree, i.e., call Preorder(right-subtree)
}
