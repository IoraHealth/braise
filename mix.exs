defmodule Braise.Mixfile do
  Code.require_file "lib/braise.ex", __DIR__

  use Mix.Project

  def project do
    [app: :braise,
     version: Braise.version,
     elixir: "~> 1.3",
     escript: escript_config(),
     description: "A library that converts JSON Schema into ember models/adapters.",
     deps: deps(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :poison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:poison, "~> 1.3.1"},
     {:earmark, "~> 0.2", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev},
     {:inflex, "~> 1.7.0"}]
  end

  defp escript_config do
    [ main_module: Braise.CLI ]
  end

  defp package do
    [maintainers: ["Patrick Robertson", "Alex Rothenberg", "Max Fierke"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/IoraHealth/braise"}]
  end
end
