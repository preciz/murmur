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
end
