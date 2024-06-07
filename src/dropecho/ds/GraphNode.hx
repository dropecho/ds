package dropecho.ds;

/**
 * A graph node data structure. 
 * @param T - The node data type (stored within nodes).
 * @param U - The edge data type (stored within edges).
 */
@:expose("GraphNode")
@:nativeGen
class GraphNode<T, U> implements IGraphNode<T, U> {
	public var label:String;
	public var value:T;
	public var graph:Graph<T, U>;

	public function new(?value:T, ?label:String) {
		this.label = label != null ? label : Std.string(Std.random(10000000));
		this.value = value;
	}

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param otherLabel - The end node of the edge.
	 * @param data - The data to assign to the edge.
	 */
	public function addUniEdge(to:IGraphNode<T, U>, ?data:U) {
		graph.addUniEdge(label, to.label);
	}

	/**
	 * Add a bidirectional edge from node to another.
	 *
	 * @param otherLabel - The end node of the edge.
	 * @param data - The data to assign to the edge.
	 */
	public function addBiEdge(to:IGraphNode<T, U>, ?data:U) {
		graph.addBiEdge(label, to.label);
	}

	/**
	 * Get the in and out neighbor labels of the node.
	 * @return The list of neighbor node labels.
	 */
	public function neighborLabels() {
		return graph.neighborLabels(this);
	}

	/**
	 * Get the in and out neighbor nodes of the node.
	 * @return The list of neighbor nodes.
	 */
	public function neighbors() {
		return graph.neighbors(this);
	}
}
