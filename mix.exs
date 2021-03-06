defmodule Arcdown.MixProject do
  use Mix.Project

  @version "0.1.2"
  @description "A parsing library for articles written in Arcdown (.ad) format."

  def project do
    [
      app: :arcdown,
      name: "Arcdown",
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps(),
      description: @description,
      package: package(),
      source_url: "https://github.com/functionhaus/arcdown",
      homepage_url: "https://functionhaus.com",
      docs: [
        logo: "assets/functionhaus_logo.png",
        extras: ["README.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/functionhaus/arcdown"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["FunctionHaus LLC, Mike Zazaian"],
     licenses: ["Apache 2"],

     links: %{"GitHub" => "https://github.com/functionhaus/arcdown",
              "Docs" => "https://hexdocs.pm/arcdown/"}
     ]
  end
end
