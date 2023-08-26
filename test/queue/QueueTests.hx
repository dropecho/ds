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

	public function test_length() {
		Assert.equals(0, intQueue.length);
		intQueue.enqueue(1);
		Assert.equals(1, intQueue.length);
		intQueue.dequeue();
		Assert.equals(0, intQueue.length);
	}
}
