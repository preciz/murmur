defmodule Murmur.Hash128X64 do
  import Bitwise
  import Murmur.Helpers

  @c1_64_128 0x87C37B91114253D5
  @c2_64_128 0x4CF5AD432745937F
  @n1_64_128 0x52DCE729
  @n2_64_128 0x38495AB5

  def hash_x64_128(data, seed) when is_binary(data) do
    hashes =
      [seed, seed]
      |> body(data)
      |> Stream.zip([
        {31, @c1_64_128, @c2_64_128},
        {33, @c2_64_128, @c1_64_128}
      ])
      |> Stream.map(fn {x, {r, a, b}} ->
        case x do
          {h, []} ->
            bxor(h, byte_size(data))

          {h, t} ->
            h
            |> bxor(
              t
              |> swap_uint()
              |> Kernel.*(a)
              |> mask_64
              |> rotl64(r)
              |> Kernel.*(b)
              |> mask_64
              |> bxor(byte_size(data))
            )
        end
      end)
      |> Enum.to_list()

    [h1, h2] =
      hashes
      |> hash_64_128_intermix
      |> Enum.map(&fmix64/1)
      |> hash_64_128_intermix

    h2 <<< 64 ||| h1
  end

  @spec body([non_neg_integer], binary) :: [{non_neg_integer, [binary]}]
  defp body(
         [h1, h2],
         <<k1::size(16)-little-unit(4), k2::size(16)-little-unit(4), t::binary>>
       ) do
    k1 = k_64_op(k1, @c1_64_128, 31, @c2_64_128)
    h1 = h_64_op(h1, k1, 27, h2, 5, @n1_64_128)

    k2 = k_64_op(k2, @c2_64_128, 33, @c1_64_128)
    h2 = h_64_op(h2, k2, 31, h1, 5, @n2_64_128)

    body([h1, h2], t)
  end

  defp body([h1, h2], <<t1::size(8)-binary, t::binary>>) do
    [{h1, t1}, {h2, t}]
  end

  defp body([h1, h2], t) when is_binary(t) do
    [{h1, t}, {h2, []}]
  end

  defp body([h1, h2], _) do
    [{h1, []}, {h2, []}]
  end

  @spec hash_64_128_intermix([non_neg_integer]) :: [non_neg_integer]
  defp hash_64_128_intermix([h1, h2]) do
    h1 = mask_64(h1 + h2)
    h2 = mask_64(h2 + h1)

    [h1, h2]
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
    |> rotl64(rotl)
    |> Kernel.+(h2)
    |> Kernel.*(const)
    |> Kernel.+(n)
    |> mask_64
  end
end
