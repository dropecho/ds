package dropecho.ds;

@:expose("GraphNode")
@:nativeGen
class GraphNode<T, U> {
	public var id:String;
	public var value:T;
	public var graph:Graph<T, U>;

	public function new(?value:T, ?id:String) {
		this.id = id != null ? id : Std.string(Std.random(10000000));
		this.value = value;
	}

	public function outNeighborIds(?filter:(String, U) -> Bool):Array<String> {
		return graph.outNeighborIds(this, filter);
	}

	public function outNeighbors(?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		return graph.outNeighbors(this, filter);
	}

	public function inNeighbors():Array<GraphNode<T, U>> {
		// TODO
		return [];
	}

	public function inNeighborIds():Array<String> {
		// TODO
		return [];
	}

	public function neighborIds():Array<String> {
		return outNeighborIds().concat(inNeighborIds());
	}

	public function neighbors(?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		return outNeighbors().concat(inNeighbors());
	}

	public function edgeData(toId:String):U {
		return graph.edgeData(this.id, toId);
	}
}
