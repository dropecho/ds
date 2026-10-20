package dropecho.ds;

@:expose("GraphNode")
@:inheritDoc(IGraphNode)
class GraphNode<T, U> implements IGraphNode<T, U> {
	@:inheritDoc(IGraphNode.label)
	public var label:String;
	@:inheritDoc(IGraphNode.value)
	public var value:T;
	@:inheritDoc(IGraphNode.graph)
	public var graph:IGraph<T, U>;

	public function new(?value:T, ?label:String) {
		this.label = label != null ? label : Std.string(Std.random(10000000));
		this.value = value;
	}

	@:inheritDoc(IGraphNode.addUniEdge)
	public function addUniEdge(to:IGraphNode<T, U>, ?data:U) {
		graph.addUniEdge(label, to.label, data);
	}

	@:inheritDoc(IGraphNode.addBiEdge)
	public function addBiEdge(to:IGraphNode<T, U>, ?data:U) {
		graph.addBiEdge(label, to.label, data);
	}

	@:inheritDoc(IGraphNode.neighborLabels)
	public function neighborLabels() {
		return graph.neighborLabels(this);
	}

	@:inheritDoc(IGraphNode.neighbors)
	public function neighbors() {
		return graph.neighbors(this);
	}

	/**
	 * The node's label. Labels are unique within a graph, so this also serves as
	 * the key when a node is used in an AbstractMap: on JS that map is a plain
	 * object keyed by `Std.string(node)`, which would otherwise dump every field.
	 * @return  The node's label.
	 */
	public function toString():String {
		return label;
	}
}
