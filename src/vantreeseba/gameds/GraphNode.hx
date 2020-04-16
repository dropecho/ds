package vantreeseba.gameds;

@:expose
@:nativeGen
class GraphNode<T, U> {
	public var id:String;
	public var value:T;
	public var graph:Graph<T, U>;

	public function new(?value:T, ?id:String) {
		this.id = id != null ? id : Std.string(Std.random(10000000));
		this.value = value;
	}

	public function neighborIds():Array<String> {
		return graph.neighborIds(this);
	}

	public function neighbors(?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		var n = graph.neighbors(this, filter);
		return n;
	}

	public function edgeData(toId:String):U {
		return graph.edgeData(this.id, toId);
	}
}
