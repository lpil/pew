defmodule Pew.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pew,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(),
      aliases: aliases(),
      deps: deps()
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
      {:mix_test_watch, ">= 0.0.0", only: :dev}
    ]
  end
end
