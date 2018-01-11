defmodule Pew.SQL do
  @moduledoc false
  alias Pew.Poller

  def new_database_connection!(postgrex_opts) do
    opts = Keyword.put(postgrex_opts, :types, Pew.PostgrexTypes)
    {:ok, conn} = Postgrex.start_link(opts)
    conn
  end

  def setup_database!(conn) do
    sql = """
    CREATE TABLE IF NOT EXISTS pew_jobs
    (
      priority    smallint    NOT NULL DEFAULT 100,
      queue       text        NOT NULL DEFAULT '',
      run_at      timestamptz NOT NULL DEFAULT now(),
      job_id      bigserial   NOT NULL,
      job_type    text        NOT NULL,
      args        jsonb       NOT NULL DEFAULT '{}'::jsonb,
      error_count integer     NOT NULL DEFAULT 0,
      last_error  text,
      CONSTRAINT pew_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id)
    );
    """

    Postgrex.query!(conn, sql, [])
    :ok
  end

  def insert_job(conn_or_name, job_type, job_args \\ %{}, data \\ [])

  def insert_job(conn, job_type, job_args, options) when is_atom(job_type) do
    sql = """
    INSERT INTO pew_jobs
    (queue, priority, run_at, job_type, args)
    VALUES
    (
      coalesce($1, '')::text,
      coalesce($2, 100)::smallint,
      coalesce($3, now())::timestamptz,
      $4::text,
      coalesce($5, '[]')::jsonb
    )
    RETURNING *
    """

    values = [
      Access.get(options, :queue),
      Access.get(options, :priority),
      Access.get(options, :run_at),
      to_string(job_type),
      Jason.encode!(job_args)
    ]

    run_query(conn, sql, values)
  end

  def delete_job(conn, queue, priority, run_at, job_id) do
    sql = """
    DELETE FROM pew_jobs
    WHERE queue    = $1::text
    AND   priority = $2::smallint
    AND   run_at   = $3::timestamptz
    AND   job_id   = $4::bigint
    """

    values = [queue, priority, run_at, job_id]
    run_query(conn, sql, values)
  end

  # TODO: Ecto version
  defp run_query(name, sql, values) when is_atom(name) do
    name
    |> Poller.name()
    |> Poller.get_conn()
    |> run_query(sql, values)
  end

  defp run_query(conn, sql, values) when is_pid(conn) do
    with {:ok, _} <- Postgrex.query(conn, sql, values) do
      :ok
    end
  end
end
