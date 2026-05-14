# TODOs

## Bugs

- [x] **GraphNode: `data` param not passed to graph** (`src/dropecho/ds/GraphNode.hx:20,25`)
  `addUniEdge()` and `addBiEdge()` accept `?data:U` but never pass it to `graph.addUniEdge()`/`graph.addBiEdge()`. Edge data is silently dropped.

- [x] **IGraph: typo in param name** (`src/dropecho/ds/IGraph.hx:116`)
  `toLabeloId` should be `toLabelId`.

## Incomplete Features

- [x] **Graph: `inNeighborLabels()` filter not implemented** (`src/dropecho/ds/Graph.hx:71`)
  The `filter` parameter is accepted but ignored. `outNeighborLabels()` has full filter support — match that behavior.

- [x] **Search: Dijkstra ignores edge weights** (`src/dropecho/ds/graph/Search.hx:72`)
  Default stays 1.0/hop (C# value types make generic-cast-to-Float unsafe); `distCalc` param is the correct opt-in for weighted graphs. Documented with a weighted test.

## Performance

- [x] **Set: slow default hashing** (`src/dropecho/ds/Set.hx:13,102`)
  Replaced JSON default with identity-based hashing (lazy `__dsId` on objects, fast paths for primitives). 4–26x faster. Breaking: object equality is now identity, not structural.

## Tests

- [x] **Graph: test edge data storage/retrieval**
  `edgeData()` is not tested — verify data passed to `addUniEdge()`/`addBiEdge()` is actually retrievable.

- [x] **Dijkstra: test custom `distCalc` function**
  No test confirms custom distance calculators work correctly.

- [x] **Graph: test `inNeighborLabels()` filter** (blocked by incomplete feature above)

- [x] **Heap: test `remove()` and `replace()` operations**

## Minor Inconsistencies

- [x] **DFIterator vs BFIterator: inconsistent `inline` on `hasNext()`**
  `BFIterator.hasNext()` is `inline`, `DFIterator.hasNext()` is not. Pick one.

- [x] **Queue: naming ambiguity on Haxe target**
  `push()`/`pop()` on the Haxe variant have FIFO semantics, which is surprising. Consider aliasing or documenting clearly.
