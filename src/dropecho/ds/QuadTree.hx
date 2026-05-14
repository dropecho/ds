package dropecho.ds;

@:nativeGen
@:expose("QuadTree")
class QuadTree<T> {
	var _bounds:Rect;
	var _getBounds:(T) -> Rect;
	var _maxItems:Int;
	var _maxDepth:Int;
	var _depth:Int;
	var _items:Array<T>;
	var _children:Array<QuadTree<T>>;

	public var bounds(get, never):Rect;

	public function new(bounds:Rect, getBounds:(T) -> Rect, maxItems:Int = 8, maxDepth:Int = 8, depth:Int = 0) {
		_bounds = bounds;
		_getBounds = getBounds;
		_maxItems = maxItems;
		_maxDepth = maxDepth;
		_depth = depth;
		_items = [];
		_children = null;
	}

	/** Insert an item. Returns false if the item lies entirely outside this node's bounds. */
	public function insert(item:T):Bool {
		var itemBounds = _getBounds(item);
		if (!_bounds.intersects(itemBounds)) return false;

		if (_children != null) {
			for (child in _children) {
				if (child._bounds.containsRect(itemBounds)) {
					return child.insert(item);
				}
			}
			// spans multiple quadrants — keep at this level
			_items.push(item);
			return true;
		}

		_items.push(item);

		if (_items.length > _maxItems && _depth < _maxDepth) {
			_subdivide();
		}

		return true;
	}

	/** Return all items whose bounds intersect the query rect. */
	public function query(rect:Rect, ?result:Array<T>):Array<T> {
		if (result == null) result = [];
		if (!_bounds.intersects(rect)) return result;

		for (item in _items) {
			if (rect.intersects(_getBounds(item))) {
				result.push(item);
			}
		}

		if (_children != null) {
			for (child in _children) {
				child.query(rect, result);
			}
		}

		return result;
	}

	/** Remove an item. Returns false if not found. */
	public function remove(item:T):Bool {
		var idx = _items.indexOf(item);
		if (idx != -1) {
			_items.splice(idx, 1);
			return true;
		}

		if (_children != null) {
			var itemBounds = _getBounds(item);
			for (child in _children) {
				if (child._bounds.intersects(itemBounds)) {
					if (child.remove(item)) return true;
				}
			}
		}

		return false;
	}

	/** Remove all items and collapse all subdivisions. */
	public function clear():Void {
		_items = [];
		_children = null;
	}

	inline function get_bounds():Rect {
		return _bounds;
	}

	function _subdivide():Void {
		var hw = _bounds.width / 2;
		var hh = _bounds.height / 2;
		var x = _bounds.x;
		var y = _bounds.y;
		var d = _depth + 1;
		var gb = _getBounds;
		var mi = _maxItems;
		var md = _maxDepth;

		_children = [
			new QuadTree(new Rect(x,      y,      hw, hh), gb, mi, md, d), // NW
			new QuadTree(new Rect(x + hw, y,      hw, hh), gb, mi, md, d), // NE
			new QuadTree(new Rect(x,      y + hh, hw, hh), gb, mi, md, d), // SW
			new QuadTree(new Rect(x + hw, y + hh, hw, hh), gb, mi, md, d)  // SE
		];

		var oldItems = _items;
		_items = [];

		for (item in oldItems) {
			var itemBounds = _getBounds(item);
			var distributed = false;
			for (child in _children) {
				if (child._bounds.containsRect(itemBounds)) {
					child.insert(item);
					distributed = true;
					break;
				}
			}
			if (!distributed) {
				_items.push(item);
			}
		}
	}
}
