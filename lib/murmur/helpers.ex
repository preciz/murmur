defmodule Murmur.Helpers do
  import Bitwise

  # since erlang/elixir integers are variable-length we have to guarantee them
  # to be 32 or 64 bit long
  defmacro mask_32(x), do: quote(do: unquote(x) &&& 0xFFFFFFFF)
  defmacro mask_64(x), do: quote(do: unquote(x) &&& 0xFFFFFFFFFFFFFFFF)

  # 32 bit helper functions

  @spec k_32_op(
          non_neg_integer(),
          597_399_067 | 951_274_213 | 2_716_044_179 | 2_869_860_233 | 3_432_918_353,
          15 | 16 | 17 | 18,
          461_845_907 | 597_399_067 | 951_274_213 | 2_716_044_179 | 2_869_860_233
        ) :: non_neg_integer
  def k_32_op(k, c1, rotl, c2) do
    k
    |> Kernel.*(c1)
    |> mask_32
    |> rotl32(rotl)
    |> mask_32
    |> Kernel.*(c2)
    |> mask_32
  end

  @spec fmix32(non_neg_integer) :: non_neg_integer
  def fmix32(h) do
    h
    |> bxor_and_shift_right(16)
    |> Kernel.*(0x85EBCA6B)
    |> mask_32
    |> bxor_and_shift_right(13)
    |> Kernel.*(0xC2B2AE35)
    |> mask_32
    |> bxor_and_shift_right(16)
  end

  @spec rotl32(non_neg_integer, non_neg_integer) :: non_neg_integer
  def rotl32(x, r), do: mask_32(x <<< r ||| x >>> (32 - r))

  # 64 bit helper functions

  @spec k_64_op(
          non_neg_integer,
          5_545_529_020_109_919_103 | 9_782_798_678_568_883_157,
          31 | 33,
          5_545_529_020_109_919_103 | 9_782_798_678_568_883_157
        ) :: non_neg_integer
  def k_64_op(k, c1, rotl, c2) do
    k
    |> Kernel.*(c1)
    |> mask_64
    |> rotl64(rotl)
    |> mask_64
    |> Kernel.*(c2)
    |> mask_64
  end

  @spec rotl64(non_neg_integer, non_neg_integer) :: non_neg_integer
  def rotl64(x, r), do: mask_64(x <<< r ||| x >>> (64 - r))

  @spec fmix64(non_neg_integer) :: non_neg_integer
  def fmix64(h0) do
    h0
    |> bxor_and_shift_right(33)
    |> Kernel.*(0xFF51AFD7ED558CCD)
    |> mask_64
    |> bxor_and_shift_right(33)
    |> Kernel.*(0xC4CEB9FE1A85EC53)
    |> mask_64
    |> bxor_and_shift_right(33)
  end

  # General helpers (for both x86 and x64)

  @spec swap_uint(binary) :: non_neg_integer
  def swap_uint(
        <<v1::size(8), v2::size(8), v3::size(8), v4::size(8), v5::size(8), v6::size(8),
          v7::size(8), v8::size(8)>>
      ) do
    v8 <<< 56
    |> bxor(v7 <<< 48)
    |> bxor(v6 <<< 40)
    |> bxor(v5 <<< 32)
    |> bxor(v4 <<< 24)
    |> bxor(v3 <<< 16)
    |> bxor(v2 <<< 8)
    |> bxor(v1)
  end

  def swap_uint(
        <<v1::size(8), v2::size(8), v3::size(8), v4::size(8), v5::size(8), v6::size(8),
          v7::size(8)>>
      ) do
    v7 <<< 48
    |> bxor(v6 <<< 40)
    |> bxor(v5 <<< 32)
    |> bxor(v4 <<< 24)
    |> bxor(v3 <<< 16)
    |> bxor(v2 <<< 8)
    |> bxor(v1)
  end

  def swap_uint(<<v1::size(8), v2::size(8), v3::size(8), v4::size(8), v5::size(8), v6::size(8)>>) do
    v6 <<< 40
    |> bxor(v5 <<< 32)
    |> bxor(v4 <<< 24)
    |> bxor(v3 <<< 16)
    |> bxor(v2 <<< 8)
    |> bxor(v1)
  end

  def swap_uint(<<v1::size(8), v2::size(8), v3::size(8), v4::size(8), v5::size(8)>>) do
    v5 <<< 32
    |> bxor(v4 <<< 24)
    |> bxor(v3 <<< 16)
    |> bxor(v2 <<< 8)
    |> bxor(v1)
  end

  def swap_uint(<<v1::size(8), v2::size(8), v3::size(8), v4::size(8)>>) do
    v4 <<< 24
    |> bxor(v3 <<< 16)
    |> bxor(v2 <<< 8)
    |> bxor(v1)
  end

  def swap_uint(<<v1::size(8), v2::size(8), v3::size(8)>>) do
    v3 <<< 16
    |> bxor(v2 <<< 8)
    |> bxor(v1)
  end

  def swap_uint(<<v1::size(8), v2::size(8)>>) do
    v2 <<< 8 |> bxor(v1)
  end

  def swap_uint(<<v1::size(8)>>), do: 0 |> bxor(v1)

  def swap_uint(""), do: 0

  @spec bxor_and_shift_right(non_neg_integer, non_neg_integer) :: non_neg_integer
  def bxor_and_shift_right(h, v), do: bxor(h, h >>> v)
end
