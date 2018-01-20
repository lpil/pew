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
        files: ~w(LICENCE README.md priv lib mix.exs)
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
      # SQL query helper
      {:yesql, "~> 0.2"},
      # Database driver
      {:postgrex, "~> 0.13"},
      # JSON encoder
      {:jason, "~> 1.0-rc"},
      # Automatic test tool
      {:mix_test_watch, ">= 0.0.0", only: :dev},
      # Documentation generator
      {:ex_doc, "~> 0.18.0", only: :dev}
    ]
  end
end
