// Generated by Haxe 4.1.5
using haxe.root;

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace dropecho.ds.algos {
	public class PreOrderTraversal {
		
		public PreOrderTraversal() {
			this.visited = new global::haxe.root.Array<string>();
		}
		
		
		public global::haxe.root.Array<string> visited;
		
		public virtual global::haxe.root.Array<string> run(global::dropecho.ds.BSPNode node) {
			return this.run(node, null);
		}
		
		
		public virtual global::haxe.root.Array<string> run(global::dropecho.ds.BSPNode node, global::haxe.lang.Function visitor) {
			if (( visitor != null )) {
				if (global::haxe.lang.Runtime.toBool(((global::haxe.lang.Function) (visitor) ).__hx_invoke1_o(default(double), node))) {
					this.visited.push(node.id);
				}
				else {
					return this.visited;
				}
				
			}
			else {
				this.visited.push(node.id);
			}
			
			if (( node.left != null )) {
				this.run(node.left, visitor);
			}
			
			if (( node.right != null )) {
				this.run(node.right, visitor);
			}
			
			return this.visited;
		}
		
		
	}
}


