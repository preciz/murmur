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
Elixir 1.20.4
Erlang 29.0.5
JIT enabled: true

Name                   ips        average  deviation         median         99th %
hash_x86_32         4.12 M      242.53 ns  ±1414.98%         220 ns         351 ns
hash_x86_128        2.66 M      376.23 ns  ±1354.00%         341 ns         541 ns
hash_x64_128        0.59 M     1704.25 ns    ±96.85%        1623 ns        2816 ns
```
