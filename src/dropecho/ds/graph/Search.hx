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

@:expose
class Search {
	/**
	 * An implementation of dijkstra search over a graph.
	 * @see https://en.wikipedia.org/wiki/Dijkstra's_algorithm
	 *
	 * @param node - The graph node to start the search at.
	 * @param [distCalc] - A distance calculation function. (optional)
	 * @return An object with the path and distances to every node.
	 */
	public static function dijkstra<T, U>(node:IGraphNode<T, U>, ?distCalc:(a:IGraphNode<T, U>, b:IGraphNode<T, U>) -> Float):SearchResult<T, U> {
		var compare = (a, b) -> (Reflect.compare(a.dist, b.dist) < 0);
		var queue = new Heap<NodeDist<T, U>>(compare);
		var dist = new AbstractMap<IGraphNode<T, U>, Float>();
		var prev = new AbstractMap<IGraphNode<T, U>, String>();

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
			var existingLabels = queue.elements.map(x -> x.node.label);
			var filter = (label, data) -> existingLabels.indexOf(label) >= 0;
			var neighbors = graph.neighbors(minDistNode, filter);

			for (neighbor in neighbors) {
				// TODO: Make this use an actual cost, instead of +1, should be distance to neighbor.
				var distanceToNeighbor = dist[minDistNode] + distCalc(minDistNode, neighbor);
				if (distanceToNeighbor <= dist[neighbor]) {
					dist[neighbor] = distanceToNeighbor;
					prev[neighbor] = minDistNode.label;

					var existing = queue.elements.find(x -> x.node == neighbor);
					// queue.set_value_obj(existing, {node: neighbor, dist: dist[neighbor]});
					queue.replace(existing, new NodeDist(neighbor, dist[neighbor]));
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
