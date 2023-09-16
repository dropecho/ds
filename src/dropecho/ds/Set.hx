package dropecho.ds;

import haxe.Int32;
import haxe.crypto.Adler32;
import haxe.Serializer;
import haxe.Json;
import haxe.io.Bytes;
import haxe.crypto.Crc32;
import dropecho.interop.AbstractFunc;
#if cs
import cs.system.collections.generic.IEqualityComparer_1;
import cs.system.collections.generic.HashSet_1;
import cs.NativeArray;
import cs.Lib;
class SetEqualityComparer<T> implements IEqualityComparer_1<T> {
	var _hasher:Func_1<T, Int>;

	public function new(?hasher:Func_1<T, Int>) {
		// TODO: This is slow, figure out a better way to do this.
		// Probably similar to the way helder.set does it.
		_hasher = hasher ?? (item:T) -> cs.Syntax.code('{0}.GetHashCode()', item);
	}

	public function Equals(t1:T, t2:T) {
		return GetHashCode(t1) == GetHashCode(t2);
	}

	public function GetHashCode(obj:T) {
		return _hasher(obj);
	}
}

@:nativeGen
@:expose("Set")
class Set<T> {
	var _data:HashSet_1<T>;

	public function new(?hasher:Func_1<T, Int>) {
		var comparer = new SetEqualityComparer<T>(hasher);
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

class StringHasher {
	static inline private function stringify(item:Dynamic):String {
		if (Std.isOfType(item, Int) || Std.isOfType(item, Float)) {
			return item.toString();
		} else {
			return Json.stringify(item);
		}
	}

	static inline public function hash(item:Dynamic):Int32 {
		var str:String = stringify(item);
		var h:Int32 = 0;

		for (i in 0...str.length) {
			h = 31 * h + str.charCodeAt(i);
		}

		return h;
	}
}

/**
 * A Set implemenation.
 */
@:expose("Set")
class Set<T> {
	var _data:IntMap<T>;
	var _hasher:Func_1<T, Int>;

	public function new(?hasher:Func_1<T, Int>) {
		_data = new IntMap<T>();

		// TODO: This is slow, figure out a better way to do this.
		// Probably similar to the way helder.set does it.
		//     _hasher = hasher ?? (item:T) -> Crc32.make(Bytes.ofString(Json.stringify(item)));
		_hasher = hasher ?? (item:T) -> StringHasher.hash(item);
	}

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
