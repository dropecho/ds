package set;

import haxe.extern.AsVar;
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
	var intSet:Set<Int>;
	var objSet:Set<TestObj>;

	public function setup() {
		intSet = new Set<Int>();
		objSet = new Set<TestObj>();
	}

	public function test_canInstantiate() {
		Assert.notNull(intSet);
	}

	public function test_count() {
		Assert.equals(0, intSet.size());
		intSet.add(1);
		Assert.equals(1, intSet.size());
		intSet.add(1);
		Assert.equals(1, intSet.size());
	}

	public function test_exists() {
		intSet.add(1);
		Assert.isTrue(intSet.exists(1));

		var obj = new TestObj();
		objSet.add(obj);
		Assert.isTrue(objSet.exists(obj));
	}

	public function test_toArray() {
		var obj = new TestObj();
		var obj2 = new TestObj();

		objSet.add(obj);
		Assert.same(obj2, objSet.array()[0]);
		Assert.same(obj, obj);
	}

	public function test_default_hasher_works_for_objects() {
		var obj = new TestObj();
		obj.x = 1;
		var obj2 = new TestObj();
		obj2.x = 2;

		objSet.add(obj);
		objSet.add(obj2);
		objSet.add(obj);

		Assert.equals(2, objSet.size());
	}

	public function test_custom_hasher_works() {
		final customHasherSet = new Set<TestObj>((item) -> item.x);

		var obj = new TestObj();
		obj.x = 1;
		var obj2 = new TestObj();
		obj2.x = 2;

		customHasherSet.add(obj);
		customHasherSet.add(obj2);
		customHasherSet.add(obj);

		Assert.equals(2, customHasherSet.size());
	}

	public function test_should_be_able_to_iterate_over_set() {
		intSet.add(1);
		intSet.add(2);
		intSet.add(3);

		var arr = [for (i in intSet) i];
		for (i in 1...3) {
			Assert.contains(i, arr);
		}
	}

	//   public function test_check_hash_chance_ints() {
	//     for (i in 1...10_000_000) {
	//       intSet.add(i);
	//     }
	//
	//     Assert.equals(9_999_999, intSet.size());
	//   }
	//   public function test_hash_collision_objects() {
	//     for (i in 1...1_000_000) {
	//       var obj = new TestObj();
	//       obj.x = i;
	//       objSet.add(obj);
	//     }
	//
	//     Assert.equals(999_999, objSet.size());
	//   }
}
#end
