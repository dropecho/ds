package dropecho.ds.algos;

@:nativeGen
@:expose("algos.BFS")
class BFS<T, U> {
	public var visited:Array<String>;
	public var toVisit:Array<GraphNode<T, U>>;

	public function new() {
		this.visited = new Array<String>();
		this.toVisit = new Array<GraphNode<T, U>>();
	}

	public function run(node:GraphNode<T, U>) {
		toVisit.push(node);

		while (toVisit.length > 0) {
			var next = toVisit.shift();
			if (visited.indexOf(next.id) == -1) {
				visited.push(next.id);
				for (n in next.neighbors()) {
					toVisit.push(n);
				}
			}
		}

		return visited;
	}

	// procedure BFS(G, start_v) is
	// let Q be a queue
	// label start_v as discovered
	// Q.enqueue(start_v)
	// while Q is not empty do
	//  v := Q.dequeue()
	//  if v is the goal then
	//  return v
	//  for all edges from v to w in G.adjacentEdges(v) do
	//    if w is not labeled as discovered then
	//    label w as discovered
	//    w.parent := v
	//    Q.enqueue(w)
}
