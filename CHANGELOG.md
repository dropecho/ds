# [2.0.0](https://github.com/dropecho/ds/compare/1.8.0...2.0.0) (2026-06-30)


### Bug Fixes

* correct sift-down child selection and pop in Heap ([6452fcc](https://github.com/dropecho/ds/commit/6452fcc0da61de1250f9ff90fc51cc4386994c3f))
* drop null labels from filtered outNeighborLabels ([efada0e](https://github.com/dropecho/ds/commit/efada0e7e14b37a0b75770d72cf334dbc7b149e7))
* key Dijkstra distance/prev maps by node label ([ef75be4](https://github.com/dropecho/ds/commit/ef75be4c51f0d602ab6b039d15d211f9903f19d3))
* **ringbuffer:** reject capacity < 1 to avoid modulo-by-zero ([7b56140](https://github.com/dropecho/ds/commit/7b56140be9022eff0fc86732dfafaa872db81d8f))
* **spatialhash:** reject cellSize <= 0 to avoid division-by-zero ([5075e24](https://github.com/dropecho/ds/commit/5075e24ba18ac7536ca628629b024d54d3485c36))
* Remove C# build for now. ([f537e65](https://github.com/dropecho/ds/commit/f537e65842487dfc0ee4e1edc25f12b0710d93b4))
* **astar:** reopen closed nodes for non-consistent heuristics ([046167a](https://github.com/dropecho/ds/commit/046167a2141580f246db6a51b71cfea87e304949))
* Try to fix cs build by removing trailing / ([265bb99](https://github.com/dropecho/ds/commit/265bb997a7e5068315d0b158ababed24f68d1852))


### Features

* add 7 new data structures, A*, MST, traversal, and project setup ([7430f30](https://github.com/dropecho/ds/commit/7430f30a3d5b9357687574b69981838ac09c64e7))
* Add graph, node interfaces.  Add BF DF iterators. ([2af5219](https://github.com/dropecho/ds/commit/2af52195828f2e53fc94c4fb2160a120b585b4cd))
* graph filter, weighted Dijkstra, heap remove, iterator inline ([0cc0197](https://github.com/dropecho/ds/commit/0cc0197f0d6d4b8c6bf4755a2e6fefbb9678d842))


### Performance Improvements

* **traversal:** count nodes during in-degree build in topologicalSort ([5f71094](https://github.com/dropecho/ds/commit/5f71094c4f5169f0bedf9991a20fee9a930874c8))
* replace JSON default hasher in Set with identity-based hashing ([4d636a0](https://github.com/dropecho/ds/commit/4d636a034deb881d6742f8e61ff86a2b14ec771f))


### Reverts

* restore object-keyed Dijkstra distance/prev maps ([f72fe2d](https://github.com/dropecho/ds/commit/f72fe2d30a3bb53903f63a0fdcd16f0c78e85501))


### BREAKING CHANGES

* default equality for objects is now identity-based (same
reference = same item). Callers needing structural equality should
pass an explicit hasher.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>

# [1.8.0](https://github.com/dropecho/ds/compare/1.7.0...1.8.0) (2023-09-16)


### Features

* Improve set performance with new hasher. ([c03ec08](https://github.com/dropecho/ds/commit/c03ec0824300d64cccfae68bd2c26db69afea121))

# [1.7.0](https://github.com/dropecho/ds/compare/1.6.0...1.7.0) (2023-09-11)


### Features

* Allow custom hashers again on set. ([3533e46](https://github.com/dropecho/ds/commit/3533e46011c4b0e5e40df47d8f89251cccf73992))

# [1.6.0](https://github.com/dropecho/ds/compare/1.5.4...1.6.0) (2023-09-11)


### Features

* Lots of cleanup, more docs, switch to list for stack/queue. ([38d63f7](https://github.com/dropecho/ds/commit/38d63f71adacd3a0b96f7db55fa6e7235d9acfcd))

## [1.5.4](https://github.com/dropecho/ds/compare/1.5.3...1.5.4) (2023-09-08)


### Bug Fixes

* Cleanup. ([e676803](https://github.com/dropecho/ds/commit/e676803e05daddb09c5d642b5fcfcda3eac0cdc6))

## [1.5.3](https://github.com/dropecho/ds/compare/1.5.2...1.5.3) (2023-08-28)


### Bug Fixes

* Fix issue with es6/genes conflict. ([565744a](https://github.com/dropecho/ds/commit/565744ab3e822c391420dfc19cef4f742029bff0))

## [1.5.2](https://github.com/dropecho/ds/compare/1.5.1...1.5.2) (2023-08-28)


### Bug Fixes

* Clean up bst tree code around children. ([51d11a0](https://github.com/dropecho/ds/commit/51d11a014fa7dad972c59ed288817103316afea1))

## [1.5.1](https://github.com/dropecho/ds/compare/1.5.0...1.5.1) (2023-08-26)


### Bug Fixes

* Fix issue with .net version, make set mostly work for c#. ([beb3224](https://github.com/dropecho/ds/commit/beb3224ac943b3f2ffe38cdce50500423796648b))

# [1.5.0](https://github.com/dropecho/ds/compare/1.4.1...1.5.0) (2023-08-26)


### Bug Fixes

* Add lix to deps. ([490f28b](https://github.com/dropecho/ds/commit/490f28b7d155a8ee85d22001e4c86fe820280fe3))


### Features

* Setup lix libs, move to utest+dropecho.testing, cleanup. ([554e373](https://github.com/dropecho/ds/commit/554e3737d4882f046d1a9a3e9f19bf96c71ee5fa))

## [1.4.1](https://github.com/dropecho/ds/compare/1.4.0...1.4.1) (2022-12-08)


### Bug Fixes

* Update to new build system, misc cleanup. ([0898924](https://github.com/dropecho/ds/commit/08989243a677c080e240d271e543f42228cb954a))

# [1.4.0](https://github.com/dropecho/ds/compare/1.3.0...1.4.0) (2021-03-20)


### Features

* Update all DS to use new interop, clean up tests, random fixes for real use in dungen and other libs. ([4466789](https://github.com/dropecho/ds/commit/44667894c6c5880f8a6cfecde22ab4f64f4e2a96))

# [1.3.0](https://github.com/dropecho/ds/compare/1.2.0...1.3.0) (2021-02-04)


### Features

* More cleanup, remove dist from git. ([3103909](https://github.com/dropecho/ds/commit/310390988d1a779690a3a6696fde286267959489))

# [1.2.0](https://github.com/dropecho/ds/compare/1.1.0...1.2.0) (2021-02-01)


### Features

* cleanup, add in/out neighbors to graph, start on grammar based transforms. ([0285f20](https://github.com/dropecho/ds/commit/0285f200952278c05568a351790f6c366e7c149b))

# [1.1.0](https://github.com/dropecho/ds/compare/v1.0.0...1.1.0) (2020-10-29)


### Features

* Change traversals and search to static funcs. ([88bfd0e](https://github.com/dropecho/ds/commit/88bfd0ebf3790635448249b58455f1b02f40143d))

## <small>0.3.1 (2020-04-25)</small>

* Fix issue with traversal ([a328f97](https://github.com/dropecho/ds/commit/a328f97))



## 0.3.0 (2020-04-25)

* Add visitor function to bsp traversals ([d619187](https://github.com/dropecho/ds/commit/d619187))
* Release 0.3.0 ([ffeb7aa](https://github.com/dropecho/ds/commit/ffeb7aa))
* version ([ea968f2](https://github.com/dropecho/ds/commit/ea968f2))



## 0.2.0 (2020-04-25)

* add hasleft && hasright to bspnode ([e89194a](https://github.com/dropecho/ds/commit/e89194a))
* Release 0.2.0 ([aff7688](https://github.com/dropecho/ds/commit/aff7688))
* version ([5ac5d00](https://github.com/dropecho/ds/commit/5ac5d00))



## <small>0.1.1 (2020-04-25)</small>

* Add heap and tests ([adb8e61](https://github.com/dropecho/ds/commit/adb8e61))
* Add placeholder readme ([f21ff24](https://github.com/dropecho/ds/commit/f21ff24))
* Cleanup ([874ca68](https://github.com/dropecho/ds/commit/874ca68))
* Initial commit ([ea1a073](https://github.com/dropecho/ds/commit/ea1a073))
* Move to dropecho namespace, rename to ds ([08fe160](https://github.com/dropecho/ds/commit/08fe160))
* Release 0.1.1 ([c06b45c](https://github.com/dropecho/ds/commit/c06b45c))
* version ([bd3a8ac](https://github.com/dropecho/ds/commit/bd3a8ac))
* version ([398b8f8](https://github.com/dropecho/ds/commit/398b8f8))
* Working on lots of algos + dijkstra ([7839930](https://github.com/dropecho/ds/commit/7839930))
