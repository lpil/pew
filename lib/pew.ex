defmodule Pew do
  @moduledoc """
  TODO: Documentation for Pew.

  """

  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(opts) do
    _repo = config_fetch!(opts, :repo)

    children = [
      # worker(Stack, [:hello])
    ]

    Supervisor.init(
      children,
      strategy: :one_for_one
    )
  end

  # TODO: Use a real exception
  defp config_fetch!(opts, key) do
    with nil <- opts[key] do
      raise "Pew option `#{key}` must be specified"
    end
  end
end
