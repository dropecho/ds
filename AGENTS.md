# AGENTS.md — dropecho.ds

Single source of truth for all AI agents working on this project.
See `.agents/` for deeper reference docs.

---

## Project Overview

**dropecho.ds** (`haxelib: dropecho.ds`, npm: `@dropecho/ds`) is a cross-platform Haxe library
of data structures and algorithms targeted at games. It compiles to JS (ESM + CJS) and C#.

- **Version:** 1.8.0
- **License:** MIT
- **Targets:** JS (Node.js, browser), C# (.NET 4.0)
- **Test runner:** `haxelib run dropecho.testing` (wraps utest)
- **Source root:** `src/`  · **Tests root:** `test/`

---

## Existing Data Structures

| Class | File | Description |
|---|---|---|
| `Stack<T>` | `src/dropecho/ds/Stack.hx` | LIFO stack backed by `List<T>` |
| `Queue<T>` | `src/dropecho/ds/Queue.hx` | FIFO queue; `push/pop` are FIFO aliases for `enqueue/dequeue` |
| `Set<T>` | `src/dropecho/ds/Set.hx` | Hash set with pluggable hasher; default is identity-based |
| `Heap<T>` | `src/dropecho/ds/Heap.hx` | Binary heap; configurable min/max via comparator |
| `Graph<T,U>` | `src/dropecho/ds/Graph.hx` | Directed/undirected graph with typed node+edge data |
| `GraphNode<T,U>` | `src/dropecho/ds/GraphNode.hx` | Graph node with edge helpers |
| `IGraph<T,U>` | `src/dropecho/ds/IGraph.hx` | Graph interface |
| `IGraphNode<T,U>` | `src/dropecho/ds/IGraphNode.hx` | Graph node interface |
| `BSPTree<T>` | `src/dropecho/ds/BSPTree.hx` | Binary Space Partition tree (extends `Graph<T,String>`) |
| `BSPNode<T>` | `src/dropecho/ds/BSPNode.hx` | BSP node with left/right/parent links |
| `graph.BFIterator<T,U>` | `src/dropecho/ds/graph/BFIterator.hx` | Breadth-first graph iterator |
| `graph.DFIterator<T,U>` | `src/dropecho/ds/graph/DFIterator.hx` | Depth-first graph iterator |
| `graph.Search` | `src/dropecho/ds/graph/Search.hx` | Dijkstra shortest-path; optional weighted `distCalc` |
| `algos.InOrderTraversal` | `src/dropecho/ds/algos/InOrderTraversal.hx` | BSP in-order traversal |
| `algos.PreOrderTraversal` | `src/dropecho/ds/algos/PreOrderTraversal.hx` | BSP pre-order traversal |
| `algos.PostOrderTraversal` | `src/dropecho/ds/algos/PostOrderTraversal.hx` | BSP post-order traversal |

See `.agents/data-structures.md` for API details and usage notes.

---

## Directory Layout

```
src/dropecho/ds/         # library source
  algos/                 # tree traversal algorithms
  graph/                 # graph iterators + search
test/                    # utest test suites (mirroring src structure)
  algos/ bsp/ graph/ heap/ queue/ set/ stack/
bench/                   # benchmark scripts
artifacts/               # compiled outputs (gitignored)
targets/                 # per-target HXML fragments
haxe_libraries/          # lix-managed dependency HXMLs
.agents/                 # extended AI agent documentation
```

---

## Testing Requirements

All new code and refactored code must be covered by tests. This is non-negotiable:

- Every new data structure or algorithm gets a corresponding `test/<package>/...Tests.hx` file.
- Every refactored method must have its existing tests updated or extended to cover the change.
- Run `npm test` after every change and confirm exit code 0 before considering work done.

See `.agents/testing.md` for test patterns, known gaps, and coverage setup.

---

## Build & Test

Prefer npm scripts from `package.json` over invoking Haxe tools directly.

```bash
npm install          # install deps + lix download
npm run build        # build all targets (JS + C#)
npm test             # run full test suite (JS + C#)
```

Direct commands (only when npm scripts don't cover the need):
```bash
haxe build.hxml                  # build
haxelib run dropecho.testing     # test
haxe bench.hxml && node artifacts/bench.js   # benchmarks
```

Tests are discovered automatically: any file ending in `Tests.hx` under `test/` is included.
Test classes extend `utest.Test`; methods prefixed `test_` are test cases.

See `.agents/testing.md` for patterns, coverage, and dropecho.testing v1.5.1 features.

---

## Key Conventions

- `@:nativeGen` + `@:expose("Name")` on classes exported to JS/C#
- Interfaces (`IGraph`, `IGraphNode`) kept in `src/dropecho/ds/` alongside implementations
- `#if cs ... #else ... #end` conditional compilation for C#-specific implementations
- `dropecho.interop.AbstractMap` / `AbstractFunc` used for cross-platform map/function abstractions
- `inline` on hot-path methods; avoid it on methods that need override
- No comments unless the WHY is non-obvious; no docstrings beyond the interface-level JSDoc

See `.agents/conventions.md` for full Haxe coding conventions.

---

## Dependencies

| Library | Purpose |
|---|---|
| `dropecho.interop` | `AbstractMap`, `AbstractFunc` cross-platform wrappers |
| `dropecho.testing` | Test runner (wraps utest); currently pinned to 1.1.4, latest available: 1.5.1 |
| `utest` | Assertion library (`utest.Assert`, `utest.Test`) |
| `hxnodejs` | Node.js target support |
| `hxcs` | C# target support |

---

## Testing Notes

- Test files live in `test/<package>/` matching source structure
- `BSPNodeTests` methods missing `test_` prefix are **not run** by utest (intentional skips or bugs)
- `dropecho.testing` v1.5.1 supports coverage instrumentation via `.dropecho.testing.json` config
- Run with: `haxelib run dropecho.testing`

See `.agents/testing.md` for patterns and gaps.
