defmodule PewTest do
  use ExUnit.Case, async: false
  doctest Pew
  import Support.DatabaseHelpers

  setup_all [:new_connection]

  describe "tree initialisation" do
    setup [:drop_jobs_table]

    test "set up of initial state", ctx do
      name = PewTestNewTree

      opts = [
        name: name,
        postgrex_options: Support.DatabaseHelpers.postgrex_options()
      ]

      refute table_exists?(ctx.conn, "pew_jobs")

      # Start tree
      assert {:ok, _pid} = Pew.start_link(opts)

      # Ensure tree is up
      assert Pew.Supervisor.name(name) |> Process.whereis()
      assert Pew.Poller.name(name) |> Process.whereis()

      # Ensure database is configured
      assert table_exists?(ctx.conn, "pew_jobs")
    end
  end
end
