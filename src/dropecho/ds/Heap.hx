package dropecho.ds;

/**
 * A heap implemenation.
 */
@:nativeGen
@:expose("Heap")
class Heap<T> {
	public var compare:(T, T) -> Bool;
	public var elements:Array<T>;

	public function new(?compare:(T, T) -> Bool) {
		this.compare = compare != null ? compare : (a:T, b:T) -> (Reflect.compare(a, b) < 0);
		this.elements = new Array<T>();
	}

	/**
	 * Push an element onto the heap.
	 * @param n The element to push onto the heap.
	 */
	public function push(n:T) {
		this.set_value(this.elements.push(n) - 1, n);
	}

	public function set_value_obj(oldVal:T, newVal:T) {
		set_value(elements.indexOf(oldVal), newVal);
	}

	public function set_value(i:Int, val:T) {
		elements[i] = val;
		while (i != 0 && compare(val, elements[_getParent(i)])) {
			_swap(i, _getParent(i));
			i = _getParent(i);
		}
	}

	/**
	 * Remove and return the ximum element in the heap.
	 * @return The ximum element on the heap.
	 */
	public function pop():T {
		if (this.elements.length == 0) {
			return null;
		}
		if (this.elements.length == 1) {
			return this.elements.shift();
		}

		var element = this.elements.shift();
		this._heapify(0);
		return element;
	}

	inline public function peek():T {
		return this.elements[0];
	}

	inline public function size() {
		return this.elements.length;
	}

	private function _heapify(index:Int) {
		var els = this.elements;
		var length = this.elements.length;

		var left = this._getLeft(index);
		var right = this._getRight(index);
		var top = index;

		if (left < length && this.compare(els[left], els[index])) {
			top = left;
		}
		if (right < length && this.compare(els[right], els[index])) {
			top = right;
		}

		if (top != index) {
			this._swap(index, top);
			this._heapify(top);
		}
	}

	/**
	 * Swap two elements of an array.
	 *
	 * @private
	 * @param {Number} a The first element to swap.
	 * @param {Number} b The second element to swap.
	 */
	inline private function _swap(a:Int, b:Int):Void {
		var temp = this.elements[a];
		this.elements[a] = this.elements[b];
		this.elements[b] = temp;
	}

	/**
	 * Get the parent index of an index in the binary heap.
	 *
	 * @private
	 * @param {Number} index The index to get the parent for.
	 * @return {Number} The parent index.
	 */
	inline private function _getParent(index:Int):Int {
		return Std.int((index - 1) / 2);
	}

	/**
	 * Get the left child index of the given index.
	 *
	 * @private
	 * @param {Number} index The index.
	 * @return {Number} The left childs index.
	 */
	inline private function _getLeft(index:Int):Int {
		return (2 * index) + 1;
	}

	/**
	 * Get the right child index of the given index.
	 *
	 * @private
	 * @param {Number} index The index.
	 * @return {Number} The right childs index.
	 */
	inline private function _getRight(index:Int):Int {
		return (2 * index) + 2;
	}
}
