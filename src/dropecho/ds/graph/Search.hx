package dropecho.ds.graph;

import dropecho.interop.AbstractMap;

using Lambda;

@:struct
class NodeDist<T, U> {
	public var node:GraphNode<T, U>;
	public var dist:Float;

	public function new(node, dist) {
		this.node = node;
		this.dist = dist;
	}
}

@:struct
class SearchResult<T, U> {
	public var path:AbstractMap<GraphNode<T, U>, String>;
	public var distances:AbstractMap<GraphNode<T, U>, Float>;

	public function new(path, distances) {
		this.path = path;
		this.distances = distances;
	}
}

@:expose("graph.Search")
class Search {
	/**
	 * An implementation of dijkstra search over a graph.
	 * @see https://en.wikipedia.org/wiki/Dijkstra's_algorithm
	 *
	 * @param node - The graph node to start the search at.
	 * @param [distCalc] - A distance calculation function. (optional)
	 * @return An object with the path and distances to every node.
	 */
	public static function dijkstra<T, U>(node:GraphNode<T, U>, ?distCalc:(a:GraphNode<T, U>, b:GraphNode<T, U>) -> Float):SearchResult<T, U> {
		var compare = (a, b) -> (Reflect.compare(a.dist, b.dist) < 0);
		var queue = new Heap<NodeDist<T, U>>(compare);
		var dist = new AbstractMap<GraphNode<T, U>, Float>();
		var prev = new AbstractMap<GraphNode<T, U>, String>();

		var graph = node.graph;

		distCalc = distCalc != null ? distCalc : (a, b) -> 1;

		dist[node] = 0.0;

		// Setup all nodes to start at distance of infinity.
		// Set their "previous in path back to source" to null.
		for (n in graph.nodes) {
			if (n != node) {
				dist[n] = Math.POSITIVE_INFINITY;
				prev[n] = null;
			}

			// Add source to processing queue with distance;
			// queue.push({node: n, dist: dist[n]});
			queue.push(new NodeDist(n, dist[n]));
		}

		while (queue.size() > 0) {
			var minDistNode = queue.pop().node;
			var existingIds = queue.elements.map(x -> x.node.id);
			var filter = (id, data) -> existingIds.indexOf(id) >= 0;
			var neighbors = graph.neighbors(minDistNode, filter);
			for (neighbor in neighbors) {
				// TODO: Make this use an actual cost.
				// instead of +1, should be distance to neighbor.
				var distanceToNeighbor = dist[minDistNode] + distCalc(minDistNode, neighbor);
				if (distanceToNeighbor <= dist[neighbor]) {
					dist[neighbor] = distanceToNeighbor;
					prev[neighbor] = minDistNode.id;

					var existing = queue.elements.find(x -> x.node == neighbor);
					// queue.set_value_obj(existing, {node: neighbor, dist: dist[neighbor]});
					queue.set_value_obj(existing, new NodeDist(neighbor, dist[neighbor]));
				}
			}
		}
		return new SearchResult(prev, dist);
		// return {
		//   distances: dist,
		//   path: prev
		// };
	}
}
