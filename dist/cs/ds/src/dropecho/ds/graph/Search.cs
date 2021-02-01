// Generated by Haxe 4.1.5

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace dropecho.ds.graph {
	public class Search {
		
		public Search() {
		}
		
		
		public static object dijkstra<T, U>(global::dropecho.ds.Graph<T, U> graph, global::dropecho.ds.GraphNode<T, U> node, global::haxe.lang.Function distCalc) {
			global::dropecho.ds.Heap<object> queue = new global::dropecho.ds.Heap<object>(( (( global::dropecho.ds.graph.Search_dijkstra_34__Fun.__hx_current != null )) ? (global::dropecho.ds.graph.Search_dijkstra_34__Fun.__hx_current) : (global::dropecho.ds.graph.Search_dijkstra_34__Fun.__hx_current = ((global::dropecho.ds.graph.Search_dijkstra_34__Fun) (new global::dropecho.ds.graph.Search_dijkstra_34__Fun()) )) ));
			global::haxe.ds.ObjectMap<object, double> dist = new global::haxe.ds.ObjectMap<object, double>();
			global::haxe.ds.ObjectMap<object, string> prev = new global::haxe.ds.ObjectMap<object, string>();
			if (( distCalc != null )) {
			}
			else {
				distCalc = new global::dropecho.ds.graph.Search_dijkstra_39__Fun<U, T>();
			}
			
			dist.@set(node, ((double) (0) ));
			{
				object n = new global::haxe.ds._StringMap.StringMapValueIterator<object>(((global::haxe.ds.StringMap<object>) (graph.nodes) ));
				while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(n, "hasNext", 407283053, null))) {
					global::dropecho.ds.GraphNode<T, U> n1 = ((global::dropecho.ds.GraphNode<T, U>) (global::haxe.lang.Runtime.callField(n, "next", 1224901875, null)) );
					if (( n1 != node )) {
						dist.@set(n1, global::haxe.root.Math.POSITIVE_INFINITY);
						{
							string v = null;
							prev.@set(n1, v);
						}
						
					}
					
					object __temp_stmt3 = null;
					{
						global::haxe.lang.Null<double> __temp_odecl1 = dist.@get(n1);
						__temp_stmt3 = new global::haxe.lang.DynamicObject(new int[]{1114204006, 1225394690}, new object[]{(__temp_odecl1).toDynamic(), n1}, new int[]{}, new double[]{});
					}
					
					queue.push(__temp_stmt3);
				}
				
			}
			
			while (( queue.size() > 0 )) {
				global::dropecho.ds.GraphNode<T, U> minDistNode = ((global::dropecho.ds.GraphNode<T, U>) (global::haxe.lang.Runtime.getField(queue.pop(), "node", 1225394690, true)) );
				global::haxe.root.Array<object> _this = queue.elements;
				global::haxe.root.Array<string> ret = new global::haxe.root.Array<string>(((string[]) (new string[_this.length]) ));
				{
					int _g = 0;
					int _g1 = _this.length;
					while (( _g < _g1 )) {
						int i = _g++;
						ret.__a[i] = ((global::dropecho.ds.GraphNode<T, U>) (global::haxe.lang.Runtime.getField(_this.__a[i], "node", 1225394690, true)) ).id;
					}
					
				}
				
				global::haxe.root.Array<string> existingIds = ret;
				global::haxe.root.Array<object> neighbors = minDistNode.neighbors(new global::dropecho.ds.graph.Search_dijkstra_58__Fun<U>(existingIds));
				{
					int _g2 = 0;
					while (( _g2 < neighbors.length )) {
						global::dropecho.ds.GraphNode<T, U> neighbor = ((global::dropecho.ds.GraphNode<T, U>) (neighbors[_g2]) );
						 ++ _g2;
						double distanceToNeighbor = ( (dist.@get(minDistNode)).@value + ((double) (((global::haxe.lang.Function) (distCalc) ).__hx_invoke2_f(default(double), minDistNode, default(double), neighbor)) ) );
						if (( distanceToNeighbor <= (dist.@get(neighbor)).@value )) {
							dist.@set(neighbor, distanceToNeighbor);
							prev.@set(neighbor, minDistNode.id);
							object existing = (global::haxe.root.Lambda.find<object>(((object) (queue.elements) ), ((global::haxe.lang.Function) (new global::dropecho.ds.graph.Search_dijkstra_68__Fun<U, T>(neighbor)) ))).@value;
							global::dropecho.ds.GraphNode<T, U> neighbor1 = neighbor;
							object __temp_stmt4 = null;
							{
								global::haxe.lang.Null<double> __temp_odecl2 = dist.@get(neighbor);
								__temp_stmt4 = new global::haxe.lang.DynamicObject(new int[]{1114204006, 1225394690}, new object[]{(__temp_odecl2).toDynamic(), neighbor1}, new int[]{}, new double[]{});
							}
							
							queue.set_value_obj(existing, __temp_stmt4);
						}
						
					}
					
				}
				
			}
			
			return new global::haxe.lang.DynamicObject(new int[]{241646494, 1246881189}, new object[]{dist, prev}, new int[]{}, new double[]{});
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace dropecho.ds.graph {
	public class Search_dijkstra_34__Fun : global::haxe.lang.Function {
		
		public Search_dijkstra_34__Fun() : base(2, 0) {
		}
		
		
		public static global::dropecho.ds.graph.Search_dijkstra_34__Fun __hx_current;
		
		public override object __hx_invoke2_o(double __fn_float1, object __fn_dyn1, double __fn_float2, object __fn_dyn2) {
			object b = ( (( __fn_dyn2 == global::haxe.lang.Runtime.undefined )) ? (((object) (__fn_float2) )) : (((object) (__fn_dyn2) )) );
			object a = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((object) (__fn_float1) )) : (((object) (__fn_dyn1) )) );
			return ( global::haxe.root.Reflect.compare<double>(((double) (global::haxe.lang.Runtime.getField_f(a, "dist", 1114204006, true)) ), ((double) (global::haxe.lang.Runtime.getField_f(b, "dist", 1114204006, true)) )) < 0 );
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace dropecho.ds.graph {
	public class Search_dijkstra_39__Fun<U, T> : global::haxe.lang.Function {
		
		public Search_dijkstra_39__Fun() : base(2, 1) {
		}
		
		
		public override double __hx_invoke2_f(double __fn_float1, object __fn_dyn1, double __fn_float2, object __fn_dyn2) {
			unchecked {
				global::dropecho.ds.GraphNode<T, U> b = ( (( __fn_dyn2 == global::haxe.lang.Runtime.undefined )) ? (((global::dropecho.ds.GraphNode<T, U>) (((object) (__fn_float2) )) )) : (((global::dropecho.ds.GraphNode<T, U>) (__fn_dyn2) )) );
				global::dropecho.ds.GraphNode<T, U> a = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((global::dropecho.ds.GraphNode<T, U>) (((object) (__fn_float1) )) )) : (((global::dropecho.ds.GraphNode<T, U>) (__fn_dyn1) )) );
				return ((double) (1) );
			}
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace dropecho.ds.graph {
	public class Search_dijkstra_58__Fun<U> : global::haxe.lang.Function {
		
		public Search_dijkstra_58__Fun(global::haxe.root.Array<string> existingIds) : base(2, 0) {
			this.existingIds = existingIds;
		}
		
		
		public override object __hx_invoke2_o(double __fn_float1, object __fn_dyn1, double __fn_float2, object __fn_dyn2) {
			U data = ( (( __fn_dyn2 == global::haxe.lang.Runtime.undefined )) ? (global::haxe.lang.Runtime.genericCast<U>(((object) (__fn_float2) ))) : (global::haxe.lang.Runtime.genericCast<U>(__fn_dyn2)) );
			string id = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (global::haxe.lang.Runtime.toString(__fn_float1)) : (global::haxe.lang.Runtime.toString(__fn_dyn1)) );
			return ( this.existingIds.indexOf(id, default(global::haxe.lang.Null<int>)) >= 0 );
		}
		
		
		public global::haxe.root.Array<string> existingIds;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace dropecho.ds.graph {
	public class Search_dijkstra_68__Fun<U, T> : global::haxe.lang.Function {
		
		public Search_dijkstra_68__Fun(global::dropecho.ds.GraphNode<T, U> neighbor) : base(1, 0) {
			this.neighbor = neighbor;
		}
		
		
		public override object __hx_invoke1_o(double __fn_float1, object __fn_dyn1) {
			object x = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((object) (__fn_float1) )) : (((object) (__fn_dyn1) )) );
			return ( ((global::dropecho.ds.GraphNode<T, U>) (global::haxe.lang.Runtime.getField(x, "node", 1225394690, true)) ) == this.neighbor );
		}
		
		
		public global::dropecho.ds.GraphNode<T, U> neighbor;
		
	}
}


