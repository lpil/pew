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
