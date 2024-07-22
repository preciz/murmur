Murmur
======

[![test](https://github.com/preciz/murmur/actions/workflows/test.yml/badge.svg)](https://github.com/preciz/murmur/actions/workflows/test.yml)

Murmur is a pure Elixir implementation of the non-cryptographic hash [Murmur3](https://code.google.com/p/smhasher/wiki/MurmurHash3).

It aims to implement the x86_32bit, x86_128bit and x64_128bit variants.

# Usage

Add Murmur as a dependency in your mix.exs file.

```elixir
def deps do
  [{:murmur, "~> 1.0"}]
end
```

# Examples

```elixir
iex> Murmur.hash_x86_32("b2622f5e1310a0aa14b7f957fe4246fa", 2147368987)
3297211900

iex> Murmur.hash_x86_128("some random data")
5586633072055552000169173700229798482

# hashes of Erlang terms may change between Erlang versions
iex> Murmur.hash_x64_128([:yes, :you, :can, :use, :any, :erlang, :term!])
300414073828138369336317731503972665325
```

# Performance

This implementation is able to achieve the following ips (iterations per second) with a 50 bytes long binary input:

```txt
CPU Information: AMD Ryzen 7 8845HS w
Number of Available Cores: 16
Elixir 1.17.2
Erlang 27.0
JIT enabled: true

Name                          ips        average  deviation         median         99th %
Murmur.hash_x86_32      1657.86 K        0.60 μs    ±86.24%        0.59 μs        0.81 μs
Murmur.hash_x86_128      776.07 K        1.29 μs  ±1061.39%        1.21 μs        1.49 μs
Murmur.hash_x64_128      496.00 K        2.02 μs   ±459.12%        1.91 μs        2.62 μs
```
