package dropecho.ds;

import dropecho.interop.AbstractFunc;
#if cs
import cs.system.collections.generic.IEqualityComparer_1;
import cs.system.collections.generic.HashSet_1;
class GenericEqualityComparer<T> implements IEqualityComparer_1<T> {
	var hasher:Func_1<T, Int>;

	public function new(hasher) {
		this.hasher = hasher;
	}

	public function Equals(t1:T, t2:T) {
		return GetHashCode(t1) == GetHashCode(t2);
	}

	public function GetHashCode(t1:T) {
		return this.hasher(t1);
	}
}

@:nativeGen
@:expose("Set")
class Set<T> {
	var data:HashSet_1<T>;
	var hasher:Func_1<T, Int>;

	public function new(?hasher:Func_1<T, Int>) {
		var comparer = new GenericEqualityComparer<T>(hasher);
		data = new HashSet_1(comparer);
	};

	public function add(item:T):Bool {
		return data.Add(item);
	}

	inline public function exists(item:T):Bool {
		return data.Contains(item);
	}

	inline public function get(item:T):T {
		return null;
		//     var out:T;
		//     var success = data.TryGetValue(item, out);
		//     return success ? out : null;
	}

	inline public function size():Int {
		return data.Count;
	}

	inline public function array():Array<T> {
		return [];
	}
}

#else
import haxe.ds.IntMap;

/**
 * A Set implemenation.
 */
@:expose("Set")
class Set<T> {
	var data:IntMap<T>;
	var hasher:Func_1<T, Int>;

	public function new(?hasher:T->Int) {
		data = new IntMap<T>();
		this.hasher = hasher != null ? hasher : t -> 0;
	};

	public function add(item:T):Bool {
		var key = hasher(item);

		if (!this.data.exists(key)) {
			this.data.set(key, item);
			return true;
		}
		return false;
	}

	inline public function exists(item:T):Bool {
		return this.data.exists(hasher(item));
	}

	inline public function get(item:T):T {
		return this.data.get(hasher(item));
	}

	inline public function size():Int {
		var count = 0;
		for (key in this.data.keys()) {
			count++;
		}

		return count;
	}

	inline public function array():Array<T> {
		var arr = [];
		for (_ => value in this.data.keyValueIterator()) {
			arr.push(value);
		}
		return arr;
	}
}
#end
