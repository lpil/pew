defmodule Pew.Mixfile do
  use Mix.Project

  @version "0.0.0"

  def project do
    [
      app: :pew,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      name: "Pew",
      description: "A durable Postgresql backed job queue",
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/lpil/pew"},
        files: ~w(LICENCE README.md lib mix.exs)
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp aliases do
    [
      # test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:postgrex, "~> 0.13"},
      {:jason, "~> 1.0-rc"},
      {:mix_test_watch, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.18.0", only: :dev}
    ]
  end
end
