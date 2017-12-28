defmodule Pew.Manager do
  @moduledoc false

  use GenServer

  #
  # GenServer state
  #
  keys = [:repo, :name]
  @enforce_keys keys
  defstruct keys

  #
  # GenServer API
  #

  def get_repo(name) do
    process_name(name)
    |> GenServer.call(:get_repo)
  end

  #
  # GenServer callbacks
  #

  def start_link(%__MODULE__{} = state) do
    GenServer.start_link(__MODULE__, state, name: process_name(state.name))
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_repo, _from, state) do
    {:reply, state.repo, state}
  end

  def process_name(name) do
    String.to_atom("#{name}.Manager")
  end
end
