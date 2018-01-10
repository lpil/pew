defmodule Pew.SQLTest do
  use ExUnit.Case, async: false
  alias Pew.SQL
  doctest SQL
  import Support.DatabaseHelpers

  setup_all [:new_connection]

  describe "insert_job/2" do
    setup [:truncate_jobs]

    test "minimal data", ctx do
      values = %{
        job_type: MyJob
      }

      assert :ok = SQL.insert_job(ctx.conn, values)

      assert [job] = list_jobs(ctx.conn)
      assert job.args == %{}
      assert job.error_count == 0
      assert job.job_type == "Elixir.MyJob"
      assert job.last_error == nil
      assert job.priority == 100
      assert job.queue == ""
      assert :gt == DateTime.compare(DateTime.utc_now(), job.run_at)
    end

    test "all values", ctx do
      values = %{
        job_type: MyJobYeah,
        args: %{},
        priority: 99,
        queue: "another",
        run_at: DateTime.utc_now() |> Map.put(:year, 1900)
      }

      assert :ok = SQL.insert_job(ctx.conn, values)

      assert [job] = list_jobs(ctx.conn)
      assert job.args == %{}
      assert job.error_count == 0
      assert job.job_type == "Elixir.MyJobYeah"
      assert job.last_error == nil
      assert job.priority == 99
      assert job.queue == "another"
      assert DateTime.compare(values.run_at, job.run_at) == :eq
    end

    test "insufficient values", ctx do
      assert_raise ArgumentError, ":job_type must be specifed", fn ->
        SQL.insert_job(ctx.conn, [])
      end
      assert [] = list_jobs(ctx.conn)
    end
  end
end
