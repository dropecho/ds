package dropecho.ds;

@:nativeGen
@:expose("Rect")
class Rect {
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;

	public function new(x:Float, y:Float, width:Float, height:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	inline public function intersects(other:Rect):Bool {
		return x <= other.x + other.width
			&& x + width >= other.x
			&& y <= other.y + other.height
			&& y + height >= other.y;
	}

	inline public function contains(px:Float, py:Float):Bool {
		return px >= x && px <= x + width && py >= y && py <= y + height;
	}

	inline public function containsRect(other:Rect):Bool {
		return other.x >= x
			&& other.x + other.width <= x + width
			&& other.y >= y
			&& other.y + other.height <= y + height;
	}
}
