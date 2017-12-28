defmodule Pew.Mixfile do
  use Mix.Project

  @version "0.0.0"

  def project do
    [
      app: :pew,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(),
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
    case Mix.env() do
      :prod ->
        [extra_applications: [:logger]]

      _ ->
        [extra_applications: [:logger], mod: {Support.Application, []}]
    end
  end

  defp elixirc_paths do
    case Mix.env() do
      :prod ->
        ["lib"]

      _ ->
        ["lib", "test/support"]
    end
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13"},
      {:mix_test_watch, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.18.0", only: :dev}
    ]
  end
end
