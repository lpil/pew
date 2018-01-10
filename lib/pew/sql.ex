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
    CREATE TABLE IF NOT EXISTS pew_jobs (
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

  # TODO: Ecto version
  def insert_job(conn_or_name, job_type, job_args \\ %{}, data \\ [])

  def insert_job(name, job_type, job_args, data) when is_atom(name) do
    name
    |> Poller.name()
    |> Poller.get_conn()
    |> insert_job(job_type, job_args, data)
  end

  def insert_job(conn, job_type, job_args, data) when is_pid(conn) do
    query = insert_job_query(job_type, job_args, data)
    run_query(conn, query)
  end

  defp insert_job_query(job_type, args, options) when is_atom(job_type) do
    sql = """
    INSERT INTO pew_jobs
    (queue, priority, run_at, job_type, args)
    VALUES (
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
      Jason.encode!(args)
    ]
    {sql, values}
  end

  defp run_query(conn, {sql, values}) do
    with {:ok, _} <- Postgrex.query(conn, sql, values) do
      :ok
    end
  end
end
