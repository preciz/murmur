defmodule Murmur.Mixfile do
  use Mix.Project

  @description """
  Murmur is a pure Elixir implementation of the non-cryptographic hash Murmur3.

  It aims to implement the x86_32bit, x86_128bit and x64_128bit variants.
  """
  @github "https://github.com/preciz/murmur"

  def project() do
    [
      app: :murmur,
      name: "Murmur",
      source_url: @github,
      homepage_url: @github,
      version: "2.0.0",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: @description,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application() do
    []
  end

  defp docs() do
    [
      main: "readme",
      logo: nil,
      extras: ["README.md"]
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Barna Kovacs", "Gonçalo Cabrita"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github}
    ]
  end

  defp deps() do
    [
      {:ex_doc, "~> 0.34", only: [:dev, :docs], runtime: false}
    ]
  end
end
