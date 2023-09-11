package dropecho.ds;

import haxe.crypto.Md5;
import haxe.io.Bytes;
import haxe.crypto.Crc32;
import dropecho.interop.AbstractFunc;
#if cs
import cs.system.collections.generic.IEqualityComparer_1;
import cs.system.collections.generic.HashSet_1;
import cs.NativeArray;
import cs.Lib;
class SetEqualityComparer<T> implements IEqualityComparer_1<T> {
	var hasher:Func_1<T, Int>;

	public function new() {
		this.hasher = (item:T) -> Crc32.make(Bytes.ofString(Std.string(item)));
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
	var _data:HashSet_1<T>;

	public function new() {
		var comparer = new SetEqualityComparer<T>();
		_data = new HashSet_1(comparer);
	};

	public function add(item:T):Bool {
		return _data.Add(item);
	}

	inline public function exists(item:T):Bool {
		return _data.Contains(item);
	}

	inline public function size():Int {
		return _data.Count;
	}

	inline public function array():Array<T> {
		final arr = new NativeArray(_data.Count);
		_data.CopyTo(arr);
		return Lib.array(arr);
	}

	inline public function iterator():Iterator<T> {
		final arr = new NativeArray(_data.Count);
		_data.CopyTo(arr);
		return arr.iterator();
	}
}

#else
import haxe.ds.IntMap;

/**
 * A Set implemenation.
 */
@:expose("Set")
class Set<T> {
	var _data:IntMap<T>;
	var _hasher:Func_1<T, Int>;

	public function new() {
		_data = new IntMap<T>();
		_hasher = (item:T) -> Crc32.make(Bytes.ofString(Std.string(item)));
	};

	public function add(item:T):Bool {
		var key = _hasher(item);

		if (!this._data.exists(key)) {
			_data.set(key, item);
			return true;
		}
		return false;
	}

	inline public function exists(item:T):Bool {
		return _data.exists(_hasher(item));
	}

	inline public function size():Int {
		var count = 0;
		for (key in _data.keys()) {
			count++;
		}

		return count;
	}

	inline public function array():Array<T> {
		return [for (_ => value in _data.keyValueIterator()) value];
	}

	inline public function iterator():Iterator<T> {
		return _data.iterator();
	}
}
#end
