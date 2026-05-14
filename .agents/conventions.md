# Haxe Coding Conventions

## Metadata

- `@:nativeGen` — generate native class hierarchy in C# (no Haxe boxing)
- `@:expose("Name")` — export to JS global scope under given name
- `@:inheritDoc(IFoo.method)` — inherit JSDoc from interface (reduces duplication)
- `@:struct` — hint for value-type-like structs (used in `Search.hx`)

## Cross-platform Patterns

### Conditional compilation

```haxe
#if cs
  import cs.system.collections.generic.HashSet_1;
  class Set<T> { ... }  // C# implementation
#else
  class Set<T> { ... }  // JS/Neko/etc implementation
#end
```

C# implementations use `cs.system.collections.generic.*` native collections.
Non-CS implementations use `haxe.ds.*` or custom structures.

### AbstractMap / AbstractFunc

`dropecho.interop.AbstractMap` is used instead of `haxe.ds.StringMap` for cross-platform
compatibility. Same for `AbstractFunc` / `Func_1<T, R>`.

Import pattern:
```haxe
import dropecho.interop.AbstractMap;
import dropecho.interop.AbstractFunc;
```

## Naming

- Classes: `PascalCase`
- Methods/fields: `camelCase`
- Private fields: `_camelCase` (underscore prefix)
- Type parameters: single uppercase letter (`T`, `U`) or short descriptive (`TNodeData`)
- Test methods: `test_snake_case_description` (required prefix for utest discovery)

## Generics

Two-param graphs use `<T, U>` where `T` = node data, `U` = edge data.
BSP specializes to `<T, String>` (edge labels are "left"/"right"/"parent").

## Inline

Use `inline` on:
- Pure getters (`get_length`, `peek`, `size`)
- Trivial delegation methods (`hasNext` in iterators)
- Short utility methods called in hot loops

Do NOT use `inline` on methods that may need to be overridden or are non-trivial.
Both `BFIterator.hasNext` and `DFIterator.hasNext` are now consistently `inline`.

## Comments

Only comment the WHY when non-obvious. No docblocks on implementations
(use `@:inheritDoc` to pull from interfaces). Inline comments for algorithms only.

## Build Targets

- `targets/js.hxml` — CommonJS output to `dist/js/cjs/`
- `targets/js-esm.hxml` — ESM output to `dist/js/esm/`
- `targets/cs.hxml` — C# output to `dist/cs/`
- `targets/docs.hxml` — XML for dox documentation (commented out in build.hxml)

## Package Structure

```
package dropecho.ds;          // top-level structures
package dropecho.ds.graph;    // graph-specific (iterators, search)
package dropecho.ds.algos;    // tree traversal algorithms
```

Expose names match class names without package prefix:
- `@:expose("Stack")`, `@:expose("Graph")`, `@:expose("GraphNode")`, etc.
- Graph algorithms: `@:expose` (no name) on `Search`

## C# Mono Compiler — `<` Operator Ambiguity

The Mono C# compiler (`dmcs`) treats `a < expr` as ambiguous when `expr` starts with a
complex generic type cast (e.g. `((IDictionary<K, V>) map)[key]`). It tries to parse `<`
as the start of a generic type argument list and emits `CS1031: Type expected`.

**Rule:** never write `someFloat < someAbstractMap[key]` directly. Extract the map read
into a local variable first:

```haxe
// BAD — generates ambiguous C# `tentativeG < ((IDictionary<...>)(gScore))[neighbor]`
if (tentativeG < gScore[neighbor]) { ... }

// GOOD — comparison against a plain local is unambiguous
var neighborG = gScore[neighbor];
if (tentativeG < neighborG) { ... }
```

Two-character operators (`<=`, `>=`, `!=`, `==`) do not trigger this ambiguity.
Single-char `>` against a generic cast also causes the same issue — use the same pattern.

## Error Handling

No defensive error handling for internal invariants. Only validate at system
boundaries (public API entry points where input is untrusted).
`Graph.remove` silently no-ops on unknown labels; `Heap.remove` silently no-ops
on items not found (`indexOf == -1` check).
