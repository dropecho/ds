package dropecho.ds;

import haxe.ds.StringMap;

@:nativeGen
@:expose("Graph")
class Graph<T, U> {
	public var nodes:StringMap<GraphNode<T, U>>;
	public var edges:StringMap<StringMap<U>>;

	public function new() {
		nodes = new StringMap<GraphNode<T, U>>();
		edges = new StringMap<StringMap<U>>();
	}

	/**
	 * Creates a new node from a given value
	 * @param value - The value to assign to the new node.
	 * @return The new node.
	 */
	public function createNode(value:T):GraphNode<T, U> {
		return addNode(new GraphNode<T, U>(value));
	}

	/**
	 * Add an existing node to this graph.
	 * This will set the internal graph property on the node to this.
	 * @param node - The Node to add.
	 * @return The added graph node.
	 */
	public function addNode(node:GraphNode<T, U>):GraphNode<T, U> {
		nodes.set(node.id, node);
		node.graph = this;
		return node;
	}

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param nodeId - The start node of the edge.
	 * @param otherId - The end node of the edge.
	 * @param data - The data to assign to the edge.
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
	 * @param nodeId - One node of the edge.
	 * @param otherId - The other node of the edge.
	 * @param data - The data to assign to the edge.
	 */
	public function addBiEdge(nodeId:String, otherId:String, ?data:U):Void {
		addUniEdge(nodeId, otherId, data);
		addUniEdge(otherId, nodeId, data);
	}

	/**
	 * Removes the node and its edges from the graph.
	 * @param id - The id of the node to remove. 
	 */
	public function remove(id:String):Void {
		// TODO: Remove inNeighborLinks to node.
		edges.remove(id);
		nodes.remove(id);
	}

	/**
	 * Get the in neighbors of the given node, filtering by the edge data.
	 * @param node - The node to find the in neighbors of.
	 * @param filter - The edge data filter.
	 * @return The list of in neighbor nodes.
	 */
	public function inNeighbors(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		return inNeighborIds(node, filter).map(id -> nodes.get(id));
	}

	/**
	 * Get the in neighbor ids of the given node, filtering by the edge data.
	 * @param node - The node to find the in neighbors of.
	 * @param filter - The edge data filter.
	 * @return The list of in neighbor node ids.
	 */
	public function inNeighborIds(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		var ids = [
			for (id => edge in edges) {
				if (edge.exists(node.id) && (filter == null || filter(id, edge.get(node.id)))) {
					id;
				}
			}
		];
		return ids;
	}

	/**
	 * Get the out-neighbors of the node.
	 * @param node - The node to get out-neighbors of.
	 * @param filter - A filter that sorts by either id or edge data.
	 * @return The list of out-neighbor nodes.
	 */
	public function outNeighbors(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		return outNeighborIds(node, filter).map(id -> nodes.get(id));
	}

	/**
	 * Get the out-neighbors ids of the node.
	 * @param node - The node to get out-neighbors of.
	 * @param filter - A filter that sorts by either id or edge data.
	 * @return The list of out-neighbor node ids.
	 */
	public function outNeighborIds(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		if (!edges.exists(node.id)) {
			return [];
		}

		var ids = [
			for (id => data in edges.get(node.id)) {
				if (filter == null || filter(id, data)) {
					id;
				}
			}
		];

		haxe.ds.ArraySort.sort(ids, Reflect.compare);
		return ids;
	}

	/**
	 * Get the data from the edge between From and To.
	 * @param fromId - The start node of the edge.
	 * @param toId - The end node of the edge.
	 * @return The edge data.
	 */
	public function edgeData(fromId:String, toId:String):Null<U> {
		if (edges.exists(fromId)) {
			return edges.get(fromId).get(toId);
		}

		return null;
	}

	public function toString() {
		var adjList = "\nGraph:\n";
		adjList += "out-Neighbors:\n";
		for (node in nodes) {
			adjList += node.id;
			adjList += "\t-> ";
			var neighbors = outNeighbors(node);
			for (node in neighbors) {
				adjList += node.id;
				if (neighbors.indexOf(node) != neighbors.length - 1) {
					adjList += ",";
				}
			}
			adjList += "\n";
		}

		adjList += "in-Neighbors:\n";
		for (node in nodes) {
			adjList += node.id;
			adjList += "\t-> ";
			var neighbors = inNeighbors(node);
			for (node in neighbors) {
				adjList += node.id;
				if (neighbors.indexOf(node) != neighbors.length - 1) {
					adjList += ",";
				}
			}
			adjList += "\n";
		}

		return adjList;
	}
}
