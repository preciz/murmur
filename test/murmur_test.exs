defmodule MurmurTest do
  use ExUnit.Case
  doctest Murmur
  import Murmur

  @boundary_vectors [
    {:hash_x86_32,
     [
       {0, 0x00000000},
       {1, 0x514E28B7},
       {3, 0x51D4D0D7},
       {4, 0xF4C0EC39},
       {5, 0xCCA4DCCB},
       {7, 0x8D7E4914},
       {8, 0xD161D673},
       {9, 0xE7E27A50},
       {15, 0x5BD6952D},
       {16, 0x191573DD},
       {17, 0xCBE58DC6},
       {31, 0x64426AD6},
       {32, 0xCAC37638},
       {33, 0x5460867A}
     ]},
    {:hash_x86_128,
     [
       {0, 0x00000000000000000000000000000000},
       {1, 0x54D201B954D201B954D201B988C4ADEC},
       {3, 0x33C18CEF33C18CEF33C18CEF37095E0D},
       {4, 0x4E343CE24E343CE24E343CE2C72C99E7},
       {5, 0x9275E7659275E7654E7CCBD190F84E5E},
       {7, 0xC75D01C8C75D01C8BEA74C33CCFA23D7},
       {8, 0x867244AC867244ACB18CD5BC91F4928A},
       {9, 0x3737CAF6D165DEFE5C93CEE468213FD9},
       {15, 0xCA77556661E2DB4E62A6E4CA757B9C59},
       {16, 0x89A55BEFEA538074559180EE6C25C825},
       {17, 0xA275AB51AE1673AD359C940B6AC99CDB},
       {31, 0x9AD5DDA345F5BC18AC1D89CA24AB92EE},
       {32, 0x97DF89CEB7BD7575A4795780D6B16AFD},
       {33, 0x220DC78120E7B67076F9913650DE15BA}
     ]},
    {:hash_x64_128,
     [
       {0, 0x00000000000000000000000000000000},
       {1, 0x51622DAA78F835834610ABE56EFF5CB5},
       {3, 0xFB6255C252B396B6B872A12FEF53E6BE},
       {4, 0xD3D605BD13C2FDE2E1C594AE0DDFAF10},
       {5, 0xF8D0155E630C23F641EE8CD4A6F94036},
       {7, 0x613ADDD4BD25C787BD4C6987CA4B0D68},
       {8, 0x60E6EE02EC31DCC747A7E1BDD68E2FC8},
       {9, 0x78DE751D0200FFB9FBB4CB0F6E812D32},
       {15, 0xCD846DEE88C67DE947231598FD4925E9},
       {16, 0xAB906456762FE845444924B591903F30},
       {17, 0xC15F026B9EDAA8245C76F40F9FE7C20E},
       {31, 0x9EE59AEFB4005490053DD3E1A32CD094},
       {32, 0x1C050A6E34C31151C66D9022B62F500F},
       {33, 0x55AC8073A7D6A30B7D41281BFABA4612}
     ]}
  ]

  test "x86_32" do
    assert hash_x86_32("") == 0
    assert hash_x86_32("random_stuff") == hash_x86_32("random_stuff", 0)
    assert hash_x86_32(:test)

    [
      {"", 0, 0},
      {"", 1, 1_364_076_727},
      {"0", 0, 3_530_670_207},
      {"01", 0, 1_642_882_560},
      {"012", 0, 3_966_566_284},
      {"0123", 0, 3_558_446_240},
      {"01234", 0, 433_070_448},
      {"b2622f5e1310a0aa14b7f957fe4246fa", 2_147_368_987, 3_297_211_900}
    ]
    |> Enum.each(fn {data, seed, expected} ->
      assert hash_x86_32(data, seed) == expected
    end)
  end

  test "x86_128" do
    assert hash_x86_128("") == 0
    assert hash_x86_128("random_stuff") == hash_x86_128("random_stuff", 0)
    assert hash_x86_128(:test)

    [
      {"asdfqwer", 0, 175_504_436_512_095_274_433_824_208_945_657_775_294},
      {"", 0, 0},
      {"", 1, 112_745_568_952_095_539_304_722_219_991_719_783_916},
      {"0", 0, 220_543_883_451_499_871_284_187_321_612_475_973_790},
      {"01", 0, 137_321_874_326_339_305_098_181_565_140_844_391_604},
      {"012", 0, 101_124_353_311_974_478_471_016_843_751_483_309_733},
      {"0123", 0, 96_188_378_572_783_053_222_457_303_740_741_816_298},
      {"01234", 0, 903_794_947_179_251_542_154_595_124_069_643_246},
      {"012345", 0, 329_842_349_853_404_661_313_702_735_247_573_441_653},
      {"b2622f5e1310a0aa14b7f957fe4246fa", 2_147_368_987,
       41_703_641_970_572_727_370_229_238_214_115_525_711}
    ]
    |> Enum.each(fn {data, seed, expected} ->
      assert hash_x86_128(data, seed) == expected
    end)
  end

  test "x64_128" do
    assert hash_x64_128("") == 0
    assert hash_x64_128("random_stuff") == hash_x64_128("random_stuff", 0)
    assert hash_x64_128(:test)

    [
      {"asdfqwer", 0, 259_562_416_584_950_860_532_122_463_349_073_498_983},
      {"", 0, 0},
      {"", 1, 108_177_238_965_372_658_051_732_455_265_379_769_525},
      {"0", 0, 77_832_081_575_998_147_576_267_703_913_017_680_768},
      {"01", 0, 306_492_543_119_272_612_795_719_006_631_500_017_806},
      {"012", 0, 281_942_414_714_165_914_479_726_705_557_978_075},
      {"0123", 0, 240_291_641_590_490_688_718_251_893_415_321_240_148},
      {"01234", 0, 314_759_026_063_816_137_774_093_326_316_203_884_481},
      {"012345", 0, 171_502_485_648_129_393_034_657_596_489_443_707_431},
      {"b2622f5e1310a0aa14b7f957fe4246fa", 2_147_368_987,
       326_275_246_143_462_972_595_823_637_050_028_897_938}
    ]
    |> Enum.each(fn {data, seed, expected} ->
      assert hash_x64_128(data, seed) == expected
    end)
  end

  test "block and tail boundaries" do
    for {function, vectors} <- @boundary_vectors, {size, expected} <- vectors do
      assert apply(Murmur, function, [sequential_bytes(size)]) == expected,
             "#{function}/1 failed for #{size} bytes"
    end
  end

  test "Erlang terms are hashed through their external binary representation" do
    term = %{tuple: {:ok, 42}, nested: [nil, true, <<0, 255>>]}
    binary = :erlang.term_to_binary(term)

    for function <- [:hash_x86_32, :hash_x86_128, :hash_x64_128], seed <- [0, 0xFFFFFFFF] do
      assert apply(Murmur, function, [term, seed]) == apply(Murmur, function, [binary, seed])
    end
  end

  defp sequential_bytes(0), do: <<>>

  defp sequential_bytes(size) do
    for byte <- 0..(size - 1), into: <<>>, do: <<byte>>
  end
end
