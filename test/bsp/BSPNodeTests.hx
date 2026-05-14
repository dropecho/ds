package bsp;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

class BSPNodeTests extends Test {
	var node:BSPNode<Int>;

	public function setup() {
		node = new BSPNode();
		node.label = "TEST_BSP_NODE";

		var tree = new BSPTree<Int>();
		tree.addNode(node);
	}

	public function test_canInstantiate() {
		Assert.notNull(node);
	}

	public function test_createLeft() {
		var left = node.createLeft(2);

		Assert.equals(2, left.value);
		Assert.equals(left, node.left);
		Assert.isTrue(node.graph.neighbors(node).indexOf(left) != -1);
	}

	public function test_createRight() {
		var right = node.createRight(2);

		Assert.equals(2, right.value);
		Assert.equals(right, node.right);
		Assert.isTrue(node.graph.neighbors(node).indexOf(right) != -1);
	}

	public function test_setLeft() {
		var left = node.setLeft(new BSPNode(2));

		Assert.equals(2, left.value);
		Assert.equals(left, node.left);
		Assert.isTrue(node.graph.neighbors(node).indexOf(left) != -1);
	}

	public function test_setRight() {
		var right = node.setRight(new BSPNode(2));

		Assert.equals(2, right.value);
		Assert.equals(right, node.right);
		Assert.isTrue(node.graph.neighbors(node).indexOf(right) != -1);
	}

	public function test_isLeaf() {
		Assert.isTrue(node.isLeaf());
		var right = node.setRight(new BSPNode(2));
		Assert.isFalse(node.isLeaf());
		Assert.isTrue(right.isLeaf());
	}

	public function test_isRoot() {
		var right = node.setRight(new BSPNode(2));
		Assert.isTrue(node.isRoot());
		Assert.isFalse(right.isRoot());
	}

	public function test_hasLeft() {
		Assert.isFalse(node.hasLeft());
		node.createLeft(1);
		Assert.isTrue(node.hasLeft());
	}

	public function test_hasRight() {
		Assert.isFalse(node.hasRight());
		node.createRight(1);
		Assert.isTrue(node.hasRight());
	}
}
