defmodule Pew.PollerTest do
  use ExUnit.Case, async: false
  doctest Pew.Poller, import: true
  alias Pew.Poller
  import Support.Helpers

  setup_all [:start_poller]

  describe "get_conn/1" do
    setup [:new_connection, :truncate_jobs]

    test "returns the conn held by the Poller" do
      assert conn = Poller.name(__MODULE__) |> Poller.get_conn()
      assert is_pid(conn)
      assert list_jobs(conn) == []
    end
  end

  defp start_poller(_) do
    opts = [name: __MODULE__, postgrex_options: postgrex_options()]
    poller = Poller.start_link(opts)
    {:ok, poller: poller}
  end
end
