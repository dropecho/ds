package dropecho.ds;

import dropecho.interop.AbstractMap;

@:nativeGen
@:expose("SpatialHash")
class SpatialHash<T> {
	var _cells:AbstractMap<String, Array<T>>;

	public var cellSize(default, null):Float;

	public function new(cellSize:Float) {
		if (cellSize <= 0) throw "SpatialHash cellSize must be > 0";
		this.cellSize = cellSize;
		_cells = new AbstractMap<String, Array<T>>();
	}

	/** Insert an item at the given position. Pass w/h for items with extent. */
	public function insert(item:T, x:Float, y:Float, w:Float = 0, h:Float = 0):Void {
		_eachCell(x, y, w, h, (key) -> {
			if (!_cells.exists(key)) _cells.set(key, []);
			_cells.get(key).push(item);
		});
	}

	/** Remove an item from the cells it occupies. Pass the same position used on insert. */
	public function remove(item:T, x:Float, y:Float, w:Float = 0, h:Float = 0):Void {
		_eachCell(x, y, w, h, (key) -> {
			if (!_cells.exists(key)) return;
			var bucket = _cells.get(key);
			var idx = bucket.indexOf(item);
			if (idx != -1) bucket.splice(idx, 1);
		});
	}

	/** Return all items whose cells overlap the given rect. Results are deduplicated. */
	public function query(x:Float, y:Float, w:Float, h:Float):Array<T> {
		var seen = new Set<T>();
		var result:Array<T> = [];
		_eachCell(x, y, w, h, (key) -> {
			if (!_cells.exists(key)) return;
			for (item in _cells.get(key)) {
				if (seen.add(item)) result.push(item);
			}
		});
		return result;
	}

	/** Remove all items from all cells. */
	public function clear():Void {
		_cells = new AbstractMap<String, Array<T>>();
	}

	inline function _key(cx:Int, cy:Int):String {
		return Std.string(cx) + "_" + Std.string(cy);
	}

	function _eachCell(x:Float, y:Float, w:Float, h:Float, fn:(String) -> Void):Void {
		var x0 = Std.int(Math.floor(x / cellSize));
		var y0 = Std.int(Math.floor(y / cellSize));
		var x1 = Std.int(Math.floor((x + w) / cellSize));
		var y1 = Std.int(Math.floor((y + h) / cellSize));
		for (cx in x0...x1 + 1) {
			for (cy in y0...y1 + 1) {
				fn(_key(cx, cy));
			}
		}
	}
}
