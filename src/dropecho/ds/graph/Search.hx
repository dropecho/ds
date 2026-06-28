package dropecho.ds.graph;

import dropecho.interop.AbstractMap;

using Lambda;

/** A node paired with a tentative distance, used as the priority-queue element
    for the searches below. The heap orders these by `dist`. */
@:struct
class NodeDist<T, U> {
	/** The graph node this entry refers to. */
	public var node:IGraphNode<T, U>;

	/** The priority key: tentative distance (Dijkstra) or f-score (A*). Lower pops first. */
	public var dist:Float;

	public function new(node, dist) {
		this.node = node;
		this.dist = dist;
	}
}

/** The result of a Dijkstra search from a single source. */
@:struct
class SearchResult<T, U> {
	/** Predecessor map: each node -> the previous node's label on its shortest
	    path back to the source. The source maps to null. Walk this backwards to
	    reconstruct a path. */
	public var path:AbstractMap<IGraphNode<T, U>, String>;

	/** Each node -> its shortest distance from the source (POSITIVE_INFINITY if unreachable). */
	public var distances:AbstractMap<IGraphNode<T, U>, Float>;

	public function new(path, distances) {
		this.path = path;
		this.distances = distances;
	}
}

/** The result of an A* search between two nodes. */
@:struct
class AStarResult<T, U> {
	/** The ordered path from start to end inclusive, or null if no path exists. */
	public var path:Array<IGraphNode<T, U>>;

	/** Whether a path from start to end was found. */
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
	 * @return A SearchResult mapping every node to its shortest distance and predecessor.
	 */
	public static function dijkstra<T, U>(node:IGraphNode<T, U>, ?distCalc:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float):SearchResult<T, U> {
		// Min-heap: the smallest tentative distance is always popped next.
		var compare = (a, b) -> (Reflect.compare(a.dist, b.dist) < 0);
		var queue = new Heap<NodeDist<T, U>>(compare);
		var dist = new AbstractMap<IGraphNode<T, U>, Float>();
		var prev = new AbstractMap<IGraphNode<T, U>, String>();

		var graph = node.graph;

		distCalc = distCalc != null ? distCalc : (a, b) -> 1.0;

		// Source sits at distance 0; every other node starts unreachable.
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
			// Once popped, a node is finalized. Restrict relaxation to neighbors still
			// in the queue so we never re-open a node whose distance is already settled.
			var existingLabels = queue.elements.map(x -> x.node.label);
			var filter = (label, data) -> existingLabels.indexOf(label) >= 0;
			var neighbors = graph.neighbors(minDistNode, filter);

			for (neighbor in neighbors) {
				var distanceToNeighbor = dist[minDistNode] + distCalc(minDistNode, neighbor);
				if (distanceToNeighbor <= dist[neighbor]) {
					dist[neighbor] = distanceToNeighbor;
					prev[neighbor] = minDistNode.label;
					// Update the neighbor's queue entry in place with its new, lower priority.
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
	public static function astar<T, U>(start:IGraphNode<T, U>, end:IGraphNode<T, U>, heuristic:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float,
			?distCalc:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float):AStarResult<T, U> {
		distCalc = distCalc != null ? distCalc : (a, b) -> 1.0;

		var graph = start.graph;
		// gScore[n] = best known cost from start to n; prev[n] = predecessor's label.
		var gScore = new AbstractMap<IGraphNode<T, U>, Float>();
		var prev = new AbstractMap<IGraphNode<T, U>, String>();
		// Labels of nodes whose shortest path is settled (popped from the open set).
		var closed = new AbstractMap<String, Bool>();

		for (n in graph.nodes) {
			gScore[n] = Math.POSITIVE_INFINITY;
			prev[n] = null;
		}
		gScore[start] = 0.0;

		// Open set ordered by f-score (g + heuristic); the most promising node pops first.
		var openSet = new Heap<NodeDist<T, U>>((a, b) -> (Reflect.compare(a.dist, b.dist) < 0));
		openSet.push(new NodeDist(start, heuristic(start, end)));

		while (openSet.size() > 0) {
			var current = openSet.pop().node;

			// A node can sit in the open set more than once; skip stale duplicates.
			if (closed.exists(current.label))
				continue;
			closed.set(current.label, true);

			if (current == end) {
				// Walk predecessors back from end to start, then reverse into start->end order.
				var path:Array<IGraphNode<T, U>> = [];
				var node = end;
				while (node != start) {
					path.push(node);
					if (!prev.exists(node))
						break;
					var label = prev[node];
					if (label == null)
						break;
					if (!node.graph.nodes.exists(label))
						break;
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
					if (closed.exists(neighbor.label))
						closed.remove(neighbor.label);
					openSet.push(new NodeDist(neighbor, tentativeG + heuristic(neighbor, end)));
				}
			}
		}

		return new AStarResult(null, false);
	}
}
