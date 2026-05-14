package dropecho.ds;

@:nativeGen
@:expose("UnionFind")
class UnionFind {
	var _parent:Array<Int>;
	var _rank:Array<Int>;
	var _count:Int;

	public var componentCount(get, never):Int;

	public function new(size:Int) {
		_parent = [for (i in 0...size) i];
		_rank = [for (_ in 0...size) 0];
		_count = size;
	}

	/** Find the root of x's component, with path compression. */
	public function find(x:Int):Int {
		if (_parent[x] != x) {
			_parent[x] = find(_parent[x]);
		}
		return _parent[x];
	}

	/** Merge the components containing x and y. Returns false if already connected. */
	public function union(x:Int, y:Int):Bool {
		var rootX = find(x);
		var rootY = find(y);
		if (rootX == rootY) return false;

		if (_rank[rootX] < _rank[rootY]) {
			_parent[rootX] = rootY;
		} else if (_rank[rootX] > _rank[rootY]) {
			_parent[rootY] = rootX;
		} else {
			_parent[rootY] = rootX;
			_rank[rootX]++;
		}
		_count--;
		return true;
	}

	inline public function connected(x:Int, y:Int):Bool {
		return find(x) == find(y);
	}

	inline function get_componentCount():Int {
		return _count;
	}
}
