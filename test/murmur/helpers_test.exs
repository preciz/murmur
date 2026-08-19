defmodule Murmur.HelpersTest do
  use ExUnit.Case
  import Murmur.Helpers

  test "fmix32/1" do
    [
      {0, 0},
      {1, 1_364_076_727},
      {2, 821_347_078},
      {10, 3_911_517_328},
      {1000, 1_718_167_128}
    ]
    |> Enum.each(fn {input, expected} ->
      assert fmix32(input) == expected
    end)
  end

  test "fmix64/1" do
    [
      {0, 0},
      {1, 12_994_781_566_227_106_604},
      {2, 4_233_148_493_373_801_447},
      {10, 7_233_188_113_542_599_437},
      {1000, 12_610_127_409_379_334_721}
    ]
    |> Enum.each(fn {input, expected} ->
      assert fmix64(input) == expected
    end)
  end

  test "swap_uint/1 decodes little-endian tails from zero through eight bytes" do
    bytes = <<1, 2, 3, 4, 5, 6, 7, 8>>

    expected = [
      0x0,
      0x01,
      0x0201,
      0x030201,
      0x04030201,
      0x0504030201,
      0x060504030201,
      0x07060504030201,
      0x0807060504030201
    ]

    for {value, size} <- Enum.with_index(expected) do
      assert bytes |> binary_part(0, size) |> swap_uint() == value
    end
  end
end
