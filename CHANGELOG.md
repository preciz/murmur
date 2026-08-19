# Changelog

## 2.0.1 (2026-08-19)

### Changed
- Reduced allocations in the 128-bit hash implementations by replacing fixed-size
  collection pipelines with direct state handling.
- Improved hashing performance and memory usage with compiler-guided arithmetic
  optimizations while preserving existing hash results.

## 2.0.0 (2024-07-26)

## Breaking changes
- Refactor and fix 128-bit results according to the original (SMHasher) version,
  this fixes the issue with the 128-bit results being incorrect, but it also means
  that the 128-bit results are not compatible with the previous version of the library,
  therefore the version has been bumped to 2.0.0.

## 1.0.4 (2024-07-22)

### Changed
- Stopped testing against Erlang terms due to potential inconsistencies between Erlang versions.
- Fixed compiler warnings.

## 1.0.3 and earlier

- See the Git history for changes prior to 1.0.4
