package dropecho.ds;

class DequeNode<T> {
	public var value:T;
	public var next:DequeNode<T>;
	public var prev:DequeNode<T>;

	public function new(value:T) {
		this.value = value;
	}
}

@:nativeGen
@:expose("Deque")
class Deque<T> {
	var _head:DequeNode<T>;
	var _tail:DequeNode<T>;
	var _length:Int;

	public var length(get, never):Int;

	public function new() {
		_length = 0;
	}

	public function pushFront(value:T) {
		var node = new DequeNode(value);
		if (_head == null) {
			_head = _tail = node;
		} else {
			node.next = _head;
			_head.prev = node;
			_head = node;
		}
		_length++;
	}

	public function pushBack(value:T) {
		var node = new DequeNode(value);
		if (_tail == null) {
			_head = _tail = node;
		} else {
			node.prev = _tail;
			_tail.next = node;
			_tail = node;
		}
		_length++;
	}

	public function popFront():T {
		if (_head == null) return null;
		var value = _head.value;
		_head = _head.next;
		if (_head != null) _head.prev = null;
		else _tail = null;
		_length--;
		return value;
	}

	public function popBack():T {
		if (_tail == null) return null;
		var value = _tail.value;
		_tail = _tail.prev;
		if (_tail != null) _tail.next = null;
		else _head = null;
		_length--;
		return value;
	}

	inline public function peekFront():T {
		return _head != null ? _head.value : null;
	}

	inline public function peekBack():T {
		return _tail != null ? _tail.value : null;
	}

	inline function get_length():Int {
		return _length;
	}

	public function iterator():Iterator<T> {
		var current = _head;
		return {
			hasNext: () -> current != null,
			next: () -> {
				var v = current.value;
				current = current.next;
				v;
			}
		};
	}
}
