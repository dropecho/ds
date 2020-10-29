package dropecho.ds.graph;

using Lambda;

@:nativeGen
typedef NodeDist<T, U> = {
	var node:GraphNode<T, U>;
	var dist:Float;
};

typedef SearchResult<T, U> = {
	var path:Map<GraphNode<T, U>, String>;
	var distances:Map<GraphNode<T, U>, Float>;
}

@:nativeGen
@:expose("graph.Search")
class Search {
	/**
	 * An implementation of dijkstra search over a graph.
	 * @see https://en.wikipedia.org/wiki/Dijkstra's_algorithm#Using_a_priority_queue
	 *
	 * @template T - The graph node value type.
	 * @template U - The graph edge value type.
	 * @param {Graph<T, U>} graph - The graph to search over.
	 * @param {GraphNode<T, U>} node - The graph node to start the search at.
	 * @return {Any} An object with the path and distances to every node.
	 */
	public static function dijkstra<T, U>(
    graph:Graph<T, U>, 
    node:GraphNode<T, U>,
    ?distCalc:(a:GraphNode<T,U>, b:GraphNode<T,U>) -> Float
    ):SearchResult<T, U> {
		var compare = (a, b) -> (Reflect.compare(a.dist, b.dist) < 0);
		var queue = new Heap<NodeDist<T, U>>(compare);
		var dist = new Map<GraphNode<T, U>, Float>();
		var prev = new Map<GraphNode<T, U>, String>();

		distCalc = distCalc != null ? distCalc : (a, b) -> 1;

		dist[node] = 0;

		// Setup all nodes to start at distance of infinity.
		// Set their "previous in path back to source" to null.
		for (n in graph.nodes) {
			if (n != node) {
				dist[n] = Math.POSITIVE_INFINITY;
				prev[n] = null;
			}

			// Add source to processing queue with distance;
			queue.push({node: n, dist: dist[n]});
		}

		while (queue.size() > 0) {
			var minDistNode = queue.pop().node;
			var existingIds = queue.elements.map(x -> x.node.id);
			var filter = (id, data) -> existingIds.indexOf(id) >= 0;
			var neighbors = minDistNode.neighbors(filter);
			for (neighbor in neighbors) {
				// TODO: Make this use an actual cost.
				// instead of +1, should be distance to neighbor.
				var distanceToNeighbor = dist[minDistNode] + distCalc(minDistNode, neighbor);
				if (distanceToNeighbor <= dist[neighbor]) {
					dist[neighbor] = distanceToNeighbor;
					prev[neighbor] = minDistNode.id;

					var existing = queue.elements.find(x -> x.node == neighbor);
					queue.set_value_obj(existing, {node: neighbor, dist: dist[neighbor]});
				}
			}
		}
		return {
			distances: dist,
			path: prev
		};
	}
}
