defmodule PewTest do
  use ExUnit.Case, async: false
  doctest Pew
  import Support.Helpers

  setup_all [:new_pew_tree, :new_connection]
  setup [:truncate_jobs]

  describe "insert_job" do
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
