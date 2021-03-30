defmodule SpiewnikHk.MixProject do
  use Mix.Project

  def project do
    [
      app: :spiewnik_hk,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:peppermint, "~> 0.3"},
      {:castore, "~> 0.1.0"},
      {:floki, "~> 0.29"},
      {:html_entities, "~> 0.4"},
      {:jason, "~> 1.2.2"}
      # {:chordpro, github: "adamzaninovich/elixir-chordpro-parser"}
    ]
  end
end
