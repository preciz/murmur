Mix.install([
  {:murmur, "~> 2.0"},
  {:benchee, "~> 1.0"}
])

string = "I'm the test string of the benchmark 50 bytes long"

Benchee.run(%{
  "hash_x86_32" => fn -> Murmur.hash_x86_32(string) end,
  "hash_x86_128" => fn -> Murmur.hash_x86_128(string) end,
  "hash_x64_128" => fn -> Murmur.hash_x64_128(string) end
})
