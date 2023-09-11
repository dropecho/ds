package dropecho.ds;

import haxe.iterators.ArrayIterator;
#if cs
import cs.system.collections.generic.Queue_1;

@:nativeGen
@:expose("Queue")
class Queue<T> {
	var _data:Queue_1<T>;

	public var length(get, never):Int;

	public function new() {
		_data = new Queue_1<T>();
	}

	inline public function enqueue(value:T) {
		_data.Enqueue(value);
	}

	inline public function enqueueMany(array:Array<T>) {
		for (x in array) {
			_data.Enqueue(x);
		}
	}

	inline public function dequeue():T {
		return _data.Dequeue();
	}

	inline public function peek():T {
		return _data.Peek();
	}

	inline function get_length():Int {
		return _data.Count;
	}

	inline public function iterator() {
		return _data.ToArray().iterator();
	}
}
#else
@:expose("Queue")
class Queue<T> {
	var _data:haxe.ds.List<T>;

	public var length(get, never):Int;

	public function new() {
		_data = new haxe.ds.List<T>();
	}

	inline public function enqueue(value:T) {
		_data.add(value);
	}

	inline public function enqueueMany(iter:Iterable<T>) {
		for (item in iter) {
			_data.push(item);
		}
	}

	inline public function dequeue():T {
		return _data.pop();
	}

	inline public function peek():T {
		return _data.first();
	}

	inline function get_length():Int {
		return _data.length;
	}

	inline public function iterator() {
		return _data.iterator();
	}
}
#end
