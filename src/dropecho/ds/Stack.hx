package dropecho.ds;

import haxe.iterators.ArrayIterator;

@:nativeGen
@:expose("Stack")
class Stack<T> {
	var _data:List<T>;

	public var length(get, never):Int;

	public function new() {
		_data = new List<T>();
	}

	/** Push an item onto the stack. */
	inline public function push(value:T) {
		_data.push(value);
	}

	/** Push a collection of items onto the stack. */
	inline public function pushMany(iter:Iterable<T>) {
		for (item in iter) {
			_data.push(item);
		}
	}

	/** Get the next item from the stack, and remove it. */
	inline public function pop():T {
		return _data.pop();
	}

	/** Get the next item from the stack, leaving it in the stack. */
	inline public function peek():T {
		return _data.first();
	}

	inline public function get_length():Int {
		return _data.length;
	}

	inline public function iterator() {
		return _data.iterator();
	}
}
