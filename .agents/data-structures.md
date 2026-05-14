# Data Structures — API Reference

## Stack\<T\>

LIFO. Backed by `haxe.ds.List<T>`.

```haxe
var s = new Stack<Int>();
s.push(1);           // add to top
s.pushMany([2,3]);   // add multiple
s.peek();            // view top, no remove
s.pop();             // remove and return top
s.length;            // count
for (x in s) { }    // iterate LIFO order
```

---

## Queue\<T\>

FIFO. JS/Neko backed by `haxe.ds.List`; C# backed by `cs.system.collections.generic.Queue_1`.
`push/pop` are FIFO aliases for `enqueue/dequeue` — not LIFO.

```haxe
var q = new Queue<Int>();
q.enqueue(1);   // or q.push(1)
q.dequeue();    // or q.pop() — removes from front
q.peek();       // view front, no remove
q.length;
for (x in q) { }
```

---

## Set\<T\>

Hash set backed by `haxe.ds.IntMap`. Pluggable hasher; default is identity-based.

**Hashing strategies (fastest → slowest):**
1. **Identity (default)** — same reference = same item. Objects get a lazy `__dsId` field.
2. **Custom field hasher** — pass `(item) -> item.x * 31 + item.y` for structural equality on known types.
3. **Generic structural** — reflection-based; ~20x slower than identity.

```haxe
var s = new Set<Int>();          // identity hasher
var s2 = new Set<Point>(p -> p.x * 31 + p.y);  // custom hasher
s.add(1);           // returns Bool (true if newly added)
s.exists(1);        // Bool
s.size();           // Int (counts keys)
s.array();          // Array<T>
for (x in s) { }   // iterate
```

**Breaking note:** default equality is identity, not structural. Two objects with equal fields are distinct unless a custom hasher makes them equal.

---

## Heap\<T\>

Binary heap. Min-heap by default (`Reflect.compare(a,b) < 0`). Configure via comparator.

```haxe
var minH = new Heap<Int>();                         // min-heap
var maxH = new Heap<Int>((a,b) -> a > b);           // max-heap
var fooH = new Heap<Foo>((a,b) -> a.d < b.d);      // by field

h.push(item);          // add; O(log n)
h.pop();               // remove+return min/max; O(log n)
h.peek();              // view min/max; O(1)
h.remove(item);        // remove specific item; O(n) find + O(log n) rebuild
h.replace(old, newV);  // replace item; O(n) find + O(log n) rebuild
h.size();              // Int
h.elements;            // Array<T> (raw heap array, not sorted)
```

---

## Graph\<T, U\>

Directed graph. `T` = node data type, `U` = edge data type.
Nodes keyed by `String` label (auto-generated random id if not provided).

```haxe
var g = new Graph<Int, Float>();
var n1 = g.createNode(10);               // creates + adds node
var n2 = g.createNode(20, "myLabel");    // custom label
g.addUniEdge(n1.label, n2.label, 1.5);  // directed edge with data
g.addBiEdge(n1.label, n2.label, 2.0);   // bidirectional edge
g.remove(n1.label);                      // remove node + all its edges
g.outNeighbors(n1);                      // Array<IGraphNode>
g.outNeighborLabels(n1);                 // Array<String>, sorted
g.inNeighbors(n1);                       // Array<IGraphNode>
g.inNeighborLabels(n1);                  // Array<String>
g.neighbors(n1);                         // in + out
g.edgeData("fromLabel", "toLabel");      // Null<U>
g.nodes;                                 // AbstractMap<String, IGraphNode>
g.edges;                                 // AbstractMap<String, AbstractMap<String, U>>
g.toString();                            // adjacency list string
g.toDot();                               // graphviz dot format
```

Filter functions: `(label:String, edgeData:U) -> Bool`

---

## GraphNode\<T, U\>

```haxe
var n = new GraphNode<Int, Float>(42, "optionalLabel");
n.addUniEdge(other, data);   // delegates to graph
n.addBiEdge(other, data);
n.neighbors();               // in + out neighbor nodes
n.neighborLabels();          // in + out neighbor labels
n.label;                     // String
n.value;                     // T
n.graph;                     // IGraph<T,U>
```

---

## BSPTree\<T\> / BSPNode\<T\>

`BSPTree<T>` extends `Graph<T, String>`. Edge data is `"left"`, `"right"`, or `"parent"`.
`BSPNode<T>` extends `GraphNode<T, String>`.

```haxe
var tree = new BSPTree<Int>(rootValue);
var root = tree.root;            // BSPNode<T>
var left = root.createLeft(1);   // creates + links as left child
var right = root.createRight(2); // creates + links as right child
root.setLeft(existingNode);      // link existing node as left
root.setRight(existingNode);
root.isLeaf();   // no children
root.isRoot();   // no parent
root.hasLeft();
root.hasRight();
tree.getParent(node);            // BSPNode<T>
tree.getChildren(node);          // Array<BSPNode<T>> (left+right)
tree.getRoot();                  // BSPNode<T>
tree.getLeafs();                 // Array of leaf nodes
```

---

## BFIterator / DFIterator

```haxe
var bfi = new BFIterator(startNode);
var dfi = new DFIterator(startNode);
for (node in bfi) { }   // breadth-first
for (node in dfi) { }   // depth-first
```

Both use `outNeighbors` for traversal (directed).

---

## graph.Search (Dijkstra)

```haxe
// Unweighted (1.0 per hop)
var result = Search.dijkstra(startNode);

// Weighted — distCalc reads edge data
var result = Search.dijkstra(startNode, (a, b) -> {
    var d = a.graph.edgeData(a.label, b.label);
    d != null ? (d : Float) : 1.0;
});

result.distances;   // AbstractMap<IGraphNode, Float>
result.path;        // AbstractMap<IGraphNode, String> — prev-node label
```

---

## Tree Traversal Algorithms

All take a `BSPNode<T>` and optional visitor `(BSPNode<T>) -> Bool` (false stops traversal).
Return `Array<String>` of visited labels.

```haxe
new InOrderTraversal().run(root);    // left, root, right
new PreOrderTraversal().run(root);   // root, left, right
new PostOrderTraversal().run(root);  // left, right, root
```
