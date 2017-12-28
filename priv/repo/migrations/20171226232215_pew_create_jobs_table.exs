defmodule Support.Repo.Migrations.PewCreateJobsTable do
  use Ecto.Migration

  _sql = """
  CREATE TABLE pew_jobs
  (
    -- priority    smallint    NOT NULL DEFAULT 100,
    -- queue       text        NOT NULL DEFAULT '',
    -- run_at      timestamptz NOT NULL DEFAULT now(),

    job_id      bigserial   NOT NULL,
    job_mod     text        NOT NULL,
    args        jsonb       NOT NULL DEFAULT '{}'::jsonb,

    error_count integer     NOT NULL DEFAULT 0,
    last_error  text,

    CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id)
  );
  """

  def change do
    create table("pew_jobs") do
      add(:job_module, :string, null: false)
      add(:args, :jsonb, null: false, default: "{}")

      add(:error_count, :integer, null: false, default: 0)
      add(:last_error, :text)
    end
  end
end
