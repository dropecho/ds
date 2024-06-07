package bsp;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

class BSPTreeTests extends Test {
	var tree:BSPTree<Int>;

	public function setup() {
		tree = new BSPTree(4);
	}

	public function test_canInstantiate() {
		Assert.notNull(tree);
	}

	public function test_createNode() {
		var root = tree.root;

		Assert.equals(4, root.value);
		Assert.isTrue(tree.nodes.exists(root.label));
	}

	public function test_getParent() {
		var root = tree.root;

		var left = root.createLeft(5);
		var right = root.createRight(5);

		Assert.equals(5, left.value);
		Assert.equals(left, root.left);
		Assert.equals(root, tree.getParent(left));

		Assert.equals(5, right.value);
		Assert.equals(right, root.right);
		Assert.equals(root, tree.getParent(right));
	}

	public function test_getChildren() {
		var root = tree.root;

		var left = root.createLeft(5);

		Assert.equals(5, left.value);
		Assert.equals(left, root.left);
		Assert.isTrue(tree.getChildren(root).indexOf(left) != -1);

		var right = root.createRight(5);

		Assert.equals(5, right.value);
		Assert.equals(right, root.right);
		Assert.isTrue(tree.getChildren(root).indexOf(right) != -1);
	}

	public function test_getLeafs() {
		var root = tree.root;
		var left = root.createLeft(1);
		var right = root.createRight(1);

		var lleft = left.createLeft(2);
		var rleft = right.createLeft(2);

		var rlleft = rleft.createLeft(3);
		var rright = right.createRight(3);

		var leafs = tree.getLeafs();

		Assert.isTrue(leafs.indexOf(root) == -1);
		Assert.isTrue(leafs.indexOf(left) == -1);
		Assert.isTrue(leafs.indexOf(right) == -1);
		Assert.isTrue(leafs.indexOf(rleft) == -1);

		// are leafs
		Assert.isTrue(leafs.indexOf(lleft) != -1);
		Assert.isTrue(leafs.indexOf(rlleft) != -1);
		Assert.isTrue(leafs.indexOf(rright) != -1);
	}

	public function test_getRoot() {
		var root = tree.root;

		Assert.equals(root, tree.getRoot());
	}
}
