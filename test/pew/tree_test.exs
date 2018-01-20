defmodule Pew.TreeTest do
  use ExUnit.Case, async: false
  doctest Pew
  import Support.Helpers

  setup_all [:new_connection, :drop_jobs_table]

  test "set up of initial state", ctx do
    name = PewTestNewTree

    opts = [
      name: name,
      postgrex_options: postgrex_options()
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
