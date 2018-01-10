defmodule PewTest do
  use ExUnit.Case, async: false
  doctest Pew
  import Support.Helpers

  setup_all [:new_connection, :drop_jobs_table]

  describe "tree initialisation" do
    setup [:drop_jobs_table]

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

  describe "insert_job" do
    setup [:new_pew_tree, :truncate_jobs]

    test "insert_job/2 delegation", ctx do
      assert :ok = Pew.insert_job(__MODULE__, MyJob)
      assert [%{job_type: "Elixir.MyJob"}] = list_jobs(ctx.conn)
    end

    test "insert_job/3 delegation", ctx do
      assert :ok = Pew.insert_job(__MODULE__, MyJob, %{foo: 1})
      assert [job] = list_jobs(ctx.conn)
      assert %{job_type: "Elixir.MyJob", args: %{"foo" => 1}} = job
    end

    test "insert_job/4 delegation", ctx do
      assert :ok = Pew.insert_job(__MODULE__, MyJob, %{foo: 3}, queue: "boop")
      assert [job] = list_jobs(ctx.conn)
      assert %{job_type: "Elixir.MyJob", args: %{"foo" => 3}, queue: "boop"} = job
    end
  end
end
