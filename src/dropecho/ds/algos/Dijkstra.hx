package dropecho.ds.algos;

using Lambda;

@:nativeGen
typedef NodeDist<T, U> = {
	var node:GraphNode<T, U>;
	var dist:Float;
};

/**
 * This class is an implementation of dijkstra search over a graph.
 * @see https://en.wikipedia.org/wiki/Dijkstra's_algorithm#Using_a_priority_queue
 */
@:nativeGen
@:expose("algos.Dijkstra")
class Dijkstra<T, U> {
	public var dist:Map<GraphNode<T, U>, Float>;
	public var prev:Map<GraphNode<T, U>, String>;

	private var queue:Heap<NodeDist<T, U>>;
	private var distCalc:(a:GraphNode<T, U>, b:GraphNode<T, U>) -> Float;

	public function new(?distCalc:(a:GraphNode<T, U>, b:GraphNode<T, U>) -> Float) {
		var compare = (a, b) -> (Reflect.compare(a.dist, b.dist) < 0);
		queue = new Heap<NodeDist<T, U>>(compare);
		dist = new Map<GraphNode<T, U>, Float>();
		prev = new Map<GraphNode<T, U>, String>();
		this.distCalc = distCalc != null ? distCalc : (a, b) -> 1;
	}

	/**
	 * Runs a dijkstra search over the whole graph.
	 *
	 * @param graph The graph to search over.
	 * @param node The node to create subgraph with dist to.
	 */
	public function run(graph:Graph<T, U>, node:GraphNode<T, U>):Void {
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
				var distanceToNeighbor = dist[minDistNode] + this.distCalc(minDistNode, neighbor);
				if (distanceToNeighbor <= dist[neighbor]) {
					dist[neighbor] = distanceToNeighbor;
					prev[neighbor] = minDistNode.id;

					var existing = queue.elements.find(x -> x.node == neighbor);
					queue.set_value_obj(existing, {node: neighbor, dist: dist[neighbor]});
				}
			}
		}
	}
}
