DELETE FROM pew_jobs
WHERE queue    = :queue::text
AND   priority = :priority::smallint
AND   run_at   = :run_at::timestamptz
AND   job_id   = :job_id::bigint
RETURNING job_id
