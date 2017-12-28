defmodule Pew.Supervisor do
  @moduledoc false
  use Supervisor

  def init(opts) do
    name = opts[:name] || Pew
    repo = config_fetch!(opts, :repo)

    manager_state = %Pew.Manager{
      repo: repo,
      name: name
    }

    children = [
      {Pew.Manager, manager_state}
    ]

    Supervisor.init(
      children,
      strategy: :one_for_one
    )
  end

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: Pew.Supervisor)
  end

  # TODO: Use a real exception
  defp config_fetch!(opts, key) do
    with nil <- opts[key] do
      raise "Pew option `#{key}` must be specified"
    end
  end
end
