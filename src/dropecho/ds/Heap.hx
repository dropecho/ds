package dropecho.ds;

/** A heap implementation. */
@:nativeGen
@:expose("Heap")
class Heap<T> {
	public var compare(default, null):(T, T) -> Bool;
	public var elements(default, null):Array<T>;

	public function new(?compare:(T, T) -> Bool) {
		this.compare = compare != null ? compare : (a:T, b:T) -> (Reflect.compare(a, b) < 0);
		this.elements = new Array<T>();
	}

	/**
	 * Push an element onto the heap.
	 * This may cause the heap to partially rebuild.
	 * @param n The element to push onto the heap.
	 */
	public function push(item:T) {
		var newLength = elements.push(item);
		_replaceAt(newLength - 1, item);
	}

	/**
	 * Replace an object in the heap. 
	 * This may cause the heap to partially rebuild.
	 */
	public function replace(oldVal:T, newVal:T) {
		_replaceAt(elements.indexOf(oldVal), newVal);
	}

	/**
	 * Replace an object in the heap by index. 
	 * This may cause the heap to partially rebuild.
	 */
	private function _replaceAt(index:Int, val:T) {
		elements[index] = val;
		var parentIndex = _getParentIndex(index);

		while (index != 0 && compare(val, elements[parentIndex])) {
			_swap(index, parentIndex);
			index = parentIndex;
			parentIndex = _getParentIndex(index);
		}
	}

	/**
	 * Remove and return the (min/max)imum element in the heap.
	 * @return The (min/max)imum element on the heap.
	 */
	public function pop():T {
		var element = elements.shift();
		if (elements.length > 1) {
			_rebuild(0);
		}
		return element;
	}

	/**
	 * Return the (min/max)imum element in the heap, without removing it.
	 * @return The (min/max)imum element on the heap.
	 */
	inline public function peek():T {
		return elements[0];
	}

	/** 
	 * Get the current count of items in the heap 
	 */
	inline public function size() {
		return elements.length;
	}

	/**
	 * Rebuild the heap, starting at the given index.
	 * This allows a partial rebuild of the tree.
	 *
	 * @param index - The index to start the rebuild at. 
	 */
	private function _rebuild(index:Int) {
		var els = elements;
		var length = elements.length;

		var left = _getLeftIndex(index);
		var right = _getRightIndex(index);
		var top = index;

		if (left < length && compare(els[left], els[index])) {
			top = left;
		}
		if (right < length && compare(els[right], els[index])) {
			top = right;
		}

		if (top != index) {
			_swap(index, top);
			_rebuild(top);
		}
	}

	/**
	 * Swap two elements of an array.
	 *
	 * @param {Number} a The first element to swap.
	 * @param {Number} b The second element to swap.
	 */
	inline private function _swap(a:Int, b:Int):Void {
		var temp = elements[a];
		elements[a] = elements[b];
		elements[b] = temp;
	}

	/**
	 * Get the parent index of an index in the binary heap.
	 *
	 * @param {Number} index The index to get the parent for.
	 * @return {Number} The parent index.
	 */
	inline private function _getParentIndex(index:Int):Int {
		return Std.int((index - 1) / 2);
	}

	/**
	 * Get the left child index of the given index.
	 *
	 * @param {Number} index The index.
	 * @return {Number} The left childs index.
	 */
	inline private function _getLeftIndex(index:Int):Int {
		return (2 * index) + 1;
	}

	/**
	 * Get the right child index of the given index.
	 *
	 * @param {Number} index The index.
	 * @return {Number} The right childs index.
	 */
	inline private function _getRightIndex(index:Int):Int {
		return (2 * index) + 2;
	}
}
