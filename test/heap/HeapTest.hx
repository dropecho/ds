package heap;

import massive.munit.Assert;
import vantreeseba.gameds.*;

typedef Foo = {
	var id:Int;
	var d:Int;
};

class HeapTest {
	var heap:Heap<Null<Int>>;

	@Before
	public function setup() {
		heap = new Heap<Null<Int>>();
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(heap);
	}

	@Test
	public function simple_push_with_pop_default_compare() {
		var heap2 = new Heap<Null<Int>>();
		heap2.push(4);
		var expected:Null<Int> = null;

		Assert.areEqual(4, heap2.pop());
		Assert.areEqual(expected, heap2.pop());
	}

	@Test
	public function simple_push_with_pop() {
		heap.push(4);
		var expected:Null<Int> = null;

		Assert.areEqual(4, heap.pop());
		Assert.areEqual(expected, heap.pop());
	}

	@Test
	public function simple_push_with_peek() {
		heap.push(4);

		Assert.areEqual(4, heap.peek());
		Assert.areEqual(4, heap.peek());
	}

	@Test
	public function peek_when_empty() {
		Assert.isTrue(null == heap.peek());
	}

	@Test
	public function push_heapifies_values_in_max_heap() {
		heap.compare = (a, b) -> Reflect.compare(a, b) > 0;
		Assert.isTrue(heap.compare(4, 3));

		heap.push(4);
		heap.push(5);
		heap.push(6);
		heap.push(2);
		heap.push(1);
		heap.push(3);

		Assert.areEqual(6, heap.pop());
		Assert.areEqual(5, heap.pop());
		Assert.areEqual(4, heap.pop());
		Assert.areEqual(3, heap.pop());
		Assert.areEqual(2, heap.pop());
		Assert.areEqual(1, heap.pop());
	}

	@Test
	public function push_heapifies_values_in_min_heap() {
		heap.compare = (a, b) -> Reflect.compare(a, b) < 0;

		heap.push(3);
		heap.push(1);
		heap.push(6);
		heap.push(5);
		heap.push(8);
		heap.push(9);

		Assert.areEqual(1, heap.pop());
		Assert.areEqual(3, heap.pop());
		Assert.areEqual(5, heap.pop());
		Assert.areEqual(6, heap.pop());
		Assert.areEqual(8, heap.pop());
		Assert.areEqual(9, heap.pop());
	}

	@Test
	public function push_heapifies_values_in_min_heap_with_equal_vals() {
		var heap2 = new Heap<Foo>((a:Foo, b:Foo) -> a.d < b.d);

		heap2.push({id: 1, d: 5});
		heap2.push({id: 2, d: 5});
		heap2.push({id: 5, d: 1});
		heap2.push({id: 6, d: 1});

		Assert.areEqual(1, heap2.pop().d);
		Assert.areEqual(1, heap2.pop().d);
		Assert.areEqual(5, heap2.pop().d);
		Assert.areEqual(5, heap2.pop().d);
	}

	@Test
	public function push_heapifies_values_in_min_heap_with_equal_vals_after_pops() {
		var heap2 = new Heap<Foo>((a:Foo, b:Foo) -> a.d < b.d);

		heap2.push({id: 1, d: 4});
		heap2.push({id: 2, d: 5});
		heap2.push({id: 3, d: 1});
		Assert.areEqual(1, heap2.pop().d);
		Assert.areEqual(4, heap2.pop().d);

		heap2.push({id: 1, d: 4});
		heap2.push({id: 4, d: 5});
		heap2.push({id: 5, d: 1});
		Assert.areEqual(1, heap2.pop().d);
		Assert.areEqual(4, heap2.pop().d);

		heap2.push({id: 1, d: 4});
		heap2.push({id: 2, d: 5});
		heap2.push({id: 6, d: 1});

		Assert.areEqual(1, heap2.pop().d);
		Assert.areEqual(4, heap2.pop().d);
		Assert.areEqual(5, heap2.pop().d);
		Assert.areEqual(5, heap2.pop().d);
		Assert.areEqual(5, heap2.pop().d);
		Assert.areEqual(null, heap2.pop());
	}

	@Test
	public function push_heapifies_values_in_min_heap_with_equal_vals_after_set_value() {
		var heap2 = new Heap<Foo>((a:Foo, b:Foo) -> a.d < b.d);

		var n1 = {id: 0, d: 1};
		var n2 = {id: 1, d: 4};
		var n3 = {id: 2, d: 8};
		var n4 = {id: 3, d: 6};

		heap2.push(n1);
		heap2.push(n2);
		heap2.push(n3);
		heap2.push(n4);

		Assert.areEqual(0, heap2.pop().id);

		heap2.set_value_obj(n4, {id: 3, d: 2});

		Assert.areEqual(3, heap2.pop().id);
		Assert.areEqual(1, heap2.pop().id);
		Assert.areEqual(2, heap2.pop().id);
		Assert.areEqual(null, heap2.pop());
	}
}
