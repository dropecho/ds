package stack;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

class TestObj {
	public var x:Int = 1;
	public var y:Int = 1;

	public function new() {};
}

class StackTests extends Test {
	var intStack:Stack<Int>;
	var objStack:Stack<TestObj>;

	public function setup() {
		intStack = new Stack<Int>();
		objStack = new Stack<TestObj>();
	}

	public function test_canInstantiate() {
		Assert.notNull(intStack);
		Assert.notNull(objStack);
	}

	public function test_length() {
		Assert.equals(0, intStack.length);
		intStack.push(1);
		Assert.equals(1, intStack.length);
		intStack.pop();
		Assert.equals(0, intStack.length);
	}
}
