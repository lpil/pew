# TODO: Poll
defmodule Pew.Poller do
  @moduledoc false
  use GenServer

  fields = [:conn]
  @enforce_keys fields
  defstruct fields

  def start_link(opts) do
    name =
      opts
      |> Keyword.fetch!(:name)
      |> name()

    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl true
  def init(opts) do
    postgrex_opts = Keyword.get(opts, :postgrex_options)
    conn = Pew.SQL.new_database_connection!(postgrex_opts)
    :ok = Pew.SQL.setup_database!(conn)
    state = %__MODULE__{conn: conn}
    {:ok, state}
  end

  @doc """
  # Examples

      iex> name(PewOne)
      PewOne.Pew.Poller

      iex> name(:foo)
      :"Elixir.foo.Pew.Poller"
  """
  def name(name) do
    Module.concat(name, __MODULE__)
  end
end
