package vantreeseba.gameds;

@:expose
@:nativeGen
@:generic
class Graph<T, U> {
	public var nodes:Map<String, GraphNode<T, U>>;
	public var edges:Map<String, Map<String, U>>;

	public function new() {
		nodes = new Map<String, GraphNode<T, U>>();
		edges = new Map<String, Map<String, U>>();
	}

	public function createNode(value:T) {
		return addNode(new GraphNode<T, U>(value));
	}

	public function addNode(node:GraphNode<T, U>) {
		nodes.set(node.id, node);
		node.graph = this;
		return node;
	}

	public function addUniEdge(nodeId:String, otherId:String, ?data:U) {
		if (edges.exists(nodeId)) {
			edges.get(nodeId).set(otherId, data);
		} else {
			edges.set(nodeId, [otherId => data]);
		}
	}

	public function addBiEdge(nodeId:String, otherId:String, ?data:U) {
		addUniEdge(nodeId, otherId, data);
		addUniEdge(otherId, nodeId, data);
	}

	public function remove(id:String) {
		nodes.remove(id);
	}

	public function neighbors(node:GraphNode<T, U>, ?filter:(String, U) -> Bool) {
		var ids = neighborIds(node, filter);
		return [for (id in ids) nodes.get(id)];
	}

	public function neighborIds(node:GraphNode<T, U>, ?filter:(String, U) -> Bool) {
		var edges = edges.get(node.id);
		if (edges == null) {
			return [];
		}
		return [
			for (id => data in edges) {
				if (filter == null || filter(id, data)) {
					id;
				} else {
					continue;
				}
			}
		];
	}

	public function edgeData(fromId:String, toId:String) {
		if (edges.exists(fromId)) {
			return edges.get(fromId).get(toId);
		}

		return null;
	}
}
