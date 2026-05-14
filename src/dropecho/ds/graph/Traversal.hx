package dropecho.ds.graph;

import dropecho.interop.AbstractMap;

@:expose
@:nativeGen
class Traversal {
	/**
	 * Topological sort of a directed graph using Kahn's algorithm.
	 * Returns null if the graph contains a cycle.
	 */
	public static function topologicalSort<T, U>(graph:IGraph<T, U>):Array<IGraphNode<T, U>> {
		var inDegree = new AbstractMap<String, Int>();
		for (node in graph.nodes) inDegree.set(node.label, 0);

		for (fromLabel => nodeEdges in graph.edges) {
			for (toLabel => _ in nodeEdges) {
				if (inDegree.exists(toLabel)) {
					inDegree.set(toLabel, inDegree.get(toLabel) + 1);
				}
			}
		}

		var queue = new Queue<IGraphNode<T, U>>();
		for (node in graph.nodes) {
			if (inDegree.exists(node.label) && inDegree.get(node.label) == 0) {
				queue.enqueue(node);
			}
		}

		var sorted:Array<IGraphNode<T, U>> = [];
		while (queue.length > 0) {
			var node = queue.dequeue();
			sorted.push(node);
			for (neighbor in graph.outNeighbors(node)) {
				var newDeg = inDegree.get(neighbor.label) - 1;
				inDegree.set(neighbor.label, newDeg);
				if (newDeg == 0) queue.enqueue(neighbor);
			}
		}

		var nodeCount = 0;
		for (_ in graph.nodes) nodeCount++;
		return sorted.length == nodeCount ? sorted : null;
	}

	/**
	 * Returns true if the directed graph contains a cycle.
	 * Uses topological sort — O(V+E).
	 */
	public static function hasCycle<T, U>(graph:IGraph<T, U>):Bool {
		return topologicalSort(graph) == null;
	}

	/**
	 * Finds all weakly connected components (ignoring edge direction).
	 * Returns an array of components, each component being an array of nodes.
	 */
	public static function connectedComponents<T, U>(graph:IGraph<T, U>):Array<Array<IGraphNode<T, U>>> {
		var visited = new Set<String>();
		var components:Array<Array<IGraphNode<T, U>>> = [];

		for (startNode in graph.nodes) {
			if (visited.exists(startNode.label)) continue;

			var component:Array<IGraphNode<T, U>> = [];
			var queue = new Queue<IGraphNode<T, U>>();
			queue.enqueue(startNode);
			visited.add(startNode.label);

			while (queue.length > 0) {
				var node = queue.dequeue();
				component.push(node);
				for (neighbor in graph.neighbors(node)) {
					if (!visited.exists(neighbor.label)) {
						visited.add(neighbor.label);
						queue.enqueue(neighbor);
					}
				}
			}

			components.push(component);
		}

		return components;
	}

	/**
	 * Tarjan's strongly connected components algorithm.
	 * Returns each SCC as an array of nodes.
	 */
	public static function stronglyConnectedComponents<T, U>(graph:IGraph<T, U>):Array<Array<IGraphNode<T, U>>> {
		return new TarjanState(graph).run();
	}
}

class TarjanState<T, U> {
	var graph:IGraph<T, U>;
	var disc:AbstractMap<String, Int>;
	var low:AbstractMap<String, Int>;
	var onStack:AbstractMap<String, Bool>;
	var stack:Array<String>;
	var components:Array<Array<IGraphNode<T, U>>>;
	var timer:Int;

	public function new(graph:IGraph<T, U>) {
		this.graph = graph;
		disc = new AbstractMap<String, Int>();
		low = new AbstractMap<String, Int>();
		onStack = new AbstractMap<String, Bool>();
		stack = [];
		components = [];
		timer = 0;
	}

	public function run():Array<Array<IGraphNode<T, U>>> {
		for (node in graph.nodes) {
			if (!disc.exists(node.label)) dfs(node);
		}
		return components;
	}

	function dfs(node:IGraphNode<T, U>):Void {
		disc.set(node.label, timer);
		low.set(node.label, timer);
		timer++;
		stack.push(node.label);
		onStack.set(node.label, true);

		for (neighbor in graph.outNeighbors(node)) {
			if (!disc.exists(neighbor.label)) {
				dfs(neighbor);
				var neighborLow = low.get(neighbor.label);
				var nodeLow = low.get(node.label);
				if (neighborLow < nodeLow) low.set(node.label, neighborLow);
			} else if (onStack.exists(neighbor.label) && onStack.get(neighbor.label)) {
				var neighborDisc = disc.get(neighbor.label);
				var nodeLow = low.get(node.label);
				if (neighborDisc < nodeLow) low.set(node.label, neighborDisc);
			}
		}

		if (low.get(node.label) == disc.get(node.label)) {
			var scc:Array<IGraphNode<T, U>> = [];
			while (true) {
				var label = stack.pop();
				onStack.set(label, false);
				scc.push(graph.nodes.get(label));
				if (label == node.label) break;
			}
			components.push(scc);
		}
	}
}
