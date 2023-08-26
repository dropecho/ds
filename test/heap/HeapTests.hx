package heap;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

typedef Foo = {
	var id:Int;
	var d:Int;
};

class HeapTests extends Test {
	var heap:Heap<Null<Int>>;

	public function setup() {
		heap = new Heap<Null<Int>>();
	}

	public function test_canInstantiate() {
		Assert.notNull(heap);
	}

	public function test_simple_push_with_pop_default_compare() {
		var heap2 = new Heap<Null<Int>>();
		heap2.push(4);
		var expected:Null<Int> = null;

		Assert.equals(4, heap2.pop());
		Assert.equals(expected, heap2.pop());
	}

	public function test_simple_push_with_pop() {
		heap.push(4);
		var expected:Null<Int> = null;

		Assert.equals(4, heap.pop());
		Assert.equals(expected, heap.pop());
	}

	public function test_simple_push_with_peek() {
		heap.push(4);

		Assert.equals(4, heap.peek());
		Assert.equals(4, heap.peek());
	}

	public function test_peek_when_empty() {
		Assert.isTrue(null == heap.peek());
	}

	public function test_push_heapifies_values_in_max_heap() {
		heap.compare = (a, b) -> Reflect.compare(a, b) > 0;
		Assert.isTrue(heap.compare(4, 3));

		heap.push(4);
		heap.push(5);
		heap.push(6);
		heap.push(2);
		heap.push(1);
		heap.push(3);

		Assert.equals(6, heap.pop());
		Assert.equals(5, heap.pop());
		Assert.equals(4, heap.pop());
		Assert.equals(3, heap.pop());
		Assert.equals(2, heap.pop());
		Assert.equals(1, heap.pop());
	}

	public function test_push_heapifies_values_in_min_heap() {
		heap.compare = (a, b) -> Reflect.compare(a, b) < 0;

		heap.push(3);
		heap.push(1);
		heap.push(6);
		heap.push(5);
		heap.push(8);
		heap.push(9);

		Assert.equals(1, heap.pop());
		Assert.equals(3, heap.pop());
		Assert.equals(5, heap.pop());
		Assert.equals(6, heap.pop());
		Assert.equals(8, heap.pop());
		Assert.equals(9, heap.pop());
	}

	public function test_push_heapifies_values_in_min_heap_with_equal_vals() {
		var heap2 = new Heap<Foo>((a:Foo, b:Foo) -> a.d < b.d);

		heap2.push({id: 1, d: 5});
		heap2.push({id: 2, d: 5});
		heap2.push({id: 5, d: 1});
		heap2.push({id: 6, d: 1});

		Assert.equals(1, heap2.pop().d);
		Assert.equals(1, heap2.pop().d);
		Assert.equals(5, heap2.pop().d);
		Assert.equals(5, heap2.pop().d);
	}

	public function test_push_heapifies_values_in_min_heap_with_equal_vals_after_pops() {
		var heap2 = new Heap<Foo>((a:Foo, b:Foo) -> a.d < b.d);

		heap2.push({id: 1, d: 4});
		heap2.push({id: 2, d: 5});
		heap2.push({id: 3, d: 1});
		Assert.equals(1, heap2.pop().d);
		Assert.equals(4, heap2.pop().d);

		heap2.push({id: 1, d: 4});
		heap2.push({id: 4, d: 5});
		heap2.push({id: 5, d: 1});
		Assert.equals(1, heap2.pop().d);
		Assert.equals(4, heap2.pop().d);

		heap2.push({id: 1, d: 4});
		heap2.push({id: 2, d: 5});
		heap2.push({id: 6, d: 1});

		Assert.equals(1, heap2.pop().d);
		Assert.equals(4, heap2.pop().d);
		Assert.equals(5, heap2.pop().d);
		Assert.equals(5, heap2.pop().d);
		Assert.equals(5, heap2.pop().d);
		Assert.equals(null, heap2.pop());
	}

	public function test_push_heapifies_values_in_min_heap_with_equal_vals_after_set_value() {
		var heap2 = new Heap<Foo>((a:Foo, b:Foo) -> a.d < b.d);

		var n1 = {id: 0, d: 1};
		var n2 = {id: 1, d: 4};
		var n3 = {id: 2, d: 8};
		var n4 = {id: 3, d: 6};

		heap2.push(n1);
		heap2.push(n2);
		heap2.push(n3);
		heap2.push(n4);

		Assert.equals(0, heap2.pop().id);

		heap2.set_value_obj(n4, {id: 3, d: 2});

		Assert.equals(3, heap2.pop().id);
		Assert.equals(1, heap2.pop().id);
		Assert.equals(2, heap2.pop().id);
		Assert.equals(null, heap2.pop());
	}
}
