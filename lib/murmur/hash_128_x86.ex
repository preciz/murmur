defmodule Murmur.Hash128X86 do
  import Bitwise
  import Murmur.Helpers

  @c1_32_128 0x239B961B
  @c2_32_128 0xAB0E9789
  @c3_32_128 0x38B34AE5
  @c4_32_128 0xA1E38B93

  @n1_32_128 0x561CCD1B
  @n2_32_128 0x0BCAA747
  @n3_32_128 0x96CD1C35
  @n4_32_128 0x32AC3B17

  def hash_x86_128(data, seed) when is_binary(data) do
    {h1, h2, h3, h4, tail} = body(seed, seed, seed, seed, data)
    {tail1, tail2, tail3, tail4} = split_tail(tail)
    length = byte_size(data)

    h1 = h1 |> mix_tail(tail1, @c1_32_128, 15, @c2_32_128) |> bxor(length)
    h2 = h2 |> mix_tail(tail2, @c2_32_128, 16, @c3_32_128) |> bxor(length)
    h3 = h3 |> mix_tail(tail3, @c3_32_128, 17, @c4_32_128) |> bxor(length)
    h4 = h4 |> mix_tail(tail4, @c4_32_128, 18, @c1_32_128) |> bxor(length)

    {h1, h2, h3, h4} = hash_32_128_intermix(h1, h2, h3, h4)

    {h1, h2, h3, h4} =
      hash_32_128_intermix(fmix32(h1), fmix32(h2), fmix32(h3), fmix32(h4))

    h4 <<< 96 ||| h3 <<< 64 ||| h2 <<< 32 ||| h1
  end

  defp body(
         h1,
         h2,
         h3,
         h4,
         <<k1::size(8)-little-unit(4), k2::size(8)-little-unit(4), k3::size(8)-little-unit(4),
           k4::size(8)-little-unit(4), t::binary>>
       ) do
    k1 = k_32_op(k1, @c1_32_128, 15, @c2_32_128)
    h1 = h_32_op(h1, k1, 19, h2, 5, @n1_32_128)

    k2 = k_32_op(k2, @c2_32_128, 16, @c3_32_128)
    h2 = h_32_op(h2, k2, 17, h3, 5, @n2_32_128)

    k3 = k_32_op(k3, @c3_32_128, 17, @c4_32_128)
    h3 = h_32_op(h3, k3, 15, h4, 5, @n3_32_128)

    k4 = k_32_op(k4, @c4_32_128, 18, @c1_32_128)
    h4 = h_32_op(h4, k4, 13, h1, 5, @n4_32_128)

    body(h1, h2, h3, h4, t)
  end

  defp body(h1, h2, h3, h4, tail), do: {h1, h2, h3, h4, tail}

  defp split_tail(
         <<tail1::size(4)-binary, tail2::size(4)-binary, tail3::size(4)-binary, tail4::binary>>
       ),
       do: {tail1, tail2, tail3, tail4}

  defp split_tail(<<tail1::size(4)-binary, tail2::size(4)-binary, tail3::binary>>),
    do: {tail1, tail2, tail3, ""}

  defp split_tail(<<tail1::size(4)-binary, tail2::binary>>),
    do: {tail1, tail2, "", ""}

  defp split_tail(tail1), do: {tail1, "", "", ""}

  defp hash_32_128_intermix(h1, h2, h3, h4) do
    h1 =
      h1
      |> Kernel.+(h2)
      |> mask_32
      |> Kernel.+(h3)
      |> mask_32
      |> Kernel.+(h4)
      |> mask_32

    h2 = mask_32(h2 + h1)
    h3 = mask_32(h3 + h1)
    h4 = mask_32(h4 + h1)

    {h1, h2, h3, h4}
  end

  defp mix_tail(h, "", _c1, _rotation, _c2), do: h

  defp mix_tail(h, tail, c1, rotation, c2) do
    bxor(h, k_32_op(swap_uint(tail), c1, rotation, c2))
  end

  @spec h_32_op(
          non_neg_integer,
          non_neg_integer,
          non_neg_integer,
          non_neg_integer,
          non_neg_integer,
          non_neg_integer
        ) :: non_neg_integer
  defp h_32_op(h1, k, rotl, h2, const, n) do
    h1
    |> bxor(k)
    |> rotl32(rotl)
    |> Kernel.+(h2)
    |> Kernel.*(const)
    |> Kernel.+(n)
    |> mask_32
  end
end
