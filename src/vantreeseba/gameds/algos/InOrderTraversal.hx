package vantreeseba.gameds.algos;

@:nativeGen
class InOrderTraversal {
	public var visited:Array<String>;

	public function new() {
		visited = new Array<String>();
	}

	public function run(node:BSPNode) {
		if (node.left != null) {
			run(node.left);
		}

		visited.push(node.id);

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
