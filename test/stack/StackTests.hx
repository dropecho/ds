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

	public function test_push_should_increase_length_by_1() {
		var len = intStack.length;
		intStack.push(1);
		Assert.equals(len + 1, intStack.length);
	}

	public function test_push_many_should_increase_length_by_count_of_given_items() {
		var len = intStack.length;
		var items = [1, 2, 3];
		intStack.pushMany(items);
		Assert.equals(len + items.length, intStack.length);
	}

	public function test_pop_should_decrease_length_by_1() {
		intStack.push(1);
		var len = intStack.length;
		intStack.pop();
		Assert.equals(len - 1, intStack.length);
	}

	public function test_peek_should_not_change_length() {
		intStack.push(1);
		var len = intStack.length;
		var out = intStack.peek();
		Assert.equals(len, intStack.length);
	}

	public function test_pop_should_return_last_item_pushed() {
		var expected = 3;
		intStack.push(1);
		intStack.push(2);
		intStack.push(expected);

		var actual = intStack.pop();
		Assert.equals(actual, expected);
	}

	public function test_peek_should_return_last_item_pushed() {
		var expected = 3;
		intStack.push(1);
		intStack.push(2);
		intStack.push(expected);

		var actual = intStack.peek();
		Assert.equals(actual, expected);
	}

	public function test_should_be_able_to_iterate_over_stack() {
		intStack.push(1);
		intStack.push(2);
		intStack.push(3);

		// start at last one pushed in.
		var num = 3;

		// Should return items in lifo order.
		for (item in intStack) {
			Assert.equals(item, num);
			num -= 1;
		}
	}
}
