package dropecho.ds;

import dropecho.interop.AbstractMap;

/**
 * A graph data structure.
 *
 * Depending on methods used, can represent both a directed and non-directed graph.
 * @param T   The node data type (stored within nodes).
 * @param U   The edge data type (stored within edges).
 */
interface IGraph<T, U> {
	/** The nodes or vertices of the graph. */
	public var nodes:AbstractMap<String, IGraphNode<T, U>>;

	/** The edges of the graph. */
	public var edges:AbstractMap<String, AbstractMap<String, U>>;

	/**
	 * Create a new node from a given value.
	 *
	 * @param value The value to assign to the new node.
	 * @param label The optional label to assign to the new node.
	 * @return      The new node.
	 */
	public function createNode(value:T, ?label:String):IGraphNode<T, U>;

	/**
	 * Add an existing node to this graph.
	 * This will set the internal graph property on the node to this.
	 *
	 * @param node  The Node to add.
	 * @return      The added graph node.
	 */
	public function addNode(node:GraphNode<T, U>):IGraphNode<T, U>;

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param fromLabel The start node of the edge.
	 * @param toLabel   The end node of the edge.
	 * @param data      The data to assign to the edge.
	 */
	public function addUniEdge(fromLabel:String, toLabel:String, ?data:U):Void;

	/**
	 * Add a bidirectional edge from node to another.
	 * @param label1  One node of the edge.
	 * @param label2  The other node of the edge.
	 * @param data    The data to assign to the edge.
	 */
	public function addBiEdge(label1:String, label2:String, ?data:U):Void;

	/**
	 * Removes a node (and it's edges) from the graph.
	 *
	 * @param id  The id of the node to remove from the graph. 
	 */
	public function remove(id:String):Void;

	/**
	 * Get the in neighbors of the given node, filtering by the edge data.
	 * @param node    The node to find the in neighbors of.
	 * @param filter  The edge data filter.
	 * @return        The list of in neighbor nodes.
	 */
	public function inNeighbors(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<IGraphNode<T, U>>;

	/**
	 * Get the in neighbor ids of the given node, filtering by the edge data.
	 * @param node    The node to find the in neighbors of.
	 * @param filter  The edge data filter.
	 * @return        The list of in neighbor node ids.
	 */
	public function inNeighborLabels(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String>;

	/**
	 * Get the out-neighbors of the node.
	 * @param node    The node to get out-neighbors of.
	 * @param filter  A filter that sorts by either id or edge data.
	 * @return        The list of out-neighbor nodes.
	 */
	public function outNeighbors(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<IGraphNode<T, U>>;

	/**
	 * Get the out-neighbors ids of the node.
	 * @param node    The node to get out-neighbors of.
	 * @param filter  A filter that sorts by either id or edge data.
	 * @return        The list of out-neighbor node ids.
	 */
	public function outNeighborLabels(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String>;

	/**
	 * Get the in and out neighbor ids of the node.
	 * @param node    The node to get neighbors of.
	 * @param filter  A filter that sorts by either id or edge data.
	 * @return        The list of neighbor node ids.
	 */
	public function neighborLabels(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String>;

	/**
	 * Get the in and out neighbor nodes of the node.
	 * @param node - The node to get neighbors of.
	 * @param filter - A filter that sorts by either id or edge data.
	 * @return The list of neighbor nodes.
	 */
	public function neighbors(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<IGraphNode<T, U>>;

	/**
	 * Get the data from the edge between From and To.
	 * @param fromLabel The start node of the edge.
	 * @param toLabel   The end node of the edge.
	 * @return          The edge data.
	 */
	public function edgeData(fromLabel:String, toLabeloId:String):Null<U>;

	/**
	 * Outputs the graph as a string, represented by an adjacency list.
	 */
	public function toString():String;

	/**
	 * Outputs the graph as a string in graph-viz dot format.
	 */
	public function toDot():String;
}
