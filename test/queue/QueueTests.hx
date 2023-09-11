package queue;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

class TestObj {
	public var x:Int = 1;
	public var y:Int = 1;

	public function new() {};
}

class QueueTests extends Test {
	var intQueue:Queue<Int>;
	var objQueue:Queue<TestObj>;

	public function setup() {
		intQueue = new Queue<Int>();
		objQueue = new Queue<TestObj>();
	}

	public function test_canInstantiate() {
		Assert.notNull(intQueue);
		Assert.notNull(objQueue);
	}

	public function test_peek_should_not_change_length() {
		intQueue.enqueue(1);
		final length = intQueue.length;
		intQueue.peek();

		Assert.equals(intQueue.length, length);
	}

	public function test_dequeue_should_decrease_length_by_1() {
		intQueue.enqueue(1);
		final length = intQueue.length;
		intQueue.dequeue();

		Assert.equals(intQueue.length, length - 1);
	}

	public function test_enqueue_should_increase_length_by_1() {
		final length = intQueue.length;
		intQueue.enqueue(1);

		Assert.equals(intQueue.length, length + 1);
	}

	public function test_pop_should_return_first_item_pushed() {
		final first = 1;
		intQueue.enqueue(first);
		intQueue.enqueue(2);
		intQueue.enqueue(3);

		final item = intQueue.dequeue();

		Assert.equals(item, first);
	}

	public function test_peek_should_return_first_item_pushed() {
		final first = 1;
		intQueue.enqueue(first);
		intQueue.enqueue(2);
		intQueue.enqueue(3);

		final item = intQueue.peek();

		Assert.equals(item, first);
	}

	public function test_should_be_able_to_iterate_over_queue() {
		intQueue.enqueue(1);
		intQueue.enqueue(2);
		intQueue.enqueue(3);

		// start at first one pushed in.
		var num = 1;

		// Should return items in lifo order.
		for (item in intQueue) {
			Assert.equals(item, num);
			num += 1;
		}
	}
}
