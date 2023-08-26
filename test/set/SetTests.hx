package set;

import utest.Assert;
import utest.Test;
import dropecho.ds.*;

#if cs
class SetTests extends Test {}
#else
class TestObj {
	public var x:Int = 1;
	public var y:Int = 1;

	public function new() {};
}

class SetTests extends Test {
	var set:Set<Int>;
	var setObj:Set<TestObj>;

	public function setup() {
		set = new Set<Int>();
		setObj = new Set<TestObj>();
	}

	public function test_canInstantiate() {
		Assert.notNull(set);
	}

	public function test_count() {
		Assert.equals(0, set.size());
		set.add(1);
		Assert.equals(1, set.size());
		set.add(1);
		Assert.equals(1, set.size());
	}

	public function test_exists() {
		set.add(1);
		Assert.isTrue(set.exists(1));

		var obj = new TestObj();
		setObj.add(obj);
		Assert.isTrue(setObj.exists(obj));
	}

	public function test_toArray() {
		var obj = new TestObj();
		var obj2 = new TestObj();

		setObj.add(obj);
		Assert.same(obj2, setObj.array()[0]);
		Assert.same(obj, obj);
	}

//   public function test_custom_hasher_works() {}
}
#end
