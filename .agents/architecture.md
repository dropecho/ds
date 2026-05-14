# Architecture

## Class Hierarchy

```
haxe.ds.List<T>
  └── used by Stack<T>, Queue<T> (non-CS)

haxe.ds.IntMap<T>
  └── used by Set<T> (non-CS)

GraphNode<T,U> implements IGraphNode<T,U>
  └── BSPNode<T> extends GraphNode<T,String>

Graph<T,U> implements IGraph<T,U>
  └── BSPTree<T> extends Graph<T,String>

IGraph<T,U> (interface)
IGraphNode<T,U> (interface)

graph.BFIterator<T,U>   — uses Queue<IGraphNode> + Set<String>
graph.DFIterator<T,U>   — uses Stack<IGraphNode> + Set<String>
graph.Search             — uses Heap<NodeDist> for Dijkstra priority queue
```

## Key Design Decisions

### Graph uses string labels as keys
Nodes have a `label:String` that defaults to a random int string. Labels are the
primary key in `graph.nodes` and `graph.edges`. This avoids object reference
equality issues across targets and makes serialization trivial.

### Set uses IntMap for non-CS
By hashing all values to Int, we get O(1) lookup without boxing. The identity
hasher uses a lazily-assigned `__dsId` field on objects (no GC pressure after
first `add`). This makes the Set not suitable for structural equality by default.

### Graph.edges is a two-level map
`edges: AbstractMap<String, AbstractMap<String, U>>` represents `from -> to -> data`.
Outgoing neighbor lookup is O(1). Incoming neighbor lookup is O(nodes) — it
scans all edge maps. `inNeighborLabels` is a full scan.

### BSPTree edge data encodes relationship
Edges between BSP nodes carry String data: `"left"`, `"right"`, or `"parent"`.
This allows graph traversal APIs to filter by relationship type.

### Dijkstra's `prev` map uses `IGraphNode` as key
`AbstractMap<IGraphNode<T,U>, Float>` — works because AbstractMap supports object keys.
The `distCalc` parameter enables weighted graphs; default is `(a,b) -> 1.0`.

## Cross-Platform Split

Files with `#if cs` blocks (full alternative implementations):
- `Queue.hx` — uses `cs.system.collections.generic.Queue_1` on C#
- `Set.hx` — uses `cs.system.collections.generic.HashSet_1` on C#

Files with `@:nativeGen` (affects C# output):
- `Stack`, `Graph`, `GraphNode`, `IGraph`, `IGraphNode`, `Heap`, `BSPNode`, `BSPTree`
- Graph iterators and traversal algorithms

## Performance Notes

- `Set.size()` currently iterates all keys to count — O(n). Could cache.
- `Heap.remove()` and `replace()` use `Array.indexOf` — O(n) scan.
- `Dijkstra` rebuilds `existingLabels` array on every iteration — O(n²) in queue size.
- `outNeighborLabels` sorts the result with `ArraySort` — intentional for determinism.
