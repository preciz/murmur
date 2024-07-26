defmodule Murmur do
  @moduledoc ~S"""
  This module implements the x86_32, x86_128 and x64_128 variants of the
  non-cryptographic hash Murmur3.

  ## Examples

      iex> Murmur.hash_x86_32("b2622f5e1310a0aa14b7f957fe4246fa", 2147368987)
      3297211900

      iex> Murmur.hash_x86_128("some random data")
      217376041865091047320520964146365461062

      # hashes of Erlang terms may change between Erlang versions
      # iex> Murmur.hash_x64_128([:yes, :you, :can, :use, :any, :Erlang, :term!])
      # => 300414073828138369336317731503972665325

  """

  @doc """
  Returns the hashed Erlang term `data` using an optional `seed` which defaults to `0`.

  This function uses the x64 128bit variant.
  """
  @spec hash_x64_128(binary | term, non_neg_integer) :: non_neg_integer
  def hash_x64_128(data, seed \\ 0)

  def hash_x64_128(data, seed) when not is_binary(data) do
    hash_x64_128(:erlang.term_to_binary(data), seed)
  end

  defdelegate hash_x64_128(data, seed), to: Murmur.Hash128X64

  @doc """
  Returns the hashed Erlang term `data` using an optional `seed` which defaults to `0`.

  This function uses the x86 128bit variant.
  """
  @spec hash_x86_128(binary | term, non_neg_integer) :: non_neg_integer
  def hash_x86_128(data, seed \\ 0)

  def hash_x86_128(data, seed) when not is_binary(data) do
    hash_x86_128(:erlang.term_to_binary(data), seed)
  end

  defdelegate hash_x86_128(data, seed), to: Murmur.Hash128X86

  @doc """
  Returns the hashed Erlang term `data` using an optional `seed` which defaults to `0`.

  This function uses the x86 32bit variant.
  """
  @spec hash_x86_32(binary | term, non_neg_integer) :: non_neg_integer
  def hash_x86_32(data, seed \\ 0)

  def hash_x86_32(data, seed) when not is_binary(data) do
    hash_x86_32(:erlang.term_to_binary(data), seed)
  end

  defdelegate hash_x86_32(data, seed), to: Murmur.Hash32X86
end
