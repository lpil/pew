defmodule Support.Repo.Migrations.PewCreateJobsTable do
  use Ecto.Migration

  def up do
    sql = """
    CREATE TABLE pew_jobs
    (
      priority    smallint    NOT NULL DEFAULT 100,
      queue       text        NOT NULL DEFAULT '',
      run_at      timestamptz NOT NULL DEFAULT now(),

      job_id      bigserial   NOT NULL,
      job_class   text        NOT NULL,
      args        json        NOT NULL DEFAULT '{}'::json,

      error_count integer     NOT NULL DEFAULT 0,
      last_error  text,

      CONSTRAINT pew_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id)
    );
    """

    execute(sql)
  end

  def down do
    sql = """
    DROP TABLE pew_jobs;
    """

    execute(sql)
  end
end
