Murmur
======

[![test](https://github.com/preciz/murmur/actions/workflows/test.yml/badge.svg)](https://github.com/preciz/murmur/actions/workflows/test.yml)

Murmur is a pure Elixir implementation of the non-cryptographic hash [Murmur3](https://github.com/aappleby/smhasher/blob/master/src/MurmurHash3.cpp).

It aims to implement the x86_32bit, x86_128bit and x64_128bit variants.

# Usage

Add Murmur as a dependency in your mix.exs file.

```elixir
def deps do
  [{:murmur, "~> 2.0"}]
end
```

# Examples

```elixir
iex> Murmur.hash_x86_32("b2622f5e1310a0aa14b7f957fe4246fa", 2147368987)
3297211900

iex> Murmur.hash_x86_128("some random data")
217376041865091047320520964146365461062

# hashes of Erlang terms may change between Erlang versions
iex> Murmur.hash_x64_128([:yes, :you, :can, :use, :any, :erlang, :term!]) |> is_integer()
true
```

# Performance

This implementation achieves the following ips (iterations per second) with a 50-byte long binary input:

```txt
CPU Information: AMD Ryzen 7 8845HS w
Number of Available Cores: 16
Elixir 1.20.3
Erlang 29.0.5
JIT enabled: true

Name                   ips        average  deviation         median         99th %
hash_x86_32         4.18 M      238.96 ns  ±2012.18%         211 ns         331 ns
hash_x86_128        2.52 M      396.91 ns  ±1137.50%         360 ns         551 ns
hash_x64_128        0.58 M     1725.26 ns   ±273.65%        1623 ns        3146 ns
```
