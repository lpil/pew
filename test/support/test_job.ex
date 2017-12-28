defmodule Support.TestJob do
  @behaviour Pew.Job

  @impl Pew.Job
  def run(_args) do
    :ok
  end
end
