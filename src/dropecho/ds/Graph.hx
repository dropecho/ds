package dropecho.ds;

import dropecho.interop.AbstractMap;

/**
 * A graph data structure.
 *
 * Depending on methods used, can represent both a directed and non-directed graph.
 * @param T - The node data type (stored within nodes).
 * @param U - The edge data type (stored within edges).
 */
@:nativeGen
@:expose("Graph")
class Graph<T, U> {
	/** The nodes or vertices of the graph. */
	public var nodes:AbstractMap<String, GraphNode<T, U>>;

	/** The edges of the graph. */
	public var edges:AbstractMap<String, AbstractMap<String, U>>;

	public function new() {
		nodes = new AbstractMap<String, GraphNode<T, U>>();
		edges = new AbstractMap<String, AbstractMap<String, U>>();
	}

	/**
	 * Creates a new node from a given value
	 * @param value - The value to assign to the new node.
	 * @return The new node.
	 */
	public function createNode(value:T, ?id:String):GraphNode<T, U> {
		return addNode(new GraphNode<T, U>(value, id));
	}

	/**
	 * Add an existing node to this graph.
	 * This will set the internal graph property on the node to this.
	 * @param node - The Node to add.
	 * @return The added graph node.
	 */
	public function addNode(node:GraphNode<T, U>):GraphNode<T, U> {
		node.graph = this;
		return nodes.set(node.id, node);
	}

	/**
	 * Add a unidirectional edge from node to another.
	 *
	 * @param nodeId - The start node of the edge.
	 * @param otherId - The end node of the edge.
	 * @param data - The data to assign to the edge.
	 */
	public function addUniEdge(fromId:String, toId:String, ?data:U):Void {
		if (!edges.exists(fromId)) {
			edges.set(fromId, new AbstractMap<String, U>());
		}

		edges.get(fromId).set(toId, data);
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
	 * Removes a node (and it's edges) from the graph.
	 *
	 * @param id - The id of the node to remove from the graph. 
	 */
	public function remove(id:String):Void {
		for (n in inNeighborIds(nodes.get(id))) {
			edges.get(n).remove(id);
		}
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
		var ids = [];

		// Get all edges as id, nodeEdges pairs
		for (id => nodeEdges in edges) {
			// If an edge exists from some other node to this node, add it to list.
			if (nodeEdges.exists(node.id)) {
				ids.push(id);
			}
		}

		// TODO: Add back in filter.
		// if (edges.exists(node.id) && (filter == null || filter(id, edge.get(node.id)))) {
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
	 * Get the in and out neighbor ids of the node.
	 * @param node - The node to get neighbors of.
	 * @param filter - A filter that sorts by either id or edge data.
	 * @return The list of neighbor node ids.
	 */
	public function neighborIds(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		return outNeighborIds(node, filter).concat(inNeighborIds(node, filter));
	}

	/**
	 * Get the in and out neighbor nodes of the node.
	 * @param node - The node to get neighbors of.
	 * @param filter - A filter that sorts by either id or edge data.
	 * @return The list of neighbor nodes.
	 */
	public function neighbors(node:GraphNode<T, U>, ?filter:(String, U) -> Bool):Array<GraphNode<T, U>> {
		return outNeighbors(node, filter).concat(inNeighbors(node, filter));
	}

	/**
	 * Get the data from the edge between From and To.
	 * @param fromId - The start node of the edge.
	 * @param toId - The end node of the edge.
	 * @return The edge data.
	 */
	public function edgeData(fromId:String, toId:String):Null<U> {
		if (edges.exists(fromId)) {
			var edgefrom = edges.get(fromId);
			if (edgefrom.exists(toId)) {
				return edgefrom.get(toId);
			}
		}

		return null;
	}

	/**
	 * Outputs the graph as a string, represented by an adjacency list.
	 */
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

	/**
	 * Outputs the graph as a string in graph-viz dot format.
	 */
	public function toDot() {
		var dot = "digraph {\n";

		for (node in nodes) {
			dot += '\t${node.id}\n';
		}

		for (node in nodes) {
			var neighbors = outNeighbors(node);
			for (n in neighbors) {
				dot += '\t${node.id} -> ${n.id}\n';
			}
		}

		dot += "}";
		return dot;
	}
}
