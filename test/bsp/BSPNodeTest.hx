package bsp;

import massive.munit.Assert;
import dropecho.ds.*;

class BSPNodeTest {
	var node:BSPNode;

	@Before
	public function setup() {
		node = new BSPNode();
		node.id = "TEST_BSP_NODE";

		var tree = new BSPTree();
		tree.addNode(node);
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(node);
	}

	@Test
	public function createLeft() {
		var left = node.createLeft(2);

		Assert.areEqual(2, left.value);
		Assert.areEqual(left, node.left);
		Assert.isTrue(node.neighbors().indexOf(left) != -1);
	}

	@Test
	public function createRight() {
		var right = node.createRight(2);

		Assert.areEqual(2, right.value);
		Assert.areEqual(right, node.right);
		Assert.isTrue(node.neighbors().indexOf(right) != -1);
	}

	@Test
	public function setLeft() {
		var left = node.setLeft(new BSPNode(2));

		Assert.areEqual(2, left.value);
		Assert.areEqual(left, node.left);
		Assert.isTrue(node.neighbors().indexOf(left) != -1);
	}

	@Test
	public function setRight() {
		var right = node.setRight(new BSPNode(2));

		Assert.areEqual(2, right.value);
		Assert.areEqual(right, node.right);
		Assert.isTrue(node.neighbors().indexOf(right) != -1);
	}

	@Test
	public function isLeaf() {
		var right = node.setRight(new BSPNode(2));

		Assert.isFalse(node.isLeaf());
		Assert.isTrue(right.isLeaf());
	}

	@Test
	public function isRoot() {
		var right = node.setRight(new BSPNode(2));

		Assert.isTrue(node.isRoot());
		Assert.isFalse(right.isRoot());
	}
}
