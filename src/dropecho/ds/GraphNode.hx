package dropecho.ds;

/**
 * A graph node data structure. 
 * @param T - The node data type (stored within nodes).
 * @param U - The edge data type (stored within edges).
 */
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

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param otherId - The end node of the edge.
	 * @param data - The data to assign to the edge.
	 */
	public function addUniEdge(to:GraphNode<T, U>, ?data:U) {
		graph.addUniEdge(id, to.id);
	}

	/**
	 * Add a bidirectional edge from node to another.
	 *
	 * @param otherId - The end node of the edge.
	 * @param data - The data to assign to the edge.
	 */
	public function addBiEdge(to:GraphNode<T, U>, ?data:U) {
		graph.addBiEdge(id, to.id);
	}

	/**
	 * Get the in and out neighbor ids of the node.
	 * @return The list of neighbor node ids.
	 */
	public function neighborIds() {
		return graph.neighborIds(this);
	}

	/**
	 * Get the in and out neighbor nodes of the node.
	 * @return The list of neighbor nodes.
	 */
	public function neighbors() {
		return graph.neighbors(this);
	}
}
