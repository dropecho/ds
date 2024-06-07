package dropecho.ds.graph;

import dropecho.ds.IGraphNode;

class DFIterator<T, U> {
	var graph:IGraph<T, U>;
	var first:IGraphNode<T, U>;
	var discovered = new Set<String>();
	var toVisit = new Stack<IGraphNode<T, U>>();

	public function new(node:IGraphNode<T, U>) {
		this.graph = node.graph;
		toVisit.push(node);
	}

	public function hasNext():Bool {
		return toVisit.length > 0;
	}

	public function next():IGraphNode<T, U> {
		var nextNode = toVisit.pop();
		discovered.add(nextNode.label);

		for (node in graph.outNeighbors(nextNode)) {
			if (discovered.exists(node.label)) {
				continue;
			}
			toVisit.push(node);
			discovered.add(node.label);
		}

		return nextNode;
	}
}
