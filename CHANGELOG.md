# Changelog

## 2.0.2 (2026-09-03)

### Added
- Comprehensive test coverage for block and tail boundary vectors (0 to 33 bytes) across all Murmur3 variants.
- Regression tests verifying Erlang term hashing against serialized binary representations.

### Changed
- Optimized tail processing in 128-bit hashes (`Murmur.Hash128X86` and `Murmur.Hash128X64`) by decoding 32-bit and 64-bit integers directly via binary pattern matching, eliminating intermediate tail splitting.
- Added fast-path early exit for empty tails in 128-bit hashes.
- Inlined hot arithmetic, round mixing, and intermixing functions in 128-bit hash implementations.
- Streamlined dispatch in the top-level `Murmur` module to directly invoke hash implementations for binary inputs.
- Simplified tail termination in `Murmur.Hash32X86` with direct empty binary pattern matching.
- Standardized binary pattern matching to canonical bit syntax (`32-little`, `64-little`).
- Updated documentation examples, local benchmark scripts, and benchmark results in `README.md`.

### Removed
- Removed unused and orphaned helper functions from `Murmur.Helpers` (`fmix32/1`, `fmix64/1`, `swap_uint/1`, `k_32_op/4`, `k_64_op/4`, `rotl32/2`, `rotl64/2`, `bxor_and_shift_right/2`).
- Removed redundant masking operations and constant function arguments in internal round helpers.

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
