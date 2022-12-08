package dropecho.ds.graph;

@:expose
class Grammar {
	// public static function Rewrite(node:GraphNode<T, U>) {}

	public static function replace<T, U>(node:GraphNode<T, U>, newNode:GraphNode<T, U>) {

		// var edgesFromNode = node.graph.edges.get(node.id);


		//TODO: Get all nodes which have edges to this node.
		// for(k=>v in node.graph.edges.keyValueIterator) {
		//   trace(v);
		// }
		// var edgesToNode = node.graph.edges.keyValueIterator

		// node.graph.remove(node.id);
	}

	// public static function depthFirst<T, U>(node:GraphNode<T, U>) {
	//   var visited = new Array<String>();
	//
	//   if (visited.indexOf(node.id) == -1) {
	//     visited.push(node.id);
	//   } else {
	//     return null;
	//   }
	//   for (n in node.neighbors()) {
	//     depthFirst(n);
	//   }
	//
	//   return visited;
	// }
}
