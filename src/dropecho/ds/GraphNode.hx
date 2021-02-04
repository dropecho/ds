package dropecho.ds;

/**
 * A graph node data structure. 
 * @param T - The node data type (stored within nodes).
 * @param U - The edge data type (stored within edges).
 */
@:expose("GraphNode")
@:nativeGen
class GraphNode<T, U> {
	public var id:String;
	public var value:T;
	public var graph:Graph<T, U>;

	public function new(?value:T, ?id:String) {
		this.id = id != null ? id : Std.string(Std.random(10000000));
		this.value = value;
	}
}
