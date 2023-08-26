package dropecho.ds;

#if cs
// import cs.system.collections.generic.HashSet;

@:nativeGen
@:expose("Set")
class Set<T> {
	//   var data:HashSet_1<T>;
	//   var hasher:T->Int;
	//
	//   public function new(?hasher:T->Int) {};
	//
	//   public function add(item:T):Bool {}
	//
	//   inline public function exists(item:T):Bool {}
	//
	//   inline public function get(item:T):T {}
	//
	//   inline public function size():Int {}
	//
	//   inline public function array():Array<T> {}
}
#else
import haxe.ds.IntMap;
import dropecho.interop.AbstractFunc;

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
