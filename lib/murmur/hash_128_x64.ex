defmodule Murmur.Hash128X64 do
  import Bitwise
  import Murmur.Helpers

  @c1_64_128 0x87C37B91114253D5
  @c2_64_128 0x4CF5AD432745937F
  @n1_64_128 0x52DCE729
  @n2_64_128 0x38495AB5

  @compile {:inline, mix_k64: 4, finalize64: 1, h_64_op: 6}

  def hash_x64_128(data, seed) when is_binary(data) do
    {h1, h2, tail} = body(seed, seed, data)
    {tail1, tail2} = split_tail(tail)
    length = byte_size(data)

    h1 = h1 |> mix_tail(tail1, @c1_64_128, 31, @c2_64_128) |> bxor(length)
    h2 = h2 |> mix_tail(tail2, @c2_64_128, 33, @c1_64_128) |> bxor(length)

    {h1, h2} = hash_64_128_intermix(h1, h2)
    {h1, h2} = hash_64_128_intermix(finalize64(h1), finalize64(h2))

    h2 <<< 64 ||| h1
  end

  defp body(
         h1,
         h2,
         <<k1::size(16)-little-unit(4), k2::size(16)-little-unit(4), t::binary>>
       ) do
    k1 = mix_k64(k1, @c1_64_128, 31, @c2_64_128)
    h1 = h_64_op(h1, k1, 27, h2, 5, @n1_64_128)

    k2 = mix_k64(k2, @c2_64_128, 33, @c1_64_128)
    h2 = h_64_op(h2, k2, 31, h1, 5, @n2_64_128)

    body(h1, h2, t)
  end

  defp body(h1, h2, tail), do: {h1, h2, tail}

  defp split_tail(<<tail1::size(8)-binary, tail2::binary>>), do: {tail1, tail2}
  defp split_tail(tail1), do: {tail1, ""}

  defp hash_64_128_intermix(h1, h2) do
    h1 = mask_64(h1 + h2)
    h2 = mask_64(h2 + h1)

    {h1, h2}
  end

  defp mix_tail(h, "", _c1, _rotation, _c2), do: h

  defp mix_tail(h, tail, c1, rotation, c2) do
    bxor(h, mix_k64(:binary.decode_unsigned(tail, :little), c1, rotation, c2))
  end

  defp mix_k64(k, c1, rotation, c2) do
    k = mask_64(k * c1)
    mask_64(rotate64(k, rotation) * c2)
  end

  defp rotate64(x, rotation), do: mask_64(x <<< rotation ||| x >>> (64 - rotation))

  defp finalize64(h) do
    h = bxor(h, h >>> 33) |> Kernel.*(0xFF51AFD7ED558CCD) |> mask_64()
    h = bxor(h, h >>> 33) |> Kernel.*(0xC4CEB9FE1A85EC53) |> mask_64()
    bxor(h, h >>> 33)
  end

  @spec h_64_op(
          non_neg_integer,
          non_neg_integer,
          non_neg_integer,
          non_neg_integer,
          non_neg_integer,
          non_neg_integer
        ) :: non_neg_integer
  defp h_64_op(h1, k, rotl, h2, const, n) do
    h1
    |> bxor(k)
    |> rotate64(rotl)
    |> Kernel.+(h2)
    |> Kernel.*(const)
    |> Kernel.+(n)
    |> mask_64()
  end
end
