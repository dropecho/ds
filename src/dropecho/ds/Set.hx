package dropecho.ds;

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
		var comparer:IEqualityComparer_1<T>;
		if (hasher == null) {
			comparer = cs.Syntax.code('System.Collections.Generic.EqualityComparer<T>.Default');
		} else {
			comparer = new SetEqualityComparer<T>(hasher);
		}
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
import haxe.Int32;

class IdentityHasher {
	static var _nextId:Int = 0;

	static public function hash(item:Dynamic):Int32 {
		if (item == null) return 0;
		if (Std.isOfType(item, Int)) return cast(item, Int);
		if (Std.isOfType(item, Float)) return Std.int(cast(item, Float));
		if (Std.isOfType(item, String)) {
			var str:String = item;
			var h:Int32 = 0;
			for (i in 0...str.length)
				h = 31 * h + str.charCodeAt(i);
			return h;
		}
		// Objects: lazily assign a stable identity id.
		if (!Reflect.hasField(item, '__dsId')) {
			Reflect.setField(item, '__dsId', ++_nextId);
		}
		return Reflect.field(item, '__dsId');
	}
}

/**
 * A Set implementation. Default equality is identity-based for objects
 * (same reference = same item). Pass a custom hasher for structural equality.
 */
@:expose("Set")
class Set<T> {
	var _data:IntMap<T>;
	var _hasher:Func_1<T, Int>;

	public function new(?hasher:Func_1<T, Int>) {
		_data = new IntMap<T>();
		_hasher = hasher ?? (item:T) -> IdentityHasher.hash(item);
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
