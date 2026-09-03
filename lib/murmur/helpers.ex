defmodule Murmur.Helpers do
  import Bitwise

  # since erlang/elixir integers are variable-length we have to guarantee them
  # to be 32 or 64 bit long
  defmacro mask_32(x), do: quote(do: unquote(x) &&& 0xFFFFFFFF)
  defmacro mask_64(x), do: quote(do: unquote(x) &&& 0xFFFFFFFFFFFFFFFF)
end
