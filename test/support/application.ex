defmodule Support.Application do
  @moduledoc """
  Test application, used in development of this lib.

  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    pew_options = [
      repo: Support.Repo
    ]

    children = [
      # Starts a worker by calling: Thingy.Worker.start_link(arg)
      supervisor(Pew, [pew_options])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
