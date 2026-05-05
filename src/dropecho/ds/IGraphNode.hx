package dropecho.ds;

/**
 * A graph node data structure. 
 * @param T  The node data type (stored within nodes).
 * @param U  The edge data type (stored within edges).
 */
@:nativeGen
interface IGraphNode<T, U> {
	public var label:String;
	public var value:T;

	/** The graph this node belongs to. */
	public var graph:IGraph<T, U>;

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param otherLabel  The end node of the edge.
	 * @param data        The data to assign to the edge.
	 */
	public function addUniEdge(to:IGraphNode<T, U>, ?data:U):Void;

	/**
	 * Add a bidirectional edge from node to another.
	 *
	 * @param otherLabel  The end node of the edge.
	 * @param data        The data to assign to the edge.
	 */
	public function addBiEdge(to:IGraphNode<T, U>, ?data:U):Void;

	/**
	 * Get the in and out neighbor labels of the node.
	 * @return  The list of neighbor node labels.
	 */
	public function neighborLabels():Array<String>;

	/**
	 * Get the in and out neighbor nodes of the node.
	 * @return  The list of neighbor nodes.
	 */
	public function neighbors():Array<IGraphNode<T, U>>;
}
