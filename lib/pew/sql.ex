defmodule Pew.SQL do
  @moduledoc false
  use Yesql, driver: Postgrex
  alias Pew.Poller

  sql = &Path.join(:code.priv_dir(:pew), &1)

  Yesql.defquery(sql.("setup_database.sql"))
  Yesql.defquery(sql.("do_insert_job.sql"))
  Yesql.defquery(sql.("do_delete_job.sql"))

  def new_database_connection!(postgrex_opts) do
    opts = Keyword.put(postgrex_opts, :types, Pew.PostgrexTypes)
    {:ok, conn} = Postgrex.start_link(opts)
    conn
  end

  def insert_job(conn_or_name, job_type, job_args \\ %{}, data \\ [])

  def insert_job(conn, job_type, job_args, options) when is_atom(job_type) do
    args = [
      queue: Access.get(options, :queue, ""),
      priority: Access.get(options, :priority, 100),
      run_at: Access.get(options, :run_at, DateTime.utc_now()),
      job_type: to_string(job_type),
      args: Jason.encode!(job_args)
    ]

    conn
    |> resolve_conn()
    |> do_insert_job(args)
    |> flatten_ok()
  end

  def delete_job(conn, args) do
    conn
    |> resolve_conn()
    |> do_delete_job(args)
  end

  # TODO: Ecto version
  defp resolve_conn(conn) when is_atom(conn), do: conn |> Poller.name() |> Poller.get_conn()
  defp resolve_conn(conn) when is_pid(conn), do: conn

  defp flatten_ok({:ok, _}), do: :ok
  defp flatten_ok(error), do: error
end
