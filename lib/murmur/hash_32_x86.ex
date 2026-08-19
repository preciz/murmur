defmodule Murmur.Hash32X86 do
  import Bitwise
  import Murmur.Helpers

  @c1_32 0xCC9E2D51
  @c2_32 0x1B873593
  @n_32 0xE6546B64

  @compile {:inline, mul32: 2, mix_k32: 1, rotate32: 2, finalize32: 1}

  def hash_x86_32(data, seed) when is_binary(data) do
    hash =
      case body(seed, data) do
        {h, []} ->
          h

        {h, t} ->
          h
          |> bxor(t |> :binary.decode_unsigned(:little) |> mix_k32())
      end

    hash
    |> bxor(byte_size(data))
    |> finalize32()
  end

  @spec body(non_neg_integer, binary) :: {non_neg_integer, [binary] | binary}
  defp body(h0, <<k::size(8)-little-unit(4), t::binary>>) do
    k1 = mix_k32(k)

    h0
    |> bxor(k1)
    |> rotate32(13)
    |> Kernel.*(5)
    |> Kernel.+(@n_32)
    |> mask_32()
    |> body(t)
  end

  defp body(h, t) when byte_size(t) > 0, do: {h, t}
  defp body(h, _), do: {h, []}

  defp mix_k32(k) do
    k = mul32(k, @c1_32)
    mul32(rotate32(k, 15), @c2_32)
  end

  defp mul32(a, b) do
    low = (a &&& 0xFFFF) * (b &&& 0xFFFF)
    cross = (a &&& 0xFFFF) * (b >>> 16) + (a >>> 16) * (b &&& 0xFFFF)
    mask_32(low + (cross <<< 16))
  end

  defp rotate32(x, rotation), do: mask_32(x <<< rotation ||| x >>> (32 - rotation))

  defp finalize32(h) do
    h = bxor(h, h >>> 16) |> mul32(0x85EBCA6B)
    h = bxor(h, h >>> 13) |> mul32(0xC2B2AE35)
    bxor(h, h >>> 16)
  end
end
