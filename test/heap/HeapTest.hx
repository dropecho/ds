package heap;

import massive.munit.Assert;
import vantreeseba.gameds.*;

class HeapTest {
	var heap:Heap<Int>;

	@Before
	public function setup() {
		heap = new Heap<Int>((a, b) -> a > b);
	}

	@Test
	public function canInstantiate() {
		Assert.isNotNull(heap);
	}

	@Test
	public function simplePush() {
		heap.push(4);

		Assert.areEqual(4, heap.pop());
	}

	@Test
	public function push_heapifies_values_in_max_heap() {
		heap.compare = (a:Int, b:Int) -> a > b;
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
		heap.compare = (a, b) -> a < b;

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
}
