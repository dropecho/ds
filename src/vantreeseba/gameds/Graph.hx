package vantreeseba.gameds;

@:expose
@:nativeGen
class Graph<T, U> {
	public var nodes:Map<String, GraphNode<T, U>>;
	public var edges:Map<String, Map<String, U>>;

	public function new() {
		nodes = new Map<String, GraphNode<T, U>>();
		edges = new Map<String, Map<String, U>>();
	}

	/**
	 * Creates a new node from a given value
	 *
	 * @param {T} value - The value to assign to the new node.
	 * @return {GraphNode<T, U>} The new node.
	 */
	public function createNode(value:T):GraphNode<T, U> {
		return addNode(new GraphNode<T, U>(value));
	}

	/**
	 * Add an existing node to this graph.
	 * This will set the internal graph property on the node to this.
	 *
	 * @param {GraphNode} node - The Node to add.
	 * @return {GraphNode<T,U>} The added graph node.
	 */
	public function addNode(node:GraphNode<T, U>):GraphNode<T, U> {
		nodes.set(node.id, node);
		node.graph = this;
		return node;
	}

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param {String} nodeId - The start node of the edge.
	 * @param {String} otherId - The end node of the edge.
	 * @param {Any} data - The data to assign to the edge.
	 * @return {Void}
	 */
	public function addUniEdge(nodeId:String, otherId:String, ?data:U):Void {
		if (edges.exists(nodeId)) {
			edges.get(nodeId).set(otherId, data);
		} else {
			edges.set(nodeId, [otherId => data]);
		}
	}

	/**
	 * Add a bidirectional edge from node to another.
	 *
	 * @param {String} nodeId - One node of the edge.
	 * @param {String} otherId - The other node of the edge.
	 * @param {Any} data - The data to assign to the edge.
	 * @return {Void}
	 */
	public function addBiEdge(nodeId:String, otherId:String, ?data:U):Void {
		addUniEdge(nodeId, otherId, data);
		addUniEdge(otherId, nodeId, data);
	}

	/**
	 * Remove a node from the graph by id.
	 *
	 * @param {String} id - The nodes id.
	 * @return {Void}
	 */
	public function remove(id:String):Void {
		nodes.remove(id);
	}

	/**
	 * Get the neighbors of the node.
	 *
	 * @param {GraphNode} node - The node to get neighbors of.
	 * @param {(String, Any) => Bool} filter - A filter that sorts by either id or edge data.
	 * @return {Array<GraphNode<T, U>>} The list of neighbor nodes.
	 */
	public function neighbors(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		return neighborIds(node, filter).map(id -> nodes.get(id));
	}

	/**
	 * Get the neighbors ids of the node.
	 *
	 * @param {GraphNode} node - The node to get neighbors of.
	 * @param {(String, Any) => Bool} filter - A filter that sorts by either id or edge data.
	 * @return {Array<String>} The list of neighbor node ids.
	 */
	public function neighborIds(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		var edges = edges.get(node.id);
		if (edges == null) {
			return [];
		}
		var ids = [
			for (id => data in edges) {
				if (filter == null || filter(id, data)) {
					id;
				} else {
					continue;
				}
			}
		];

		haxe.ds.ArraySort.sort(ids, Reflect.compare);
		return ids;
	}

  /**
   * Get the data from the edge between From and To.
   *
   * @param {String} fromId - The start node of the edge.
   * @param {String} toId - The end node of the edge.
   * @return {Any} The edge data.
   */
	public function edgeData(fromId:String, toId:String):U {
		if (edges.exists(fromId)) {
			return edges.get(fromId).get(toId);
		}

		return null;
	}
}
