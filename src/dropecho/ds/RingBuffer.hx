package dropecho.ds;

@:nativeGen
@:expose("RingBuffer")
class RingBuffer<T> {
	var _data:Array<T>;
	var _head:Int;
	var _tail:Int;
	var _length:Int;
	var _overwrite:Bool;

	public var capacity(default, null):Int;
	public var length(get, never):Int;

	public function new(capacity:Int, overwrite:Bool = true) {
		if (capacity < 1) throw "RingBuffer capacity must be >= 1";
		this.capacity = capacity;
		_overwrite = overwrite;
		_data = [];
		_data.resize(capacity);
		_head = 0;
		_tail = 0;
		_length = 0;
	}

	/** Write a value. In overwrite mode, silently drops the oldest entry when full.
	    In bounded mode, returns false and does nothing when full. */
	public function write(value:T):Bool {
		if (_length == capacity) {
			if (!_overwrite) return false;
			_head = (_head + 1) % capacity;
			_length--;
		}
		_data[_tail] = value;
		_tail = (_tail + 1) % capacity;
		_length++;
		return true;
	}

	/** Remove and return the oldest value. Returns null if empty. */
	public function read():T {
		if (_length == 0) return null;
		var value = _data[_head];
		_head = (_head + 1) % capacity;
		_length--;
		return value;
	}

	/** Return the oldest value without removing it. */
	inline public function peek():T {
		return _length > 0 ? _data[_head] : null;
	}

	inline public function isFull():Bool {
		return _length == capacity;
	}

	inline public function isEmpty():Bool {
		return _length == 0;
	}

	inline function get_length():Int {
		return _length;
	}

	public function iterator():Iterator<T> {
		var i = 0;
		return {
			hasNext: () -> i < _length,
			next: () -> {
				var v = _data[(_head + i) % capacity];
				i++;
				v;
			}
		};
	}
}
