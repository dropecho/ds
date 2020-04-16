package vantreeseba.gameds.algos;

@:nativeGen
class DFS {
	public var visited:Array<String>;

	public function new() {
		this.visited = new Array<String>();
	}

	public function run<T, U>(node:GraphNode<T, U>) {
		if (visited.indexOf(node.id) == -1) {
			visited.push(node.id);
		} else {
			return null;
		}
		for (n in node.neighbors()) {
			run(n);
		}

		return visited;
	}

	// procedure DFS(G, v) is
	// label v as discovered
	// for all directed edges from v to w that are in G.adjacentEdges(v) do
	// if vertex w is not labeled as discovered then
	// recursively call DFS(G, w)
}
