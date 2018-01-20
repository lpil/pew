INSERT INTO pew_jobs
(queue, priority, run_at, job_type, args)
VALUES
(
  coalesce(:queue, '')::text,
  coalesce(:priority, 100)::smallint,
  coalesce(:run_at, now())::timestamptz,
  :job_type::text,
  coalesce(:args, '{}')::jsonb
)
RETURNING *
