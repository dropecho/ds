package dropecho.ds.graph;

import dropecho.interop.AbstractMap;

using Lambda;

@:struct
class NodeDist<T, U> {
	public var node:IGraphNode<T, U>;
	public var dist:Float;

	public function new(node, dist) {
		this.node = node;
		this.dist = dist;
	}
}

@:struct
class SearchResult<T, U> {
	public var path:AbstractMap<IGraphNode<T, U>, String>;
	public var distances:AbstractMap<IGraphNode<T, U>, Float>;

	public function new(path, distances) {
		this.path = path;
		this.distances = distances;
	}
}

@:struct
class AStarResult<T, U> {
	/** Ordered path from start to end, or null if no path exists. */
	public var path:Array<IGraphNode<T, U>>;
	public var found:Bool;

	public function new(path, found) {
		this.path = path;
		this.found = found;
	}
}

@:expose
@:nativeGen
class Search {
	/**
	 * Dijkstra shortest-path from a source node to all reachable nodes.
	 * @param node      The source node.
	 * @param distCalc  Optional edge-weight function; defaults to 1.0 per hop.
	 */
	public static function dijkstra<T, U>(node:IGraphNode<T, U>, ?distCalc:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float):SearchResult<T, U> {
		var compare = (a, b) -> (Reflect.compare(a.dist, b.dist) < 0);
		var queue = new Heap<NodeDist<T, U>>(compare);
		var dist = new AbstractMap<IGraphNode<T, U>, Float>();
		var prev = new AbstractMap<IGraphNode<T, U>, String>();

		var graph = node.graph;

		distCalc = distCalc != null ? distCalc : (a, b) -> 1.0;

		dist[node] = 0.0;

		for (n in graph.nodes) {
			if (n != node) {
				dist[n] = Math.POSITIVE_INFINITY;
				prev[n] = null;
			}
			queue.push(new NodeDist(n, dist[n]));
		}

		while (queue.size() > 0) {
			var minDistNode = queue.pop().node;
			var existingLabels = queue.elements.map(x -> x.node.label);
			var filter = (label, data) -> existingLabels.indexOf(label) >= 0;
			var neighbors = graph.neighbors(minDistNode, filter);

			for (neighbor in neighbors) {
				var distanceToNeighbor = dist[minDistNode] + distCalc(minDistNode, neighbor);
				if (distanceToNeighbor <= dist[neighbor]) {
					dist[neighbor] = distanceToNeighbor;
					prev[neighbor] = minDistNode.label;
					var existing = queue.elements.find(x -> x.node == neighbor);
					queue.replace(existing, new NodeDist(neighbor, dist[neighbor]));
				}
			}
		}
		return new SearchResult(prev, dist);
	}

	/**
	 * A* shortest path from start to end.
	 * @param start      The source node.
	 * @param end        The target node.
	 * @param heuristic  Estimated cost from a node to end. Must be admissible (never
	 *                   overestimates). Inconsistent (non-monotone) admissible heuristics
	 *                   are still optimal here because closed nodes are reopened when a
	 *                   cheaper path is found.
	 * @param distCalc   Optional edge-weight function; defaults to 1.0 per hop.
	 * @return AStarResult with the ordered path array and a found flag.
	 */
	public static function astar<T, U>(
		start:IGraphNode<T, U>,
		end:IGraphNode<T, U>,
		heuristic:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float,
		?distCalc:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float
	):AStarResult<T, U> {
		distCalc = distCalc != null ? distCalc : (a, b) -> 1.0;

		var graph = start.graph;
		var gScore = new AbstractMap<IGraphNode<T, U>, Float>();
		var prev = new AbstractMap<IGraphNode<T, U>, String>();
		var closed = new AbstractMap<String, Bool>();

		for (n in graph.nodes) {
			gScore[n] = Math.POSITIVE_INFINITY;
			prev[n] = null;
		}
		gScore[start] = 0.0;

		var openSet = new Heap<NodeDist<T, U>>((a, b) -> (Reflect.compare(a.dist, b.dist) < 0));
		openSet.push(new NodeDist(start, heuristic(start, end)));

		while (openSet.size() > 0) {
			var current = openSet.pop().node;

			if (closed.exists(current.label)) continue;
			closed.set(current.label, true);

			if (current == end) {
				var path:Array<IGraphNode<T, U>> = [];
				var node = end;
				while (node != start) {
					path.push(node);
					if (!prev.exists(node)) break;
					var label = prev[node];
					if (label == null) break;
					if (!node.graph.nodes.exists(label)) break;
					node = node.graph.nodes.get(label);
				}
				path.push(start);
				path.reverse();
				return new AStarResult(path, true);
			}

			for (neighbor in graph.outNeighbors(current)) {
				var tentativeG = gScore[current] + distCalc(current, neighbor);
				var neighborG = gScore[neighbor];
				if (tentativeG < neighborG) {
					gScore[neighbor] = tentativeG;
					prev[neighbor] = current.label;
					// A cheaper path to neighbor was found. If it was already closed,
					// reopen it so the improvement can propagate — this keeps A* optimal
					// even when the heuristic is admissible but not consistent.
					if (closed.exists(neighbor.label)) closed.remove(neighbor.label);
					openSet.push(new NodeDist(neighbor, tentativeG + heuristic(neighbor, end)));
				}
			}
		}

		return new AStarResult(null, false);
	}
}
