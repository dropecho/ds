package dropecho.ds;

#if cs
import cs.system.collections.generic.Queue_1;

@:nativeGen
@:expose("Queue")
class Queue<T> {
	var data:Queue_1<T>;

	public var length(get, never):Int;

	public function new() {
		this.data = new Queue_1<T>();
	}

	inline public function enqueue(value:T) {
		data.Enqueue(value);
	}

	inline public function enqueueMany(array:Array<T>) {
		for (x in array) {
			data.Enqueue(x);
		}
	}

	inline public function dequeue():T {
		return data.Dequeue();
	}

	inline function get_length():Int {
		return data.Count;
	}
}
#else
@:expose("Queue")
class Queue<T> {
	var data:Array<T>;

	public var length(get, never):Int;

	public function new() {
		this.data = new Array<T>();
	}

	inline public function enqueue(value:T) {
		data.unshift(value);
	}

	inline public function enqueueMany(array:Array<T>) {
		data = array.concat(data);
	}

	inline public function dequeue():T {
		return data.pop();
	}

	inline function get_length():Int {
		return data.length;
	}
}
#end
