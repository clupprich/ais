defmodule AIS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ais,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ais",
      source_url: "https://github.com/clupprich/ais",
      homepage_url: "https://github.com/clupprich/ais",
      docs: [
        main: "AIS",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_parameterized, "~> 1.3.7"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
