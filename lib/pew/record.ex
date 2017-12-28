defmodule Pew.Record do
  use Ecto.Schema

  schema "pew_jobs" do
    field(:job_module)
    field(:args)
    field(:error_count)
    field(:last_error)
  end
end
