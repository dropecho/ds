package dropecho.ds.graph;

import dropecho.interop.AbstractMap;

@:struct
class EdgeRecord {
	public var from:String;
	public var to:String;
	public var weight:Float;

	public function new(from, to, weight) {
		this.from = from;
		this.to = to;
		this.weight = weight;
	}
}

@:expose
@:nativeGen
class MST {
	/**
	 * Kruskal's minimum spanning tree algorithm.
	 * Works correctly on undirected graphs (addBiEdge). For directed graphs,
	 * each unique pair of nodes is considered once (canonical order by label).
	 *
	 * @param graph   The graph to span.
	 * @param weight  Edge weight function; defaults to 1.0 per edge.
	 * @return Array of edges forming the MST, sorted by weight.
	 */
	public static function kruskal<T, U>(
		graph:IGraph<T, U>,
		?weight:(from:String, to:String, data:U) -> Float
	):Array<EdgeRecord> {
		weight = weight != null ? weight : (from, to, data) -> 1.0;

		// Collect all unique undirected edges (canonical: smaller label first)
		var seen = new Set<String>();
		var edges:Array<EdgeRecord> = [];

		for (fromLabel => nodeEdges in graph.edges) {
			for (toLabel => data in nodeEdges) {
				var a = fromLabel < toLabel ? fromLabel : toLabel;
				var b = fromLabel < toLabel ? toLabel : fromLabel;
				var key = a + "|" + b;
				if (seen.add(key)) {
					edges.push(new EdgeRecord(fromLabel, toLabel, weight(fromLabel, toLabel, data)));
				}
			}
		}

		haxe.ds.ArraySort.sort(edges, (a, b) -> Reflect.compare(a.weight, b.weight));

		// Map node labels to UnionFind indices
		var labels:Array<String> = [];
		for (node in graph.nodes) labels.push(node.label);

		var labelToIdx = new AbstractMap<String, Int>();
		for (i in 0...labels.length) labelToIdx.set(labels[i], i);

		var uf = new UnionFind(labels.length);
		var mst:Array<EdgeRecord> = [];

		for (edge in edges) {
			if (!labelToIdx.exists(edge.from) || !labelToIdx.exists(edge.to)) continue;
			var i = labelToIdx.get(edge.from);
			var j = labelToIdx.get(edge.to);
			if (uf.union(i, j)) {
				mst.push(edge);
				if (mst.length == labels.length - 1) break;
			}
		}

		return mst;
	}
}
