defmodule Pew.SQLTest do
  use ExUnit.Case, async: false
  alias Pew.SQL
  doctest SQL
  import Support.Helpers

  setup_all [:new_connection, :new_pew_tree]
  setup [:truncate_jobs]

  describe "insert_job/4" do
    test "minimal values", ctx do
      assert :ok = SQL.insert_job(ctx.conn, MyJob)

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
      options = [
        priority: 99,
        queue: "another",
        run_at: DateTime.utc_now() |> Map.put(:year, 1900)
      ]

      assert :ok = SQL.insert_job(ctx.conn, MyJobYeah, %{foo: 2}, options)

      assert [job] = list_jobs(ctx.conn)
      assert job.args == %{"foo" => 2}
      assert job.error_count == 0
      assert job.job_type == "Elixir.MyJobYeah"
      assert job.last_error == nil
      assert job.priority == 99
      assert job.queue == "another"
      assert DateTime.compare(options[:run_at], job.run_at) == :eq
    end

    test "incorrect values", ctx do
      ["no", 1, [], %{}]
      |> Enum.each(fn item ->
        assert_raise FunctionClauseError, fn ->
          SQL.insert_job(ctx.conn, item, [])
        end
      end)

      assert [] = list_jobs(ctx.conn)
    end

    test "using Pew tree name rather than postgrex connection pid", ctx do
      assert :ok = SQL.insert_job(__MODULE__, MyJob)

      assert [job] = list_jobs(ctx.conn)
      assert job.args == %{}
      assert job.error_count == 0
      assert job.job_type == "Elixir.MyJob"
      assert job.last_error == nil
      assert job.priority == 100
      assert job.queue == ""
      assert :gt == DateTime.compare(DateTime.utc_now(), job.run_at)
    end
  end

  describe "delete_job/5" do
    test "job is deleted", ctx do
      queue = "some-queu"
      priority = 58
      run_at = DateTime.utc_now()
      job_type = MyJob
      args = %{value: "ok"}
      opts = %{queue: queue, priority: priority, run_at: run_at}
      assert :ok = SQL.insert_job(ctx.conn, job_type, args, opts)
      assert [%{job_id: job_id}] = list_jobs(ctx.conn)
      assert :ok = SQL.insert_job(ctx.conn, AnotherJob, args, opts)
      assert [_, _] = list_jobs(ctx.conn)

      assert SQL.delete_job(
               ctx.conn,
               queue: queue,
               priority: priority,
               run_at: run_at,
               job_id: job_id
             ) == {:ok, [%{job_id: job_id}]}

      assert [%{job_type: "Elixir.AnotherJob"}] = list_jobs(ctx.conn)

      assert SQL.delete_job(
               ctx.conn,
               queue: queue,
               priority: priority,
               run_at: run_at,
               job_id: job_id
             ) == {:ok, []}

      assert [%{job_type: "Elixir.AnotherJob", job_id: job_id_2}] = list_jobs(ctx.conn)

      assert SQL.delete_job(
               ctx.conn,
               queue: queue,
               priority: priority,
               run_at: run_at,
               job_id: job_id_2
             ) == {:ok, [%{job_id: job_id_2}]}

      assert [] = list_jobs(ctx.conn)
    end

    test "using Pew tree name rather than postgrex connection pid", ctx do
      queue = "some-queu"
      priority = 58
      run_at = DateTime.utc_now()
      job_type = MyJob
      args = %{value: "ok"}
      opts = %{queue: queue, priority: priority, run_at: run_at}
      assert :ok = SQL.insert_job(__MODULE__, job_type, args, opts)
      assert [%{job_id: job_id}] = list_jobs(ctx.conn)
      assert :ok = SQL.insert_job(__MODULE__, AnotherJob, args, opts)
      assert [_, _] = list_jobs(ctx.conn)

      assert SQL.delete_job(
               __MODULE__,
               queue: queue,
               priority: priority,
               run_at: run_at,
               job_id: job_id
             ) == {:ok, [%{job_id: job_id}]}

      assert [%{job_type: "Elixir.AnotherJob"}] = list_jobs(ctx.conn)

      assert SQL.delete_job(
               __MODULE__,
               queue: queue,
               priority: priority,
               run_at: run_at,
               job_id: job_id
             ) == {:ok, []}

      assert [%{job_type: "Elixir.AnotherJob", job_id: job_id_2}] = list_jobs(ctx.conn)

      assert SQL.delete_job(
               __MODULE__,
               queue: queue,
               priority: priority,
               run_at: run_at,
               job_id: job_id_2
             ) == {:ok, [%{job_id: job_id_2}]}

      assert [] = list_jobs(ctx.conn)
    end
  end
end
