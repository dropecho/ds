package vantreeseba.gameds;

@:expose
class GraphNode<T, U> {
	public var id:String;
	public var value:T;
	public var graph:Graph<T, U>;

	public function new(?value:T) {
		this.id = Std.string(Std.random(10000000));
		this.value = value;
	}

	public function neighborIds():Array<String> {
		return graph.neighborIds(this);
	}

	public function neighbors():Array<GraphNode<T, U>> {
		var n = graph.neighbors(this);
    return n;
	}

	public function edgeData(toId:String):U {
		return graph.edgeData(this.id, toId);
	}
}
