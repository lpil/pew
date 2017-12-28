defmodule Pew.ManagerTest do
  use ExUnit.Case, async: true
  alias Pew.Manager
  doctest Manager

  describe "get_repo/1" do
    setup [:new_state, :start_manager]

    test "returns the repo held in state", ctx do
      assert SomeManagerRepo = Manager.get_repo(ctx.state.name)
    end
  end

  defp new_state(_ctx) do
    state = %Manager{
      repo: SomeManagerRepo,
      name: __MODULE__
    }

    {:ok, state: state}
  end

  defp start_manager(ctx) do
    {:ok, _} = Manager.start_link(ctx.state)
    :ok
  end
end
