defmodule ConnArtist.MixProject do
  use Mix.Project

  def project do
      app: :archivist,
      name: "Archivist",
      version: "0.0.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/functionhaus/archivist",
      homepage_url: "https://functionhaus.com",

      docs: [
        main: "Archivist", # The main page in the docs
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

  defp deps do
    [
     {:earmark, "~> 1.3"},
     {:ex_doc, "~> 0.19", only: :dev, runtime: false},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  defp description do
    "Opinionated blog utility for writing in-repo articles with markdown."
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["FunctionHaus LLC, Mike Zazaian"],
     licenses: ["Apache 2"],

     links: %{"GitHub" => "https://github.com/functionhaus/archivist",
              "Docs" => "https://hexdocs.pm/archivist/"}
     ]
  end
end
