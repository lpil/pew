defmodule Pew.Poller do
  @moduledoc false
  use GenServer

  fields = [:conn]
  @enforce_keys fields
  defstruct fields

  # API

  def start_link(opts) do
    name =
      opts
      |> Keyword.fetch!(:name)
      |> name()

    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc false
  def get_conn(poller) do
    GenServer.call(poller, :get_conn)
  end

  # Callbacks

  @impl GenServer
  def init(opts) do
    postgrex_opts = Keyword.get(opts, :postgrex_options)
    conn = Pew.SQL.new_database_connection!(postgrex_opts)
    {:ok, _} = Pew.SQL.setup_database(conn, [])
    state = %__MODULE__{conn: conn}
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:get_conn, _from, state) do
    {:reply, state.conn, state}
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
