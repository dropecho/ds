# Testing Guide

## Running Tests

```bash
haxelib run dropecho.testing
# or
npm test
```

Compiles to `artifacts/js_test/js_test.cjs` (JS) and `artifacts/cs_test/` (C#), then runs both.

---

## Test Framework

- **Test runner:** `dropecho.testing` v1.1.4 (pinned), v1.5.1 available
- **Assertion library:** `utest` (`utest.Assert`, `utest.Test`)
- **Discovery:** Any file ending in `Tests.hx` under `test/` is auto-included
- **Test methods:** Must be prefixed `test_` to be picked up by utest

### Test Class Pattern

```haxe
package mypackage;

import utest.Assert;
import utest.Test;
import dropecho.ds.MyStruct;

class MyStructTests extends Test {
    var subject:MyStruct<Int>;

    public function setup() {        // runs before each test
        subject = new MyStruct();
    }

    public function test_canInstantiate() {
        Assert.notNull(subject);
    }

    public function test_someOperation() {
        subject.doThing(42);
        Assert.equals(42, subject.getValue());
    }
}
```

---

## Common Assertions

```haxe
Assert.equals(expected, actual);
Assert.notEquals(a, b);
Assert.isTrue(expr);
Assert.isFalse(expr);
Assert.notNull(x);
Assert.isNull(x);
Assert.same(a, b);          // structural equality
Assert.contains(item, arr); // array contains
```

---

## Coverage (dropecho.testing v1.5.1)

The latest version (1.5.1, available locally but not yet pinned) supports instrumentation
via a `.dropecho.testing.json` config file:

```json
{
  "hxml": "test.hxml",
  "root_package": "dropecho.ds",
  "instrument": {
    "coverage": true,
    "coverage_reporter": "lcov-reporter"
  }
}
```

To upgrade and enable coverage:
1. Update `haxe_libraries/dropecho.testing.hxml` to point at 1.5.1
2. Create `.dropecho.testing.json` with coverage config above
3. Ensure `instrument` haxelib is installed

---

## Known Test Gaps

### BSPNodeTests — methods missing `test_` prefix (not run by utest)
These exist in `test/bsp/BSPNodeTests.hx` but are NOT executed:
- `createLeft()` → should be `test_createLeft()`
- `createRight()` → should be `test_createRight()`
- `setLeft()` → should be `test_setLeft()`
- `setRight()` → should be `test_setRight()`
- `isLeaf()` → should be `test_isLeaf()`
- `isRoot()` → should be `test_isRoot()`

### Missing tests
- `Stack`: no test for empty `peek()` / `pop()` behavior
- `Queue`: no `push/pop` alias tests (only enqueue/dequeue tested)
- `Set`: `test_toArray` has a logic bug — adds `obj2` but asserts `obj2` in result without adding it first
- `Graph`: no test for `neighbors()` filter, `toString()` output
- `BFIterator/DFIterator`: no edge cases (disconnected graph, single node, cycle)
- `BSPTree/BSPNode`: `getLeafs()` tested but `setLeft/setRight` not
- Tree traversals: no visitor-function tests (early-stop path)

---

## Test File Locations

```
test/
  algos/
    InOrderTraversalTests.hx
    PostOrderTraversalTests.hx
    PreOrderTraversalTests.hx
  bsp/
    BSPNodeTests.hx      ← methods need test_ prefix
    BSPTreeTests.hx
  graph/
    DijkstraTests.hx
    GraphNodeTests.hx
    GraphTests.hx
    IteratorTests.hx
  heap/
    HeapTests.hx
  queue/
    QueueTests.hx
  set/
    SetTests.hx
  stack/
    StackTests.hx
```
