defmodule Murmur.Hash32X86 do
  import Bitwise
  import Murmur.Helpers

  @c1_32 0xCC9E2D51
  @c2_32 0x1B873593
  @n_32 0xE6546B64

  def hash_x86_32(data, seed) when is_binary(data) do
    hash =
      case body(seed, data) do
        {h, []} ->
          h

        {h, t} ->
          h
          |> bxor(
            t
            |> swap_uint()
            |> Kernel.*(@c1_32)
            |> mask_32
            |> rotl32(15)
            |> Kernel.*(@c2_32)
            |> mask_32
          )
      end

    hash
    |> bxor(byte_size(data))
    |> fmix32()
  end

  @spec body(non_neg_integer, binary) :: {non_neg_integer, [binary] | binary}
  defp body(h0, <<k::size(8)-little-unit(4), t::binary>>) do
    k1 = k_32_op(k, @c1_32, 15, @c2_32)

    h0
    |> bxor(k1)
    |> rotl32(13)
    |> Kernel.*(5)
    |> Kernel.+(@n_32)
    |> mask_32
    |> body(t)
  end

  defp body(h, t) when byte_size(t) > 0, do: {h, t}
  defp body(h, _), do: {h, []}
end
