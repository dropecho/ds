package lrucache;

import utest.Assert;
import utest.Test;
import dropecho.ds.LRUCache;

class LRUCacheTests extends Test {
	var cache:LRUCache<Int>;

	public function setup() {
		cache = new LRUCache<Int>(3);
	}

	public function test_canInstantiate() {
		Assert.notNull(cache);
	}

	public function test_capacity_is_set() {
		Assert.equals(3, cache.capacity);
	}

	public function test_size_starts_at_zero() {
		Assert.equals(0, cache.size);
	}

	public function test_set_increases_size() {
		cache.set("a", 1);
		Assert.equals(1, cache.size);
	}

	public function test_get_returns_null_for_missing_key() {
		Assert.isNull(cache.get("missing"));
	}

	public function test_get_returns_value_after_set() {
		cache.set("a", 42);
		Assert.equals(42, cache.get("a"));
	}

	public function test_has_returns_false_for_missing_key() {
		Assert.isFalse(cache.has("x"));
	}

	public function test_has_returns_true_after_set() {
		cache.set("x", 1);
		Assert.isTrue(cache.has("x"));
	}

	public function test_set_updates_existing_key() {
		cache.set("a", 1);
		cache.set("a", 99);
		Assert.equals(99, cache.get("a"));
		Assert.equals(1, cache.size);
	}

	public function test_evicts_lru_when_over_capacity() {
		cache.set("a", 1);
		cache.set("b", 2);
		cache.set("c", 3);
		cache.set("d", 4); // evicts "a" (least recently used)
		Assert.isFalse(cache.has("a"));
		Assert.isTrue(cache.has("b"));
		Assert.isTrue(cache.has("c"));
		Assert.isTrue(cache.has("d"));
		Assert.equals(3, cache.size);
	}

	public function test_get_refreshes_recency() {
		cache.set("a", 1);
		cache.set("b", 2);
		cache.set("c", 3);
		cache.get("a"); // "a" is now most recent; "b" becomes LRU
		cache.set("d", 4); // evicts "b"
		Assert.isTrue(cache.has("a"));
		Assert.isFalse(cache.has("b"));
		Assert.isTrue(cache.has("c"));
		Assert.isTrue(cache.has("d"));
	}

	public function test_set_refreshes_recency() {
		cache.set("a", 1);
		cache.set("b", 2);
		cache.set("c", 3);
		cache.set("a", 10); // "a" is now most recent; "b" becomes LRU
		cache.set("d", 4);  // evicts "b"
		Assert.isTrue(cache.has("a"));
		Assert.isFalse(cache.has("b"));
	}

	public function test_remove_returns_true_for_existing_key() {
		cache.set("a", 1);
		Assert.isTrue(cache.remove("a"));
	}

	public function test_remove_returns_false_for_missing_key() {
		Assert.isFalse(cache.remove("x"));
	}

	public function test_remove_decreases_size() {
		cache.set("a", 1);
		cache.remove("a");
		Assert.equals(0, cache.size);
	}

	public function test_remove_item_not_returned_by_get() {
		cache.set("a", 1);
		cache.remove("a");
		Assert.isNull(cache.get("a"));
	}

	public function test_clear_removes_all_entries() {
		cache.set("a", 1);
		cache.set("b", 2);
		cache.clear();
		Assert.equals(0, cache.size);
		Assert.isFalse(cache.has("a"));
		Assert.isFalse(cache.has("b"));
	}

	public function test_can_reuse_after_clear() {
		cache.set("a", 1);
		cache.clear();
		cache.set("a", 2);
		Assert.equals(2, cache.get("a"));
	}

	public function test_eviction_order_with_many_accesses() {
		cache.set("a", 1);
		cache.set("b", 2);
		cache.set("c", 3);
		cache.get("a");
		cache.get("b");
		cache.get("a");
		// order now: a (most recent), b, c (LRU)
		cache.set("d", 4); // evicts "c"
		Assert.isFalse(cache.has("c"));
		Assert.isTrue(cache.has("a"));
		Assert.isTrue(cache.has("b"));
		Assert.isTrue(cache.has("d"));
	}
}
