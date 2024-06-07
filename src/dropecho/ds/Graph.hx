package dropecho.ds;

import dropecho.ds.IGraph;
import dropecho.interop.AbstractMap;

@:nativeGen
@:expose("Graph")
@:inheritDoc(IGraph)
class Graph<T, U> implements IGraph<T, U> {
	/** The nodes or vertices of the graph. */
	public var nodes:AbstractMap<String, IGraphNode<T, U>>;

	/** The edges of the graph. */
	public var edges:AbstractMap<String, AbstractMap<String, U>>;

	public function new() {
		nodes = new AbstractMap<String, IGraphNode<T, U>>();
		edges = new AbstractMap<String, AbstractMap<String, U>>();
	}

	@:inheritDoc(IGraph.createNode)
	public function createNode(value:T, ?label:String) {
		return addNode(new GraphNode<T, U>(value, label));
	}

	@:inheritDoc(IGraph.addNode)
	public function addNode(node:IGraphNode<T, U>) {
		node.graph = this;
		return nodes.set(node.label, node);
	}

	@:inheritDoc(IGraph.addUniEdge)
	public function addUniEdge(fromLabel:String, toLabel:String, ?data:U):Void {
		if (!edges.exists(fromLabel)) {
			edges.set(fromLabel, new AbstractMap<String, U>());
		}

		edges.get(fromLabel).set(toLabel, data);
	}

	@:inheritDoc(IGraph.addBiEdge)
	public function addBiEdge(nodeLabel:String, otherLabel:String, ?data:U):Void {
		addUniEdge(nodeLabel, otherLabel, data);
		addUniEdge(otherLabel, nodeLabel, data);
	}

	@:inheritDoc(IGraph.remove)
	public function remove(label:String):Void {
		for (n in inNeighborLabels(nodes.get(label))) {
			edges.get(n).remove(label);
		}
		edges.remove(label);
		nodes.remove(label);
	}

	@:inheritDoc(IGraph.remove)
	public function inNeighbors(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<IGraphNode<T, U>> {
		return inNeighborLabels(node, filter).map(label -> nodes.get(label));
	}

	public function inNeighborLabels(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		var labels = [];

		// Get all edges as id, nodeEdges pairs
		for (label => nodeEdges in edges) {
			// If an edge exists from some other node to this node, add it to list.
			if (nodeEdges.exists(node.label)) {
				labels.push(label);
			}
		}

		// TODO: Add back in filter.
		// if (edges.exists(node.id) && (filter == null || filter(id, edge.get(node.id)))) {
		return labels;
	}

	@:inheritDoc(IGraph.outNeighbors)
	public function outNeighbors(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<IGraphNode<T, U>> {
		return outNeighborLabels(node, filter).map(label -> nodes.get(label));
	}

	@:inheritDoc(IGraph.outNeighborLabels)
	public function outNeighborLabels(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		if (!edges.exists(node.label)) {
			return [];
		}

		var labels = [
			for (label => data in edges.get(node.label)) {
				if (filter == null || filter(label, data)) {
					label;
				}
			}
		];

		haxe.ds.ArraySort.sort(labels, Reflect.compare);
		return labels;
	}

	@:inheritDoc(IGraph.neighborLabels)
	public function neighborLabels(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<String> {
		return outNeighborLabels(node, filter).concat(inNeighborLabels(node, filter));
	}

	@:inheritDoc(IGraph.neighbors)
	public function neighbors(node:IGraphNode<T, U>, ?filter:(String, U) -> Bool):Array<IGraphNode<T, U>> {
		return outNeighbors(node, filter).concat(inNeighbors(node, filter));
	}

	@:inheritDoc(IGraph.edgeData)
	public function edgeData(fromLabel:String, toLabel:String):Null<U> {
		if (edges.exists(fromLabel)) {
			var edgefrom = edges.get(fromLabel);
			if (edgefrom.exists(toLabel)) {
				return edgefrom.get(toLabel);
			}
		}

		return null;
	}

	@:inheritDoc(IGraph.toString)
	public function toString() {
		var adjList = "\nGraph:\n";
		adjList += "out-Neighbors:\n";
		for (node in nodes) {
			adjList += node.label;
			adjList += "\t-> ";
			var neighbors = outNeighbors(node);
			for (node in neighbors) {
				adjList += node.label;
				if (neighbors.indexOf(node) != neighbors.length - 1) {
					adjList += ",";
				}
			}
			adjList += "\n";
		}

		adjList += "in-Neighbors:\n";
		for (node in nodes) {
			adjList += node.label;
			adjList += "\t-> ";
			var neighbors = inNeighbors(node);
			for (node in neighbors) {
				adjList += node.label;
				if (neighbors.indexOf(node) != neighbors.length - 1) {
					adjList += ",";
				}
			}
			adjList += "\n";
		}

		return adjList;
	}

	@:inheritDoc(IGraph.toDot)
	public function toDot() {
		var dot = "digraph {\n";

		for (node in nodes) {
			dot += '\t${node.label}\n';
		}

		for (node in nodes) {
			var neighbors = outNeighbors(node);
			for (n in neighbors) {
				dot += '\t${node.label} -> ${n.label}\n';
			}
		}

		dot += "}";
		return dot;
	}
}
