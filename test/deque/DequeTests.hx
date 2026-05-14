package deque;

import utest.Assert;
import utest.Test;
import dropecho.ds.Deque;

class DequeTests extends Test {
	var deque:Deque<Null<Int>>;

	public function setup() {
		deque = new Deque<Null<Int>>();
	}

	public function test_canInstantiate() {
		Assert.notNull(deque);
	}

	public function test_pushFront_increases_length() {
		deque.pushFront(1);
		Assert.equals(1, deque.length);
		deque.pushFront(2);
		Assert.equals(2, deque.length);
	}

	public function test_pushBack_increases_length() {
		deque.pushBack(1);
		Assert.equals(1, deque.length);
		deque.pushBack(2);
		Assert.equals(2, deque.length);
	}

	public function test_popFront_returns_null_when_empty() {
		Assert.isNull(deque.popFront());
	}

	public function test_popBack_returns_null_when_empty() {
		Assert.isNull(deque.popBack());
	}

	public function test_peekFront_returns_null_when_empty() {
		Assert.isNull(deque.peekFront());
	}

	public function test_peekBack_returns_null_when_empty() {
		Assert.isNull(deque.peekBack());
	}

	public function test_pushFront_then_popFront_is_lifo() {
		deque.pushFront(1);
		deque.pushFront(2);
		deque.pushFront(3);
		Assert.equals(3, deque.popFront());
		Assert.equals(2, deque.popFront());
		Assert.equals(1, deque.popFront());
	}

	public function test_pushBack_then_popBack_is_lifo() {
		deque.pushBack(1);
		deque.pushBack(2);
		deque.pushBack(3);
		Assert.equals(3, deque.popBack());
		Assert.equals(2, deque.popBack());
		Assert.equals(1, deque.popBack());
	}

	public function test_pushBack_then_popFront_is_fifo() {
		deque.pushBack(1);
		deque.pushBack(2);
		deque.pushBack(3);
		Assert.equals(1, deque.popFront());
		Assert.equals(2, deque.popFront());
		Assert.equals(3, deque.popFront());
	}

	public function test_pushFront_then_popBack_is_fifo() {
		deque.pushFront(1);
		deque.pushFront(2);
		deque.pushFront(3);
		Assert.equals(1, deque.popBack());
		Assert.equals(2, deque.popBack());
		Assert.equals(3, deque.popBack());
	}

	public function test_peekFront_does_not_remove() {
		deque.pushBack(1);
		deque.pushBack(2);
		Assert.equals(1, deque.peekFront());
		Assert.equals(2, deque.length);
	}

	public function test_peekBack_does_not_remove() {
		deque.pushBack(1);
		deque.pushBack(2);
		Assert.equals(2, deque.peekBack());
		Assert.equals(2, deque.length);
	}

	public function test_popFront_decreases_length() {
		deque.pushBack(1);
		deque.pushBack(2);
		deque.popFront();
		Assert.equals(1, deque.length);
	}

	public function test_popBack_decreases_length() {
		deque.pushBack(1);
		deque.pushBack(2);
		deque.popBack();
		Assert.equals(1, deque.length);
	}

	public function test_single_element_popFront_empties_deque() {
		deque.pushBack(42);
		Assert.equals(42, deque.popFront());
		Assert.equals(0, deque.length);
		Assert.isNull(deque.popFront());
		Assert.isNull(deque.popBack());
	}

	public function test_single_element_popBack_empties_deque() {
		deque.pushFront(42);
		Assert.equals(42, deque.popBack());
		Assert.equals(0, deque.length);
		Assert.isNull(deque.popFront());
		Assert.isNull(deque.popBack());
	}

	public function test_mixed_push_preserves_order() {
		deque.pushBack(3);
		deque.pushFront(2);
		deque.pushBack(4);
		deque.pushFront(1);
		// front -> [1, 2, 3, 4] -> back
		Assert.equals(1, deque.popFront());
		Assert.equals(4, deque.popBack());
		Assert.equals(2, deque.popFront());
		Assert.equals(3, deque.popBack());
	}

	public function test_iterate_front_to_back() {
		deque.pushBack(1);
		deque.pushBack(2);
		deque.pushBack(3);
		var result = [for (x in deque) x];
		Assert.equals(1, result[0]);
		Assert.equals(2, result[1]);
		Assert.equals(3, result[2]);
	}
}
