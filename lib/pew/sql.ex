defmodule Pew.SQL do
  @moduledoc false

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
  def insert_job(conn, data) when is_pid(conn) do
    sql =
      """
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

    job_type =
      (Access.get(data, :job_type) || raise(ArgumentError, ":job_type must be specifed"))
      |> to_string()

    args = Access.get(data, :args, %{}) |> Jason.encode!()

    values = [
      Access.get(data, :queue),
      Access.get(data, :priority),
      Access.get(data, :run_at),
      job_type,
      args
    ]

    with {:ok, _} <- Postgrex.query(conn, sql, values) do
      :ok
    end
  end
end
