package dropecho.ds;

@:nativeGen
@:expose("Stack")
class Stack<T> {
	var data:Array<T>;

	public var length(get, never):Int;

	public function new() {
		this.data = new Array<T>();
	}

	inline public function push(value:T) {
		data.push(value);
	}

	public function pushMany(array:Array<T>) {
		data = data.concat(array);
	}

	inline public function pop():T {
		return data.pop();
	}

	inline function get_length():Int {
		return data.length;
	}
}
