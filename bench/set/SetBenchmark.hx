package set;

import dropecho.ds.Set;
import haxe.Timer;
import haxe.Json;

class BenchObj {
	public var x:Int;
	public var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
}

class SetBenchmark {
	static final N = 100_000;

	static function run(label:String, fn:() -> Void):Float {
		var start = Timer.stamp();
		fn();
		var elapsed = (Timer.stamp() - start) * 1000;
		Sys.println('  $label: ${Math.round(elapsed)}ms');
		return elapsed;
	}

	static function jsonHash(item:Dynamic):Int {
		var str:String = Json.stringify(item);
		var h:Int = 0;
		for (i in 0...str.length)
			h = 31 * h + str.charCodeAt(i);
		return h;
	}

	static function stringHash(s:String):Int {
		var h:Int = 0;
		for (i in 0...s.length)
			h = 31 * h + s.charCodeAt(i);
		return h;
	}

	// Structural hash: walks fields directly, no intermediate string.
	static function structuralHash(item:Dynamic):Int {
		if (item == null) return 0;
		if (Std.isOfType(item, Int)) return cast(item, Int);
		if (Std.isOfType(item, Float)) return Std.int(cast(item, Float));
		if (Std.isOfType(item, String)) return stringHash(item);
		if (Std.isOfType(item, Bool)) return item ? 1 : 0;
		var h:Int = 0;
		for (field in Reflect.fields(item)) {
			h = h * 31 + stringHash(field);
			h = h * 31 + structuralHash(Reflect.field(item, field));
		}
		return h;
	}

	static function main() {
		Sys.println('=== Set Benchmark (N=$N) ===\n');

		Sys.println('[add] Int:');
		run("identity (default)", () -> {
			var s = new Set<Int>();
			for (i in 0...N) s.add(i);
		});
		run("structural (no string alloc)", () -> {
			var s = new Set<Int>((i) -> structuralHash(i));
			for (i in 0...N) s.add(i);
		});
		run("json (old default)", () -> {
			var s = new Set<Int>((i) -> jsonHash(i));
			for (i in 0...N) s.add(i);
		});

		Sys.println('[add] Object:');
		run("identity (default)", () -> {
			var s = new Set<BenchObj>();
			for (i in 0...N) s.add(new BenchObj(i, i));
		});
		run("structural (no string alloc)", () -> {
			var s = new Set<BenchObj>((o) -> structuralHash(o));
			for (i in 0...N) s.add(new BenchObj(i, i));
		});
		run("json (old default)", () -> {
			var s = new Set<BenchObj>((o) -> jsonHash(o));
			for (i in 0...N) s.add(new BenchObj(i, i));
		});
		run("custom field", () -> {
			var s = new Set<BenchObj>((o) -> o.x);
			for (i in 0...N) s.add(new BenchObj(i, i));
		});

		Sys.println('');

		Sys.println('[exists] Object:');
		var objs = [for (i in 0...N) new BenchObj(i, i)];
		var objSetId = new Set<BenchObj>();
		var objSetStructural = new Set<BenchObj>((o) -> structuralHash(o));
		var objSetJson = new Set<BenchObj>((o) -> jsonHash(o));
		var objSetCustom = new Set<BenchObj>((o) -> o.x);
		for (o in objs) {
			objSetId.add(o);
			objSetStructural.add(o);
			objSetJson.add(o);
			objSetCustom.add(o);
		}
		run("identity (default)", () -> { for (o in objs) objSetId.exists(o); });
		run("structural (no string alloc)", () -> { for (o in objs) objSetStructural.exists(o); });
		run("json (old default)", () -> { for (o in objs) objSetJson.exists(o); });
		run("custom field", () -> { for (o in objs) objSetCustom.exists(o); });
	}
}
