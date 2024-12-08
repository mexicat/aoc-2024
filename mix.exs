defmodule AoC.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.15",
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
      {:benchee, "~> 1.3.1"},
      {:httpoison, "~> 2.2.1"},
      {:libgraph, "~> 0.16.0"},
      {:flow, "~> 1.2.4"},
      {:formulae, "~> 0.17.0"}
    ]
  end
end
