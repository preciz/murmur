defmodule Murmur.HelpersTest do
  use ExUnit.Case
  import Murmur.Helpers

  test "mask_32/1" do
    assert mask_32(0) == 0
    assert mask_32(0xFFFFFFFF) == 0xFFFFFFFF
    assert mask_32(0x1_00000000) == 0
    assert mask_32(0x1_FFFFFFFF) == 0xFFFFFFFF
  end

  test "mask_64/1" do
    assert mask_64(0) == 0
    assert mask_64(0xFFFFFFFFFFFFFFFF) == 0xFFFFFFFFFFFFFFFF
    assert mask_64(0x1_0000000000000000) == 0
    assert mask_64(0x1_FFFFFFFFFFFFFFFF) == 0xFFFFFFFFFFFFFFFF
  end
end
