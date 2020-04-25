package bsp;

import massive.munit.Assert;
import dropecho.ds.*;

class BSPTreeTest {
	var tree:BSPTree;

	@Before
	public function setup() {
		tree = new BSPTree(4);
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(tree);
	}

	@Test
	public function createNode() {
		var root = tree.root;

		Assert.areEqual(4, root.value);
		Assert.isTrue(tree.nodes.exists(root.id));
	}

	@Test
	public function getParent() {
		var root = tree.root;

		var left = root.createLeft(5);
		var right = root.createRight(5);

		Assert.areEqual(5, left.value);
		Assert.areEqual(left, root.left);
		Assert.areEqual(root, tree.getParent(left));

		Assert.areEqual(5, right.value);
		Assert.areEqual(right, root.right);
		Assert.areEqual(root, tree.getParent(right));
	}

	@Test
	public function getChildren() {
		var root = tree.root;

		var left = root.createLeft(5);

		Assert.areEqual(5, left.value);
		Assert.areEqual(left, root.left);
		Assert.isTrue(tree.getChildren(root).indexOf(left) != -1);

		var right = root.createRight(5);

		Assert.areEqual(5, right.value);
		Assert.areEqual(right, root.right);
		Assert.isTrue(tree.getChildren(root).indexOf(right) != -1);
	}

	@Test
	public function getLeafs() {
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

	@Test
	public function getRoot() {
		var root = tree.root;

		Assert.areEqual(root, tree.getRoot());
	}
}
