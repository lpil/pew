defmodule Pew.Supervisor do
  @moduledoc false
  use Supervisor
  require Logger

  def start_link(opts) do
    name =
      opts
      |> Keyword.fetch!(:name)
      |> name()

    Supervisor.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    [
      {Pew.Poller, opts}
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end

  @doc """
  # Examples

      iex> name(PewOne)
      PewOne.Pew.Supervisor

      iex> name(:foo)
      :"Elixir.foo.Pew.Supervisor"
  """
  def name(name) do
    Module.concat(name, __MODULE__)
  end
end
