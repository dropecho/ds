package dropecho.ds;

import dropecho.interop.AbstractMap;

class LRUNode<V> {
	public var key:String;
	public var value:V;
	public var prev:LRUNode<V>;
	public var next:LRUNode<V>;

	public function new(key:String, value:V) {
		this.key = key;
		this.value = value;
	}
}

@:nativeGen
@:expose("LRUCache")
class LRUCache<V> {
	var _map:AbstractMap<String, LRUNode<V>>;
	var _head:LRUNode<V>;
	var _tail:LRUNode<V>;
	var _size:Int;

	public var capacity(default, null):Int;
	public var size(get, never):Int;

	public function new(capacity:Int) {
		this.capacity = capacity;
		_map = new AbstractMap<String, LRUNode<V>>();
		_size = 0;
	}

	/** Return the value for key, marking it as most-recently-used. Returns null if not found. */
	public function get(key:String):Null<V> {
		if (!_map.exists(key)) return null;
		var node = _map.get(key);
		_moveToFront(node);
		return node.value;
	}

	/** Insert or update a key. Evicts the least-recently-used entry if over capacity. */
	public function set(key:String, value:V):Void {
		if (_map.exists(key)) {
			var node = _map.get(key);
			node.value = value;
			_moveToFront(node);
			return;
		}

		var newNode = new LRUNode(key, value);
		_map.set(key, newNode);
		_addToFront(newNode);
		_size++;

		if (_size > capacity) {
			var evicted = _removeTail();
			_map.remove(evicted.key);
			_size--;
		}
	}

	inline public function has(key:String):Bool {
		return _map.exists(key);
	}

	public function remove(key:String):Bool {
		if (!_map.exists(key)) return false;
		var node = _map.get(key);
		_removeNode(node);
		_map.remove(key);
		_size--;
		return true;
	}

	public function clear():Void {
		_map = new AbstractMap<String, LRUNode<V>>();
		_head = null;
		_tail = null;
		_size = 0;
	}

	inline function get_size():Int {
		return _size;
	}

	function _addToFront(node:LRUNode<V>):Void {
		node.next = _head;
		node.prev = null;
		if (_head != null) _head.prev = node;
		_head = node;
		if (_tail == null) _tail = node;
	}

	function _removeNode(node:LRUNode<V>):Void {
		if (node.prev != null) node.prev.next = node.next else _head = node.next;
		if (node.next != null) node.next.prev = node.prev else _tail = node.prev;
		node.prev = null;
		node.next = null;
	}

	inline function _moveToFront(node:LRUNode<V>):Void {
		if (node == _head) return;
		_removeNode(node);
		_addToFront(node);
	}

	function _removeTail():LRUNode<V> {
		var node = _tail;
		_removeNode(node);
		return node;
	}
}
