package ringbuffer;

import utest.Assert;
import utest.Test;
import dropecho.ds.RingBuffer;

class RingBufferTests extends Test {
	var rb:RingBuffer<Null<Int>>;

	public function setup() {
		rb = new RingBuffer<Null<Int>>(4);
	}

	public function test_canInstantiate() {
		Assert.notNull(rb);
	}

	public function test_capacity_is_set() {
		Assert.equals(4, rb.capacity);
	}

	public function test_starts_empty() {
		Assert.isTrue(rb.isEmpty());
		Assert.equals(0, rb.length);
	}

	public function test_write_increases_length() {
		rb.write(1);
		Assert.equals(1, rb.length);
	}

	public function test_read_returns_null_when_empty() {
		Assert.isNull(rb.read());
	}

	public function test_peek_returns_null_when_empty() {
		Assert.isNull(rb.peek());
	}

	public function test_write_and_read_fifo_order() {
		rb.write(1);
		rb.write(2);
		rb.write(3);
		Assert.equals(1, rb.read());
		Assert.equals(2, rb.read());
		Assert.equals(3, rb.read());
	}

	public function test_peek_does_not_remove() {
		rb.write(42);
		Assert.equals(42, rb.peek());
		Assert.equals(1, rb.length);
		Assert.equals(42, rb.peek());
	}

	public function test_isFull_when_at_capacity() {
		rb.write(1);
		rb.write(2);
		rb.write(3);
		rb.write(4);
		Assert.isTrue(rb.isFull());
	}

	public function test_overwrite_mode_drops_oldest_when_full() {
		rb.write(1);
		rb.write(2);
		rb.write(3);
		rb.write(4);
		rb.write(5); // overwrites 1
		Assert.equals(4, rb.length);
		Assert.equals(2, rb.read());
		Assert.equals(3, rb.read());
		Assert.equals(4, rb.read());
		Assert.equals(5, rb.read());
	}

	public function test_overwrite_mode_multiple_wraps() {
		rb.write(1);
		rb.write(2);
		rb.write(3);
		rb.write(4);
		rb.write(5);
		rb.write(6);
		rb.write(7);
		// Only last 4 survive: 4, 5, 6, 7
		Assert.equals(4, rb.length);
		Assert.equals(4, rb.read());
		Assert.equals(5, rb.read());
		Assert.equals(6, rb.read());
		Assert.equals(7, rb.read());
	}

	public function test_bounded_mode_returns_false_when_full() {
		var bounded = new RingBuffer<Null<Int>>(3, false);
		Assert.isTrue(bounded.write(1));
		Assert.isTrue(bounded.write(2));
		Assert.isTrue(bounded.write(3));
		Assert.isFalse(bounded.write(4));
		Assert.equals(3, bounded.length);
		Assert.equals(1, bounded.read());
	}

	public function test_read_decreases_length() {
		rb.write(1);
		rb.write(2);
		rb.read();
		Assert.equals(1, rb.length);
	}

	public function test_wraps_correctly_after_reads_and_writes() {
		rb.write(1);
		rb.write(2);
		rb.read(); // consume 1; head moves
		rb.write(3);
		rb.write(4);
		rb.write(5); // wraps tail around
		// contains: 2, 3, 4, 5
		Assert.equals(2, rb.read());
		Assert.equals(3, rb.read());
		Assert.equals(4, rb.read());
		Assert.equals(5, rb.read());
	}

	public function test_isEmpty_after_draining() {
		rb.write(1);
		rb.read();
		Assert.isTrue(rb.isEmpty());
	}

	public function test_iterate_front_to_back() {
		rb.write(10);
		rb.write(20);
		rb.write(30);
		var result = [for (x in rb) x];
		Assert.equals(10, result[0]);
		Assert.equals(20, result[1]);
		Assert.equals(30, result[2]);
	}

	public function test_iterate_after_wrap() {
		rb.write(1);
		rb.write(2);
		rb.write(3);
		rb.write(4);
		rb.read(); // consume 1
		rb.write(5); // wraps tail
		var result = [for (x in rb) x];
		Assert.equals(2, result[0]);
		Assert.equals(3, result[1]);
		Assert.equals(4, result[2]);
		Assert.equals(5, result[3]);
	}
}
