defmodule Arcdown.MixProject do
  use Mix.Project

  def project do
    [
      app: :arcdown,
      name: "Arcdown",
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/functionhaus/arcdown",
      homepage_url: "https://functionhaus.com",

      docs: [
        main: "Arcdown", # The main page in the docs
        logo: "assets/functionhaus_logo.png",
        extras: ["README.md"]
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
      {:ex_doc, "~> 0.19", only: :docs}
    ]
  end

  defp description do
    "A parsing library for articles written in Arcdown (.ad) format."
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
