use Mix.Config

config :pew, ecto_repos: [Support.Repo]

config :pew, Support.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pew_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
