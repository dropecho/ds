package unionfind;

import utest.Assert;
import utest.Test;
import dropecho.ds.UnionFind;

class UnionFindTests extends Test {
	var uf:UnionFind;

	public function setup() {
		uf = new UnionFind(6);
	}

	public function test_canInstantiate() {
		Assert.notNull(uf);
	}

	public function test_initial_component_count_equals_size() {
		Assert.equals(6, uf.componentCount);
	}

	public function test_each_element_is_its_own_root_initially() {
		for (i in 0...6) {
			Assert.equals(i, uf.find(i));
		}
	}

	public function test_union_merges_two_components() {
		uf.union(0, 1);
		Assert.equals(5, uf.componentCount);
	}

	public function test_union_returns_true_when_newly_merged() {
		Assert.isTrue(uf.union(0, 1));
	}

	public function test_union_returns_false_when_already_connected() {
		uf.union(0, 1);
		Assert.isFalse(uf.union(0, 1));
		Assert.isFalse(uf.union(1, 0));
	}

	public function test_union_does_not_decrease_count_when_already_connected() {
		uf.union(0, 1);
		uf.union(0, 1);
		Assert.equals(5, uf.componentCount);
	}

	public function test_connected_after_union() {
		uf.union(0, 1);
		Assert.isTrue(uf.connected(0, 1));
		Assert.isTrue(uf.connected(1, 0));
	}

	public function test_not_connected_initially() {
		Assert.isFalse(uf.connected(0, 1));
	}

	public function test_transitive_connectivity() {
		uf.union(0, 1);
		uf.union(1, 2);
		Assert.isTrue(uf.connected(0, 2));
		Assert.equals(4, uf.componentCount);
	}

	public function test_disjoint_components_stay_separate() {
		uf.union(0, 1);
		uf.union(2, 3);
		Assert.isTrue(uf.connected(0, 1));
		Assert.isTrue(uf.connected(2, 3));
		Assert.isFalse(uf.connected(0, 2));
		Assert.equals(4, uf.componentCount);
	}

	public function test_merging_two_large_components() {
		uf.union(0, 1);
		uf.union(1, 2);
		uf.union(3, 4);
		uf.union(4, 5);
		Assert.equals(2, uf.componentCount);
		uf.union(0, 3);
		Assert.equals(1, uf.componentCount);
		Assert.isTrue(uf.connected(0, 5));
	}

	public function test_find_is_consistent_after_path_compression() {
		uf.union(0, 1);
		uf.union(1, 2);
		uf.union(2, 3);
		var root = uf.find(0);
		Assert.equals(root, uf.find(1));
		Assert.equals(root, uf.find(2));
		Assert.equals(root, uf.find(3));
	}

	public function test_self_is_always_connected_to_self() {
		for (i in 0...6) {
			Assert.isTrue(uf.connected(i, i));
		}
	}
}
