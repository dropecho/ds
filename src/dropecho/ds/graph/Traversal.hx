package dropecho.ds.graph;

@:nativeGen
@:expose("graph.traversal")
class Traversal {
	/*
		procedure BFS(G, start_v) is
		let Q be a queue
		label start_v as discovered
		Q.enqueue(start_v)
		while Q is not empty do
		 v := Q.dequeue()
		 if v is the goal then
		 return v
		 for all edges from v to w in G.adjacentEdges(v) do
				if w is not labeled as discovered then
				label w as discovered
				w.parent := v
				Q.enqueue(w)
	 */
	public static function breadthFirst<T, U>(node:GraphNode<T, U>) {
		var graph = node.graph;
		var visited = new Array<String>();
		var toVisit = new Array<GraphNode<T, U>>();

		toVisit.push(node);

		while (toVisit.length > 0) {
			var next = toVisit.shift();
			if (visited.indexOf(next.id) == -1) {
				visited.push(next.id);
				for (n in graph.neighbors(next)) {
					toVisit.push(n);
				}
			}
		}

		return visited;
	}

	/*
		procedure DFS(G, v) is
			  label v as discovered
			  for all directed edges from v to w that are in G.adjacentEdges(v) do
		if vertex w is not labeled as discovered then
		recursively call DFS(G, w)
	 */
	public static function depthFirst<T, U>(node:GraphNode<T, U>) {
		var graph = node.graph;
		var visited = new Array<String>();

		if (visited.indexOf(node.id) == -1) {
			visited.push(node.id);
		} else {
			return null;
		}
		for (n in graph.neighbors(node)) {
			depthFirst(n);
		}

		return visited;
	}
}
