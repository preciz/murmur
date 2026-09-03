defmodule Murmur.Helpers do
  import Bitwise

  # since erlang/elixir integers are variable-length we have to guarantee them
  # to be 32 or 64 bit long
  defmacro mask_32(x), do: quote(do: unquote(x) &&& 0xFFFFFFFF)
  defmacro mask_64(x), do: quote(do: unquote(x) &&& 0xFFFFFFFFFFFFFFFF)

  # 32 bit helper functions

  @compile {:inline, mul32: 2}

  @spec fmix32(non_neg_integer) :: non_neg_integer
  def fmix32(h) do
    h = bxor(h, h >>> 16) |> mul32(0x85EBCA6B)
    h = bxor(h, h >>> 13) |> mul32(0xC2B2AE35)
    bxor(h, h >>> 16)
  end

  defp mul32(a, b) do
    low = (a &&& 0xFFFF) * (b &&& 0xFFFF)
    cross = (a &&& 0xFFFF) * (b >>> 16) + (a >>> 16) * (b &&& 0xFFFF)
    mask_32(low + (cross <<< 16))
  end

  # 64 bit helper functions

  @spec fmix64(non_neg_integer) :: non_neg_integer
  def fmix64(h) do
    h = bxor(h, h >>> 33) |> Kernel.*(0xFF51AFD7ED558CCD) |> mask_64()
    h = bxor(h, h >>> 33) |> Kernel.*(0xC4CEB9FE1A85EC53) |> mask_64()
    bxor(h, h >>> 33)
  end
end
